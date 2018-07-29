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

class NetworkManager {
    
    static let sys
    
    //Yelp API
    static func getStore(address: String, type: String, callback: @escaping ([Store]) -> Void ) {
        let apiToContact = " https://api.yelp.com/v3/businesses/search?term=\(type)&location=\(address)&sort_by=best_match"
        guard let url = URL(string: apiToContact) else { return assertionFailure("URL failed")}
        
        var request = URLRequest(url: url)
        request.setValue("Bearer h0qV778TvuJApBtfqotaaLzU253N0ig0fReQfF0FDI4esqyf3y2nMLQjKum6mw7NcAbKQynDhIEiUlcaY2ib13yDwAd2uiiKEyogJK8pjtF3RLyld2uCut9FGa1XW3Yx", forHTTPHeaderField: "Authorization")
        
        
        
        Alamofire.request(request).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    let businesJson = json["businesses"].arrayValue
                    
                    var stores = [Store]()
                    
                    businesJson.forEach({ (json) in
                        let aStore = Store(json: json)
                        stores.append(aStore)
                    })
                    
                    DispatchQueue.main.async {
                        return callback(stores)
                    }
                    
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    //location iq!!!
    
    static func turnLatLonToAddress( lat: Double, lon: Double, completion: @escaping (String) -> Any?) {
        let apiToContact = "https://us1.locationiq.org/v1/reverse.php?key=e8a9e03ba8f450&lat=\(lat)&lon=\(lon)&format=json"
        guard let url = URL(string: apiToContact) else { return assertionFailure("URL failed")}
        let request = URLRequest(url: url)
        
        
        Alamofire.request(request).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    
                    let houseNumber = json["address"]["house_number"].stringValue
                    let road = json["address"]["road"].stringValue
                    let city = json["address"]["city"].stringValue
                    let state = json["address"]["state"].stringValue
                    let postcode = json["address"]["postcode"].stringValue
                    let finalAddress = "\(houseNumber) \(road), \(city), \(state) \(postcode)"
                    
                    completion(finalAddress)
                    
                }
                
            case .failure(_):
                print("turnLatLonToAddress function failed")
            }
        }
    }
}

