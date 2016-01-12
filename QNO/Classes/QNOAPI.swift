//
//  QNOAPI.swift
//  QNO
//
//  Created by Xinhong LIU on 11/1/2016.
//  Copyright © 2016 September. All rights reserved.
//

import Foundation
import Alamofire

enum QNOAPIStatus {
    case GUEST
    case CUSTOMER
    case HOUSE
}

enum QNOAPIRuntimeError: ErrorType {
    case InvalidOperation
}

class QNOAPI {
    
    let URLPrefix = "http://144.214.121.58:8080/JOS"
    let housePrefix = "/house"
    
    var APIStatus: QNOAPIStatus = .GUEST
    var userId: String?
    var accessToken: String?
    
    init() {
        // as guest
    }
    
    init(fromUserId userId: String, accessToken: String) {
        // as a user
    }
    
    func status() -> QNOAPIStatus {
        if userId == nil || accessToken == nil {
            APIStatus = .GUEST
        }
        
        return APIStatus
    }
    
    // MARK: House Controller
    
    // permission: GUEST
    func addHouse(houseName: String, address: String?, tel: String?, homepage: String?, callback: (errorMessage: String?) -> Void) throws {
        guard (status() == .GUEST) else {
            throw QNOAPIRuntimeError.InvalidOperation
        }
        
        let url = "\(URLPrefix)\(housePrefix)/addHouse"
            
        var parameter = [String: AnyObject]()
        
        parameter["houseName"] = houseName
        
        if address != nil {
            parameter["address"] = address
        }
        
        if tel != nil {
            parameter["tel"] = address
        }
        
        if homepage != nil {
            parameter["homepage"] = homepage
        }
        
        Alamofire.request(.POST, url, parameters: parameter).responseString(completionHandler: {response in
            var HTTPStatus: Int
            if let httpError = response.result.error {
                HTTPStatus = httpError.code
            } else {
                HTTPStatus = (response.response?.statusCode)!
            }
            
            if HTTPStatus == 200 {
                callback(errorMessage: nil)
            } else {
                var message: String?
                do {
                    try message = QNOAPIError.sharedInstance.getMessage(fromHTTPStatus: HTTPStatus)
                } catch _ {
                    message = "Unknown error occurs, please contact our support for help."
                }
                callback(errorMessage: message)
            }
        })
    }
    
    // permission: HOUSE
    func addQueue(houseName: String, queueName: String, expectedNumber: Int, ticketNumber: Int, callback: (errorMessage: String?) -> Void) throws {
        guard (status() == .HOUSE) else {
            throw QNOAPIRuntimeError.InvalidOperation
        }
        
        let url = "\(URLPrefix)\(housePrefix)/addQueue"
        
        var parameter = [String: AnyObject]()
        
        parameter["houseName"] = houseName
        
        parameter["queueName"] = queueName
        
        parameter["expectedNumber"] = expectedNumber
        
        parameter["ticketNumber"] = ticketNumber
        
        Alamofire.request(.POST, url, parameters: parameter).responseString(completionHandler: {response in
            var HTTPStatus: Int
            if let httpError = response.result.error {
                HTTPStatus = httpError.code
            } else {
                HTTPStatus = (response.response?.statusCode)!
            }
            
            if HTTPStatus == 200 {
                callback(errorMessage: nil)
            } else {
                var message: String?
                do {
                    try message = QNOAPIError.sharedInstance.getMessage(fromHTTPStatus: HTTPStatus)
                } catch _ {
                    message = "Unknown error occurs, please contact our support for help."
                }
                callback(errorMessage: message)
            }
        })
    }
    
    // permission: HOUSE
    func updateQueue(houseName: String, queueName: String, expectedNumber: Int, ticketNumber: Int, callback: (errorMessage: String?) -> Void) throws {
        guard (status() == .HOUSE) else {
            throw QNOAPIRuntimeError.InvalidOperation
        }
        
        let url = "\(URLPrefix)\(housePrefix)/updateQueue"
        
        var parameter = [String: AnyObject]()
        
        parameter["houseName"] = houseName

        parameter["queueName"] = queueName

        parameter["expectedNumber"] = expectedNumber
        
        parameter["ticketNumber"] = ticketNumber
        
        Alamofire.request(.POST, url, parameters: parameter).responseString(completionHandler: {response in
            var HTTPStatus: Int
            if let httpError = response.result.error {
                HTTPStatus = httpError.code
            } else {
                HTTPStatus = (response.response?.statusCode)!
            }
            
            if HTTPStatus == 200 {
                callback(errorMessage: nil)
            } else {
                var message: String?
                do {
                    try message = QNOAPIError.sharedInstance.getMessage(fromHTTPStatus: HTTPStatus)
                } catch _ {
                    message = "Unknown error occurs, please contact our support for help."
                }
                callback(errorMessage: message)
            }
        })
    }
    
    // permission: GUEST | HOUSE | CUSTOMER
    func requestQueue(houseName: String, queueName: String, callback: (errorMessage: String?) -> Void) throws {
        
        let url = "\(URLPrefix)\(housePrefix)/requestQueue"
        
        var parameter = [String: AnyObject]()
        
        parameter["houseName"] = houseName
        
        parameter["queueName"] = queueName
        
        Alamofire.request(.POST, url, parameters: parameter).responseString(completionHandler: {response in
            var HTTPStatus: Int
            if let httpError = response.result.error {
                HTTPStatus = httpError.code
            } else {
                HTTPStatus = (response.response?.statusCode)!
            }
            
            if HTTPStatus == 200 {
                callback(errorMessage: nil)
            } else {
                var message: String?
                do {
                    try message = QNOAPIError.sharedInstance.getMessage(fromHTTPStatus: HTTPStatus)
                } catch _ {
                    message = "Unknown error occurs, please contact our support for help."
                }
                callback(errorMessage: message)
            }
        })
    }
    
    // MARK: Customer Controller
    
    // permission: GUEST
    func addGuest(email: String, mobile: String?, address: String?, callback: (errorMessage: String?) -> Void) throws {
        guard (status() == .GUEST) else {
            throw QNOAPIRuntimeError.InvalidOperation
        }
        
        let url = "\(URLPrefix)\(housePrefix)/addHouse"
        
        var parameter = [String: AnyObject]()
        
        parameter["email"] = email
        
        if mobile != nil {
            parameter["mobile"] = mobile
        }
        
        if address != nil {
            parameter["address"] = address
        }
        
        Alamofire.request(.POST, url, parameters: parameter).responseString(completionHandler: {response in
            var HTTPStatus: Int
            if let httpError = response.result.error {
                HTTPStatus = httpError.code
            } else {
                HTTPStatus = (response.response?.statusCode)!
            }
            
            if HTTPStatus == 200 {
                callback(errorMessage: nil)
            } else {
                var message: String?
                do {
                    try message = QNOAPIError.sharedInstance.getMessage(fromHTTPStatus: HTTPStatus)
                } catch _ {
                    message = "Unknown error occurs, please contact our support for help."
                }
                callback(errorMessage: message)
            }
        })
    }
    
}