//
//  File.swift
//  Shopp
//
//  Created by Nikhil Sridhar on 7/29/18.
//  Copyright © 2018 rsrn. All rights reserved.
//

import Foundation
import Firebase

class Business{
    
    var type: ItemType
    var name: String
    var location: GeoPoint
    
    init(type: ItemType, name: String, location: GeoPoint) {
        self.type = type
        self.name = name
        self.location = location
    }
    
    init() {
        type = .grocery
        name = ""
        location = GeoPoint(latitude: 0, longitude: 0)
    }
    
}
