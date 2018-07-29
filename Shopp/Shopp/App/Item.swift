//
//  Item.swift
//  Shopp
//
//  Created by Nikhil Sridhar on 7/28/18.
//  Copyright © 2018 rsrn. All rights reserved.
//

import Foundation
import UIKit

class Item{
    
    var itemID: String
    
    var type: ItemType
    
    var name: String
    var description: String
    var price: Double
    var imageURL: String
    
    init(itemID: String, type: ItemType, name: String, description: String, price: Double, imageURL: String) {
        self.itemID = itemID
        self.type = type
        self.name = name
        self.description = description
        self.price = price
        self.imageURL = imageURL
    }
    
    init() {
        self.itemID = ""
        self.type = .none
        self.name = ""
        self.description = ""
        self.price = 0.00
        self.imageURL = ""
    }
    
}

enum ItemType{
    case grocery
    case clothing
    case pharmacy
    case none
}
