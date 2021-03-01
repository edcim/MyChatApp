//
//  LogInService.swift
//  ChatApp
//
//  Created by Siddhant on 28/02/21.
//

import Foundation
import UIKit
import CoreData

class LoginService {
    func getUser(name:String, dob:String) ->Bool {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let entity =
            NSEntityDescription.entity(forEntityName: "User",
                                       in: managedContext)!
        
        let memberFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        memberFetch.predicate = NSPredicate(format: "name = %@ AND dob = %@",  name,dob)
        let arrMatchedResult = try! managedContext.fetch(memberFetch)
        
        if(arrMatchedResult.count > 0) {
            return true
        } else {
            return false
        }
    }
}
