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
    
    var hasLogo: Bool
    var ShopDescription: String
    var ShopAddress: String
    var distance: Double?
    
    var ShopLatitude: Double?
    var ShopLongitude: Double?
    
    
    init(name:String, hasLogo: Bool, description: String?, address: String?, latitude: Double?, longitude: Double?){
        self.Name = name
        
        self.hasLogo = hasLogo
        if description == nil {
            ShopDescription = "No description"
        } else {
            self.ShopDescription = description!
        }
        
        if address == nil {
            ShopAddress = "No address"
        } else {
            self.ShopAddress = address!
        }
        
        self.ShopLatitude = latitude
        self.ShopLongitude = longitude
    }
    
}
