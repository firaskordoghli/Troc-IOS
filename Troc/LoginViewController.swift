//
//  ViewController.swift
//  Troc
//
//  Created by Besbes Ahmed on 11/25/18.
//  Copyright © 2018 firas.kordoghli. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire


class LoginViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var fbButton: FBSDKLoginButton!
    //Utils
    //utils
    var dict : [String : AnyObject]!
    let URL_SIGNUP = "http://192.168.1.9:3000/login"
    let URL_TEST = "http://192.168.1.9:3000/testemail"
    var Infos : String?
    var emailfb : String = ""
    var first_namefb : String = ""
    var last_namefb : String = ""
    var usernamefb : String = ""
    let UserDefault = UserDefaults.standard
    var logind : NSArray = []
    var status : String?
    
    
    
    @IBAction func keyboardDismiss(_ sender: Any) {
        email.resignFirstResponder()
        password.resignFirstResponder()
    }
    

    

    
    @IBAction func login(_ sender: Any) {
        
        let parameters: Parameters = ["email": email.text!,"password": password.text!]
        
        Alamofire.request( URL_SIGNUP, method: .post, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if response.result.value == nil {
                let alert = UIAlertController(title: "Echec", message: "Echec d'envoie des données", preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
            }else{
            
            
                
            
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
               
            }
            
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
                //self.status = (utf8Text["msg"] as! String)
            }
               
                
                
            switch(response.result) {
            case .success(_):
               // let status = false
                let reponse = response.result.value as? [String: Any]
                if reponse == nil {
                    self.logind = response.result.value as! NSArray
                    
                    let loginsh = self.logind[0] as! Dictionary<String,Any>
                    let idInf = (loginsh["Id"]! as! Int)
                    //Defaults.saveLogAndId("true",String(idInf))
                    self.UserDefault.set(String(idInf), forKey: "id")
                    self.UserDefault.set("true", forKey: "login")
                    self.UserDefault.synchronize()
                    if  self.UserDefault.string(forKey: "id") != nil{
                        let next = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                        self.present(next, animated: true, completion: nil)
                    }
                }else {
                    let alert = UIAlertController(title: "Erreur", message: "Email ou mot de passe est incorrect", preferredStyle: .alert)
                    let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert,animated: true,completion: nil)
                }
               
            case .failure(_):
                let alert = UIAlertController(title: "Echec", message: "Echec d'envoie des données", preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
                
            }
            
            }
        }
        
    }
    
    
    @IBAction func loginFacebookAction(_ sender: Any) {
       getFBUserData()
    }
   
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = (result as! [String : AnyObject])
                    print(result!)
                    print(self.dict)
                    self.emailfb = (self.dict["email"] as! String)
                    print(self.emailfb)
                    self.first_namefb = (self.dict["first_name"] as! String)
                    print(self.first_namefb)
                    self.last_namefb = (self.dict["last_name"] as! String)
                    print(self.last_namefb)
                    self.usernamefb = (self.dict["name"] as! String)
                    print(self.usernamefb)
                    
                    let parameters: Parameters = ["email":String("'"+self.usernamefb+"'")]
                    Alamofire.request( self.URL_TEST, method: .post, parameters: parameters).responseJSON { response in
                        print("Request: \(String(describing: response.request))")   // original url request
                        print("Response: \(String(describing: response.response))") // http url response
                        print("Result: \(response.result)")
                        
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)") // original server data as UTF8 string
                            //self.status = (utf8Text["msg"] as! String)
                            
                        }
                        switch(response.result) {
                        case .success(_):
                            let status = true
                            let reponse = response.result.value as? [String: Any]
                            if status == reponse!["status"] as! Bool {
                                self.dismiss(animated: true, completion: nil)
                                let next = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                                self.present(next, animated: true, completion: nil)
                            }else{
                                let refreshAlert = UIAlertController(title: "Inscription", message: "Continuer l'inscription", preferredStyle: UIAlertController.Style.alert)
                                
                                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                    self.performSegue(withIdentifier: "toInscription", sender: self)
                                }))
                                
                                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                                    FBSDKLoginManager().logOut()
                                }))
                                
                                self.present(refreshAlert, animated: true, completion: nil)
                               
                            }
                        case .failure(_):
                            let alert = UIAlertController(title: "Echec", message: "Echec d'envoie des données", preferredStyle: .alert)
                            let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                            alert.addAction(action)
                            self.present(alert,animated: true,completion: nil)
                        }
                        
                        
                    }
                }
            })
        
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //let logged = Defaults.getLogAndId.log
        //if logged != nil
            if self.UserDefault.string(forKey: "login") != nil {
            self.dismiss(animated: true, completion: nil)
            let next = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            self.present(next, animated: true, completion: nil)
        }
        
    }
   
    
    
    ////Navigation bar control//////
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        fbButton.readPermissions = ["public_profile", "email"]
        getFBUserData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if segue.identifier == "toInscription"{
            
            if let destinationViewController =  segue.destination as? InscriptionViewController{
                
                
                // destinationViewController.movieNam = moviesNames[index!.item]
                
                // destinationViewController.movieImg = moviesImg[index!.item]
                
                destinationViewController.first_nam = self.first_namefb
                destinationViewController.last_nam = self.last_namefb
                destinationViewController.emaill = self.emailfb
                destinationViewController.usernam = self.usernamefb
                
                
            }
        }
    }

}

