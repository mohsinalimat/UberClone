//
//  CallUberViewController.swift
//  Uberr
//
//  Created by Flyco Developer on 29.11.2017.
//  Copyright © 2017 Flyco Developer. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

class CallUberViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var taxiButton: UIButton!
    @IBOutlet weak var uberMap: MKMapView!
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var taciCalled:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if let email = Auth.auth().currentUser?.email {
            Database.database().reference().child("TaksiCagiranlar").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
                self.taciCalled = true //Taksi zaten çağırmış
                self.taxiButton.setTitle("İptal Et", for: UIControlState.normal)
            })
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate{
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            userLocation = center
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
        let email = Auth.auth().currentUser?.email
        let userInfos = ["email":email!, "enlem":userLocation.latitude, "boylam":userLocation.longitude] as [String : Any]
        if taciCalled {
            taciCalled = false
            taxiButton.setTitle("Taksi Çağır", for: .normal)
            //Veritabanından taksi isteğini kaldırmalıyız
            Database.database().reference().child("TaksiCagiranlar").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(DataEventType.childAdded, with: { (snapshot) in
                snapshot.ref.removeValue()
                Database.database().reference().child("TaksiCagiranlar").removeAllObservers()
            })
            
        } else {
        
       
        Database.database().reference().child("TaksiCagiranlar").childByAutoId().setValue(userInfos)
        taxiButton.setTitle("Taksi Çağır İptal Et", for: UIControlState.normal)
        taciCalled = true
        }
        
    }
    
    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("Çıkış yapılamadı")
        }
        
    }
    
}
