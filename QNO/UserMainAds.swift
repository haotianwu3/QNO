//
//  UserMainAds.swift
//  QNO
//
//  Created by Randolph on 12/1/2016.
//  Copyright © 2016年 September. All rights reserved.
//
import UIKit

class UserMainAds{
    
    var description: String
    var photo: UIImage?
    
    init?(description: String, photo: UIImage?) {
        // Initialize stored properties.
        self.description = description
        self.photo = photo
        
        // if there is no photo, it will return nil
        if photo == nil  {
            return nil
        }
    }
    
}
