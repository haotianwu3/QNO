//
//  Shops.swift
//  QNO
//
//  Created by Randolph on 13/1/2016.
//  Copyright © 2016年 September. All rights reserved.
//

import UIKit

class Shop{
    var Name: String
    
    var ShopLogoName: String
    var ShopDescription: String
    var ShopAddress: String
    
    var ShopLatitude: Double
    var ShopLongitude: Double
    
    
    init?(name:String, logoName: String, descirption: String, address: String, latitude: Double, longitude: Double){
        self.Name = name
        
        self.ShopLogoName = logoName
        self.ShopDescription = descirption
        self.ShopAddress = address
        
        self.ShopLatitude = latitude
        self.ShopLongitude = longitude
        
        if (name.isEmpty || latitude.isNaN || longitude.isNaN) {
            return nil
        }
    }
    
}
