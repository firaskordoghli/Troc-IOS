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
    let URL_SIGNUP = "http://localhost:3000/login"
    let URL_TEST = "http://localhost:3000/testemail"
    let defaults = UserDefaults.standard
    var Infos : String?
    var emailfb : String = ""
    var first_namefb : String = ""
    var last_namefb : String = ""
    var usernamefb : String = ""
    
    var logind : NSArray = []
    
    
    
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
            
            self.logind = response.result.value as! NSArray
            let loginsh = self.logind[0] as! Dictionary<String,Any>
            let idInf = (loginsh["Id"]! as! Int)
            
            
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
                
                
                
                Defaults.saveLogAndId("true",String(idInf))
                
                
                
            case .failure(_):
                
                print("echec")
                
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
                    
                }
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
   
    
    
    ////Navigation bar control//////
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
        getFBUserData()
        /*self.navigationController?.setNavigationBarHidden(true, animated: true)
        fbButton.readPermissions = ["public_profile", "email"]
        if (FBSDKAccessToken.current() != nil) {
            
            
            let parameters: Parameters = ["email": self.emailfb]
            
            Alamofire.request( URL_TEST, method: .post, parameters: parameters).responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                
                
                switch(response.result) {
                case .success(_):
                    
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                    self.present(next, animated: true, completion: nil)
                    
                    
                    
                    Defaults.saveLog("true")
                    
                    
                    
                case .failure(_):
                    self.getFBUserData()
                    self.performSegue(withIdentifier: "toInscription", sender: self)
                    
                }
                
                
            }
            
        }*/
        
        let logged = Defaults.getLogAndId.log
        if logged != nil {
            self.dismiss(animated: true, completion: nil)
            let next = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            self.present(next, animated: true, completion: nil)
        }
       
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

