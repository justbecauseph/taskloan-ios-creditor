//
//  TasksListFeature.swift
//  decode-tomorrow
//
//  Created by Mark on 10/11/2018.
//  Copyright © 2018 Just Because. All rights reserved.
//

import Foundation
import RxSwift

struct GetTaskListViewModel {
    
    struct TaskViewModel {
        init(_ model: Task) {
        }
    }
    
    var tasks: [TaskViewModel]
    
    init(_ model: TaskListResponse) {
        self.tasks = model.array.map { TaskViewModel($0) }
    }
}

protocol TasksListFeatureDelegate {
    func getTaskListSuccess(_ viewModel: GetTaskListViewModel)
    func getLoanError(error: String)
}

class TasksListFeature: Feature<TasksListFeatureDelegate> {
    
    func fetchTasksList() {
        provider.request(.getTasksList).mapX(TaskListResponse.self, dBag: dBag) { (event) in
            switch event {
            case .next(let value):
                let vm = GetTaskListViewModel(value)
                self.delegate?.getTaskListSuccess(vm)
            case .error(let error):
                self.delegate?.getLoanError(error: error.localizedDescription)
            case .completed:
                break
            }
        }
    }
    
}

