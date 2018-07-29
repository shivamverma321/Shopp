//
//  GooglePlaces.swift
//
//  Created by Nikhil Sridhar on 9/8/14.

// ------------------------------------------------------------------------------------------
// Ref: https://developers.google.com/places/documentation/search#PlaceSearchRequests
//
// Example search
//
// https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&types=food&name=cruise&key=AddYourOwnKeyHere
//
// required parameters: key, location, radius
// ------------------------------------------------------------------------------------------

import Foundation
import CoreLocation
import MapKit

protocol GooglePlacesDelegate {
    
    func googlePlacesSearchResult(_: [MKMapItem])
    
}

class GooglePlaces {
    
    let URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    var LOCATION = "location="
    var RADIUS = "radius="
    var KEY = "key="
    
    var delegate: GooglePlacesDelegate?
    
    // ------------------------------------------------------------------------------------------
    // init requires google.plist with key "places-key" (the sever key)
    // ------------------------------------------------------------------------------------------
    
    init() {
        guard let path = Bundle.main.path(forResource: "google", ofType: "plist"),
            let google = NSDictionary(contentsOfFile: path),
            let apiKey = google["places-key"] as? String else{
                print("Exception: places-key is not set in google.plist")
                return
        }
        
        self.KEY = "\(self.KEY)\(apiKey)"
    }
    
    // ------------------------------------------------------------------------------------------
    // Google Places search with callback
    // ------------------------------------------------------------------------------------------
    
    func search(
        location: CLLocationCoordinate2D,
        radius: Int,
        query: String,
        callback: @escaping (_ items: [MKMapItem]?, _ errorDescription: String?) -> Void) {
        
        let urlEncodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let urlString = "\(URL)\(LOCATION)\(location.latitude),\(location.longitude)&\(RADIUS)\(radius)&\(KEY)&name=\(urlEncodedQuery!)"
        
        let url = NSURL(string: urlString)
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url! as URL) { (data, response, error) in
            if let error = error {
                callback(nil, error.localizedDescription)
            }
            
            if let statusCode = response as? HTTPURLResponse {
                if statusCode.statusCode != 200 {
                    callback(nil, "Could not continue.  HTTP Status Code was \(statusCode)")
                }
            }
            
            callback(GooglePlaces.parseFromData(data: data! as NSData), nil)
            
            }.resume()
    }
    
    
    // ------------------------------------------------------------------------------------------
    // Google Places search with delegate
    // ------------------------------------------------------------------------------------------
    
    func searchWithDelegate(
        location: CLLocationCoordinate2D,
        radius: Int,
        query: String) {
        
        self.search(location: location, radius: radius, query: query) { (items, errorDescription) -> Void in
            if self.delegate != nil {
                self.delegate!.googlePlacesSearchResult(items!)
            }
        }
    }
    
    // ------------------------------------------------------------------------------------------
    // Parse JSON into array of MKMapItem
    // ------------------------------------------------------------------------------------------
    
    class func parseFromData(data: NSData) -> [MKMapItem] {
        var mapItems = [MKMapItem]()
        
        let json = (try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary)!
        
        let results = json["results"] as? Array<NSDictionary>
        
        for result in results! {
            
            let name = result["name"] as! String
            
            var coordinate: CLLocationCoordinate2D!
            
            if let geometry = result["geometry"] as? NSDictionary {
                if let location = geometry["location"] as? NSDictionary {
                    let lat = location["lat"] as! CLLocationDegrees
                    let long = location["lng"] as! CLLocationDegrees
                    coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
                    let mapItem = MKMapItem(placemark: placemark)
                    mapItem.name = name
                    mapItems.append(mapItem)
                }
            }
        }
        
        return mapItems
    }
    
}
