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
    let URL_SIGNUP = "http://localhost:3000/login"
    let defaults = UserDefaults.standard
    var Infos : String?
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
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                    
                    
                }
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    print(result!)
                }
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttonText = NSAttributedString(string: "Continuer avec facebook")
        fbButton.setAttributedTitle(buttonText, for: .normal)
        let logged = Defaults.getLogAndId.log
        if logged != nil {
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }


}

