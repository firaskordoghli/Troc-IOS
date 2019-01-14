//
//  AjouterServiceEtape3ViewController.swift
//  Troc
//
//  Created by Belhassen LIMAM on 13/01/2019.
//  Copyright © 2019 firas.kordoghli. All rights reserved.
//

import UIKit
import MapKit

class AjouterServiceEtape3ViewController: UIViewController {
  
    //Utils
    var categories : String?
    var titre : String?
    var descriptionserv: String?
    var type : String?
    var image = UIImage()
    var latitude: Double?
    var longitude : Double?
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locManager.location  else {
                return
            }
        latitude = currentLocation.coordinate.latitude
        longitude = currentLocation.coordinate.longitude
            
        
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func suivant(_ sender: Any) {
        self.performSegue(withIdentifier: "derniereEtape", sender: self)
    }
    
    @IBAction func retour(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if segue.identifier == "derniereEtape"{
            
            if let destinationViewController =  segue.destination as? AjoutServiceFinViewController{
                
                destinationViewController.categories = self.categories!
                destinationViewController.descriptionserv = self.descriptionserv!
                destinationViewController.titre = self.titre!
                destinationViewController.type = self.type!
                destinationViewController.image = self.image
                destinationViewController.latitude = self.latitude
                destinationViewController.longitude = self.longitude
                
                
                
            }
        }
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
