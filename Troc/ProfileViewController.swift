//
//  ProfileViewController.swift
//  Troc
//
//  Created by Belhassen LIMAM on 08/12/2018.
//  Copyright © 2018 firas.kordoghli. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import FBSDKCoreKit
import FBSDKLoginKit

class ProfileViewController: UIViewController {

    //Outlet
    @IBOutlet weak var deconnexion: UIButton!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var nom: UILabel!
    //Web service
    let url_profile = Connexion.adresse + "/getUserWithId/"
    var profils : NSArray = []
    let UserDefault = UserDefaults.standard
    
    
    @IBAction func mesannonces(_ sender: Any) {
    }
    
    
    
    @IBAction func modifProfil(_ sender: Any) {
    }
   /* func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        UserDefault.removeObject(forKey: "id")
        UserDefault.removeObject(forKey: "username")
        UserDefault.removeObject(forKey: "phone")
        UserDefault.removeObject(forKey: "email")
        UserDefault.removeObject(forKey: "login")
        if UserDefault.string(forKey: "login") == nil {
            let next = self.storyboard!.instantiateViewController(withIdentifier: "LoginView")
            self.present(next, animated: true, completion: nil)
        }
        print("User Logged Out")
    }*/
    @IBAction func deconnexion(_ sender: Any) {
        
        
            UserDefault.removeObject(forKey: "id")
            UserDefault.removeObject(forKey: "username")
            UserDefault.removeObject(forKey: "phone")
            UserDefault.removeObject(forKey: "email")
            UserDefault.removeObject(forKey: "login")
            if UserDefault.string(forKey: "login") == nil {
                let next = self.storyboard!.instantiateViewController(withIdentifier: "LoginView")
                self.present(next, animated: true, completion: nil)
            
        }
        
        //Defaults.clearUserData()
    }
    //Get des données du profile
    func FetchData() {
        
        //let parameters: Parameters = ["id":String("'"+Defaults.getLogAndId.id!+"'")]
        let parameters: Parameters = ["id":String("'"+UserDefault.string(forKey: "id")!+"'")]
        Alamofire.request( url_profile, method: .post, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
            // print(response)
            //print(response.result.value)
            
            self.profils = response.result.value as! NSArray
            let profil  = self.profils[0] as! Dictionary<String,Any>
            let urlImage = Connexion.adresse + "/Ressources/Profiles/" + ( profil["image"] as! String )
            self.imageProfile.af_setImage(withURL:URL(string: urlImage)!)
            
            
        }
        
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FetchData()
        //self.username.text = self.UserDefault.string(forKey: "username")!
        //self.email.text = self.UserDefault.string(forKey: "email")!
        //self.nom.text = String(self.UserDefault.string(forKey: "phone")!)
        self.imageProfile.layer.cornerRadius = 20
        self.imageProfile.clipsToBounds = true
        self.imageProfile.layer.borderColor = UIColor.black.cgColor
        self.imageProfile.layer.borderWidth = 2
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FetchData()
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
