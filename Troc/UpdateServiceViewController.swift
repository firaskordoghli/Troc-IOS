//
//  UpdateServiceViewController.swift
//  Troc
//
//  Created by Belhassen LIMAM on 15/01/2019.
//  Copyright © 2019 firas.kordoghli. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Photos

class UpdateServiceViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //Utils
    var pickedImageProduct = UIImage()
    let imagePicker = UIImagePickerController()
    var idService: Int?
    var ancienneimage: String = ""
    var imageName:String = ""
    let url_getserv = Connexion.adresse + "/getServiceWithId/"
    let url_updateprof = Connexion.adresse + "/apdateService"
    let url_delete = Connexion.adresse + "/delServiceWithId/"
    var services : NSArray = []
    var titre : String?
    var categorie : String?
    var descriptionserv: String?
    var type : String?
    var latitude : Double?
    var longitude : Double?

    //Outlets
    @IBOutlet weak var typeService: UISegmentedControl!
    @IBOutlet weak var DescService: UITextField!
    @IBOutlet weak var titreService: UITextField!
    @IBOutlet weak var imageService: UIImageView!
    
    
    
    
    //Bouton retour
    @IBAction func retour(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    
    //Bouton supprimer
    @IBAction func suppService(_ sender: Any) {
        let deleteAlert = UIAlertController(title: "Suppression", message: "Voulez vous vraiment supprimer ce service ?", preferredStyle: UIAlertController.Style.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (action: UIAlertAction!) in
            self.DeleteData()
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    //Bouton Enregistrer
    @IBAction func updateService(_ sender: Any) {
        if titreService.text! == "" || DescService.text! == "" {
            let alert = UIAlertController(title: "Echec", message: "Veuillez remplir les champs", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alert.addAction(action)
        }else{
            uploadImage()
        }
        
    }
    
    //Get des données du service
    func FetchData() {
        
        //let parameters: Parameters = ["id":String("'"+Defaults.getLogAndId.id!+"'")]
        let parameters: Parameters = ["id": idService!]
        Alamofire.request( url_getserv, method: .post, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
            // print(response)
            //print(response.result.value)
            if response.result.value as? NSArray == nil {
                print("erreuuuur")
            }else{
                self.services = response.result.value as! NSArray
                let profil  = self.services[0] as! Dictionary<String,Any>
                self.latitude =  (profil["latitude"] as! Double)
                self.longitude = (profil["longitude"] as! Double)
                let urlImage = Connexion.adresse + "/Ressources/Services/" + ( profil["image"] as! String )
                self.imageService.af_setImage(withURL:URL(string: urlImage)!)
                self.ancienneimage = profil["image"] as! String
                
            }
        }
        
    }
    
    //Supprimer le service
    func DeleteData() {
        
        //let parameters: Parameters = ["id":String("'"+Defaults.getLogAndId.id!+"'")]
        let parameters: Parameters = ["id": idService!]
        Alamofire.request( url_delete, method: .post, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
            
            switch(response.result) {
            case .success(_):
                let next = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                self.present(next, animated: true, completion: nil)
                
            case .failure(_):
                let alert = UIAlertController(title: "Echec", message: "Echec de la suppression", preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: .cancel, handler: {(UIAlertAction) in
                    
                    self.dismiss(animated: true, completion: nil)
                    
                })
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
            }
        }
        
    }
    
    //update des données du service
    func Update() {
        
        //Update profile
        let parameters: Parameters = ["id": idService!, "titre": self.titreService.text!, "description": self.DescService.text!, "categorie": self.categorie!, "type": type!, "longitude": self.longitude!, "latitude": self.latitude!, "image": String("'" + self.ancienneimage + "'")]
        Alamofire.request( self.url_updateprof, method: .post, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
            // print(response)
            //print(response.result.value)
            
            switch(response.result) {
            case .success(_):
                
               
                let alert = UIAlertController(title: "", message: "Service mis à jour", preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: .cancel, handler: {(UIAlertAction) in
                    
                    self.dismiss(animated: true, completion: nil)
                    
                })
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
            case .failure(_):
                let alert = UIAlertController(title: "Echec", message: "Echec de reception des données", preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: .cancel, handler: {(UIAlertAction) in
                    
                self.dismiss(animated: true, completion: nil)
                    
                })
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
            }
            
        }
        
        
        
    }
    
    
    //Get l'image du service
    func uploadImage () {
        
        //Ajouter image sous serveur
        guard let imageData = pickedImageProduct.jpegData(compressionQuality: 0.5) else {
            Update()
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
                        self.ancienneimage = response.result.value as! String
                        self.Update()
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        })
        
    }
    
    //Bouron changer image
    @IBAction func addPhoto(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FetchData()
        imagePicker.delegate = self
        titreService.text = titre!
        DescService.text = descriptionserv!
        
        if type! == "Service" {
            typeService.selectedSegmentIndex = 1
        }else{
            typeService.selectedSegmentIndex = 0
        }
        
        
    }
    
    
    
    //Service pour l'imagePicker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Error: \(info)")
        }
        pickedImageProduct = selectedImage
        let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as! URL
        print(fileUrl.lastPathComponent)
        self.imageService.image = pickedImageProduct
        self.dismiss(animated: true, completion: nil)
    }
    
}
