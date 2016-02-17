//
//  QNOAPI.swift
//  QNO
//
//  Created by Xinhong LIU on 11/1/2016.
//  Copyright © 2016 September. All rights reserved.
//

import Foundation
import Alamofire

enum QNOAPIStatus: Int {
    case GUEST = 0
    case CUSTOMER = 1
    case HOUSE = 2
    case CH = 3
}

enum QNOAPIRuntimeError: ErrorType {
    case InvalidOperation
}

class QNOAPI {
    
    let URLPrefix = "http://144.214.121.58:8080/JOS"
    let housePrefix = "/house"
    let customerPrefix = "/customer"
    let adPrefix = "/ad"
    
    var userId: String?
    var accessToken: String?

    func status() -> QNOAPIStatus {
        var s = 0
        
        if QNOStorage.getHouseName() != nil {
            s = s | QNOAPIStatus.HOUSE.rawValue
        }
        
        return QNOAPIStatus(rawValue: s)!
    }
    
    // MARK: House Controller
    
    // permission: GUEST
    func addHouse(houseName: String, address: String?, tel: String?, homepage: String?, callback: (errorMessage: String?) -> Void) throws {
        
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
        guard (status().rawValue & QNOAPIStatus.HOUSE.rawValue > 0) else {
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
    func removeQueue(houseName: String, queueName: String, callback: (errorMessage: String?) -> Void) throws {
        guard (status().rawValue & QNOAPIStatus.HOUSE.rawValue > 0) else {
            throw QNOAPIRuntimeError.InvalidOperation
        }
        
        let url = "\(URLPrefix)\(housePrefix)/removeQueue"
        
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
    
    // permission: HOUSE
    func updateQueue(houseName: String, queueName: String, expectedNumber: Int, ticketNumber: Int, callback: (errorMessage: String?) -> Void) throws {
        guard (status().rawValue & QNOAPIStatus.HOUSE.rawValue > 0) else {
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
    func requestQueue(houseName: String, queueName: String, callback: (errorMessage: String?, response: NSData?) -> Void) throws {
        
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
                callback(errorMessage: nil, response: response.data)
            } else {
                var message: String?
                do {
                    try message = QNOAPIError.sharedInstance.getMessage(fromHTTPStatus: HTTPStatus)
                } catch _ {
                    message = "Unknown error occurs, please contact our support for help."
                }
                callback(errorMessage: message, response: nil)
            }
        })
    }
    
    // permission: GUEST | HOUSE | CUSTOMER
    func requestAllQueues(houseName: String, callback: (errorMessage: String?, response: NSData?) -> Void) throws {
        
        let url = "\(URLPrefix)\(housePrefix)/queryQueues"
        
        var parameter = [String: AnyObject]()
        
        parameter["houseName"] = houseName
        
        Alamofire.request(.POST, url, parameters: parameter).responseString(completionHandler: {response in
            var HTTPStatus: Int
            if let httpError = response.result.error {
                HTTPStatus = httpError.code
            } else {
                HTTPStatus = (response.response?.statusCode)!
            }
            
            if HTTPStatus == 200 {
                callback(errorMessage: nil, response: response.data)
            } else {
                var message: String?
                do {
                    try message = QNOAPIError.sharedInstance.getMessage(fromHTTPStatus: HTTPStatus)
                } catch _ {
                    message = "Unknown error occurs, please contact our support for help."
                }
                callback(errorMessage: message, response: nil)
            }
        })
    }
    
    // MARK: Customer Controller
    
    // permission: GUEST
    func addCustomer(account: String, email: String?, mobile: String?, address: String?, callback: (errorMessage: String?) -> Void) throws {
        
        let url = "\(URLPrefix)\(customerPrefix)/addCustomer"
        
        var parameter = [String: AnyObject]()
        
        parameter["customerId"] = account
        
        if email != nil {
            parameter["email"] = email
        }
        
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
    
    func requestAllHouses(callback: (errorMessage: String?, houses: [AnyObject]?) -> Void) throws {
        let url = "\(URLPrefix)\(housePrefix)/listAllHouses"
        
        Alamofire.request(.POST, url).responseString(completionHandler: {response in
            var HTTPStatus: Int
            if let httpError = response.result.error {
                HTTPStatus = httpError.code
            } else {
                HTTPStatus = (response.response?.statusCode)!
            }
            
            if HTTPStatus == 200 {
                do {
                    let houses = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments) as! [AnyObject]
                    callback(errorMessage: nil, houses: houses)
                } catch {
                    callback(errorMessage: "Response is invalid", houses: nil)
                }
            } else {
                var message: String?
                do {
                    try message = QNOAPIError.sharedInstance.getMessage(fromHTTPStatus: HTTPStatus)
                } catch _ {
                    message = "Unknown error occurs, please contact our support for help."
                }
                callback(errorMessage: message, houses: nil)
            }
        })
    }
    
    func requestAllAds(callback: (errorMessage: String?, ads: [AnyObject]?) -> Void) throws {
        let url = "\(URLPrefix)\(adPrefix)/allAds"
        
        Alamofire.request(.POST, url).responseString(completionHandler: {response in
            var HTTPStatus: Int
            if let httpError = response.result.error {
                HTTPStatus = httpError.code
            } else {
                HTTPStatus = (response.response?.statusCode)!
            }
            
            if HTTPStatus == 200 {
                do {
                    let ads = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments) as! [AnyObject]
                    callback(errorMessage: nil, ads: ads)
                } catch {
                    callback(errorMessage: "Response is invalid", ads: nil)
                }
            } else {
                var message: String?
                do {
                    try message = QNOAPIError.sharedInstance.getMessage(fromHTTPStatus: HTTPStatus)
                } catch _ {
                    message = "Unknown error occurs, please contact our support for help."
                }
                callback(errorMessage: message, ads: nil)
            }
        })
    }
}
