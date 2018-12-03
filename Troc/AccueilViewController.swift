//
//  AccueilViewController.swift
//  Troc
//
//  Created by Besbes Ahmed on 11/25/18.
//  Copyright © 2018 firas.kordoghli. All rights reserved.
//

import UIKit
import Alamofire

class AccueilViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let url = "http://localhost:3000/getService"
    let defaults = UserDefaults.standard
    var listeServices : NSArray = []
    var serviceId: Int?
    var serviceCategorie: String?

    @IBOutlet weak var tableView: UITableView!
    
    
    
    func FetchData() {
        Alamofire.request(url).responseJSON{
            response in
            // print(response)
            
            self.listeServices = response.result.value as! NSArray
            
            
            
            self.tableView.reloadData()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listeServices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Services")
        
        let contentView = cell?.viewWithTag(0)
        
        let serviceTitre = contentView?.viewWithTag(1) as! UILabel
        
        let serviceDesc = contentView?.viewWithTag(2) as! UILabel
        
        let listeService  = listeServices[indexPath.item] as! Dictionary<String,Any>
        
        serviceTitre.text = (listeService["titre"] as! String)
        serviceDesc.text = (listeService["description"] as! String)
       
        return cell!

    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let index = sender as? NSIndexPath
        
        let serviceshow  = listeServices[ index!.item] as! Dictionary<String,Any>
      
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
        
        var logged = defaults.bool(forKey: "log")
        if logged == true {
            FetchData()
        }else{
            let next = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as! UIViewController
            self.present(next, animated: true, completion: nil)
        }
        
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
