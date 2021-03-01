//
//  ProfilesService.swift
//  ChatApp
//
//  Created by Siddhant on 28/02/21.
//

import Foundation

class ProfilesService {
//    func getProfile(requestString : String, completed: ((_ success: String?,_ error:ECError?) -> ())?) {
//
//    }
    
    func getProfile( requestString:String, completed: ((_ profiles: [Profiles]?,_ error:CPError?) -> ())? ) {
        
        APIManager.shared.callServerAPI(isAuth: false, method: .post, param: nil, urlString: requestString) { (response) in
            switch response {
            case .errors(let error) :
                // MARK:- Todo :- send proper error
                let serverError = CPError.init(code: "00", type: "Unknown", message: error.debugDescription)
                completed?(nil, serverError)
                print(error)
            case .failure(let failed) :
                // MARK:- Todo :- send proper response
                let serverError = CPError.init(code: "00", type: "Unknown", message: failed.debugDescription)
                completed?(nil, serverError)
            case .success(let json) :
                // MARK:- Todo :- send proper success
                print("Success : \(json)")
            case .noInternetConnection(let noInternetConnection):
                let serverError = CPError.init(code: "00", type: "Unknown", message: noInternetConnection)
                completed?(nil, serverError)
            case .data(let data):
                // MARK:- Todo :- data Object convert into respective model
                do {
                    let responseString = String(data: data, encoding: .utf8)
                    let ggg = responseString?.replacingOccurrences(of: "\\", with: "")
                    print("responseString = \(String(ggg ?? ""))")
                    
                    let decoder = JSONDecoder()
                    let reservationData = try decoder.decode([Profiles].self, from: data)
                    
                        completed?(reservationData, nil)
                    
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
                print("data Object convert into respective model: \(data)")
            }
        }
    }
}
