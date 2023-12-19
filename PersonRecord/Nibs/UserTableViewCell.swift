//
//  UserTableViewCell.swift
//  PersonRecord
//
//  Created by Apple on 19/12/23.
//

import UIKit
import Reusable

class UserTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        configTheme()
    }
    
    private func configTheme() {
        profileImageView.layer.borderWidth = 1.5
        profileImageView.layer.borderColor = UIColor.blue.cgColor
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }

}
