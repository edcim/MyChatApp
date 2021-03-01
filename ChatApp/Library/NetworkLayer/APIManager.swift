//
//  APIManager.swift
//  ChatApp
//
//  Created by Siddhant on 28/02/21.
//

import Foundation
import UIKit
import Alamofire


public enum ServiceResponse {
    case data(Constants.data)
    case success(Constants.success)
    case errors(Constants.jsonErrors)
    case failure(String)
    case noInternetConnection(String)
}
public struct Constants {
    public typealias jsonErrors = [[String: Any]]
    public typealias data = Data
    public typealias success = Bool
    typealias completionHandler = (Data?, Error?) -> Void
    typealias completionHandlerWithString = (String?, Error?) -> Void
    typealias completionHandlerForService = (Data?, CPError?) -> Void
}

public enum AlertMessageServer : String {
    case internetFailure = "Please check your internet connection."
    case serverNotResponding = "Something went wrong. Please try again."
    case serverReqTimeout = "Request timed out. Please try after sometime."
    case detailsNotAvailable = "Details not available"
}

class APIManager : NSObject {
    static let shared = APIManager()
    
    func callServerAPI(isAuth : Bool = false, method: HTTPMethod, param:[String:Any]?, urlString:String, callback: @escaping ((ServiceResponse) -> ())) {
        if(!CPNetworkRechability.isConnectedToNetwork()) {
            #if DEBUG
                print("postRequestTsream No Internet Connection")
            #endif
            callback(ServiceResponse.noInternetConnection(AlertMessageServer.internetFailure.rawValue))
        } else {
            // Network Fine and cont to API call
            let headerObj : HTTPHeaders? = ["Content-Type" : "application/json"]
            Alamofire.request(urlString,
            method: method,
            parameters: ((param == nil) ? nil : param),
            encoding: JSONEncoding.default, headers: headerObj)
              .validate()
                .response { response in
                    if let data = response.data, let responseObj = response.response {
                        let resp = responseObj.statusCode
                        print("Content-Type: \(responseObj.allHeaderFields["Content-Type"] ?? "")")
                        print("statusCode: \(responseObj.statusCode)")
                        print(String(data: data, encoding: .utf8) ?? "")
                        
                        if resp == 200 {
                            #if DEBUG
                            print("postRequest 200 Success \(response).")
                            #endif
                            DispatchQueue.main.async(execute: {
                                callback(ServiceResponse.data(data))
                            })
                        } else {
                            #if DEBUG
                            print("postRequest No specific Error.\(String(describing: response.error?.localizedDescription))")
                            #endif
                            callback(ServiceResponse.failure( AlertMessageServer.serverNotResponding.rawValue))
                            return
                        }
                    } else {
                        #if DEBUG
                        print("postRequest data Error.\(String(describing: response.error?.localizedDescription))")
                        #endif
                        callback(ServiceResponse.failure( AlertMessageServer.serverNotResponding.rawValue))
                        return
                    }
                }
        }
    }
}
