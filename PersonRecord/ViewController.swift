//
//  ViewController.swift
//  PersonRecord
//
//  Created by Apple on 15/12/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // Reference to managed object context.

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
//    private func saveData() {
//
//        let newUser = RegisteredRecord(context: self.context)
//        newUser.dob = .now
//        newUser.education = "Education"
//        newUser.email = "email"
//        newUser.firstName = "First"
//        newUser.gender = false
//        newUser.lastName = "Last"
//        newUser.mobileNumber = "Mobile Number"
//        newUser.password = "lalala"
//
//        let imageData = getImage?.jpegData(compressionQuality: 1.0)
//        newUser.photo = imageData
//
//        do{
//            try self.context.save()
//        } catch {
//            print("Error in saving the data")
//        }
//
//        print("Called")
//    }
    
    

}
