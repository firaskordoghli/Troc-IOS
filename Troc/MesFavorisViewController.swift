//
//  MesFavorisViewController.swift
//  Troc
//
//  Created by Belhassen LIMAM on 17/01/2019.
//  Copyright © 2019 firas.kordoghli. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData

class MesFavorisViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    

    var servicesArray: [NSManagedObject] = []
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidAppear(_ animated: Bool) {
        GetFavoris()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetFavoris()
        // Do any additional setup after loading the view.
    }
    //Retourner à la page précédente
    @IBAction func retour(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func supprimerFavoris(_ sender: UIButton) {
        
       
        
    }
    
    //Avoir les favoris depuis le coreData
    func GetFavoris() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject> (entityName: "Service")
        
        do {
            servicesArray = try context.fetch(request)
            collectionView.reloadData()
        } catch  {
            print ("Error!")
        }
    }
    
    
    
    
    //Remplir la collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return servicesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MesAnnonces", for: indexPath)
        let contentView = cell.viewWithTag(0)
        
        //Design collection view
        contentView!.layer.cornerRadius = 6.0
        contentView!.layer.borderWidth = 1.0
        contentView!.layer.borderColor = UIColor.black.cgColor
        contentView!.layer.masksToBounds = true
        
        let servicesImg = contentView!.viewWithTag(1) as! UIImageView
        let servicesTitre = contentView!.viewWithTag(2) as! UILabel
        let servicesDesc = contentView!.viewWithTag(3) as! UILabel
        
        

        let service = servicesArray[indexPath.row]
        if (service.value(forKey: "img") as! String) != ""{
            let urlImage = Connexion.adresse + "/Ressources/Services/" + (service.value(forKey: "img") as! String)
            servicesImg.af_setImage(withURL:URL(string: urlImage)!)
            
        }
        servicesTitre.text =  (service.value(forKey: "titre") as! String)
        servicesDesc.text = (service.value(forKey: "desc") as! String)
        
        
        
        //Design Image
        servicesImg.layer.cornerRadius = 20
        servicesImg.clipsToBounds = true
        servicesImg.layer.borderColor = UIColor.black.cgColor
        servicesImg.layer.borderWidth = 2
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let serviceToDelete =  servicesArray[indexPath.item]
        context.delete(serviceToDelete)
        do{
            try context.save()
            servicesArray.remove(at: indexPath.item)
            collectionView.reloadData()
        }catch{
            print("Error")
        }
    }
    
}



