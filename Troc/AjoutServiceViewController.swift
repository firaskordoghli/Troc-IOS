//
//  AjoutServiceViewController.swift
//  Troc
//
//  Created by Belhassen LIMAM on 30/11/2018.
//  Copyright © 2018 firas.kordoghli. All rights reserved.
//

import UIKit

class AjoutServiceViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    //outlets
    @IBOutlet weak var titre: UITextField!
    @IBOutlet var desc: UITextField!
    @IBOutlet weak var categorie: UIPickerView!
    @IBOutlet weak var type: UISegmentedControl!
    //utils
    var categorieData : [String] = [String]()
    var categories = ""
    var types = ""
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categorieData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categorieData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let valueSelected = categorieData[row] as String
        print(valueSelected)
        categories = valueSelected
    }
    
    @IBAction func getType(_ sender: Any) {
        let seg = type.selectedSegmentIndex
        if seg == 0 {
            types = "Bien"
        }else{
            types = "Service"
        }
       
    }
    
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        titre.resignFirstResponder()
        desc.resignFirstResponder()
        categorie.resignFirstResponder()
        type.resignFirstResponder()
    }
    
    
    //Action pour ajouter le service
    @IBAction func addService(_ sender: Any) {
      
        if (titre.text! == "") || (desc.text! == "") || (categories == "") || (types == "") {
            
            let alert = UIAlertController(title: "", message: "Veuillez remplir tous les champs et choisir une catégorie", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert,animated: true,completion: nil)
            
        }else{
                self.performSegue(withIdentifier: "etape2", sender: self)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if segue.identifier == "etape2"{
            
            if let destinationViewController =  segue.destination as? AjouterServiceEtape2ViewController{
                
                destinationViewController.categories = self.categories
                destinationViewController.descriptionserv = self.desc.text!
                destinationViewController.titre = self.titre.text!
                destinationViewController.type = self.types
                
                
            }
        }
    }
    
    

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        categorieData = ["Alimentation", "Animaux", "Arts et spectacle", "Collectionneurs", "Coup de main", "Bricolage", "Beauté/Bien être", "Enfance", "Informatique/Multimédia", "Jardin et plantes", "Maison", "Vacances/Weekend", "Livre/CD/DVD", "Vêtements et accessoires",  "Sports et loisirs", "Transports/Véhicules",  "Autre"]
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        
    }
   

    


}
