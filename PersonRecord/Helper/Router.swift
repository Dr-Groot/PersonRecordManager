//
//  Router.swift
//  PersonRecord
//
//  Created by Aman Pratap Singh on 16/06/24.
//

import Foundation
import UIKit
import Contacts

enum AppStoryBoard: String {
    case userRegister = "UserRegister"
}

enum Route: String {
    case userListingVC
    case registerNewUserVC
}


protocol Router {
    func route(
        to route: Route,
        from context: UIViewController,
        parameters: Any?
    )
    func pop(
        from context: UIViewController, animation: Bool
    )
}

class AppRouter: Router {
    
    static let shared = AppRouter()
    
    func pop(from context: UIViewController, animation: Bool) {
        DispatchQueue.main.async {
            if let navcontroller = context.navigationController {
                navcontroller.popViewController(animated: animation)
            }
        }
    }
    
    func route (to route: Route, from context: UIViewController, parameters: Any?) {
        DispatchQueue.main.async {
            switch route {
            case .registerNewUserVC:
                if let controller = self.getViewController(ofType: RegisterNewUserViewController.self, storyBoard: AppStoryBoard.userRegister.rawValue) {
                    context.navigationController?.pushViewController(controller, animated: true)
                }
            case .userListingVC:
                if let controller = self.getViewController(ofType: UserViewController.self, storyBoard: AppStoryBoard.userRegister.rawValue) {
                    context.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    // MARK: - Get ViewController From Storyboard
    private func getViewController<T: UIViewController>(ofType viewController: T.Type, storyBoard: String) -> T? {
        if let controller = UIStoryboard(name: storyBoard, bundle: nil).instantiateViewController(withIdentifier: String(describing: type(of: T()))) as? T {
            return controller
        }
        return nil
    }
}
