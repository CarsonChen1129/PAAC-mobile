import {Component, ViewChild, ElementRef, NgZone} from '@angular/core';
import {NavController, Platform, ViewController} from 'ionic-angular';
import { Geolocation } from '@ionic-native/geolocation';
import {TranslateService} from "@ngx-translate/core";
import { MenuController } from 'ionic-angular';

import { SpeechRecognition } from '@ionic-native/speech-recognition';
import {Connectivity} from "../../providers/connectivity-service";
import {GoogleMapsService} from "../../providers/GoogleMaps";

declare var google;

@Component({
  selector: 'home-page',
  templateUrl: 'home.html',
  providers:[SpeechRecognition,Connectivity, GoogleMapsService]
})
export class HomePage {

  // map: GoogleMap;

  @ViewChild('map') mapElement: ElementRef;
  @ViewChild('pleaseConnect') pleaseConnect: ElementRef;

  latitude: number;
  longitude: number;
  autocompleteService: any;
  placesService: any;
  query: string = '';
  places: any = [];
  searchDisabled: boolean;
  saveDisabled: boolean;
  location: any;
  lan: any;
  busStopList: any = [];
  nearbyBusList: any = [];
  markers: any = [];
  directionsService:any;
  directionsDisplay:any;

  GoogleAutocomplete = new google.maps.places.AutocompleteService();
  autocomplete:any;
  autocompleteItems:any;

  constructor(
    public navCtrl: NavController,
    public geolocation: Geolocation,
    public translate: TranslateService,
    public menuCtrl: MenuController,
    public zone: NgZone,
    public maps: GoogleMapsService,
    public platform: Platform,
    public viewCtrl: ViewController,
    public connectivityService: Connectivity,
    private speechRecognition: SpeechRecognition) {

    this.lan = 'en';
    translate.setDefaultLang(this.lan);

    this.searchDisabled = true;
    this.saveDisabled = true;

    this.nearbyBusList = [
      {num:"61A", name:"Fifth Ave + S Bellefield", time:"2 mins"},
      {num:"62B", name:"Fifth Ave + S Craig St", time:"5 mins"},
      {num:"71A", name:"Forbes Ave + S Bellefield", time:"8 mins"},
      {num:"72B", name:"Forbes Ave + S Craig St", time:"10 mins"},
    ]
  }

  toggleMenu() {
    this.menuCtrl.toggle();
  }


  ionViewDidLoad(){
    this.platform.ready().then(() => {
      let mapLoaded = this.maps.init(this.mapElement.nativeElement, this.pleaseConnect.nativeElement).then(() => {

        let map = new google.maps.Map(document.createElement('div'));
        this.autocompleteService = new google.maps.places.AutocompleteService();
        this.placesService = new google.maps.places.PlacesService(map);
        this.directionsService = new google.maps.DirectionsService;
        this.directionsDisplay = new google.maps.DirectionsRenderer;
        this.directionsDisplay.setMap(map);
        new google.maps.TransitLayer().setMap(map);
        this.searchDisabled = false;

      });

    });
  }

  selectPlace(place){

    this.places = [];

    let location = {
      lat: null,
      lng: null,
      name: place.name
    };

    this.placesService.getDetails({placeId: place.place_id}, (details) => {

      this.zone.run(() => {

        location.name = details.name;
        location.lat = details.geometry.location.lat();
        location.lng = details.geometry.location.lng();
        this.saveDisabled = false;

        this.maps.map.setCenter({lat: location.lat, lng: location.lng});

        this.location = location;

        let marker = new google.maps.Marker({
          map: this.maps.map,
          animation: google.maps.Animation.DROP,
          position: this.maps.map.getCenter()
        });

        this.placesService.nearbySearch({
          location: {lat: location.lat, lng: location.lng},
          radius: 1000,
          type: ['bus_station']
        }, (results,status) => {
          if (status === google.maps.places.PlacesServiceStatus.OK) {
            this.busStopList = [];
            for (let i = 0; i < results.length; i++) {
              this.busStopList.push(results[i]);
            }
            console.log(this.busStopList);
          }
        });

      });

    });
  }

  goPlace() {
    this.busStopList = [];
  }

  selectBusStop(bus) {
    let location = {
      lat: null,
      lng: null,
      name: bus.name
    };
    location.name = bus.name;
    location.lat = bus.geometry.location.lat();
    location.lng = bus.geometry.location.lng();
    this.maps.map.setCenter({lat: location.lat, lng: location.lng});
    this.location = location;

    this.clearMarkers(null);
    let marker = new google.maps.Marker({
      map: this.maps.map,
      animation: google.maps.Animation.DROP,
      position: this.maps.map.getCenter(),
      icon:"assets/icon/terminal-icon-blue.png"
    });
    this.markers.push(marker);
    if (this.directionsDisplay != null) {
      this.directionsDisplay.setMap(null);
      this.directionsDisplay = null;
    }
    this.directionsDisplay = new google.maps.DirectionsRenderer;
    this.directionsDisplay.setMap(this.maps.map);
    this.geolocation.getCurrentPosition().then((position) => {
      this.directionsService.route({
        origin: {lat:position.coords.latitude, lng:position.coords.longitude},
        destination: {lat:location.lat, lng:location.lng},
        travelMode: google.maps.TravelMode.TRANSIT
      }, (response, status) => {
        if (status === 'OK') {
          console.log(response);
          this.directionsDisplay.setDirections(response);
        } else {
          window.alert('Directions request failed due to ' + status);
        }
      });
    });

  }

  clearMarkers(map) {
    for (let i = 0; i < this.markers.length; i++) {
      this.markers[i].setMap(map);
    }
  }

