//
//  Destination.swift
//  decode-tomorrow
//
//  Created by Mark on 10/11/2018.
//  Copyright © 2018 Just Because. All rights reserved.
//

import Foundation
import UIKit

enum Destination {
    
    enum NavigationType {
        case present
        case push
    }
    
    case login(CallsAnApiBehindLogin)
    case register
    case documentUpload
    case dashboard
    case taskDetails(TaskViewModel)
    case loan(taskId: Int, loanAmount: String)
    
    var viewController: UIViewController {
        switch self {
        case .login(let callsAnApiBehindLogin):
            let vc = LoginViewController.instanciate()
            vc.callsAnApiBehindMe = callsAnApiBehindLogin
            return vc
        case .register:
            return RegistrationViewController.instanciate()
        case .documentUpload:
            return DocumentUploadViewController.instanciate()
        case .dashboard:
            return DashboardViewController.instanciate()
        case .taskDetails(let taskViewModel):
            let vc = TaskDetailViewController.instanciate()
            vc.initValues(taskViewModel)
            return vc
        case .loan(let id, let amount):
            let vc = LoanViewController.instanciate()
            vc.initValues(id, loanAmount: amount)
            return vc
        }
    }
    
    var completion: (() -> Void)? {
        switch self {
        case .login,
             .register,
             .documentUpload,
             .dashboard,
             .taskDetails,
             .loan:
            return nil
        }
    }
    
    var navType: NavigationType {
        switch self {
        case .login,
             .register,
             .documentUpload,
             .dashboard:
            return .present
        case .taskDetails,
             .loan:
            return .push
        }
    }
    
    var animated: Bool {
        switch self {
        case .login,
             .dashboard:
            return false
        case .register,
             .documentUpload,
             .taskDetails,
             .loan:
            return true
        }
    }
    
}
