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

class ProfileViewController: UIViewController {

    //Outlet
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
    
    @IBAction func mesFavoris(_ sender: Any) {
    }
    
    @IBAction func modifProfil(_ sender: Any) {
    }
    
    @IBAction func deconnexion(_ sender: Any) {
        
        UserDefault.removeObject(forKey: "id")
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
            self.username.text = (profil["username"] as! String)
            self.email.text = (profil["email"] as! String)
            self.nom.text = String((profil["phone"]) as! Int)
            self.imageProfile.setRounded()
            let urlImage = Connexion.adresse + "/Ressources/Profiles/" + ( profil["image"] as! String )
            self.imageProfile.af_setImage(withURL:URL(string: urlImage)!)
            
            
        }
        
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FetchData()
        
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