  speech() {
    this.speechRecognition.isRecognitionAvailable()
      .then((available: boolean) => {
        this.speechRecognition.hasPermission()
          .then((hasPermission: boolean) => {
            if(hasPermission) {
              this.speechRecognition.startListening()
                .subscribe(
                  (matches: Array<string>) => {
                    console.log(matches);
                    this.query = matches[0];
                    this.searchPlace();
                  },
                  (onerror) => console.log('error:', onerror)
                )
            } else {
              this.speechRecognition.requestPermission()
                .then(
                  () => console.log('Granted'),
                  () => console.log('Denied')
                )
            }
          });
      });
  }

  searchPlace(){

    this.saveDisabled = true;

    if(this.query.length > 0 && !this.searchDisabled) {

      let config = {
        types: ['geocode'],
        input: this.query
      };

      this.autocompleteService.getPlacePredictions(config, (predictions, status) => {

        if(status == google.maps.places.PlacesServiceStatus.OK && predictions){

          this.places = [];

          predictions.forEach((prediction) => {
            this.places.push(prediction);
          });
        }

      });

    } else {
      this.places = [];
    }

  }

  save(){
    this.viewCtrl.dismiss(this.location);
  }

  close(){
    this.viewCtrl.dismiss();
  }

  // searchPlaces(keywords) {
  //   console.log(keywords);
  // }



//   updateSearchResults(){
//     if (this.autocomplete.input == '') {
//       this.autocompleteItems = [];
//       return;
//     }
//     this.GoogleAutocomplete.getPlacePredictions({ input: this.autocomplete.input },
//       (predictions, status) => {
//         this.autocompleteItems = [];
//         this.zone.run(() => {
//           predictions.forEach((prediction) => {
//             this.autocompleteItems.push(prediction);
//           });
//         });
//       });
//   }
//
//   loadMap(){
//     this.addConnectivityListeners();
//
//     if(typeof google == "undefined" || typeof google.maps == "undefined"){
//
//       console.log("Google maps JavaScript needs to be loaded.");
//       this.disableMap();
//
//       if(this.connectivityService.isOnline()){
//         console.log("online, loading map");
//
//         //Load the SDK
//         window['mapInit'] = () => {
//           this.initMap();
//           this.enableMap();
//         }
//
//         let script = document.createElement("script");
//         script.id = "googleMaps";
//
//         if(this.apiKey){
//           script.src = 'http://maps.google.com/maps/api/js?key=' + this.apiKey + '&callback=mapInit';
//         } else {
//           script.src = 'http://maps.google.com/maps/api/js?callback=mapInit';
//         }
//
//         document.body.appendChild(script);
//
//       }
//     }
//     else {
//
//       if(this.connectivityService.isOnline()){
//         console.log("showing map");
//         this.initMap();
//         this.enableMap();
//       }
//       else {
//         console.log("disabling map");
//         this.disableMap();
//       }
//
//     }
//
//     // this.geolocation.getCurrentPosition().then((position) => {
//     //
//     //   let mapOptions: GoogleMapOptions = {
//     //     camera: {
//     //       target: {
//     //         lat: position.coords.latitude,
//     //         lng: position.coords.longitude
//     //       },
//     //       zoom: 15
//     //     }
//     //   };
//     //
//     //   this.map = GoogleMaps.create('map_canvas', mapOptions);
//     //
//     // }, (err) => {
//     //   console.log(err);
//     // });
//   }
//
//   initMap() {
//   this.mapInitialised = true;
//   this.geolocation.getCurrentPosition().then((position) => {
//
//     let latLng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
//
//     let mapOptions = {
//       center: latLng,
//       zoom: 15,
//       mapTypeId: google.maps.MapTypeId.ROADMAP
//     };
//
//     this.map = new google.maps.Map(this.mapElement.nativeElement, mapOptions);
//
//   }, (err) => {
//     console.log(err);
//   });
// }
//
//   disableMap(){
//     console.log("disable map");
//   }
//
//   enableMap(){
//     console.log("enable map");
//   }
//
//   addMarker(){
//
//     let marker = new google.maps.Marker({
//       map: this.map,
//       animation: google.maps.Animation.DROP,
//       position: this.map.getCenter()
//     });
//
//     let content = "<h4>Information!</h4>";
//
//     this.addInfoWindow(marker, content);
//     // Wait the MAP_READY before using any methods.
//     // this.map.one(GoogleMapsEvent.MAP_READY)
//     //   .then(() => {
//     //     console.log('Map is ready!');
//     //
//     //     // Now you can use all methods safely.
//     //     this.map.addMarker({
//     //       title: 'Ionic',
//     //       icon: 'blue',
//     //       animation: 'DROP',
//     //       position: this.map.getCameraTarget()
//     //     })
//     //       .then(marker => {
//     //         marker.on(GoogleMapsEvent.MARKER_CLICK)
//     //           .subscribe(() => {
//     //             alert('clicked');
//     //           });
//     //       });
//     //
//     //   });
//
//   }
//
//   addInfoWindow(marker, content){
//
//     let infoWindow = new google.maps.InfoWindow({
//       content: content
//     });
//
//     google.maps.event.addListener(marker, 'click', () => {
//       infoWindow.open(this.map, marker);
//     });
//
//   }
//
//   addConnectivityListeners(){
//
//     let onOnline = () => {
//
//       setTimeout(() => {
//         if(typeof google == "undefined" || typeof google.maps == "undefined"){
//
//           this.loadMap();
//
//         } else {
//
//           if(!this.mapInitialised){
//             this.initMap();
//           }
//
//           this.enableMap();
//         }
//       }, 2000);
//
//     };
//
//     let onOffline = () => {
//       this.disableMap();
//     };
//
//     document.addEventListener('online', onOnline, false);
//     document.addEventListener('offline', onOffline, false);
//
//   }

}
