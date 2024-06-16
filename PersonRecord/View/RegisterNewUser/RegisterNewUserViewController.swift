//
//  RegisterNewUserViewController.swift
//  PersonRecord
//
//  Created by Apple on 15/12/23.
//

import UIKit

class RegisterNewUserViewController: UIViewController {
    
    @IBOutlet weak var formTableView: UITableView!
    
    private let viewModel = RegisterNewUserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTheme()
        configDependency()
        viewModelListner()
    }
}

// MARK: Private Functions
extension RegisterNewUserViewController {
    
    private func configTheme() {
        self.navigationItem.title = "REGISTER"
    }
    
    private func configDependency() {
        formTableView.register(cellType: FormUpperCell.self)
        formTableView.register(cellType: GenderTableViewCell.self)
        formTableView.register(cellType: DropDownOptionsTableViewCell.self)
        formTableView.register(cellType: UserImageTableViewCell.self)
        formTableView.register(cellType: SubmitButtonTableViewCell.self)
        
        formTableView.delegate = viewModel
        formTableView.dataSource = viewModel
        formTableView.separatorStyle = .none
        formTableView.allowsSelection = false
    }
    
    private func viewModelListner() {
        viewModel.showAlert = {
            let validationErrorAlert = UIAlertController(title: "Something went wrong", message: $0, preferredStyle: .alert)
            validationErrorAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(validationErrorAlert, animated: true)
        }
        
        viewModel.popVC = {
            AppRouter.shared.pop(from: self, animation: true)
        }
        
        viewModel.openProfileImage = {
            self.openProfileImagePickerMenu()
        }
    }

    private func openProfileImagePickerMenu() {
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
        photoSelectionAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        self.present(photoSelectionAlert, animated: true)
    }
}

// MARK: UIImage Picker View
extension RegisterNewUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //  Picker controller to select image from gallery or camera
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
                
                self.viewModel.profileImage = image
                guard let imageData = viewModel.profileImage.jpegData(compressionQuality: 1) else {
                    print("Failed to convert")
                    return
                }
                self.viewModel.newUserData.photo = imageData
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
