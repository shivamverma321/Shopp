//
//  StoreSystem.swift
//  Shopp
//
//  Created by Nikhil Sridhar on 7/28/18.
//  Copyright © 2018 rsrn. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class BusinessSystem {
    
    public typealias CompletionHandler = (Error?) -> Void
    public typealias BusinessCallback = ([Business]?, Error?) -> Void
    
    public static let system = ItemSystem()
    
    private let database = Firestore.firestore()
    private let storage = Storage.storage().reference()
    private let store = Firestore.firestore().collection(NameFile.Firebase.StoreDB.stores)
    
    private var storeRegistrations = [ListenerRegistration]()
    
    public func addStoreObserver(forEventType eventType: DocumentChangeType, callback: @escaping ItemCallback){
        itemRegistrations.append(items.whereField(NameFile.Firebase.ItemDB.user, isEqualTo: AppStorage.User.userID).addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot, error == nil else{
                callback(nil, error)
                return
            }
            
            var ret = [Item]()
            snapshot.documentChanges.forEach({ (documentChange) in
                if documentChange.type == eventType{
                    let data = documentChange.document.data()
                    let databaseID = documentChange.document.documentID
                    
                    let typeText = data[NameFile.Firebase.ItemDB.type] as! String
                    var type: ItemType = .grocery
                    if typeText == "Grocery"{
                        type = .grocery
                    }else if typeText == "Clothing"{
                        type = .clothing
                    }else if typeText == "Pharmacy"{
                        type = .pharmacy
                    }
                    
                    let name = data[NameFile.Firebase.ItemDB.name] as! String
                    let description = data[NameFile.Firebase.ItemDB.description] as! String
                    let price = data[NameFile.Firebase.ItemDB.price] as! Double
                    let imageURL = data[NameFile.Firebase.ItemDB.imageURL] as! String
                    ret.append(Item(databaseID: databaseID, type: type, name: name, description: description, price: price, imageURL: imageURL))
                }
            })
            callback(ret, nil)
        })
    }
    
    public func removeItemObservers(){
        itemRegistrations.forEach { (registration) in
            registration.remove()
        }
    }
    
    public func deleteItem(withDatabaseID databaseID: String, completionHandler: CompletionHandler? = nil){
        items.document(databaseID).delete(completion: completionHandler)
    }
    
    private var productRegistrations = [ListenerRegistration]()
    
    public func addProductObserver(forEventType eventType: DocumentChangeType, callback: @escaping ItemCallback){
        productRegistrations.append(products.whereField(NameFile.Firebase.ProductDB.name, isGreaterThan: " ").addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot, error == nil else{
                callback(nil, error)
                return
            }
            
            var ret = [Item]()
            snapshot.documentChanges.forEach({ (documentChange) in
                if documentChange.type == eventType{
                    let data = documentChange.document.data()
                    let databaseID = documentChange.document.documentID
                    
                    let typeText = data[NameFile.Firebase.ItemDB.type] as! String
                    var type: ItemType = .grocery
                    if typeText == "Grocery"{
                        type = .grocery
                    }else if typeText == "Clothing"{
                        type = .clothing
                    }else if typeText == "Pharmacy"{
                        type = .pharmacy
                    }
                    
                    let name = data[NameFile.Firebase.ItemDB.name] as! String
                    let description = data[NameFile.Firebase.ItemDB.description] as! String
                    let price = data[NameFile.Firebase.ItemDB.price] as! Double
                    let imageURL = data[NameFile.Firebase.ItemDB.imageURL] as! String
                    ret.append(Item(databaseID: databaseID, type: type, name: name, description: description, price: price, imageURL: imageURL))
                }
            })
            callback(ret, nil)
        })
    }
    
    public func removeProductObservers(){
        productRegistrations.forEach { (registration) in
            registration.remove()
        }
    }
    
    public func addItem(_ product: Item, completionHandler: CompletionHandler? = nil){
        var textType = ""
        switch product.type{
        case .grocery:
            textType = "Grocery"
        case.clothing:
            textType = "Clothing"
        case .pharmacy:
            textType = "Pharmacy"
        }
        items.document().setData([
            NameFile.Firebase.ItemDB.user: AppStorage.User.userID,
            NameFile.Firebase.ItemDB.type: textType,
            NameFile.Firebase.ItemDB.name: product.name,
            NameFile.Firebase.ItemDB.description: product.description,
            NameFile.Firebase.ItemDB.price: product.price,
            NameFile.Firebase.ItemDB.imageURL: product.imageURL
            ], completion: completionHandler)
    }
    
}

