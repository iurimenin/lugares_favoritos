//
//  ViewController.swift
//  LugaresFavoritos
//
//  Created by Iuri Menin on 04/08/16.
//  Copyright © 2016 Iuri Menin. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    var manager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        if activePlace == -1 {
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        } else {
            
            let lat = NSString(string: places[activePlace]["lat"]!).doubleValue
            let lon = NSString(string: places[activePlace]["lon"]!).doubleValue

            let coordinate = CLLocationCoordinate2DMake(lat, lon)
        
            let latDelta: CLLocationDegrees = 0.01
            let lonDelta: CLLocationDegrees = 0.01
        
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
            let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        
            self.map.setRegion(region, animated: true)

            let annotation = MKPointAnnotation()
                
            annotation.coordinate = coordinate
            annotation.title = places[activePlace]["name"]
                
            self.map.addAnnotation(annotation)
        }
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.action(_:)))
        uilpgr.minimumPressDuration = 2
        
        map.addGestureRecognizer(uilpgr)
    }
    
    func action (gesture: UIGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizerState.Began {
            
            let touchPoint = gesture.locationInView(self.map)
            let coordinate = self.map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placeMarks, error) in
                
                var title = ""
                
                if error == nil {
                    
                    if let pm = placeMarks?[0] {
                        
                        var address: String = ""
                        var address2: String = ""
                        
                        if pm.subThoroughfare != nil {
                            address2 = pm.subThoroughfare!
                        }
                        
                        if pm.thoroughfare != nil {
                            address = pm.thoroughfare!
                        }
                        
                        title = "\(address2) \(address)"
                    }
                }
                
                if title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "" {
                    title = "Adicionado em \(NSDate())"
                }
                
                places.append(["name": title, "lat":"\(coordinate.latitude)","lon": "\(coordinate.longitude)"])
                
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = coordinate
                annotation.title = title
                
                self.map.addAnnotation(annotation)
            })
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        let userLocation: CLLocation = locations[0]
        
        let lat = userLocation.coordinate.latitude
        let lon = userLocation.coordinate.longitude
        
        let coordinate = CLLocationCoordinate2DMake(lat, lon)
        
        let latDelta: CLLocationDegrees = 0.01
        let lonDelta: CLLocationDegrees = 0.01
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        
        self.map.setRegion(region, animated: true)
    }

}

