//
//  TaskDeleter.swift
//  decode-tomorrow
//
//  Created by Mark on 11/11/2018.
//  Copyright © 2018 Just Because. All rights reserved.
//

import Foundation
import RxSwift

class TaskDeleter {
    
    static let shared = TaskDeleter()
    
    let dBag = DisposeBag()
    
    func deleteTask(then: (() -> Void)) {
        Provider.sharedRx.request(.deleteTask).mapX(EmptyResponse.self, dBag: dBag) { (event) in
            print("")
        }
    }
    
}
