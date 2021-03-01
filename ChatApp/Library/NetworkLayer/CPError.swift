//
//  CPError.swift
//  ChatApp
//
//  Created by Siddhant on 28/02/21.
//

import Foundation

class CPError {
    
    var code: String?
    var type: String?
    var message: String?
    
    init(code: String, type:String, message:String) {
        self.code = code
        self.type = type
        self.message = message
    }

}
