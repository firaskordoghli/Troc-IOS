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
    @IBOutlet weak var prenom: UILabel!
    //Web service
    let url = "http://localhost:3000/UserById"
    var profils : NSArray = []
    
    
    func FetchData() {
        let url = "http://localhost:3000/getUserById/"
        let parameters: Parameters = ["id":String("'"+Defaults.getLogAndId.id!+"'")]
        Alamofire.request( url, method: .post, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
            // print(response)
            //print(response.result.value)
            
            self.profils = response.result.value as! NSArray
            let profil  = self.profils[0] as! Dictionary<String,Any>
            self.username.text = (profil["username"] as! String)
            self.email.text = (profil["email"] as! String)
            self.nom.text = (profil["last_name"] as! String)
            self.prenom.text = (profil["first_name"] as! String)
            
            
        }
        
    }
    
    
    
    
    
    //Deconnexion
    @IBAction func deconnexion(_ sender: Any) {
        let next = self.storyboard!.instantiateViewController(withIdentifier: "LoginView")
        self.present(next, animated: true, completion: nil)
        
        Defaults.clearUserData()
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
