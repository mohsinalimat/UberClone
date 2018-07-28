//
//  DriverViewController.swift
//  Uberr
//
//  Created by Flyco Developer on 7.01.2018.
//  Copyright © 2018 Flyco Developer. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MapKit

class DriverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    @IBOutlet var tableView: UITableView!
    
    var taksiCagiranlar :[DataSnapshot] = []
    var konumYoneticisi = CLLocationManager()
    var sofurKonum = CLLocationCoordinate2D()

    override func viewDidLoad() {
        super.viewDidLoad()

        konumYoneticisi.delegate=self
        konumYoneticisi.desiredAccuracy=kCLLocationAccuracyBest
        konumYoneticisi.requestWhenInUseAuthorization()
        konumYoneticisi.startUpdatingLocation()
        
        Database.database().reference().child("TaksiCagiranlar").observe(.childAdded) { (snapshot) in
            self.taksiCagiranlar.append(snapshot)
            self.tableView.reloadData()
        }
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (updateTimer) in
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let  sofurKoord = manager.location?.coordinate {
            sofurKonum = sofurKoord
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taksiCagiranlar.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "taksiCaigranlarCell", for: indexPath)
        let snapshot = taksiCagiranlar[indexPath.row]
        if let taksiCagiranlarVerisi = snapshot.value as? [String:AnyObject] {
            if let email = taksiCagiranlarVerisi["email"] as? String{
                
                if let enlem = taksiCagiranlarVerisi["enlem"] as? Double {
                    if let boylam = taksiCagiranlarVerisi["boylam"] as? Double {
                        let sofurKonumBilgileri = CLLocation(latitude: sofurKonum.latitude, longitude: sofurKonum.longitude)
                        let yolcuDurumBilgileri = CLLocation(latitude: enlem, longitude: boylam)
                        
                        let uzaklik = sofurKonumBilgileri.distance(from: yolcuDurumBilgileri) / 1000
                        let yaklasikUzaklik = round(uzaklik*100) / 100
                        cell.textLabel?.text = "\(email) - \(yaklasikUzaklik) mesafe"

                    }
                }

        }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let passengerVC = storyboard.instantiateViewController(withIdentifier: "TaxiRequestVC")
        self.present(passengerVC, animated: true, completion: nil)
    }
}
