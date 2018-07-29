//
//  ItemSystem.swift
//  Shopp
//
//  Created by Nikhil Sridhar on 7/28/18.
//  Copyright © 2018 rsrn. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class ItemSystem {
    
    public typealias CompletionHandler = (Error?) -> Void
    public typealias ItemCallback = ([Item]?, Error?) -> Void
    
    public static let system = ItemSystem()
    
    private let database = Firestore.firestore()
    private let items = Firestore.firestore().collection(NameFile.Firebase.ItemDB.items)
    private let itemImages = Storage.storage().reference().child(NameFile.Firebase.ImageStorage.itemImages)
    
    private var itemRegistrations = [ListenerRegistration]()
    
    public func addItemObserver(forEventType eventType: DocumentChangeType, callback: @escaping ItemCallback){
        itemRegistrations.append(items.whereField(NameFile.Firebase.ItemDB.user, isEqualTo: AppStorage.User.userID).addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot, error == nil else{
                callback(nil, error)
                return
            }
            
            var ret = [Item]()
            snapshot.documentChanges.forEach({ (documentChange) in
                if documentChange.type == eventType{
                    let data = documentChange.document.data()
                    let itemID = documentChange.document.documentID
                    
                    let typeText = data[NameFile.Firebase.ItemDB.type] as! String
                    var type: ItemType = .none
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
                    ret.append(Item(itemID: itemID, type: type, name: name, description: description, price: price, imageURL: imageURL))
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
    
    public func deleteItem(withItemID itemID: String, completionHandler: CompletionHandler? = nil){
        items.document(itemID).delete(completion: completionHandler)
    }
    
}

