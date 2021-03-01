//
//  SignUpModel.swift
//  ChatApp
//
//  Created by Siddhant on 28/02/21.
//

import Foundation

class SignUpModel {
    var name : String?
    var dob : String?
    var imageURL : String?
    var gender : String?
    
    init(name:String?, dob:String?, imageURL: String?, gender: String?) {
        self.name = name
        self.dob = dob
        self.imageURL = imageURL
        self.gender = gender
    }
    init() {
        
    }
}

