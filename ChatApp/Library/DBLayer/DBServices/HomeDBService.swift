//
//  HomeDBService.swift
//  ChatApp
//
//  Created by Siddhant on 28/02/21.
//

import Foundation
import UIKit
import CoreData

class HomeDBService {
    func getUser(name:String, dob:String) -> SignUpModel {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return SignUpModel()
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let entity =
            NSEntityDescription.entity(forEntityName: "User",
                                       in: managedContext)!
        
        let memberFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        memberFetch.predicate = NSPredicate(format: "name = %@ AND dob = %@",  name,dob)
        let arrMatchedResult = try! managedContext.fetch(memberFetch)
        
        var signUpModel = SignUpModel()
        if(arrMatchedResult.count > 0) {
//            return true
            let obj = arrMatchedResult[0] as! User
            signUpModel = SignUpModel(name: obj.name, dob: obj.dob, imageURL: obj.imageUrl, gender: obj.gender)
        }
        return signUpModel
    }
}
