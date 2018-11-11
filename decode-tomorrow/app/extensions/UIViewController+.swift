//
//  UIViewController+.swift
//  decode-tomorrow
//
//  Created by Mark on 10/11/2018.
//  Copyright © 2018 Just Because. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    enum AlertType {
        case info
        case success
        case error
        
        var title: String {
            switch self {
            case .info:
                return "Good Day!"
            case .success:
                return "Success!"
            case .error:
                return "Error"
            }
        }
        
    }
    
    struct AffirmativeAction {
        let name: String
        let handler: (() -> Void)
    }
    
    struct CancelAction {
        let name: String
        let handler: (() -> Void)
    }
    
    func showAlert(_ type: AlertType,
                   title paramTitle: String? = nil,
                   message: String,
                   affirmativeAction: AffirmativeAction? = nil,
                   cancelAction: CancelAction? = nil) {
        
        let title = paramTitle ?? type.title
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let aAction = affirmativeAction {
            alertController.addAction(UIAlertAction(title: aAction.name, style: .default, handler: { (_) in
                aAction.handler()
            }))
        }
        
        if let cAction = cancelAction {
            alertController.addAction(UIAlertAction(title: cAction.name, style: .cancel, handler: { (_) in
                cAction.handler()
            }))
        }
        
        if affirmativeAction == nil && cancelAction == nil {
            let basicAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(basicAction)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
