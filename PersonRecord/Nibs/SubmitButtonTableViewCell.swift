//
//  SubmitButtonTableViewCell.swift
//  PersonRecord
//
//  Created by Apple on 19/12/23.
//

import UIKit
import Reusable

class SubmitButtonTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var submitButton: UIButton!
    
    var submitButtonTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    @IBAction func didTapSubmitButton(_ sender: UIButton) {
        submitButtonTapped?()
    }
    
}
