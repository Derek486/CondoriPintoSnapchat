//
//  AudiosViewController.swift
//  CondoriPintoSnapchat
//
//  Created by Neals Paye Aguilar on 3/06/24.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class AudiosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var audios: [Audio] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if audios.count == 0 {
            return 1
        } else {
            return audios.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "audioRow", for: indexPath)
        if audios.count == 0 {
            cell.textLabel?.text = "No tienes audios 🥑"
        } else {
            let audio = audios[indexPath.row]
            cell.textLabel?.text = audio.from
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let audio = audios[indexPath.row]
        performSegue(withIdentifier: "veraudiosegue", sender: audio)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "veraudiosegue" {
            let next = segue.destination as! VerAudioViewController
            next.audio = sender as! Audio
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("audios").observe(DataEventType.childAdded, with: {(snapshot) in
            let audio = Audio()
            audio.audioURL = (snapshot.value as! NSDictionary)["audioURL"] as! String
            audio.from = (snapshot.value as! NSDictionary)["from"] as! String
            audio.descripcion = (snapshot.value as! NSDictionary)["descripcion"] as! String
            audio.id = snapshot.key
            audio.audioID = (snapshot.value as! NSDictionary) ["audioID"] as! String
            self.audios.append(audio)
            self.tableView.reloadData()
            
        })
        
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("audios").observe(DataEventType.childRemoved, with: { (snapshot) in
            var iterator = 0
            for audio in self.audios {
                if audio.id == snapshot.key {
                    self.audios.remove(at: iterator)
                }
                iterator += 1
            }
            self.tableView.reloadData()
        })
        
    }
}
