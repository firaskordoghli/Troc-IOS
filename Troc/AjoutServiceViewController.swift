//
//  AjoutServiceViewController.swift
//  Troc
//
//  Created by Belhassen LIMAM on 30/11/2018.
//  Copyright © 2018 firas.kordoghli. All rights reserved.
//

import UIKit
import Alamofire
class AjoutServiceViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    //outlets
    @IBOutlet weak var titre: UITextField!
    @IBOutlet var desc: UITextField!
    @IBOutlet weak var categorie: UIPickerView!
    @IBOutlet weak var type: UISegmentedControl!
    //utils
    let URL_SIGNUP = Connexion.adresse + "/addService"
    let URL_CAT =    Connexion.adresse + "/getcategorie"
    var categoriesGet : NSArray = []
    var categorieData : [String] = [String]()
    var categories : String?
    var types : String?
    let UserDefault = UserDefaults.standard
    

    func FetchData() {
        Alamofire.request(URL_CAT).responseJSON{
            response in
             print(response)
            
            self.categoriesGet = response.result.value as! NSArray
            print(self.categoriesGet)
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
                
                
            }
        }
        
    }
    
    
    
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
        
       /*
        let parameters: Parameters = ["titre": titre.text!,"description": desc.text!,"categorie": categories!,"type":types!,"id":self.UserDefault.string(forKey: "id")! ]
        
        Alamofire.request( URL_SIGNUP, method: .post, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
            switch(response.result) {
            case .success(_):
            self.dismiss(animated: true, completion: nil)
            let next = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            self.present(next, animated: true, completion: nil)
                case .failure(_):
                    let alert = UIAlertController(title: "Echec", message: "Votre n'a pas été ajouter, veuillez vérifier vos données", preferredStyle: .alert)
                    let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert,animated: true,completion: nil)
            }
        }
 */
        if(titre.text! == "" || desc.text! == "") {
            let alert = UIAlertController(title: "Echec", message: "Veuillez remplir tous les champs", preferredStyle: .alert)
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
                
                destinationViewController.categories = self.categories!
                destinationViewController.descriptionserv = self.desc.text!
                destinationViewController.titre = self.titre.text!
                destinationViewController.type = self.types!
                
                
            }
        }
    }
    
    

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FetchData()
        categorieData = ["Alimentation", "Animaux", "Arts et spectacle", "Collectionneurs", "Coup de main", "Bricolage", "Beauté/Bien être", "Enfance", "Informatique/Multimédia", "Jardin et plantes", "Maison", "Vacances/Weekend", "Livre/CD/DVD", "Vêtements et accessoires",  "Sports et loisirs", "Transports/Véhicules",  "Autre"]
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        
    }
   

    


}
