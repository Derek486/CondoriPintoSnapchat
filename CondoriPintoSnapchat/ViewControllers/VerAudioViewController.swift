//
//  VerAudioViewController.swift
//  CondoriPintoSnapchat
//
//  Created by Neals Paye Aguilar on 3/06/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import AVFoundation

class VerAudioViewController: UIViewController {
    var audio = Audio()
    var audioData: Data? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMensaje.text = "Mensaje " + audio.descripcion
        reproducirrButton.isEnabled = false
        
        let storageRef = Storage.storage().reference().child("audios").child("\(audio.audioID).m4a")

        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error al descargar el audio: \(error.localizedDescription)")
            } else {
                if (data != nil) {
                    print("Longitud de los datos de audio: \((data)!.count)")
                    self.audioData = data!
                    self.reproducirrButton.isEnabled = true
                    print("Información obtenida")
                } else {
                    print("No se obtuvo información")
                }
                
            }
        }
    }
    
    @IBAction func reproducirTapped(_ sender: Any) {
        do {
            let reproducirAudio = try AVAudioPlayer(data: audioData!)
            reproducirAudio.play()
            print("Reproduciendo...")
        } catch let error {
            print("Error al reproducir el audio: \(error.localizedDescription)")
        }
    }
    
    @IBOutlet weak var reproducirrButton: UIButton!
    
    @IBOutlet weak var lblMensaje: UILabel!

    override func viewWillDisappear(_ animated: Bool) {
        
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("audios").child(audio.id).removeValue()
        
        Storage.storage().reference().child("audios").child("\(audio.audioID).m4a").delete {
            (error) in
            print("Se elimino el audio correctamente")
        }
         
    }
}
