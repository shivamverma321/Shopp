//
//  MapVC.swift
//  Shopp
//
//  Created by Nikhil Sridhar on 7/28/18.
//  Copyright © 2018 rsrn. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import SVProgressHUD

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    private var currentLocation = CLLocation()
    private var types = Set<String>()
    private var stores = [MKMapItem]()
    private var storeLocations = [CLLocation]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        types.removeAll()
        stores.removeAll()
        storeLocations.removeAll()
    }
    
    private func observeItems(){
        ItemSystem.system.addItemObserver(forEventType: .added) { (addedItems, error) in
            guard let addedItems = addedItems, error == nil else{
                SVProgressHUD.dismiss()
                self.issueAlert(ofType: .dataRetrievalFailed)
                return
            }
            
            for addedItem in addedItems{
                switch addedItem.type{
                case .grocery:
                    self.types.insert("Grocery Store")
                case .clothing:
                    self.types.insert("Clothing Store")
                case .pharmacy:
                    self.types.insert("Pharmacy")
                }
            }
            ItemSystem.system.removeItemObservers()
            self.fetchStores()
        }
    }
    
    private func fetchStores(){
        let placesAPI = GooglePlaces()
        let myGroup = DispatchGroup()
        for type in self.types{
            myGroup.enter()
            placesAPI.search(location: currentLocation.coordinate, radius: 20, query: type) { (mapItems, errorDescription) in
                guard let mapItem = mapItems?[0] else{
                    self.issueAlert(ofType: .dataRetrievalFailed)
                    return
                }
                
                self.stores.append(mapItem)
                myGroup.leave()
            }
        }
        myGroup.notify(queue: .main) {
            self.convertStoresToLocations()
        }
    }
    
    private func convertStoresToLocations(){
        for store in stores{
            storeLocations.append(CLLocation(latitude: store.placemark.coordinate.latitude, longitude: store.placemark.coordinate.longitude))
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = store.placemark.coordinate
            annotation.title = store.placemark.name
            annotation.subtitle = store.phoneNumber
            mapView.addAnnotation(annotation)
        }
        storeLocations.append(currentLocation)
        storeLocations.insert(currentLocation, at: 0)
        drawRoutes()
    }
    
    private func drawRoutes(){
        for index in 0..<storeLocations.count-1{
            let start = storeLocations[index]
            let end = storeLocations[index + 1]
            let line = draw(start: start.coordinate, end: end.coordinate)
            mapView.add(line)
        }
        SVProgressHUD.dismiss()
    }
    
    private func draw( start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) -> MKPolyline{
        var points = [start]
        let s = "https://api.coord.co/v1/routing/route?origin_latitude=" + String(start.latitude) + "&origin_longitude=" + String(start.longitude) + "&destination_latitude=" + String(end.latitude) + "&destination_longitude=" + String(end.longitude) + "&access_key=EEC7nTIyYHOJUHCC1tHjrPUTGVgoyUsksMj-KMl-OHc"
        let request = URLRequest(url: NSURL(string: s)! as URL)
        
        do {
            let response: AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
            let data = try NSURLConnection.sendSynchronousRequest(request, returning: response)
            
            // Convert the data to JSON
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            let trips = json!["trips"] as! NSArray
            let legs = trips[0] as! NSDictionary
            let geometry = legs["legs"] as! NSArray
            for g in geometry{
                let geo = g as! NSDictionary
                let n = geo["geometry"] as! NSDictionary
                let loop = n["coordinates"] as! NSArray
                for coord in loop{
                    let coordinates = coord as! NSArray
                    let s : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: coordinates[1] as! CLLocationDegrees, longitude: coordinates[0] as! CLLocationDegrees)
                    points.append(s)
                }
            }
            points.append(end)
            return MKPolyline(coordinates: points, count: points.count)
        }
        catch{}
        
        
        return MKPolyline(coordinates: points, count: 2)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let testlineRenderer = MKPolylineRenderer(polyline: polyline)
            testlineRenderer.strokeColor = UIColor.orange
            testlineRenderer.lineWidth = 3
            return testlineRenderer
        }
        fatalError("TODO: Handle error")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = manager.location else{
            self.issueAlert(ofType: .dataRetrievalFailed)
            return
        }
        
        SVProgressHUD.show()
        
        self.currentLocation = currentLocation
        
        mapView.centerCoordinate = currentLocation.coordinate
        mapView.region = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015))
        
        observeItems()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.issueAlert(ofType: .dataRetrievalFailed)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
