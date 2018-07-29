//
//  NameFile.swift
//  Shopp
//
//  Created by Nikhil Sridhar on 7/28/18.
//  Copyright © 2018 rsrn. All rights reserved.
//

import Foundation
import UIKit

struct NameFile {
    
    struct Cells {
        static let item = "ItemCell"
    }
    
    struct Firebase {
        struct ItemDB {
            static let items = "Items"
            // item <document> - randomID
            static let type = "Type"
            static let user = "User"
            static let name = "Name"
            static let description = "Description"
            static let price = "Price"
            static let imageURL = "ImageURL"
        }
        struct ImageStorage {
            static let itemImages = "itemImages"
        }
    }
    
}

