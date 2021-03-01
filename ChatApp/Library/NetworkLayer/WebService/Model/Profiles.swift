//
//  Profiles.swift
//  ChatApp
//
//  Created by Siddhant on 28/02/21.
//

import Foundation

class Profiles : Codable {
    var picture: String?
    var name: String?
    var geoLocation: GeoLocationConfig?
    var gender : String?
    var age: Int?
    var favoriteColor: String?
    var phone: String?
    var lastSeen: String?
    var _id: String?
    var email: String?
}

class GeoLocationConfig : Codable {
    var latitude: Double?
    var longitude : Double?
}
