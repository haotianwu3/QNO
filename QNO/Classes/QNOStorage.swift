//
//  DefaultsKeys.swift
//  QNO
//
//  Created by Xinhong LIU on 13/1/2016.
//  Copyright © 2016 September. All rights reserved.
//

import SwiftyUserDefaults

let houseNameKey = DefaultsKey<String?>("house_name")
let customerIdKey = DefaultsKey<String?>("customer_id")
let notFirstLoginKey = DefaultsKey<Bool?>("not_first_login")

class QNOStorage {
    class func setHouseName(houseName: String?) {
        if houseName == nil {
            Defaults.remove(houseNameKey)
        } else {
            Defaults[houseNameKey] = houseName!
        }
    }
    
    class func getHouseName() -> String? {
        return Defaults[houseNameKey]
    }
    
    class func getAndSetNotFirstLogin() -> Bool {
        let nfl = Defaults[notFirstLoginKey] == true
        Defaults[notFirstLoginKey] = true
        return nfl
    }
}