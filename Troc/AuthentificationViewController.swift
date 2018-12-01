//
//  AuthentificationViewController.swift
//  Troc
//
//  Created by Besbes Ahmed on 11/25/18.
//  Copyright © 2018 firas.kordoghli. All rights reserved.
//

import UIKit
import Alamofire


class AuthentificationViewController: UIViewController, UITextViewDelegate {

    //textfields
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    //utils
    let URL_SIGNUP = "http://localhost:3000/login"
    let defaults = UserDefaults.standard
   
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        username.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    @IBAction func login(_ sender: Any) {
        
        
        
        let parameters: Parameters = ["username": username.text!,"password": password.text!]
        
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
                let next = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                self.present(next, animated: true, completion: nil)
               
                self.defaults.set(true, forKey: "log")
               
                self.defaults.set(self.username.text!, forKey: "username")
               

                
            case .failure(_):
                
                print("echec")
                
            }
        }
            
        
    }
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
