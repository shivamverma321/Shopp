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

class MapVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let startCord = CLLocationCoordinate2D(latitude: 37.8002, longitude: -122.4149)
        let endCord = CLLocationCoordinate2D(latitude:37.7875 , longitude: -122.4281)
        let testline = draw(start: startCord, end: endCord)
        //adds MKPolyLine as an overlay
        
        let pin = Pin(title: "YAYAYA", locationName: "Some Place in SF", discipline: "Store", coordinate: startCord)
        let pin2 = Pin(title: "NONONO", locationName: "Another Place in SF", discipline: "Store", coordinate: endCord)
        mapView.addAnnotation(pin)
        mapView.addAnnotation(pin2)
        mapView.add(testline)
        
        mapView.centerCoordinate = startCord
        mapView.region = MKCoordinateRegion(center: startCord, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
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
            print(points)
            
            print(points.count)
            return MKPolyline(coordinates: points, count: points.count)
        }
        catch{
            print("Oh no!")
        }
        
        
        return MKPolyline(coordinates: points, count: 2)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //Return an MKPolylineRenderer for the MKPolyline in the MKMapViewDelegates method
        if let polyline = overlay as? MKPolyline {
            let testlineRenderer = MKPolylineRenderer(polyline: polyline)
            testlineRenderer.strokeColor = .orange
            testlineRenderer.lineWidth = 4.5
            return testlineRenderer
        }
        fatalError("Something wrong...")
        //return MKOverlayRenderer()
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
