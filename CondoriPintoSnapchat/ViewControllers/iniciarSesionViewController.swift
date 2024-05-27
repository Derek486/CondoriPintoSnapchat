//
//  ViewController.swift
//  CondoriPintoSnapchat
//
//  Created by Neals Paye Aguilar on 20/05/24.
//

import UIKit

import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
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
                    let alerta = UIAlertController(title: "Inicio de sesión fallido", message: "Error al momento de intentar ingresar mediante credenciales de Google", preferredStyle: .alert)
                    let btncancelar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                    alerta.addAction(btncancelar)
                    self.present(alerta, animated: true, completion: nil)
                } else {
                    print("Inicio de sesion correcto con GOOGLE")
                    self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                }
            }
                
          // ...
        }
    }
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {
            (user, error) in
            print("Iniciando sesión...")
            if error != nil {
                print("Error al iniciar sesión \(error!)")
                let alerta = UIAlertController(title: "Inicio de sesión fallido", message: "Las credenciales proporcionadas no corresponden a ningún usuario, si no posee unas, puede crear un nuevo usuario en la vista de registro", preferredStyle: .alert)
                let btncrear = UIAlertAction(title: "Crear usuario", style: .default, handler: {(UIAlertAction) in
                    self.performSegue(withIdentifier: "registroSegue", sender: nil)
                })
                let btncancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
                alerta.addAction(btncrear)
                alerta.addAction(btncancelar)
                self.present(alerta, animated: true, completion: nil)
            } else {
                print("Inicio de sesión exitoso")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
        }
    }
    
    
}

