//
//  Locations.swift
//  Task13
//
//  Created by buqian zheng on 5/10/18.
//  Copyright © 2018 buqian zheng. All rights reserved.
//

import Foundation
import MapKit


let FifthAtMorewood = CLLocationCoordinate2D(latitude: 40.447461, longitude: -79.942604)
let FifthAtCraig = CLLocationCoordinate2D(latitude: 40.446905, longitude: -79.949149)
let FifthAtShady = CLLocationCoordinate2D(latitude: 40.452819, longitude: -79.920540)
let FifthAtBellefield = CLLocationCoordinate2D(latitude: 40.446484, longitude: -79.951856)
let FifthAtTennyson = CLLocationCoordinate2D(latitude: 40.445581, longitude: -79.953185)
let FifthAtBouquet = CLLocationCoordinate2D(latitude: 40.442620, longitude: -79.957456)

let ForbesAtMorewood = CLLocationCoordinate2D(latitude: 40.444635, longitude: -79.942977)
let ForbesAtCraig = CLLocationCoordinate2D(latitude: 40.444635, longitude: -79.942977)
let ForbesAtAtwood = CLLocationCoordinate2D(latitude: 40.441049, longitude: -79.957596)
let ForbesAtHamburg = CLLocationCoordinate2D(latitude: 40.444520, longitude: -79.945904)
let ForbesAtMeyran = CLLocationCoordinate2D(latitude: 40.440564, longitude: -79.958353)
let ForbesAtCraft = CLLocationCoordinate2D(latitude: 40.437095, longitude: -79.963087)
let ForbesAtVanBraam = CLLocationCoordinate2D(latitude: 40.437553, longitude: -79.982689)

let MainBlue = UIColor(red: 37.0/255, green: 148.0/255, blue: 248.0/255, alpha: 1)

let Location71D = FifthAtBellefield
let Location71B = FifthAtCraig
let Location75  = FifthAtBouquet
let Location71C = FifthAtTennyson


let Location61D = ForbesAtAtwood
let Location61B = ForbesAtMeyran
let Location67  = ForbesAtCraft
let Location61C = ForbesAtVanBraam

let buses = [
    BusInfo(name: "61D", direction: "Outbound to Waterfront", remainingTime: 7, waitLocation: "Forbes / Hamburg Hall"),
    BusInfo(name: "61B", direction: "Inbound Braddock", remainingTime: 8, waitLocation: "Forbes / Hamburg Hall"),
    BusInfo(name: "67", direction: "Outbound Ccac Boyce", remainingTime: 11, waitLocation: "Forbes / Hamburg Hall"),
    BusInfo(name: "61C", direction: "Outbound McKeesport", remainingTime: 15, waitLocation: "Forbes / Hamburg Hall")
]

let ShowRouteNotification = "ShowRouteNotification"
let SearchInfoIdentifier = "SearchInfoIdentifier"
let searchResults = [
    ("7:30 pm", "Forbes / Hamburg Hall", "7:35pm", "61A"),
    ("7:33 pm", "Forbes / Hamburg Hall", "7:38pm", "61C"),
    ("7:38 pm", "Forbes / Hamburg Hall", "7:43pm", "67"),
    ("7:45 pm", "Forbes / Hamburg Hall", "7:50pm", "61D"),
]
