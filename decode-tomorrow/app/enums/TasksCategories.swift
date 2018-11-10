//
//  TasksCategories.swift
//  decode-tomorrow
//
//  Created by Mark on 10/11/2018.
//  Copyright © 2018 Just Because. All rights reserved.
//

import Foundation
import UIKit

enum TasksCategories: String {
    
    case creative
    case office
    case academic
    
    var text: String {
        switch self {
        case .creative:
            return "Creative"
        case .office:
            return "Office"
        case .academic:
            return "Academic"
        }
    }
    
    var color: UIColor {
        switch self {
        case .creative:
            return #colorLiteral(red: 0.1803921569, green: 0.1921568627, blue: 0.5725490196, alpha: 1)
        case .office:
            return #colorLiteral(red: 0.968627451, green: 0.5764705882, blue: 0.1176470588, alpha: 1)
        case .academic:
            return #colorLiteral(red: 0.831372549, green: 0.07843137255, blue: 0.3529411765, alpha: 1)
        }
    }
    
    init(_ text: String) {
        switch text {
        case "creative":
            self = .creative
        case "office":
            self = .office
        case "academic":
            self = .academic
        default:
            fatalError()
        }
    }
    
}
