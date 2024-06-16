//
//  Validations.swift
//  PersonRecord
//
//  Created by Apple on 19/12/23.
//

import Foundation

class Validation {
    
    static let shared = Validation()
    
    func isValidName(_ name: String) -> Bool {
        return name.count > 3 ? true : false
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passRegEx = "(?=[^a-z]*[a-z])[^0-9]*[0-9].*"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    func isPasswordConfirm(password: String, confirmPassword: String) -> Bool {
        return password == confirmPassword ? true : false
    }
    
    func isValidPhoneNumber(_ number: String) -> Bool {
        return number.count == 10 ? true : false
    }
}
