//
//  ViewController.swift
//  Task13
//
//  Created by buqian zheng on 5/9/18.
//  Copyright © 2018 buqian zheng. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var blockingView: UIControl!
    @IBOutlet weak var busListView: UITableView!
    @IBOutlet weak var searchedBusListView: UITableView!
    let locationManager: CLLocationManager = CLLocationManager()
    var currentShowingBus: String?
    var currentLocation: CLLocationCoordinate2D?
    
    
    var currentShowing: String?
    var locations: [String : CLLocationCoordinate2D] = [
        "61B": Location61B,
        "61D": Location61D,
        "61C": Location61C,
        "67" : Location67
    ]
    var annotations: [String : MKPointAnnotation] = [:]
    var items: [String : MKMapItem] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        
        busListView.dataSource = self
        busListView.delegate = self
        busListView.rowHeight = 70
        searchedBusListView.dataSource = self
        searchedBusListView.rowHeight = 80
        searchedBusListView.separatorStyle = .none
        
        setupDemoAnnotation()
        
        let notification = NSNotification.Name(rawValue: ShowRouteNotification)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.showDemoRoute), name: notification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = MainBlue
        renderer.lineWidth = 4.0
        return renderer
    }
    
    @IBAction func didTouchBackground(_ sender: UIControl) {
        sender.isHidden = true
    }
    
    // MARK: UITableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchedBusListView {
            return 1
        }
        return buses.count
    }
    let BusCellIdentifier = "BusCellIdentifier"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchedBusListView {
            var cell: SearchInfoCell? = tableView.dequeueReusableCell(withIdentifier: SearchInfoIdentifier) as? SearchInfoCell
            if cell == nil {
                searchedBusListView.register(UINib(nibName: "SearchInfoCell", bundle: nil), forCellReuseIdentifier: SearchInfoIdentifier)
                cell = tableView.dequeueReusableCell(withIdentifier: SearchInfoIdentifier) as? SearchInfoCell
            }
            cell?.name.text = searchResults[0].3
            cell?.start.text = searchResults[0].0
            cell?.stop.text = searchResults[0].1
            cell?.end.text = searchResults[0].2
            cell?.selectionStyle = .none
            return cell!
        }
        var cell: BusInfoCell? = tableView.dequeueReusableCell(withIdentifier: BusCellIdentifier) as? BusInfoCell
        if cell == nil {
            busListView.register(UINib(nibName: "BusInfoCell", bundle: nil), forCellReuseIdentifier: BusCellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: BusCellIdentifier) as? BusInfoCell
        }
        let bus = buses[indexPath.row]
        cell?.set(busInfo: bus)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == searchedBusListView {
            return
        }
        let bus = buses[indexPath.row]
        if let showing = currentShowing {
            if showing == bus.name {
                hide(name: bus.name)
                return
            }
            hide(name: showing)
        }
        show(name: bus.name)
        currentShowing = bus.name
    }
    func hide(name: String) {
        mapView.removeAnnotation(annotations[name]!)
    }
    func show(name: String) {
        mapView.showAnnotations([annotations[name]!], animated: true)
        let rect = MKMapRect.of(currentLocation!, locations[name]!)
        mapView.setRegion(MKCoordinateRegionForMapRect(rect.bigger), animated: true)
    }
    
    // MARK: Core Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = manager.location!.coordinate
    }
    
    // MARK: drawing on map
    func setupDemoAnnotation() {
        for (name, location) in locations {
            let mark = MKPlacemark(coordinate: location)
            let item = MKMapItem(placemark: mark)
            items[name] = item
            let annotation = MKPointAnnotation()
            annotation.title = name
            annotation.coordinate = location
            annotations[name] = annotation
        }
    }
    @IBOutlet weak var busConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchConstraint: NSLayoutConstraint!
    func hideView(_ constraint: NSLayoutConstraint) {
        UIView.animate(withDuration: 0.5) {
            constraint.constant = -500
            self.busListView.layoutIfNeeded()
            self.searchedBusListView.layoutIfNeeded()
        }
    }
    func showView(_ constraint: NSLayoutConstraint) {
        UIView.animate(withDuration: 0.5) {
            constraint.constant = 0
            self.busListView.layoutIfNeeded()
            self.searchedBusListView.layoutIfNeeded()
        }
    }
    
    @objc func showDemoRoute() {
        hideView(busConstraint)
        showView(searchConstraint)
        self.view.layoutIfNeeded()
        
        let sourceLocation = ForbesAtAtwood
        let destinationLocation = ForbesAtHamburg
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Forbes / Atwood"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
    
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Forbes / Hamburg Hall"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true )
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect.bigger), animated: true)
        }
    }
    
    @IBAction func hideDemoRoute(_ sender: Any) {
        hideView(searchConstraint)
        showView(busConstraint)
        self.view.layoutIfNeeded()
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
    }
    

}

extension MKMapRect {
    var bigger: MKMapRect {
        let delta = self.size.width * 0.15
        let adjustedRect = MKMapRect(origin: MKMapPoint(x: self.origin.x - delta, y: self.origin.y - delta), size: MKMapSize(width: self.size.width + 2 * delta, height: self.size.height + 2 * delta))
        return adjustedRect
    }
    static func of(_ l1: CLLocationCoordinate2D, _ l2: CLLocationCoordinate2D) -> MKMapRect {
        let p1 = MKMapPointForCoordinate(l1)
        let p2 = MKMapPointForCoordinate(l2)
        return MKMapRectMake(fmin(p1.x,p2.x), fmin(p1.y,p2.y), fabs(p1.x-p2.x), fabs(p1.y-p2.y))
    }
}
