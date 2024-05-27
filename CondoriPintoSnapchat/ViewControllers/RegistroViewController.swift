//
//  RegistroViewController.swift
//  CondoriPintoSnapchat
//
//  Created by Neals Paye Aguilar on 27/05/24.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegistroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func cancelar(_ sender: Any) {
        
    }
    @IBAction func registrar(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
            print("intentando crear un usuario")
            if error != nil {
                print("Se presentó el siguiente error al crear el usuario:: \(error!)")
            } else {
                print("El usuario fue creado exitosamente")
                
                Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                
                let alerta = UIAlertController(title: "Creacion de usuario", message: "Usuario \(self.emailTextField.text!) se creo correctamente", preferredStyle: .alert)
                let btnok = UIAlertAction(title: "Aceptar", style: .default, handler: {(UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                })
                alerta.addAction(btnok)
                self.present(alerta, animated: true, completion: nil)
            }
        })
    }
    
}
