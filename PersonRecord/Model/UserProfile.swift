//
//  UserProfile.swift
//  PersonRecord
//
//  Created by Apple on 19/12/23.
//

import Foundation

struct UserProfile {
    var firstName: String?
    var lastName: String?
    var dob: Date?
    var education: String?
    var email: String?
    var gender: Bool?
    var mobileNumber: String?
    var password: String?
    var confirmPassword: String?
    var photo: Data?
    
    init(firstName: String? = nil, lastName: String? = nil, dob: Date? = nil, education: String? = nil, email: String? = nil, gender: Bool? = nil, mobileNumber: String? = nil, password: String? = nil, confirmPassword: String? = nil, photo: Data? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.dob = dob
        self.education = education
        self.email = email
        self.gender = gender
        self.mobileNumber = mobileNumber
        self.password = password
        self.confirmPassword = confirmPassword
        self.photo = photo
    }
}
