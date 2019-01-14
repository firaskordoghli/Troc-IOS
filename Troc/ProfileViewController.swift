//
//  ProfileViewController.swift
//  Troc
//
//  Created by Belhassen LIMAM on 08/12/2018.
//  Copyright © 2018 firas.kordoghli. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController {

    //Outlet
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var nom: UILabel!
    //Web service
    let url_profile = Connexion.adresse + "/getUserWithId/"
    var profils : NSArray = []
    let UserDefault = UserDefaults.standard
    
    
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
            self.nom.text = (profil["phone"] as! String)
            
            
        }
        
    }
    
    
    
    
    
    //Deconnexion
    @IBAction func deconnexion(_ sender: Any) {
        UserDefault.removeObject(forKey: "id")
        UserDefault.removeObject(forKey: "login")
        if UserDefault.string(forKey: "login") == nil {
        let next = self.storyboard!.instantiateViewController(withIdentifier: "LoginView")
        self.present(next, animated: true, completion: nil)
        }
        //Defaults.clearUserData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        FetchData()
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
