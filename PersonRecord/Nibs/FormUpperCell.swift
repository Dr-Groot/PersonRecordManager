//
//  FormUpperCell.swift
//  PersonRecord
//
//  Created by Apple on 18/12/23.
//

import UIKit
import Reusable

class FormUpperCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var TextFieldBackgroundView: UIView!
    @IBOutlet weak var symbolImageView: UIImageView!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var detailLabel: UILabel!
    
    var textFieldData: ((String) -> Void)?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        detailTextField.addTarget(self, action: #selector(FormUpperCell.textFieldDidChange(_:)), for: .editingChanged)
    }
        
    func cellSetup(symbolImage: UIImage, placeholderText: String, detailLabelText: String, isSecureText: Bool) {
        
        self.TextFieldBackgroundView.layer.borderWidth = 1.5
        self.TextFieldBackgroundView.layer.borderColor = UIColor.black.cgColor
        
        self.symbolImageView.image = symbolImage
        
        self.detailTextField.placeholder = placeholderText
        
        self.detailLabel.text = detailLabelText
        self.detailLabel.textColor = .black
        
        self.detailTextField.isSecureTextEntry = isSecureText
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        textFieldData?(textField.text ?? "")
    }
    
}
