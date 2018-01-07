//
//  SingUpViewController.swift
//  Uberr
//
//  Created by Flyco Developer on 29.11.2017.
//  Copyright © 2017 Flyco Developer. All rights reserved.
//

import UIKit
import Firebase

class SingUpViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pass1: UITextField!
    @IBOutlet weak var pass2: UITextField!
    
    @IBOutlet weak var choiceSegment: UISegmentedControl!
    var driver:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func selectUserType(_ sender: Any) {
        if choiceSegment.selectedSegmentIndex == 0 {
            print("Yolcu Seçildi")
            driver = false
            if(!(email.text?.isEmpty)!){
                self.save(sender)
            } else {
                print("Sofur Seçildi")
                driver = true
                if (!(email.text?.isEmpty)!) {
                    self.save(sender)
                }
            }
        }
        
    }
    @IBAction func save(_ sender: Any) {
        
        if (email.text?.isEmpty)! && (pass1.text?.isEmpty)! && (pass2.text?.isEmpty)! {
            showAlert(title: "HATA", message: "Lütfen Boş Alan Bırakmıyınız")
            
        }
        if pass2.text != pass1.text {
            showAlert(title: "HATA", message: "Şifre tekrarlarınız yanlış")
        }
        
        //Kayıt işlemini yapabiliriz
        Auth.auth().createUser(withEmail: email.text!, password: pass1.text!) { (user, error) in
            if let error = error{
                self.showAlert(title: "HATA", message: error.localizedDescription)
                
            }else {
                self.showAlert(title: "Tebrikler", message: "Kullanıcı Kaydı Başarı ile olmuştur")
            }
        }
        
        if driver {
            let userInfos:[String:Any] = ["email":email.text!,"gorev":"sofor"]
            Database.database().reference().child("kullanicilar").childByAutoId().setValue(userInfos)
            self.email.text = ""
        } else {
            let userInfos:[String:Any] = ["email":email.text!,"gorev":"yolcu"]
            Database.database().reference().child("kullanicilar").childByAutoId().setValue(userInfos)
            self.email.text = ""
        }
    }


}


extension UIViewController{
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
