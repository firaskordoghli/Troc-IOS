//
//  BookmarksViewController.swift
//  Troc
//
//  Created by Belhassen LIMAM on 03/12/2018.
//  Copyright © 2018 firas.kordoghli. All rights reserved.
//

import UIKit
import CoreData

class BookmarksViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    var servicesArray: [NSManagedObject] = []
    
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servicesArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Services") 
        let content = cell!.viewWithTag(0)
        let servicesTitre = content!.viewWithTag(1) as! UILabel
        let servicesDesc = content!.viewWithTag(2) as! UILabel
        let service = servicesArray[indexPath.row]
        servicesTitre.text =  (service.value(forKey: "titre") as! String)
        servicesDesc.text = (service.value(forKey: "desc") as! String)
        
        return cell!
    }
    
    
    func fetchMovies() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject> (entityName: "Service")
        
        do {
            servicesArray = try context.fetch(request)
            tableView.reloadData()
        } catch  {
            print ("Error!")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let serviceToDelete =  servicesArray[indexPath.row]
            context.delete(serviceToDelete)
            
            do{
                try context.save()
                servicesArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                //tableView.reloadData()
            }catch{
                print("Error")
            }
            
            
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovies()
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
