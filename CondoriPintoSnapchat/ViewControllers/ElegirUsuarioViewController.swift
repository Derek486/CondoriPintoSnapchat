//
//  ElegirUsuarioViewController.swift
//  CondoriPintoSnapchat
//
//  Created by Neals Paye Aguilar on 27/05/24.
//

import UIKit
import Firebase
import FirebaseDatabase

class ElegirUsuarioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var usuarios:[Usuario] = []
    var imageURL = ""
    var descrip = ""
    var imagenID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        listaUsuarios.delegate = self
        listaUsuarios.dataSource = self
        Database.database().reference().child("usuarios").observe(DataEventType.childAdded, with: {(snapshot) in
            print(snapshot)
            let usuario = Usuario()
            usuario.email = (snapshot.value as! NSDictionary)["email"] as! String
            usuario.uid = snapshot.key
            self.usuarios.append(usuario)
            self.listaUsuarios.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let usuario = usuarios[indexPath.row]
        cell.textLabel?.text = usuario.email
        return cell
    }
    
    @IBOutlet weak var listaUsuarios: UITableView!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usuario = usuarios[indexPath.row]
        let snap = ["from": Auth.auth().currentUser?.email, "descripcion": descrip, "imagenURL": imageURL, "imagenID": imagenID]
        
        Database.database().reference().child("usuarios").child(usuario.uid).child("snaps")
            .childByAutoId().setValue(snap)
        
        navigationController?.popViewController(animated: true)
    }

}
