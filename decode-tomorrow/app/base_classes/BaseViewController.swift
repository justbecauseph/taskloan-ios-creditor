//
//  BaseViewController.swift
//  decode-tomorrow
//
//  Created by Mark on 10/11/2018.
//  Copyright © 2018 Just Because. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController<R: BaseRepository>: UIViewController {
    var repository: R?
}
