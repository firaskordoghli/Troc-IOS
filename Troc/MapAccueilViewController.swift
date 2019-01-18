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
                let point = MyPointAnnotation()
                print(listeService["latitude"] as! Double)
                point.coordinate = CLLocationCoordinate2D(latitude: (listeService["latitude"] as! Double), longitude: (listeService["longitude"] as! Double))
                point.title = (listeService["titre"] as! String)
                point.subtitle = (listeService["description"] as! String)
                self.serviceId = (listeService["id"] as! Int)
                point.id = (listeService["id"] as! Int)
                point.categorie = (listeService["categorie"] as! String)
                
                
                
                mapView.addAnnotation(point)
                
                
                self.e = self.e + 1
                
            }
            
            
        }
        // Do any additional setup after loading the view.
        
        
        
        
    }
    
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        mapView.setCenter((mapView.userLocation?.coordinate)!, zoomLevel: 10, animated: false)
        
        
        
    }
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        // Hide the callout view.
        // mapView.deselectAnnotation(annotation, animated: true)
        
        performSegue(withIdentifier: "detailsMap", sender: view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailsMap"{
            
            if let destinationViewController =  segue.destination as? DetailsViewController{
                
                
                // destinationViewController.movieNam = moviesNames[index!.item]
                
                // destinationViewController.movieImg = moviesImg[index!.item]
                
                destinationViewController.previousService = (sender as! MyPointAnnotation).id
                destinationViewController.previousCategorie = (sender as! MyPointAnnotation).categorie
                
                
            }
        }
    }
    
  

    
}

class MyPointAnnotation: MGLPointAnnotation {
    var id: Int?
    var categorie: String?
    
}
