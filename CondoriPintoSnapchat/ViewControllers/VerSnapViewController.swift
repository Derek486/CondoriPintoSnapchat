//
//  VerSnapViewController.swift
//  CondoriPintoSnapchat
//
//  Created by Neals Paye Aguilar on 3/06/24.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseDatabase
import FirebaseStorage

class VerSnapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        lblMensaje.text = "Mensaje " + snap.descripcion
        imageView.sd_setImage(with: URL(string: snap.imagenURL), completed: nil)
    }
    
    var snap = Snap()
    @IBOutlet weak var lblMensaje: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewWillDisappear(_ animated: Bool) {
        
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.id).removeValue()
        
        Storage.storage().reference().child("imagenes").child("\(snap.imagenID).jpg").delete {
            (error) in
            print("Se elimino la imagen correctamente")
        }
    }

}
