//
//  CreateurViewController.swift
//  Troc
//
//  Created by Belhassen LIMAM on 16/01/2019.
//  Copyright © 2019 firas.kordoghli. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class CreateurViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
        //Utils
    var previousId : String?
    let url_getcreateur = Connexion.adresse + "/getUserWithId/"
    let url_servicecrea = Connexion.adresse + "/getAllServiceForUser/"
    var createurs : NSArray = []
    var services : NSArray = []
    var serviceId : Int?
    var serviceCat : String?
    //Outlets
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var identifiantProfile: UILabel!
    @IBOutlet weak var telephoneProfile: UILabel!
    @IBOutlet weak var emailProfile: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCreateur()
        getServices()
        self.imageProfile.layer.cornerRadius = 20
        self.imageProfile.clipsToBounds = true
        self.imageProfile.layer.borderColor = UIColor.black.cgColor
        self.imageProfile.layer.borderWidth = 2
        
    }
    
    //Gérer contenu de la collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return services.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Offres", for: indexPath)
        
        let contentView = cell.viewWithTag(0)
        
        let serviceTitre = contentView?.viewWithTag(2) as! UILabel
        let serviceCat = contentView?.viewWithTag(3) as! UILabel
        let serviceImg = contentView?.viewWithTag(1) as! UIImageView
        let service  = services[indexPath.item] as! Dictionary<String,Any>
        let urlImage = Connexion.adresse + "/Ressources/Services/" + ( service["image"] as! String )
        serviceImg.af_setImage(withURL:URL(string: urlImage)!)
        serviceTitre.text = (service["titre"] as! String)
        serviceCat.text = (service["categorie"] as! String)
        
        return cell
    }
    
    
    //Avoir tous les services du créateur
    func getServices(){
        
        let parameters: Parameters = ["idUser": previousId!]
        Alamofire.request( url_servicecrea, method: .post, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
            // print(response)
            //print(response.result.value)
            if response.result.value as? NSArray == nil {
                print("erreuuuur")
            }else{
                self.services = response.result.value as! NSArray
                self.collectionView.reloadData()
                
            }
        }
        
    }
    
    
    
    //Avoir info créateur
    func fetchCreateur(){
        
        let parameters: Parameters = ["id": previousId!]
        Alamofire.request( url_getcreateur, method: .post, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
            // print(response)
            //print(response.result.value)
            if response.result.value as? NSArray == nil {
                print("erreuuuur")
            }else{
                self.createurs = response.result.value as! NSArray
                let profilcrea  = self.createurs[0] as! Dictionary<String,Any>
                self.emailProfile.text = ( profilcrea["email"] as! String )
                self.identifiantProfile.text = ( profilcrea["username"] as! String )
                self.telephoneProfile.text = String( profilcrea["phone"] as! Int )
                let urlImage = Connexion.adresse + "/Ressources/Profiles/" + ( profilcrea["image"] as! String )
                self.imageProfile.af_setImage(withURL:URL(string: urlImage)!)
                
                
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            performSegue(withIdentifier: "offreCrea", sender: indexPath)
        
    }
    
    //Donner à envoyer à la prochaine view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let index = sender as? NSIndexPath
        
        let service  = services[ index!.item] as! Dictionary<String,Any>
        
        
        
        
        if segue.identifier == "offreCrea"{
            serviceId = (service["id"] as! Int)
            serviceCat = (service["categorie"] as! String)
            if let destinationViewController =  segue.destination as? DetailsViewController{
                
                destinationViewController.previousService = serviceId
                destinationViewController.previousCategorie = serviceCat
               
                
                
            }
        }
    }
    
    
    
    //Bouton retour
    @IBAction func retour(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
