//
//  RegisterViewController.swift
//  Flash Chat
//
//  Created by Abdeljaouad Mezrari on 04/03/2023.
//  Copyright © 2023 Abdeljaouad Mezrari. All rights reserved.
//

import UIKit
import FirebaseAuth
class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if error != nil{
                    self.throwAlert(title: "Error", text: "\(String(describing: error?.localizedDescription))")
                } else{
                    Auth.auth().currentUser?.sendEmailVerification { error in
                        if error != nil{
                            self.throwAlert(title: "Error", text: "\(String(describing: error?.localizedDescription))")
                        }
                    }
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                
                }
            }
        }
    }
    func throwAlert(title: String, text: String){
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let closeAlertBtn = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(closeAlertBtn)
        self.present(alert, animated: true)

    }
    
}
