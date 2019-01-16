//
//  AccueilTrocTableViewController.swift
//  Troc
//
//  Created by Belhassen LIMAM on 09/12/2018.
//  Copyright © 2018 firas.kordoghli. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage




class AccueilTrocTableViewController: UITableViewController,UICollectionViewDelegate,UICollectionViewDataSource {
   
   //Utils
   var similaresshow : NSArray = []
   var similaresserv : NSArray = []
   var similarvets : NSArray = []
   var categories : NSArray = []
   var serviceId: Int?
   var serviceCategorie: String?
   let url_Cat = Connexion.adresse + "/getcategorie"
   let url_ani = Connexion.adresse + "/getCategorieAnimaux"
   let url_Inf = Connexion.adresse + "/getCategorieInformatique"
   let url_Vet = Connexion.adresse + "/getCategorieVetement'"
   //Outlets
   @IBOutlet weak var collecInf: UICollectionView!
   @IBOutlet weak var collecCatg: UICollectionView!
   @IBOutlet weak var collecServ: UICollectionView!
   @IBOutlet weak var collecVet: UICollectionView!
    
    
    //Afficher plus informatique
    @IBAction func afficherInfo(_ sender: Any) {
        performSegue(withIdentifier: "informatique", sender: self)
    }
    
    //Afficher plus animaux
    @IBAction func afficherAnimaux(_ sender: Any) {
        performSegue(withIdentifier: "animaux", sender: self)
    }
    
    //Afficher vêtement
    @IBAction func afficherVetement(_ sender: Any) {
        performSegue(withIdentifier: "vetement", sender: self)
    }
    
    //Afficher les catégories
    func Fetchcategories() {
        
        Alamofire.request(url_Cat).responseJSON{
            response in
            print(response)
            if response.result.value as? NSArray == nil {
                print("erreuuuur")
            }else{
            self.categories = response.result.value as! NSArray
            self.collecCatg.reloadData()
            
        }
        }
    }
    
    //Afficher les services ayant comme catégorie 'Animaux'
    func FetchDataAni() {
        
        Alamofire.request(url_ani).responseJSON{
            response in
            print(response)
            if response.result.value as? NSArray == nil {
                print("erreuuuur")
            }else{
            self.similaresserv = response.result.value as! NSArray
            self.collecServ.reloadData()
            }
        }
        
    }
    
    func fetchVet () {
    
        Alamofire.request(url_Vet).responseJSON{
            response in
            print(response)
            if response.result.value as? NSArray == nil {
                print("erreuuuur")
            }else{
                self.similarvets = response.result.value as! NSArray
                self.collecVet.reloadData()
            }
        }
    }
    
