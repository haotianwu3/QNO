//
//  QNOAPIError.swift
//  QNO
//
//  Created by Xinhong LIU on 11/1/2016.
//  Copyright © 2016 September. All rights reserved.
//

import Foundation

enum QNOAPIErrorError: ErrorType {
    case InvalidHTTPStatusCode
}

class QNOAPIError {
    
    static let sharedInstance = QNOAPIError()
    
    var dict = [Int: String]()
    
    init() {
        dict[601] = "Server doesn't recognize the restaurant by name"
        dict[602] = "Restaurant creation failed due to invalid fields"
        dict[605] = "Duplicate restaurant name"
        dict[609] = "Restaurant processing failed due to unknown reason"
        dict[611] = "Server doesn't recognize the customer by name"
        dict[612] = "Customer creation failed due to invalid fields"
        dict[614] = "Customer creation failed due to duplicate name"
        dict[619] = "Customer processing failed due to unknown reason"
        dict[621] = "Ticket creation failed"
        dict[622] = "Ticket not found"
        dict[623] = "Ticket update failed"
        dict[624] = "Ticket id is invalid"
        dict[629] = "Ticket processing failed due to unknow reason"
        dict[631] = "House followed by duplicate customer"
        dict[632] = "Customer following duplicate house"
        dict[641] = "Queue creation failed due to duplicate name"
        dict[642] = "Queue not found by name"
        dict[643] = "Queue number is invalid"
        dict[644] = "Queue number has alread passed"
        dict[649] = "Queue processing failed due to unknown reason"
    }
    
    func getMessage(fromHTTPStatus httpStatus: Int) throws -> String {
        let message = dict[httpStatus]
        
        guard message != nil else {
            throw QNOAPIErrorError.InvalidHTTPStatusCode
        }
        
        return message!
    }
}