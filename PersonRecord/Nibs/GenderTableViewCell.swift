//
//  GenderTableViewCell.swift
//  PersonRecord
//
//  Created by Apple on 18/12/23.
//

import UIKit
import Reusable

class GenderTableViewCell: UITableViewCell, NibReusable {
        
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var headingLabel: UILabel!
        
    var sendGenderResponse: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        configTheme()
    }
    
    private func configTheme() {
        maleButton.setTitle("Male", for: .normal)
        femaleButton.setTitle("Female", for: .normal)
        headingLabel.text = "Gender"
        maleButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        femaleButton.setImage(UIImage(systemName: "circle"), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.sendGenderResponse?(true)
        })
    }
    
    @IBAction func didTapMaleButton(_ sender: UIButton) {
        maleButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        femaleButton.setImage(UIImage(systemName: "circle"), for: .normal)
        sendGenderResponse?(true)
    }
    
    @IBAction func didTapFemaleButton(_ sender: UIButton) {
        maleButton.setImage(UIImage(systemName: "circle"), for: .normal)
        femaleButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        sendGenderResponse?(false)
    }
    
}
