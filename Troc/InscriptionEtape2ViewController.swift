//
//  InscriptionEtape2ViewController.swift
//  Troc
//
//  Created by Belhassen LIMAM on 16/01/2019.
//  Copyright © 2019 firas.kordoghli. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class InscriptionEtape2ViewController: UIViewController {
    
    let URL_SIGNUP = Connexion.adresse + "/signup"
    let URL_LOGIN =  Connexion.adresse + "/login"
    var first_nam : String?
    var last_nam : String?
    var emaill : String?
    var usernam : String?
    var image_nam = UIImage()
    var imagename = ""
    let UserDefault = UserDefaults.standard
    var logind : NSArray = []
    
    
    @IBOutlet weak var mdp: UITextField!
    @IBOutlet weak var telephone: UITextField!
    @IBOutlet weak var retapmdp: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func inscription(_ sender: Any) {
        if (mdp.text! == "") || (retapmdp.text! == "") || (telephone.text! == "") {
            let alert = UIAlertController(title: "", message: "Veuillez remplir tous les champs", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert,animated: true,completion: nil)
        }else {
            if (mdp.text! != retapmdp.text!){
                let alert = UIAlertController(title: "", message: "Veuillez écrire le même mot de passe", preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
            } else {
                uploadImage()
                
            }
        }
    }
    
    
    
    func uploadImage (){
        
        guard let imageData = image_nam.jpegData(compressionQuality: 0.5) else {
            self.inscri()
            print("Could not get JPEG representation of UIImage")
            return
        }
        let headers: HTTPHeaders = [:]
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "file", fileName:"image.jpg" , mimeType: "image/jpeg")
        },
            to: Connexion.adresse + "/UploadImage/profil",
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    print(encodingResult)
                    upload.responseJSON { response in
                        debugPrint(response)
                        self.imagename = response.result.value as! String
                        self.inscri()
                        
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
                
        })
        
    }
    
    
    
    
    func inscri () {
        
        
        let parameters: Parameters = ["first_name": first_nam!,"last_name": last_nam!,"username": usernam!,"email": emaill!,"password": mdp.text!,"phone": telephone.text!,"image": imagename]
        
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
                let alert = UIAlertController(title: "Succès", message: "Votre compte à été crée avec succès", preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: .cancel, handler: {(UIAlertAction) in
                    let parameters: Parameters = ["email": self.emaill!,"password": self.mdp.text!]
                    
                    Alamofire.request( self.URL_LOGIN, method: .post, parameters: parameters).responseJSON { response in
                        print("Request: \(String(describing: response.request))")   // original url request
                        print("Response: \(String(describing: response.response))") // http url response
                        print("Result: \(response.result)")                         // response serialization result
                        if let json = response.result.value {
                            print("JSON: \(json)") // serialized json response
                            
                        }
                        
                        
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)") // original server data as UTF8 string
                            //self.status = (utf8Text["msg"] as! String)
                        }
                        self.logind = response.result.value as! NSArray
                        
                        let loginsh = self.logind[0] as! Dictionary<String,Any>
                        let idInf = (loginsh["Id"]! as! Int)
                        let nameInf = (loginsh["username"]! as! String)
                        let emailInf = (loginsh["email"]! as! String)
                        let phoneInf = (loginsh["phone"]! as! Int)
                        //Defaults.saveLogAndId("true",String(idInf))
                        self.UserDefault.set(String(idInf), forKey: "id")
                        self.UserDefault.set(nameInf, forKey: "username")
                        self.UserDefault.set(emailInf, forKey: "email")
                        self.UserDefault.set(phoneInf, forKey: "phone")
                        self.UserDefault.set("true", forKey: "login")
                        self.UserDefault.synchronize()
                        if  self.UserDefault.string(forKey: "id") != nil{
                            let next = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                            self.present(next, animated: true, completion: nil)
                            
                        }
                    }})
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
            case .failure(_):
                
                print("echec")
                
            }
            
        }
        
    }
    
    @IBAction func retour(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
