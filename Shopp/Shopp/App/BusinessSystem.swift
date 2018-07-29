//
//  StoreSystem.swift
//  Shopp
//
//  Created by Nikhil Sridhar on 7/28/18.
//  Copyright © 2018 rsrn. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
import Geofirestore

class BusinessSystem {
    
    public typealias CompletionHandler = (Error?) -> Void
    public typealias BusinessCallback = ([Business]?, Error?) -> Void
    
    public static let system = BusinessSystem()
    
    private let database = Firestore.firestore()
    private let storage = Storage.storage().reference()
    private let businesses = Firestore.firestore().collection(NameFile.Firebase.BusinessDB.businesses)
    
    private var businessRegistrations = [ListenerRegistration]()
    
    public func addBusinessObserver(forEventType eventType: DocumentChangeType, location: GeoPoint, callback: @escaping BusinessCallback){
        businessRegistrations.append(businesses.whereField(NameFile.Firebase.BusinessDB.name, isGreaterThan: " ").addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot, error == nil else{
                callback(nil, error)
                return
            }
            
            var ret = [Business]()
            snapshot.documentChanges.forEach({ (documentChange) in
                if documentChange.type == eventType{
                    let data = documentChange.document.data()
                    
                    let typeText = data[NameFile.Firebase.BusinessDB.type] as! String
                    var type: ItemType = .grocery
                    if typeText == "Grocery"{
                        type = .grocery
                    }else if typeText == "Clothing"{
                        type = .clothing
                    }else if typeText == "Pharmacy"{
                        type = .pharmacy
                    }
                    
                    let name = data[NameFile.Firebase.BusinessDB.name] as! String
                    let location = data[NameFile.Firebase.BusinessDB.location] as! GeoPoint
                    ret.append(Business(type: type, name: name, location: location))
                }
            })
            callback(ret, nil)
        })
    }
    
    public func removeBusinessObservers(){
        businessRegistrations.forEach { (registration) in
            registration.remove()
        }
    }
    
    
}

