//
//  UIView+shake.swift
//  decode-tomorrow
//
//  Created by Mark on 11/11/2018.
//  Copyright © 2018 Just Because. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func shake() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
}
