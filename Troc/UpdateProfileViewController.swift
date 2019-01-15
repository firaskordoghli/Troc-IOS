//
//  UpdateProfileViewController.swift
//  Troc
//
//  Created by Belhassen LIMAM on 15/01/2019.
//  Copyright © 2019 firas.kordoghli. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Photos

class UpdateProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    //Utils
    var pickedImageProduct = UIImage()
    let imagePicker = UIImagePickerController()
    var imageName:String = ""
    let url_profile = Connexion.adresse + "/getUserWithId/"
    let url_updateprof = Connexion.adresse + "/updateUser"
    var profils : NSArray = []
    var ancienneimage:String = ""
    let UserDefault = UserDefaults.standard
    
    //Outlets
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var identifiant: UITextField!
    @IBOutlet weak var telephone: UITextField!
    @IBOutlet weak var email: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        FetchData()
        imageProfile.setRounded()
        self.identifiant.text = UserDefault.string(forKey: "username")!
        self.email.text = UserDefault.string(forKey: "email")!
        self.telephone.text = String(UserDefault.string(forKey: "phone")!)
        self.imageProfile.layer.cornerRadius = 20
        self.imageProfile.clipsToBounds = true
        self.imageProfile.layer.borderColor = UIColor.black.cgColor
        self.imageProfile.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }
    
    @IBAction func retour(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
   
   
    @IBAction func enregistrer(_ sender: Any) {
        
        uploadImage()
    }
    
    @IBAction func changerImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(self.imagePicker, animated: true, completion: nil)
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
            if response.result.value as? NSArray == nil {
                print("erreuuuur")
            }else{
          self.profils = response.result.value as! NSArray
            let profil  = self.profils[0] as! Dictionary<String,Any>
            let urlImage = Connexion.adresse + "/Ressources/Profiles/" + ( profil["image"] as! String )
            self.imageProfile.af_setImage(withURL:URL(string: urlImage)!)
            self.ancienneimage = profil["image"] as! String
            
        }
        }
        
    }
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
                to: Connexion.adresse + "/UploadImage/profil",
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
    
    //Get des données du profile
    func Update() {
        
        //Update profile
        let parameters: Parameters = ["id":  self.UserDefault.string(forKey: "id")!, "username": self.identifiant.text!, "email": self.email.text!, "phone": self.telephone.text!, "image": String("'" + self.ancienneimage + "'")]
                        Alamofire.request( self.url_updateprof, method: .post, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
            // print(response)
            //print(response.result.value)
            
                            switch(response.result) {
                            case .success(_):
                               
                                self.UserDefault.set(self.identifiant.text!, forKey: "username")
                                self.UserDefault.set(self.email.text!, forKey: "email")
                                self.UserDefault.set(self.telephone.text!, forKey: "phone")
                                self.UserDefault.synchronize()
                                let alert = UIAlertController(title: "", message: "Profil mis à jour", preferredStyle: .alert)
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
        self.imageProfile.image = pickedImageProduct
        self.dismiss(animated: true, completion: nil)
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
