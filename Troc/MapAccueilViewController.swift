//
//  MapAccueilViewController.swift
//  Troc
//
//  Created by Belhassen LIMAM on 14/01/2019.
//  Copyright © 2019 firas.kordoghli. All rights reserved.
//

import UIKit
import Mapbox
import Alamofire

class MapAccueilViewController: UIViewController , MGLMapViewDelegate{
    
    //Utils
    let url = Connexion.adresse + "/getService"
    var listeServices : NSArray = []
    var serviceId: Int?
    var serviceCategorie: String?
    var e = 0
    
   

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 40.74699, longitude: -73.98742), zoomLevel: 9, animated: false)
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.showsUserLocation = true
        Alamofire.request(url).responseJSON{
            response in
            self.listeServices = response.result.value as! NSArray
            print(response)
            
            while self.e < self.listeServices.count {
                
                let listeService  = self.listeServices[self.e] as! Dictionary<String,Any>
                let point = MGLPointAnnotation()
                print(listeService["latitude"] as! Double)
                point.coordinate = CLLocationCoordinate2D(latitude: (listeService["longitude"] as! Double), longitude: (listeService["latitude"] as! Double))
                point.title = (listeService["titre"] as! String)
                point.subtitle = (listeService["description"] as! String)
                mapView.addAnnotation(point)
                self.e = self.e + 1
                
            }
            
            
            }
        
        
    }
    
    
    
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        mapView.setCenter((mapView.userLocation?.coordinate)!, zoomLevel: 10, animated: false)
        
        
        
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
