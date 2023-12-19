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
    var userList: [RegisteredRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTheme()
        configDependency()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchUser()
    }
    
    private func configDependency() {
        userTableView.dataSource = self
        userTableView.delegate = self
        
        userTableView.register(cellType: UserTableViewCell.self)
    }
    
    private func configTheme() {
        
        self.navigationItem.title = "User"
        
        registerButton.backgroundColor = .systemBlue
        registerButton.setTitle("REGISTER", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
    }
    
    private func fetchUser() {
        do {
            let request = RegisteredRecord.fetchRequest() as NSFetchRequest<RegisteredRecord>
            self.userList = try context.fetch(request)
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
    
    @IBAction func didTapRegisterButton(_ sender: UIButton) {
        
        let userRegisterSB = UIStoryboard(name:  "UserRegister", bundle: .main)
        let registerNewUserVC = userRegisterSB.instantiateViewController(withIdentifier: "registerUserView") as! RegisterNewUserViewController
        registerNewUserVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(registerNewUserVC, animated: true)
    }
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(for: indexPath, cellType: UserTableViewCell.self)
        userCell.nameLabel.text = (self.userList[indexPath.row].firstName ?? "") + " " + (self.userList[indexPath.row].lastName ?? "")
        userCell.educationLabel.text = self.userList[indexPath.row].education
        userCell.profileImageView.image = UIImage(data: self.userList[indexPath.row].photo!)
        return userCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetailAlert(record: self.userList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _,_,_  in
            let personToRemove = self.userList[indexPath.row]
            self.context.delete(personToRemove)
            do {
                try self.context.save()
            } catch {
                print("Error in saving data while deleting")
            }
            self.fetchUser()
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
