//
//  SignUpService.swift
//  ChatApp
//
//  Created by Siddhant on 28/02/21.
//

import Foundation
import UIKit
import CoreData


class SignUpService {
    func saveUser(model :SignUpModel) {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let entity =
            NSEntityDescription.entity(forEntityName: "User",
                                       in: managedContext)!
        
        let memberFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        memberFetch.predicate = NSPredicate(format: "%K = %@", "dob", model.dob ?? "")
        
        let arrMatchedResult = try! managedContext.fetch(memberFetch)
        
        if(arrMatchedResult.count > 0){
            return
        }
        
        let user = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        user.setValue(model.name, forKeyPath: "name")
        user.setValue(model.dob, forKey: "dob")
        user.setValue(model.gender, forKey: "gender")
        user.setValue(model.imageURL, forKey: "imageUrl")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
}
