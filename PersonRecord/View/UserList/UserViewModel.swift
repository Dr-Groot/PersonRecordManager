//
//  UserViewModel.swift
//  PersonRecord
//
//  Created by Aman Pratap Singh on 16/06/24.
//

import Foundation
import UIKit

class UserViewModel: NSObject {
    
    var userList: [RegisteredRecord] = []
    var showUserDetailAlert: ((RegisteredRecord) -> Void)?
    var deleteUser: ((RegisteredRecord) -> Void)?
}

extension UserViewModel: UITableViewDelegate, UITableViewDataSource {
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
        showUserDetailAlert?(self.userList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _,_,_  in
            self.deleteUser?(self.userList[indexPath.row])
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

