//
//  AjouterServiceEtape2ViewController.swift
//  Troc
//
//  Created by Belhassen LIMAM on 13/01/2019.
//  Copyright © 2019 firas.kordoghli. All rights reserved.
//

import UIKit
import Photos
import Alamofire
import AlamofireImage

class AjouterServiceEtape2ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    //Utils
    var pickedImageProduct = UIImage()
    let imagePicker = UIImagePickerController()
    var imageName:String = ""
    var categories : String?
    var titre : String?
    var descriptionserv: String?
    var type : String?
    
    //Outlets
    @IBOutlet weak var imageServiceImgView: UIImageView!
    
    
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
        self.imageServiceImgView.image = pickedImageProduct
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func etapeSuivante(_ sender: Any) {
        if (pickedImageProduct == nil){
            let alert = UIAlertController(title: "Echec", message: "Il faut ajouter une image", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert,animated: true,completion: nil)
        }else{
        self.performSegue(withIdentifier: "etape3", sender: self)
    }
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if segue.identifier == "etape3"{
            
            if let destinationViewController =  segue.destination as? AjouterServiceEtape3ViewController{
                
                destinationViewController.categories = self.categories!
                destinationViewController.descriptionserv = self.descriptionserv!
                destinationViewController.titre = self.titre!
                destinationViewController.type = self.type!
                destinationViewController.image = self.pickedImageProduct
                
                
            }
        }
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
