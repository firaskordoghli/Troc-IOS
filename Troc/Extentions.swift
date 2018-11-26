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
