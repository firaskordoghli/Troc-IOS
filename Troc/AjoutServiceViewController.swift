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
    let URL_SIGNUP = "http://localhost:3000/addService"
    var categorieData : [String] = [String]()
    var categories : String?
    var types : String?
    var username : String!
    /////
    let defaults = UserDefaults.standard
    
    @IBAction func deconnexion(_ sender: Any) {
        let next = self.storyboard!.instantiateViewController(withIdentifier: "LoginView")
        self.present(next, animated: true, completion: nil)
        
        self.defaults.set(false,forKey: "log")
        self.defaults.removeObject(forKey: "username")
        
        
        
    }
    @IBOutlet weak var deconnexion: UIButton!
    
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
        
        
        let parameters: Parameters = ["titre": titre.text!,"description": desc.text!,"categorie": categories!,"type":types!,"username":username! ]
        
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
            let next = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController!
            self.present(next!, animated: true, completion: nil)
                case .failure(_):
                    let alert = UIAlertController(title: "Echec", message: "Votre n'a pas été ajouter, veuillez vérifier vos données", preferredStyle: .alert)
                    let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert,animated: true,completion: nil)
            }
        }
        
    }
    
    

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categorieData = ["Alimentation", "Animaux", "Arts et spectacle", "Collectionneurs", "Coup de main", "Bricolage", "Beauté/Bien être", "Enfance", "Informatique/Multimédia", "Jardin et plantes", "Maison", "Vacances/Weekend", "Livre/CD/DVD", "Vêtements et accessoires",  "Sports et loisirs", "Transports/Véhicules",  "Autre"]
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        
    }
   

    


}
