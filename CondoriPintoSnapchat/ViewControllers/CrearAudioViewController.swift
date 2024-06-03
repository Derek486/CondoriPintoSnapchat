//
//  CrearAudioViewController.swift
//  CondoriPintoSnapchat
//
//  Created by Neals Paye Aguilar on 3/06/24.
//

import UIKit
import Firebase
import FirebaseStorage
import AVFoundation

class CrearAudioViewController: UIViewController {
        
        @IBOutlet weak var agregarButton: UIButton!
        @IBOutlet weak var nombreTextField: UITextField!
        @IBOutlet weak var reproducirButton: UIButton!
        @IBOutlet weak var grabarButton: UIButton!
        @IBOutlet weak var elegirContactoButton: UIButton!
    
        var grabarAudio: AVAudioRecorder?
        var reproducirAudio: AVAudioPlayer?
        var audioURL: URL?
        var audioId = NSUUID().uuidString
        
        override func viewDidLoad() {
            super.viewDidLoad()

            configurarGrabacion()
            reproducirButton.isEnabled = false
            agregarButton.isEnabled = false
        }
        
        func configurarGrabacion() {
        do {
        
            let session = AVAudioSession.sharedInstance()
            try session.setCategory (AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: [])
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            //creando direccion para el archivo de audio
            let basePath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,
            true).first!
            let pathComponents = [basePath, "\(audioId).m4a"]
            audioURL = NSURL.fileURL (withPathComponents: pathComponents)!
            //impresion de ruta donde se guardan los archivos
            print("*********************")
            print(audioURL!)
            print("*********************")
            //crear opciones para el grabador de audio
            var settings: [String: AnyObject] = [:]
            settings [AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            //crear el objeto de grabacion de audio
            grabarAudio = try AVAudioRecorder (url: audioURL!, settings: settings)
            grabarAudio!.prepareToRecord()
        }catch let error as NSError{
            print(error)
        }
        }
        
    
    @IBAction func agregarTapped(_ sender: Any) {
            let grabacion = Audio()
            let storageRef = Storage.storage().reference().child("audios").child(audioId + ".m4a")
            storageRef.putFile(from: audioURL!, metadata: nil) {(meta, error) in
                if error != nil {
                    self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir el audio. Verifique su conexión a internet y vuelva a intentarlo", accion: "Aceptar")
                    self.elegirContactoButton.isEnabled = true
                    print("Ocurrio un error al subir el audio: \(error!)")
                    return
                } else {
                    storageRef.downloadURL(completion: { (url, error) in
                        guard let enlaceURL = url else {
                            self.mostrarAlerta(titulo: "Error", mensaje: "Se obtuvo un error al intentar obtener información de audio", accion: "Cancelar")
                            self.elegirContactoButton.isEnabled = true
                            print("Ocurrió un error la obtener información de audio \(error)")
                            return
                            
                        }
                        self.performSegue(withIdentifier: "seleccionarContactoSegueAudio", sender: url?.absoluteString)
                    })
                }
            }
        }
    
    @IBAction func reproducirTapped(_ sender: Any) {
            do {
                try reproducirAudio = AVAudioPlayer(contentsOf: audioURL!)
                reproducirAudio!.play()
                print("Reproduciendo...")
            } catch {}
        }
    

    @IBAction func grabarTapped(_ sender: Any) {
            if grabarAudio!.isRecording {
                grabarAudio?.stop()
                grabarButton?.setTitle("GRABAR", for: .normal)
                do {
                    let audio = try AVAudioPlayer(contentsOf: audioURL!)
                    let formatter = DateComponentsFormatter()
                    formatter.allowedUnits = [.hour, .minute, .second]
                    formatter.unitsStyle = .short
                } catch {}
                reproducirButton.isEnabled = true
                agregarButton.isEnabled = true
            } else {
                grabarAudio?.record()
                grabarButton.setTitle("DETENER", for: .normal)
                reproducirButton.isEnabled = false
            }
        }

    func mostrarAlerta(titulo: String, mensaje: String, accion: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextvc = segue.destination as! ElegirUsuarioViewController
        nextvc.descrip = nombreTextField.text!
        nextvc.type = "audio"
        nextvc.audioURL = (sender as! String)
        nextvc.audioID = audioId
    }
}
