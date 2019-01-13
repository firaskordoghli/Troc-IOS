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
    var categories : String?
    var type : String?
    
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
        
       
        guard let imageData = pickedImageProduct.jpegData(compressionQuality: 0.5) else {
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
                        // self.imageName = response.result.value as! String*/
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
                
        })
        
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
