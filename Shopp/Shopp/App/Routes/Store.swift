//
//  store.swift
//  Shopp
//
//  Created by Gabbie on 7/28/18.
//  Copyright © 2018 Gabbie. All rights reserved.
//

import Foundation
import SwiftyJSON


struct Store {
    
    let name: String
    let address: String
    
    
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.address = json["location"].stringValue
        
    }
    
}