    //Afficher les services ayant comme catégorie 'Informatique/multimédia'
    func FetchDataInf() {
        Alamofire.request(url_Inf).responseJSON{
            response in
            print(response)
            if response.result.value as? NSArray == nil {
                print("erreuuuur")
            }else{
            self.similaresshow = response.result.value as! NSArray
            self.collecInf.reloadData()
            
        }
        }
         
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collecInf{
        return similaresshow.count
        }else if collectionView == collecServ {
            return similaresserv.count
        }
        else if collectionView == collecVet {
            return similarvets.count
        }
        else {
            return categories.count
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collecInf {
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "Informatiques", for: indexPath)
            
            let contentView = cellA.viewWithTag(0)
            let serviceImage = contentView?.viewWithTag(1) as! UIImageView
            let serviceTitre = contentView?.viewWithTag(2) as! UILabel
            let similareshow  = similaresshow[indexPath.item] as! Dictionary<String,Any>
            serviceTitre.text = (similareshow["titre"] as! String)
            let urlImage = Connexion.adresse + "/Ressources/Services/" + ( similareshow["image"] as! String )
            serviceImage.af_setImage(withURL:URL(string: urlImage)!)
           
           
            return cellA
        }
        else if collectionView == collecServ{
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "Services", for: indexPath)
            
            let contentView = cellB.viewWithTag(0)
            let serviceImage = contentView?.viewWithTag(7) as! UIImageView
            let serviceTitre2 = contentView?.viewWithTag(4) as! UILabel
            let similareserv  = similaresserv[indexPath.item] as! Dictionary<String,Any>
            let urlImage = Connexion.adresse + "/Ressources/Services/" + ( similareserv["image"] as! String )
            serviceImage.af_setImage(withURL:URL(string: urlImage)!)
            
            serviceTitre2.text = (similareserv["titre"] as! String)
            
            return cellB
        }
        else if collectionView == collecVet{
            let cellD = collectionView.dequeueReusableCell(withReuseIdentifier: "Mieuxnotes", for: indexPath)
            
            let contentView = cellD.viewWithTag(0)
            let serviceImage = contentView?.viewWithTag(3) as! UIImageView
            let serviceTitre2 = contentView?.viewWithTag(6) as! UILabel
            let similarevet  = similarvets[indexPath.item] as! Dictionary<String,Any>
            let urlImage = Connexion.adresse + "/Ressources/Services/" + ( similarevet["image"] as! String )
            serviceImage.af_setImage(withURL:URL(string: urlImage)!)
            serviceTitre2.text = (similarevet["titre"] as! String)
            
            return cellD
        }
        else {
            let cellC = collectionView.dequeueReusableCell(withReuseIdentifier: "Categories", for: indexPath)
            cellC.layer.borderColor = UIColor.black.cgColor
            cellC.layer.borderWidth = 0.5
            let contentView = cellC.viewWithTag(0)
            let serviceTitre2 = contentView?.viewWithTag(5) as! UILabel
            let categorie  = categories[indexPath.item] as! Dictionary<String,Any>
            serviceTitre2.text = (categorie["categorie"] as! String)
            
            return cellC
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collecInf{
         performSegue(withIdentifier: "accueilDetails", sender: indexPath)
        }else if collectionView == collecServ{
         performSegue(withIdentifier: "serviceDetails", sender: indexPath)
        }else{
         performSegue(withIdentifier: "afficherPlus", sender: indexPath)
        }
    }
    
    //Donner à envoyer à la prochaine view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let index = sender as? NSIndexPath
        
        
        
        
        
        
        
        if segue.identifier == "accueilDetails"{
            let serviceshow  = similaresshow[ index!.item] as! Dictionary<String,Any>
            serviceId = (serviceshow["id"] as! Int)
            serviceCategorie = (serviceshow["categorie"] as! String)
            if let destinationViewController =  segue.destination as? DetailsViewController{
                
                destinationViewController.previousService = serviceId
                destinationViewController.previousCategorie = serviceCategorie
                
                
            }
        }else if segue.identifier == "serviceDetails"{
            let similareserv  = similaresserv[ index!.item] as! Dictionary<String,Any>
            serviceId = (similareserv["id"] as! Int)
            serviceCategorie = (similareserv["categorie"] as! String)
            if let destinationViewController =  segue.destination as? DetailsViewController{
                
                destinationViewController.previousService = serviceId
                destinationViewController.previousCategorie = serviceCategorie
                
            }
        }
        else if segue.identifier == "afficherPlus"{
            let categorie  = categories[index!.item] as! Dictionary<String,Any>
            serviceCategorie = (categorie["categorie"] as! String)
            if let destinationViewController =  segue.destination as? AccueilViewController{
                destinationViewController.previousCategorie = serviceCategorie
                
            }
        }
        else if segue.identifier == "informatique"{
            let cat = "Informatique/Multimédia"
            if let destinationViewController =  segue.destination as? AccueilViewController{
                destinationViewController.previousCategorie = cat
                
            }
        }
        else if segue.identifier == "vetement"{
            let catv = "Vêtements et accessoires"
            if let destinationViewController =  segue.destination as? AccueilViewController{
                destinationViewController.previousCategorie = catv
                
            }
        }
        else if segue.identifier == "animaux"{
            let cat = "animaux"
            if let destinationViewController =  segue.destination as? AccueilViewController{
                destinationViewController.previousCategorie = cat
                
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
    }
    override func viewWillAppear(_ animated: Bool) {
        FetchDataAni()
        FetchDataInf()
        Fetchcategories()
        fetchVet ()
    }
    
  

}
