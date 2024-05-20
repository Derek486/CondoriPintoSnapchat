//
//  ViewController.swift
//  CondoriPintoSnapchat
//
//  Created by Neals Paye Aguilar on 20/05/24.
//

import UIKit

import Firebase
import FirebaseAuth
import GoogleSignIn

class iniciarSesionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func iniciargoogle(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
          guard error == nil else {
            return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in

                if error != nil {
                    print("Error \(error!)")
                } else {
                    
                    print("Inicio de sesion correcto con GOOGLE")
                }
            }
                
          // ...
        }
    }
    
    @IBAction func tappedSigniN(_ sender: Any) {
        
    }
    @IBOutlet weak var signInButton: GIDSignInButton!
    
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

