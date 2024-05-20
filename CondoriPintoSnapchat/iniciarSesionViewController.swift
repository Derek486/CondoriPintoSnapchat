//
//  ViewController.swift
//  CondoriPintoSnapchat
//
//  Created by Neals Paye Aguilar on 20/05/24.
//

import UIKit

import Firebase
import FirebaseAuth

class iniciarSesionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {
            (user, error) in
            print("Iniciando sesión...")
            if error != nil {
                print("Error al iniciar sesión \(error!)")
            } else {
                print("Inicio de sesión exitoso")
            }
        }
    }
    
    
}

