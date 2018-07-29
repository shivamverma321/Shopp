//
//  File.swift
//  Shopp
//
//  Created by Nikhil Sridhar on 7/29/18.
//  Copyright © 2018 rsrn. All rights reserved.
//

import Foundation
import Firebase

class Store{
    
    var name: String
    var location: GeoPoint
    
    init(name: String, location: GeoPoint) {
        self.name = name
        self.location = location
    }
    
    init() {
        name = ""
        location = GeoPoint(lo)
    }
    
}
