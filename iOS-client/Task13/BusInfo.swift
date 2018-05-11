//
//  BusInfo.swift
//  Task13
//
//  Created by buqian zheng on 5/9/18.
//  Copyright © 2018 buqian zheng. All rights reserved.
//

import UIKit

class BusInfo {
    let name: String
    let direction: String
    let remainingTime: Int
    let waitLocation: String
    
    init(name: String, direction: String, remainingTime: Int, waitLocation: String) {
        self.name = name
        self.direction = direction
        self.remainingTime = remainingTime
        self.waitLocation = waitLocation
    }
}
