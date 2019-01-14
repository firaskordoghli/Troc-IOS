//
//  AfficherCommentaireViewController.swift
//  Troc
//
//  Created by Belhassen LIMAM on 14/01/2019.
//  Copyright © 2019 firas.kordoghli. All rights reserved.
//

import UIKit
import Alamofire

class AfficherCommentaireViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //Utils
    var comsshow : NSArray = []
    var previousService:Int?
    let url_Com = Connexion.adresse + "/getCommentaireForService/"
    let url_addcomm = Connexion.adresse + "/addCommentaire"
    let UserDefault = UserDefaults.standard
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textcomnt: UITextField!
    
    //retour à la page précédente
    @IBAction func retour(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //Ajouter un commentaire
    @IBAction func ajouterCommentaire(_ sender: Any) {
        if textcomnt.text! != "" {
        let parameters: Parameters = ["commentaires": textcomnt.text!, "name": self.UserDefault.string(forKey: "username")!,"id_annonce": self.previousService!,"id_utilisateur": self.UserDefault.string(forKey: "id")!]
        Alamofire.request( url_addcomm, method: .post, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
            // print(response)
            //print(response.result.value)
            switch(response.result) {
            case .success(_):
                print("commentaire ajouter")
                self.textcomnt.text = ""
                self.AffichCom()
            case .failure(_):
                let alert = UIAlertController(title: "Echec", message: "Echec de reception des données", preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
            }
            
        }
        }else{
            let alert = UIAlertController(title: "Echec", message: "Veuillez écrire d'abord un commentaire", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert,animated: true,completion: nil)
        }
    }
    
    
    //nombre de ligne de la table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comsshow.count
    }
    
    //Remplir la table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Commentaires")
        
        let contentView = cell?.viewWithTag(0)
        let serviceNom = contentView?.viewWithTag(1) as! UILabel
        let serviceDate = contentView?.viewWithTag(2) as! UILabel
        let serviceCom = contentView?.viewWithTag(3) as! UITextView
        let listeCom  = comsshow[indexPath.item] as! Dictionary<String,Any>
        serviceNom.text = (listeCom["name"] as! String)
        serviceCom.text = (listeCom["commentaires"] as! String)
        serviceDate.text = (listeCom["date"] as! String)
        
        return cell!
    }
    
    //Récupérer les commentaires
    func AffichCom() {
        
        let parameters: Parameters = ["id_annonce":previousService!]
        Alamofire.request( url_Com, method: .post, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
            // print(response)
            //print(response.result.value)
            
            self.comsshow = response.result.value as! NSArray
            self.tableView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AffichCom()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
