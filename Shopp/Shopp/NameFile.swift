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
    
    struct Segues {
        static let toProductVC = "SegueToProductVC"
        static let unwindToItems = "UnwindSegueToItems"
    }
    
    struct Cells {
        static let item = "ItemCell"
        static let product = "ProductCell"
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
        struct ProductDB {
            static let products = "Products"
            // product <document> - randomID
            static let type = "Type"
            static let name = "Name"
            static let description = "Description"
            static let price = "Price"
            static let imageURL = "ImageURL"
        }
        struct BusinessDB{
            static let businesses = "Businesses"
            // business <document> - randomID
            static let location = "Location"
            static let type = "Type"
            static let name = "Name"
        }
    }
    
}

