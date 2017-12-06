//
//  CallUberViewController.swift
//  Uberr
//
//  Created by Flyco Developer on 29.11.2017.
//  Copyright © 2017 Flyco Developer. All rights reserved.
//

import UIKit
import MapKit

class CallUberViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var uberMap: MKMapView!
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate{
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            let span = MKCoordinateSpanMake(0.08, 0.08)
            let region = MKCoordinateRegion(center: center, span: span)
            uberMap.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = "Buradasınız"
            
            uberMap.addAnnotation(annotation)
        }
    }
    
    @IBAction func callTaksi(_ sender: Any) {
        
        
    }
    
    @IBAction func logout(_ sender: Any) {
        
        
    }
    
}
