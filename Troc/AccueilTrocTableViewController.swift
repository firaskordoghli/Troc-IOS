//
//  AccueilTrocTableViewController.swift
//  Troc
//
//  Created by Belhassen LIMAM on 09/12/2018.
//  Copyright © 2018 firas.kordoghli. All rights reserved.
//

import UIKit
import Alamofire




class AccueilTrocTableViewController: UITableViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
   var similaresshow : NSArray = []
   var similaresserv : NSArray = []
   var categories : NSArray = []
   var serviceId: Int?
   var serviceCategorie: String?
   
    
    
    @IBOutlet weak var collecInf: UICollectionView!
    @IBOutlet weak var collecCatg: UICollectionView!
    @IBOutlet weak var collecServ: UICollectionView!
    
    
    
    var categorieInf = "Informatique/Multimédia"
    var typeserv = "Service"
    
    func Fetchcategories() {
        let url = "http://localhost:3000/getcategories"
        Alamofire.request(url).responseJSON{
            response in
            print(response)
            self.categories = response.result.value as! NSArray
            self.collecCatg.reloadData()
            
        }
        
    }
    
    func FetchDataServ() {
        let url = "http://localhost:3000/getServType/"
        let parameters: Parameters = ["type":"'"+typeserv+"'"]
        Alamofire.request( url, method: .post, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
            // print(response)
            //print(response.result.value)
            if response.result.value == nil {
                let alert = UIAlertController(title: "Echec", message: "La connexion au serveur à échoué", preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
                
            }else{
            self.similaresserv = response.result.value as! NSArray
            self.collecServ.reloadData()
            }
        }
        
    }
    
    func FetchDataSim() {
        let url = "http://localhost:3000/getSim/"
        let parameters: Parameters = ["categorie":"'"+categorieInf+"'"]
        Alamofire.request( url, method: .post, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
            // print(response)
            //print(response.result.value)
            
            self.similaresshow = response.result.value as! NSArray
            self.collecInf.reloadData()
            
        }
         
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collecInf{
        return similaresshow.count
        }else if collectionView == collecServ {
            return similaresserv.count
        }else{
            return categories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        if collectionView == collecInf {
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "Informatiques", for: indexPath)
            
            let contentView = cellA.viewWithTag(0)
            let serviceTitre = contentView?.viewWithTag(2) as! UILabel
            let similareshow  = similaresshow[indexPath.item] as! Dictionary<String,Any>
            
            serviceTitre.text = (similareshow["titre"] as! String)
        
            return cellA
        }
        else if collectionView == collecServ{
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "Services", for: indexPath)
            
            let contentView = cellB.viewWithTag(0)
            let serviceTitre2 = contentView?.viewWithTag(4) as! UILabel
            let similareserv  = similaresserv[indexPath.item] as! Dictionary<String,Any>
            
            serviceTitre2.text = (similareserv["titre"] as! String)
            
            return cellB
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
        }else{
            performSegue(withIdentifier: "serviceDetails", sender: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let index = sender as? NSIndexPath
        
        let serviceshow  = similaresshow[ index!.item] as! Dictionary<String,Any>
        let similareserv  = similaresserv[ index!.item] as! Dictionary<String,Any>
        
        
        
        if segue.identifier == "accueilDetails"{
            serviceId = (serviceshow["id"] as! Int)
            serviceCategorie = (serviceshow["categorie"] as! String)
            if let destinationViewController =  segue.destination as? DetailsViewController{
                
                
                // destinationViewController.movieNam = moviesNames[index!.item]
                
                // destinationViewController.movieImg = moviesImg[index!.item]
                
                destinationViewController.previousService = serviceId
                destinationViewController.previousCategorie = serviceCategorie
                
                
            }
        }else if segue.identifier == "serviceDetails"{
            serviceId = (similareserv["id"] as! Int)
            serviceCategorie = (similareserv["categorie"] as! String)
            if let destinationViewController =  segue.destination as? DetailsViewController{
                
                destinationViewController.previousService = serviceId
                destinationViewController.previousCategorie = serviceCategorie
                
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FetchDataServ()
        FetchDataSim()
        Fetchcategories()
        
    }
    
  

}
