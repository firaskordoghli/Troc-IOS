//
//  AccueilViewController.swift
//  Troc
//
//  Created by Besbes Ahmed on 11/25/18.
//  Copyright © 2018 firas.kordoghli. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class AccueilViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let url_simserv = Connexion.adresse + "/getCategorieByCategorie/"
    var similaresshow : NSArray = []
    var serviceId: Int?
    var serviceCategorie: String?
    var previousCategorie:String?

    @IBOutlet weak var tableView: UITableView!
    
    
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
            
            self.similaresshow = response.result.value as! NSArray
            self.tableView.reloadData()
        }
        
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return similaresshow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Services")
        
        let contentView = cell?.viewWithTag(0)
        
        let serviceTitre = contentView?.viewWithTag(1) as! UILabel
        
        let serviceDesc = contentView?.viewWithTag(2) as! UILabel
        
        let listeService  = similaresshow[indexPath.item] as! Dictionary<String,Any>
        
        serviceTitre.text = (listeService["titre"] as! String)
        serviceDesc.text = (listeService["description"] as! String)
       
        return cell!

    }
    
    
    @IBAction func retour(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let index = sender as? NSIndexPath
        
        let serviceshow  = similaresshow[ index!.item] as! Dictionary<String,Any>
      
        serviceId = (serviceshow["id"] as! Int)
        serviceCategorie = (serviceshow["categorie"] as! String)
        if segue.identifier == "toDetails"{
            
            if let destinationViewController =  segue.destination as? DetailsViewController{
                
                
                // destinationViewController.movieNam = moviesNames[index!.item]
                
                // destinationViewController.movieImg = moviesImg[index!.item]
                
                destinationViewController.previousService = serviceId
                destinationViewController.previousCategorie = serviceCategorie
               
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toDetails", sender: indexPath)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       AffichCatSim()
      
        
        // Do any additional setup after loading the view.
    }
    
    
    
    ////Navigation bar control//////
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }


}
