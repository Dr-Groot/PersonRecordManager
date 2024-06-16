//
//  RegisterNewUserViewModel.swift
//  PersonRecord
//
//  Created by Aman Pratap Singh on 16/06/24.
//

import Foundation
import UIKit

class RegisterNewUserViewModel: NSObject {
    
    var profileImage: UIImage = UIImage(systemName: "person")!
    var newUserData: UserProfile = UserProfile(firstName: nil, lastName: nil, dob: nil, education: nil, email: nil, gender: nil, mobileNumber: nil, password: nil, confirmPassword: nil, photo: nil)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var showAlert:((String) -> Void)?
    var popVC: (() -> Void)?
    var openProfileImage: (() -> Void)?
    
    private func validateUser() {
        let isValidUser: [Bool] = [
            self.newUserData.firstName?.isValidName() ?? false && self.newUserData.lastName?.isValidName() ?? false,
            self.newUserData.email?.isValidEmail() ?? false,
            self.newUserData.password?.isValidPassword() ?? false,
            self.newUserData.password == self.newUserData.confirmPassword ? true : false,
            self.newUserData.mobileNumber?.isValidPhoneNumber() ?? false,
            self.newUserData.photo != nil ? true : false
        ]
        
        isValidUser.allSatisfy({$0})
            ? saveUserDataToDB()
            : showAlert?("Field Missing Or Invalid: " + (isValidUser[0] ? "" : " Names ") + (isValidUser[1] ? "" : " Email ") + (isValidUser[2] ? "" : " Password ") + (isValidUser[3] ? "" : " Confrim Password ") + (isValidUser[4] ? "" : " Phone Number ") + (isValidUser[5] ? "" : " Photo "))
    }
    
    private func saveUserDataToDB() {
        let newUser = RegisteredRecord(context: self.context)
        newUser.firstName = self.newUserData.firstName
        newUser.lastName = self.newUserData.lastName
        newUser.dob = self.newUserData.dob
        newUser.education = self.newUserData.education
        newUser.email = self.newUserData.email
        newUser.gender = self.newUserData.gender ?? true
        newUser.mobileNumber = self.newUserData.mobileNumber
        newUser.password = self.newUserData.password
        newUser.photo = self.newUserData.photo
        
        do{
            try self.context.save()
            self.popVC?()
        } catch {
            print("Error in saving the data")
        }
    }
    
    @objc func profileImageTapped(_ sender:AnyObject){
        openProfileImage?()
    }
}

extension RegisterNewUserViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RegisterNewViews.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch RegisterNewViews(rawValue: indexPath.row) {
            
        case .ProfileImage:
            let profileImageCell = tableView.dequeueReusableCell(for: indexPath, cellType: UserImageTableViewCell.self)
            profileImageCell.userProfile.image = profileImage
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(_:)))
            profileImageCell.userProfile.isUserInteractionEnabled = true
            profileImageCell.userProfile.tag = indexPath.row
            profileImageCell.userProfile.addGestureRecognizer(tapGestureRecognizer)
            return profileImageCell
            
        case .FirstName:
            let upperCell = tableView.dequeueReusableCell(for: indexPath, cellType: FormUpperCell.self)
            upperCell.cellSetup(symbolImage: UIImage(systemName: "person.fill")!, placeholderText: "Enter your first name here", detailLabelText: "First Name", isSecureText: false)
            upperCell.textFieldData = {
                self.newUserData.firstName = $0
            }
            return upperCell
            
        case .LastName:
            let upperCell = tableView.dequeueReusableCell(for: indexPath, cellType: FormUpperCell.self)
            upperCell.cellSetup(symbolImage: UIImage(systemName: "person.fill")!, placeholderText: "Enter your last name here", detailLabelText: "Last Name", isSecureText: false)
            upperCell.textFieldData = {
                self.newUserData.lastName = $0
            }
            return upperCell
            
        case .PhoneNumber:
            let upperCell = tableView.dequeueReusableCell(for: indexPath, cellType: FormUpperCell.self)
            upperCell.cellSetup(symbolImage: UIImage(systemName: "phone.fill")!, placeholderText: "Enter your 10 digit phone number here", detailLabelText: "Phone Number", isSecureText: false)
            upperCell.textFieldData = {
                self.newUserData.mobileNumber = $0
            }
            return upperCell
            
        case .Email:
            let upperCell = tableView.dequeueReusableCell(for: indexPath, cellType: FormUpperCell.self)
            upperCell.cellSetup(symbolImage: UIImage(systemName: "mail.fill")!, placeholderText: "Your email goes here", detailLabelText: "Email", isSecureText: false)
            upperCell.textFieldData = {
                self.newUserData.email = $0
            }
            return upperCell
            
        case .Gender:
            let genderCell = tableView.dequeueReusableCell(for: indexPath, cellType: GenderTableViewCell.self)
            genderCell.sendGenderResponse = {
                self.newUserData.gender = $0
            }
            return genderCell
            
        case .Password:
            let upperCell = tableView.dequeueReusableCell(for: indexPath, cellType: FormUpperCell.self)
            upperCell.cellSetup(symbolImage: UIImage(systemName: "lock.fill")!, placeholderText: "Password", detailLabelText: "Password", isSecureText: true)
            upperCell.textFieldData = {
                self.newUserData.password = $0
            }
            return upperCell
            
        case .ConfirmPassword:
            let upperCell = tableView.dequeueReusableCell(for: indexPath, cellType: FormUpperCell.self)
            upperCell.cellSetup(symbolImage: UIImage(systemName: "lock.fill")!, placeholderText: "Password", detailLabelText: "Confirm Password", isSecureText: false)
            upperCell.textFieldData = {
                self.newUserData.confirmPassword = $0
            }
            return upperCell
            
        case .Education:
            let educatonCell = tableView.dequeueReusableCell(for: indexPath, cellType: DropDownOptionsTableViewCell.self)
            educatonCell.configureDropDownButtonMenu()
            educatonCell.setDropDownOption(placeholderText: "Select Your Qualification", optionLabelText: "Education", dropDownButtonImageName: "arrowtriangle.down.fill")
            educatonCell.getDropDownOption = {
                self.newUserData.education = $0
            }
            return educatonCell
            
        case .DateOfBirth:
            let dateOfBirthCell = tableView.dequeueReusableCell(for: indexPath, cellType: DropDownOptionsTableViewCell.self)
            dateOfBirthCell.selectDateOption = true
            dateOfBirthCell.setDropDownOption(placeholderText: "Select Your Date Of Birth", optionLabelText: "Date Of Birth", dropDownButtonImageName: "arrowtriangle.down.fill")
            dateOfBirthCell.getChangedDate = {
                self.newUserData.dob = $0
            }
            return dateOfBirthCell
            
        case .Submit:
            let submitCell = tableView.dequeueReusableCell(for: indexPath, cellType: SubmitButtonTableViewCell.self)
            submitCell.submitButtonTapped = {
                print(self.newUserData)
                self.validateUser()
            }
            return submitCell
            
        default:
            let upperCell = tableView.dequeueReusableCell(for: indexPath, cellType: FormUpperCell.self)
            upperCell.cellSetup(symbolImage: UIImage(systemName: "person.fill")!, placeholderText: "Enter your first name here", detailLabelText: "NA", isSecureText: false)
            return upperCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
