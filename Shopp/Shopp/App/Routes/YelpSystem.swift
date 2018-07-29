//
//  NetworkManager.swift
//  Shopp
//
//  Created by Gabbie on 7/28/18.
//  Copyright © 2018 Gabbie. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class YelpSystem {
    
    public typealias CompletionHandler = (Error?) -> Void
    public typealias StoreCallback = ([Store]?, Error?) -> Void
    public typealias AddressCallback = (String?, Error?) -> Void
    
    static let system = YelpSystem()
    
    public func getStores(address: String, type: String, callback: @escaping StoreCallback) {
        let apiToContact = " https://api.yelp.com/v3/businesses/search?term=\(type)&location=\(address)&sort_by=best_match"
        
        guard let url = URL(string: apiToContact) else{
            callback(nil, YelpError.urlRetrievalFailed)
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer h0qV778TvuJApBtfqotaaLzU253N0ig0fReQfF0FDI4esqyf3y2nMLQjKum6mw7NcAbKQynDhIEiUlcaY2ib13yDwAd2uiiKEyogJK8pjtF3RLyld2uCut9FGa1XW3Yx", forHTTPHeaderField: "Authorization")
        
        
        Alamofire.request(request).validate().responseJSON() { response in
            switch response.result {
            case .success:
                guard let value = response.result.value else{
                    callback(nil, YelpError.responseUnsuccessful)
                    return
                }
                
                let json = JSON(value)
                let businesJson = json["businesses"].arrayValue
                
                var stores = [Store]()
                
                businesJson.forEach({ (json) in
                    let aStore = Store(json: json)
                    stores.append(aStore)
                })
                callback(stores, nil)
                
            case .failure(_):
                callback(nil, YelpError.responseUnsuccessful)
            }
        }
    }
    
    
    public func createAddress(from lat: Double, lon: Double, callback: @escaping AddressCallback) {
        let apiToContact = "https://us1.locationiq.org/v1/reverse.php?key=e8a9e03ba8f450&lat=\(lat)&lon=\(lon)&format=json"
        guard let url = URL(string: apiToContact) else{
            callback(nil, YelpError.urlRetrievalFailed)
            return
        }
        
        let request = URLRequest(url: url)
        
        Alamofire.request(request).validate().responseJSON() { response in
            switch response.result {
            case .success:
                
                guard let value = response.result.value else{
                    callback(nil, YelpError.responseUnsuccessful)
                    return
                }
                
                let json = JSON(value)
                
                let houseNumber = json["address"]["house_number"].stringValue
                let road = json["address"]["road"].stringValue
                let city = json["address"]["city"].stringValue
                let state = json["address"]["state"].stringValue
                let postcode = json["address"]["postcode"].stringValue
                let finalAddress = "\(houseNumber) \(road), \(city), \(state) \(postcode)"
                
                callback(finalAddress, nil)
                
            case .failure(_):
                callback(nil, YelpError.responseUnsuccessful)
            }
        }
    }
}

enum YelpError: Error{
    case urlRetrievalFailed
    case responseUnsuccessful
}

