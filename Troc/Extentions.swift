 //
//  Extentions.swift
//  Troc
//
//  Created by Besbes Ahmed on 11/26/18.
//  Copyright © 2018 firas.kordoghli. All rights reserved.
//

import Foundation
import  UIKit
 
 extension UIColor {
    static let universalBlue = UIColor().colorFromHex("B40037")
    
    func colorFromHex(_ hex : String) -> UIColor {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#"){
            hexString.remove(at: hexString.startIndex)
        }
        
        if hexString.count != 6 {
            return UIColor.blue
        }
        
        var rgb :  UInt32 = 0
        Scanner(string: hexString).scanHexInt32(&rgb)
        
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16 ) / 255.0 ,
                            green: CGFloat((rgb & 0x00FF00) >> 8 ) / 255.0 ,
                            blue: CGFloat(rgb & 0x0000FF) / 255.0  ,
                            alpha: 1.0)
        
        
    }
 }

 
 struct Defaults {
    static let (logKey, idKey) = ("log", "id")
    static let userSessionKey = "com.save.usersession"
    
    struct Model {
        var log: String?
        var id: String?
        
        
        
        init(_ json: [String: String]) {
            self.log = json[logKey]
            self.id = json[idKey]
           
        }
    }
    
    static var saveLog = { (log: String) in
        UserDefaults.standard.set([logKey: log], forKey: userSessionKey)
    }
    
    static var saveLogAndId = { (log: String, id: String) in
        UserDefaults.standard.set([logKey: log, idKey: id], forKey: userSessionKey)
    }
    
    
    static var getLogAndId = { _ -> Model in
        return Model((UserDefaults.standard.value(forKey: userSessionKey) as? [String: String]) ?? [:])
    }(())
    
    static func clearUserData(){
        UserDefaults.standard.removeObject(forKey: userSessionKey)
    }
 }
