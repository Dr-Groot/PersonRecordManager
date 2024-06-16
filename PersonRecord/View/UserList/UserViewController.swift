//
//  UserViewController.swift
//  PersonRecord
//
//  Created by Apple on 15/12/23.
//

import UIKit
import CoreData

class UserViewController: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var userTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let viewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTheme()
        configDependency()
        viewModelListner()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
    }
    
    @IBAction func didTapRegisterButton(_ sender: UIButton) {
        AppRouter.shared.route(to: .registerNewUserVC, from: self, parameters: nil)
    }
}

// MARK: Private Function
extension UserViewController {
    
    private func configTheme() {
        self.navigationItem.title = "User"
        registerButton.backgroundColor = .systemTeal
        registerButton.setTitle("REGISTER", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
    }
    
    private func configDependency() {
        userTableView.register(cellType: UserTableViewCell.self)
        userTableView.dataSource = viewModel
        userTableView.delegate = viewModel
    }
    
    private func viewModelListner() {
        viewModel.showUserDetailAlert = {
            self.showDetailAlert(record: $0)
        }
        
        viewModel.deleteUser = { user in
            self.context.delete(user)
            do {
                try self.context.save()
            } catch {
                print("Error in saving data while deleting")
            }
            self.fetchUser()
        }
    }
    
    private func fetchUser() {
        do {
            let request = RegisteredRecord.fetchRequest() as NSFetchRequest<RegisteredRecord>
            viewModel.userList = try context.fetch(request)
            DispatchQueue.main.async {
                self.userTableView.reloadData()
            }
        } catch {
            print("Unable to fetch request")
        }
    }
    
    private func showDetailAlert(record: RegisteredRecord) {
        // dob, email, gender, mobile number
        let dob = record.dob
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy"
        let formattedDate = formatter.string(from: dob ?? Date.now)
        
        let email = record.email!
        let gender = (record.gender) ? "Male" : "Female"
        let mobileNumber = record.mobileNumber!
        let name = record.firstName! + " " + record.lastName!
        
        let alertMessage = "DOB: \(formattedDate)\n Email: \(email)\n Gender: \(gender)\n Mobile Number: \(mobileNumber)\n"
        
        let detailAlert = UIAlertController(title: name, message: alertMessage, preferredStyle: .alert)
        detailAlert.addAction(UIAlertAction(title: "Done", style: .cancel))
        self.present(detailAlert, animated: true)
    }
}
