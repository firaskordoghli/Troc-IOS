//
//  InscriptionViewController.swift
//  Troc
//
//  Created by Besbes Ahmed on 11/25/18.
//  Copyright © 2018 firas.kordoghli. All rights reserved.
//

import UIKit
import Photos

class InscriptionViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    // textfields
    @IBOutlet weak var nom: UITextField!
    @IBOutlet weak var prenom: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var indentifiant: UITextField!
    @IBOutlet weak var imageProfil: UIImageView!
    // utils
    var pickedImageProduct = UIImage()
    let imagePicker = UIImagePickerController()
    var imageName: String = ""
    var first_nam = ""
    var last_nam = ""
    var emaill = ""
    var usernam = ""
    
    
    @IBAction func retour(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Inscription(_ sender: Any) {
        if (nom.text! == "" ) || ( prenom.text! == "") || (email.text! == "") || (indentifiant.text! == "") {
            let alert = UIAlertController(title: "", message: "Veuillez remplir tous les champs", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert,animated: true,completion: nil)
        }else{
            self.performSegue(withIdentifier: "inscriEtape2", sender: self)
        }
    }
    
    @IBAction func ajouterImage(_ sender: Any) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(self.imagePicker, animated: true, completion: nil)
        
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
        self.imageProfil.image = pickedImageProduct
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        nom.text = last_nam
        prenom.text = first_nam
        email.text = emaill
        indentifiant.text = usernam
        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "inscriEtape2"{
            
            if let destinationViewController =  segue.destination as? InscriptionEtape2ViewController{
                
                destinationViewController.first_nam = prenom.text!
                destinationViewController.last_nam = nom.text!
                destinationViewController.emaill = email.text!
                destinationViewController.usernam = indentifiant.text!
                destinationViewController.image_nam = pickedImageProduct
                
                
                
                
            }
        }
        
    }
    
   
    

}
