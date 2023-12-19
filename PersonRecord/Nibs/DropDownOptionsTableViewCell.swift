//
//  DropDownOptionsTableViewCell.swift
//  PersonRecord
//
//  Created by Apple on 18/12/23.
//

import UIKit
import Reusable

class DropDownOptionsTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var optionTextField: UITextField!
    
    var qualification: Qualification = .none
    var selectDateOption: Bool = false
    var getDropDownOption: ((String) -> Void)?
    var getChangedDate: ((Date) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configTheme()
        configDatePicker()
    }
    
    private func configTheme() {
        self.optionView.layer.borderWidth = 1.5
        self.optionView.layer.borderColor = UIColor.black.cgColor
    }
    
    private func configDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        optionTextField.inputView = datePicker
    }
    
    func configureDropDownButtonMenu() {
        let option1 = UIAction(title: "Primary") { (action) in
            self.qualification = .Primary
            self.optionTextField.text = self.qualification.rawValue
            self.getDropDownOption?(self.qualification.rawValue)
        }
        let option2 = UIAction(title: "Secondary") { (action) in
            self.qualification = .Secondary
            self.optionTextField.text = self.qualification.rawValue
            self.getDropDownOption?(self.qualification.rawValue)
        }
        let option3 = UIAction(title: "Bachelors") { (action) in
            self.qualification = .Bachelors
            self.optionTextField.text = self.qualification.rawValue
            self.getDropDownOption?(self.qualification.rawValue)
        }
        
        let option4 = UIAction(title: "Master") { (action) in
            self.qualification = .Masters
            self.optionTextField.text = self.qualification.rawValue
            self.getDropDownOption?(self.qualification.rawValue)
        }
        
        let menu = UIMenu(title: "Qualification", children: [option1, option2, option3, option4])
        optionButton.menu = menu
        optionButton.showsMenuAsPrimaryAction = true
    }
    
    func setDropDownOption(placeholderText: String, optionLabelText: String, dropDownButtonImageName: String) {
        optionTextField.placeholder = placeholderText
        self.optionLabel.text = optionLabelText
        self.optionButton.setImage(UIImage(systemName: dropDownButtonImageName), for: .normal)
    }
    
    @objc func dateChange(datePicker: UIDatePicker)
    {
        self.getChangedDate?(datePicker.date)
        optionTextField.text = formatDate(date: datePicker.date)
    }
    
    func formatDate(date: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy"
        return formatter.string(from: date)
    }
    
    @IBAction func didTapOptionsButton(_ sender: UIButton) {
        if selectDateOption {
            self.optionTextField.becomeFirstResponder()
        }
    }
}
