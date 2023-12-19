//
//  RegisterNewUserViewController.swift
//  PersonRecord
//
//  Created by Apple on 15/12/23.
//

import UIKit

class RegisterNewUserViewController: UIViewController {
    
    @IBOutlet weak var formTableView: UITableView!

    var profileImage: UIImage = UIImage(systemName: "person")!
    var newUserData: UserProfile = UserProfile(firstName: nil, lastName: nil, dob: nil, education: nil, email: nil, gender: nil, mobileNumber: nil, password: nil, confirmPassword: nil, photo: nil)
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTheme()
        configDependency()
    }
    
    private func configTheme() {
        
        self.navigationItem.title = "REGISTER"
    }
    
    private func configDependency() {

        formTableView.register(cellType: FormUpperCell.self)
        formTableView.register(cellType: GenderTableViewCell.self)
        formTableView.register(cellType: DropDownOptionsTableViewCell.self)
        formTableView.register(cellType: UserImageTableViewCell.self)
        formTableView.register(cellType: SubmitButtonTableViewCell.self)
        
        formTableView.delegate = self
        formTableView.dataSource = self
        formTableView.separatorStyle = .none
        formTableView.allowsSelection = false
    }
    
    private func validateUser() {
        let validNames = Validation().isValidName(self.newUserData.firstName ?? "") && Validation().isValidName(self.newUserData.lastName ?? "")
        let validEmail = Validation().isValidEmail(self.newUserData.email ?? "")
        let validPassword = Validation().isValidPassword(self.newUserData.password ?? "")
        let validConfirmPassword = Validation().isPasswordConfirm(password: self.newUserData.password ?? "", confirmPassword: self.newUserData.confirmPassword ?? "")
        let validPhoneNumber = Validation().isValidPhoneNumber(self.newUserData.mobileNumber ?? "")
        let validPhoto = self.newUserData.photo != nil ? true : false
        
        if (validNames && validEmail && validPassword && validPhoneNumber && validConfirmPassword && validPhoneNumber && validPhoto) {
            saveDataToDB()
        } else {
            let nonValidationString = "Please Check" + (validNames ? "" : " Names ") + (validEmail ? "" : " Email ") + (validPassword ? "" : " Password ") + (validConfirmPassword ? "" : " Confrim Password ") + (validPhoneNumber ? "" : " Phone Number ") + (validPhoto ? "" : " Photo ")
            let validationErrorAlert = UIAlertController(title: "Something went wrong", message: nonValidationString, preferredStyle: .alert)
            validationErrorAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(validationErrorAlert, animated: true)
        }
    }
    
    private func saveDataToDB() {
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
            self.navigationController?.popViewController(animated: true)
        } catch {
            print("Error in saving the data")
        }
    }
    
    @objc func cellTappedMethod(_ sender:AnyObject){
        let photoSelectionAlert = UIAlertController(title: "", message: "Select Image Mode", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { _ in
            let cameraPickerVC = UIImagePickerController()
            cameraPickerVC.sourceType = .camera
            cameraPickerVC.allowsEditing = true
            cameraPickerVC.delegate = self
            self.present(cameraPickerVC, animated: true)

        })
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: { _ in
            let imagePickerVC = UIImagePickerController()
            imagePickerVC.sourceType = .photoLibrary
            imagePickerVC.delegate = self
            imagePickerVC.allowsEditing = true
            self.present(imagePickerVC, animated: true)
        })
        photoSelectionAlert.addAction(cameraAction)
        photoSelectionAlert.addAction(galleryAction)
        self.present(photoSelectionAlert, animated: true)
    }
}


extension RegisterNewUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RegisterNewViews.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch RegisterNewViews(rawValue: indexPath.row) {
        case .ProfileImage:
            let profileImageCell = tableView.dequeueReusableCell(for: indexPath, cellType: UserImageTableViewCell.self)
            profileImageCell.userProfile.image = profileImage
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterNewUserViewController.cellTappedMethod(_:)))

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

extension RegisterNewUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //  Picker controller to select image from gallery or camera
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {

                    self.profileImage = image
                    guard let imageData = self.profileImage.jpegData(compressionQuality: 1) else {
                        print("Failed to convert")
                        return
                    }
                    self.newUserData.photo = imageData
                }
                
                DispatchQueue.main.async {
                    let indexPath = IndexPath(item: 0, section: 0)
                    self.formTableView.reloadRows(at: [indexPath], with: .none)

                }
                
                picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }
