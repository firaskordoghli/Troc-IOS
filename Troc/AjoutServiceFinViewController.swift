//
//  AjoutServiceFinViewController.swift
//  Troc
//
//  Created by Belhassen LIMAM on 13/01/2019.
//  Copyright © 2019 firas.kordoghli. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class AjoutServiceFinViewController: UIViewController {

    //Utils
    var categories : String?
    var titre : String?
    var descriptionserv: String?
    var type : String?
    var image = UIImage()
    var latitude: Double?
    var longitude : Double?
    let UserDefault = UserDefaults.standard
    let URL_SIGNUP = Connexion.adresse + "/addService"
    var imageName:String = ""
    //Outlets
    @IBOutlet weak var imageService: UIImageView!
    @IBOutlet weak var titreService: UILabel!
    @IBOutlet weak var descriptionService: UITextView!
    @IBOutlet weak var categorieService: UILabel!
    @IBOutlet weak var typeService: UILabel!
    
    
    
    @IBAction func retour(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    func addservice(){
        //Ajout service
        let parameters: Parameters = ["titre": self.titreService.text!,"description": self.descriptionService.text!,"categorie": self.categorieService.text!,"type": self.typeService.text!,"image":self.imageName,"longitude":self.longitude!,"latitude":self.latitude!,"idUser":self.UserDefault.string(forKey: "id")! ]
        
        Alamofire.request( self.URL_SIGNUP, method: .post, parameters: parameters).responseJSON { response in
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
            case .failure(_):
                let alert = UIAlertController(title: "Echec", message: "Votre service n'a pas été ajouter, veuillez vérifier vos données", preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
            }
        }
    }
    
    func uploadImage(){
        //Ajouter image sous serveur
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            self.addservice()
            print("Could not get JPEG representation of UIImage")
            return
        }
        let headers: HTTPHeaders = [:]
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "file", fileName:"image.jpg" , mimeType: "image/jpeg")
        },
            to: Connexion.adresse + "/UploadImage/service",
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    print(encodingResult)
                    upload.responseJSON { response in
                        debugPrint(response)
                        self.imageName = response.result.value as! String
                        self.addservice()
                        
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
                
        })
        
    }
    
    
    @IBAction func enregistrer(_ sender: Any) {
        
      uploadImage()
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imageService.image = image
        titreService.text = titre!
        descriptionService.text = descriptionserv!
        categorieService.text = categories!
        typeService.text = type!
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
