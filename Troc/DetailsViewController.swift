//
//  DetailsViewController.swift
//  Troc
//
//  Created by Belhassen LIMAM on 02/12/2018.
//  Copyright © 2018 firas.kordoghli. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData
import Cosmos

class DetailsViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate {
   
    //Outlets
    @IBOutlet weak var imageBanner: UIImageView!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceDesc: UITextView!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var update: UIBarButtonItem!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var rating2: CosmosView!
    @IBOutlet weak var viewColl: UIView!
    //Utils
    let URL_TestAvis = Connexion.adresse + "/testavis"
    let URL_GetAvisById = Connexion.adresse + "/getavisById"
    let url_simserv = Connexion.adresse + "/getCategorieByCategorie/"
    let url_getserv = Connexion.adresse + "/getServiceWithId/"
    let url_addavis = Connexion.adresse + "/ajoutAvis"
    var serviceNam:String?
    var serviceText:String?
    var serviceType:String?
    var previousService:Int?
    var idUser:String?
    var previousCategorie:String?
    var servicesshow : NSArray = []
    var similaresshow : NSArray = []
    var avisshow : NSArray = []
    let UserDefault = UserDefaults.standard
    
    //Retourner à la page précédente
    @IBAction func retour(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    //Aller à la page des commentaire
    @IBAction func voirCom(_ sender: Any) {
         performSegue(withIdentifier: "afficherCommentaire", sender: self)
    }
    
    @IBAction func updateServ(_ sender: Any) {
         performSegue(withIdentifier: "updateServ", sender: self)
    }
    
    @IBAction func profilCreateur(_ sender: Any) {
        performSegue(withIdentifier: "createur", sender: self)
    }
    //Récupérer l'avis de l'utilisateur'
    func testAvis() {
        
        let parameters: Parameters = ["id_user": self.UserDefault.string(forKey: "id")!, "id_service": self.previousService!]
        Alamofire.request( URL_TestAvis, method: .post, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
            // print(response)
            //print(response.result.value)
            
            
            switch(response.result) {
            case .success(_):
                let status = true
                let reponse = response.result.value as? [String: Any]
                if status == reponse!["status"] as! Bool {
                   
                    self.GetAvisById()
                }else{
                    print("avis inexistant")
                }
            case .failure(_):
                let alert = UIAlertController(title: "Echec", message: "Echec de reception des données", preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
            }
        }
        
    }
    
    
    //Récupérer l'avis de l'utilisateur'
    func GetAvisById() {
       
        let parameters: Parameters = ["id_user": self.UserDefault.string(forKey: "id")!, "id_service": self.previousService!]
        Alamofire.request( URL_GetAvisById, method: .post, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
            // print(response)
            //print(response.result.value)
            if response.result.value as? NSArray == nil {
                print("erreuuuur")
            }else{
            self.avisshow = response.result.value as! NSArray
            
            }
            
            switch(response.result) {
            case .success(_):
                self.rating.isHidden = true
                self.rating2.isHidden = false
                
                let note = self.avisshow[0] as! Dictionary<String,Any>
                self.rating2.settings.updateOnTouch = false
                self.rating2.rating = (Double(note["note"] as! Int))
                
            case .failure(_):
                let alert = UIAlertController(title: "Echec", message: "Echec de reception des données", preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
            }
        }
        
    }
    
    
    //Récupérer les services ayant une catégorie similaire
    func AffichCatSim() {
        print(previousCategorie!)
        let parameters: Parameters = ["categorie":previousCategorie!]
        Alamofire.request( url_simserv, method: .post, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
            // print(response)
            //print(response.result.value)
            if response.result.value as? NSArray == nil {
                print("erreuuuur")
            }else{
            self.similaresshow = response.result.value as! NSArray
            self.collectionView.reloadData()
            }
        }
        
    }
    
    //Remplir la collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similaresshow.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceSim", for: indexPath)
        
        let contentView = cell.viewWithTag(0)
      
        let view = contentView?.viewWithTag(4)
        let serviceTitre = contentView?.viewWithTag(1) as! UILabel
        let serviceDesc = contentView?.viewWithTag(2) as! UILabel
        let serviceImg = contentView?.viewWithTag(3) as! UIImageView
        let similareshow  = similaresshow[indexPath.item] as! Dictionary<String,Any>
        let urlImage = Connexion.adresse + "/Ressources/Services/" + ( similareshow["image"] as! String )
        serviceImg.af_setImage(withURL:URL(string: urlImage)!)
        serviceTitre.text = (similareshow["titre"] as! String)
        serviceDesc.text = (similareshow["description"] as! String)
        
        /// Adds a shadow to our view
        /*
        view!.layer.cornerRadius = 4.0
        view!.layer.shadowColor = UIColor.black.cgColor
        view!.layer.shadowOpacity = 1
        view!.layer.shadowRadius = 5
        view!.layer.shadowOffset = CGSize.zero
        */
        view!.dropShadow(color: UIColor.lightGray, opacity: 1, radius: 4, scale: true)
        cell.layer.cornerRadius = 4.0
        return cell
    }
    
    
    
    //fonction ajouter le service aux favoris
    @IBAction func insertCoreData(_ sender: Any) {
        serviceNam = serviceName.text
        serviceText = serviceDesc.text
        let serviceshow = self.servicesshow[0] as! Dictionary<String,Any>
        let imagecore = (serviceshow["image"] as! String)
        let idcore = (serviceshow["id"] as! Int)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistantContainer = appDelegate.persistentContainer
        
        let context = persistantContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Service")
        
        request.predicate = NSPredicate(format: "titre == %@", serviceName!)
        request.predicate = NSPredicate(format: "desc == %@", serviceText!)
        request.predicate = NSPredicate(format: "img == %@", imagecore)
        
        
        
        
        do {
            let resultArray = try context.fetch(request)
            if resultArray.count == 0 {
                let movieDesc = NSEntityDescription.entity(forEntityName: "Service", in: context)
                
                let newService = NSManagedObject (entity: movieDesc!, insertInto: context)
                 newService.setValue(idcore, forKey: "id")
                 newService.setValue(imagecore, forKey: "img")
                 newService.setValue(serviceNam, forKey: "titre")
                 newService.setValue(serviceText, forKey: "desc")
                
                
                
                do {
                    try context.save()
                    print ("Service Saved !!")
                } catch {
                    print("Error !")
                }
            }else{
                let alert = UIAlertController(title: "Duplication", message: "Le service est déjà dans vos favoris", preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
            }
        } catch {
            print("error")
        }
        
    }
    
    //Afficher le service
    func AfficheService() {
       
            let parameters: Parameters = ["id": String(previousService!)]
        Alamofire.request( url_getserv, method: .post, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
            // print(response)
            //print(response.result.value)
            if response.result.value as? NSArray == nil {
                print("erreuuuur")
            }else{
            self.servicesshow = response.result.value as! NSArray
            let serviceshow = self.servicesshow[0] as! Dictionary<String,Any>
            self.serviceName.text = (serviceshow["titre"] as! String)
            self.serviceDesc.text = (serviceshow["description"] as! String)
            self.idUser = (serviceshow["idUser"] as! String)
            if self.UserDefault.string(forKey: "id")! == self.idUser! {
                self.update.isEnabled = true
                self.view2.isHidden = true
            }else{
                self.update.isEnabled = false
                self.view2.isHidden = false
            }
            let urlImage = Connexion.adresse + "/Ressources/Services/" + ( serviceshow["image"] as! String )
           self.imageBanner.af_setImage(withURL:URL(string: urlImage)!)
            self.serviceType = (serviceshow["type"] as! String)
        }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "afficherCommentaire"{
            
            if let destinationViewController =  segue.destination as? AfficherCommentaireViewController{
                
                destinationViewController.previousService = self.previousService!
                
                
                
                
            }
        } else if segue.identifier == "updateServ"{
            
            if let destinationViewController =  segue.destination as? UpdateServiceViewController{
                
                destinationViewController.idService = self.previousService!
                destinationViewController.titre = serviceName.text!
                destinationViewController.descriptionserv = serviceDesc.text!
                destinationViewController.type = self.serviceType!
                destinationViewController.categorie = self.previousCategorie
                
                
                
            }
        }
        else if segue.identifier == "createur"{
            
            if let destinationViewController =  segue.destination as? CreateurViewController{
                
                destinationViewController.previousId = self.idUser!
                
                
                
            }
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        testAvis()
        AfficheService()
        AffichCatSim()
        
        rating.didFinishTouchingCosmos = { rating in
            
            let parameters: Parameters = ["id_user": self.UserDefault.string(forKey: "id")!, "id_service": self.previousService!,"note": rating]
            Alamofire.request( self.url_addavis, method: .post, parameters: parameters).responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")
                
                switch(response.result) {
                case .success(_):
                    let alert = UIAlertController(title: "Succés", message: "Votre avis à été ajouter avec succés", preferredStyle: .alert)
                    let action = UIAlertAction(title: "ok", style: .cancel, handler: {(UIAlertAction) in
                        self.testAvis()
                    })
                    alert.addAction(action)
                    self.present(alert,animated: true,completion: nil)
                    
                    
                    
                case .failure(_):
                    let alert = UIAlertController(title: "Echec", message: "Votre avis n'a pas pu être ajouter", preferredStyle: .alert)
                    let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert,animated: true,completion: nil)
                    
                }
                
                // print(response)
                //print(response.result.value)
                
                
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testAvis()
        AfficheService()
        AffichCatSim()
        self.imageBanner.layer.cornerRadius = 20
        self.imageBanner.clipsToBounds = true
        self.imageBanner.layer.borderColor = UIColor.black.cgColor
        self.imageBanner.layer.borderWidth = 2
        
        rating.didFinishTouchingCosmos = { rating in
            
            let parameters: Parameters = ["id_user": self.UserDefault.string(forKey: "id")!, "id_service": self.previousService!,"note": rating]
            Alamofire.request( self.url_addavis, method: .post, parameters: parameters).responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")
                
                switch(response.result) {
                case .success(_):
                    let alert = UIAlertController(title: "Succés", message: "Votre avis à été ajouter avec succés", preferredStyle: .alert)
                    let action = UIAlertAction(title: "ok", style: .cancel, handler: {(UIAlertAction) in
                        self.testAvis()
                    })
                    alert.addAction(action)
                    self.present(alert,animated: true,completion: nil)
                    
                    
                    
                case .failure(_):
                    let alert = UIAlertController(title: "Echec", message: "Votre avis n'a pas pu être ajouter", preferredStyle: .alert)
                    let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert,animated: true,completion: nil)
                    
                }
                
                // print(response)
                //print(response.result.value)
               
            
            }
            
        }
        // Do any additional setup after loading the view.
    }
    
  

    

   

}
