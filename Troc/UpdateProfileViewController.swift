//
//  UpdateProfileViewController.swift
//  Troc
//
//  Created by Belhassen LIMAM on 15/01/2019.
//  Copyright © 2019 firas.kordoghli. All rights reserved.
//

import UIKit

class UpdateProfileViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var identifiant: UILabel!
    @IBOutlet weak var telephone: UILabel!
    @IBOutlet weak var email: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageProfile.setRounded()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func retour(_ sender: Any) {
    }
    @IBAction func enregistreer(_ sender: Any) {
    }
    
    @IBAction func changerImage(_ sender: Any) {
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
