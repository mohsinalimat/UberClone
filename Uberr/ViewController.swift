//
//  ViewController.swift
//  Uberr
//
//  Created by Flyco Developer on 28/09/2017.
//  Copyright © 2017 Flyco Developer. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    var driver:Bool = false
    @IBOutlet weak var choiceSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    @IBAction func login(_ sender: Any) {
        if (email.text?.isEmpty)! && (password.text?.isEmpty)! {
            showAlert(title: "HATA", message: "Lütfen Boş Alan Bırakmayınız")
        }else{
            Auth.auth().signIn(withEmail: email.text!, password: password.text!, completion: { (user, error) in
                if error != nil{
                    self.showAlert(title: "HATA", message: (error?.localizedDescription)!)
                }else {
                    if self.driver {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let passengerVC = storyboard.instantiateViewController(withIdentifier: "DriverVC")
                    self.present(passengerVC, animated: true, completion: nil)
                        self.email.text = ""
                    } else {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let passengerVC = storyboard.instantiateViewController(withIdentifier: "PassengerVC")
                        self.present(passengerVC, animated: true, completion: nil)
                        self.email.text = ""
                    }
                }
            })
        }
        
    }
    
    @IBAction func selectUserType(_ sender: Any) {
        if self.choiceSegment.selectedSegmentIndex == 0 {
            print("yolcu seçildi")
            driver = false
            if (!(email.text?.isEmpty)!){
                self.login(sender)
            }
        } else {
            print("sofor seçildi")
            driver = true
            if(!(email.text?.isEmpty)!){
                self.login(sender)
            }
            
        }
    }
}

