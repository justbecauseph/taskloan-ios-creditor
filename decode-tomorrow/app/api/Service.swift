//
//  Service.swift
//  decode-tomorrow
//
//  Created by Mark on 10/11/2018.
//  Copyright © 2018 Just Because. All rights reserved.
//

import Foundation
import Moya

enum Service {
    case login(LoginParams)
    case register(RegistrationParams)
    case uploadDocument(Data)
    case getTasksList(TasksCategories)
    case claimTask(ClaimTaskParams)
}

extension Service: TargetType {
    
    var baseURL: URL {
        let urlString = "https://taskloan.pro/api/"
        guard let url = URL(string: urlString) else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .login:
            return "login"
        case .register:
            return "users"
        case .getTasksList:
            return "tasks"
        case .uploadDocument:
            return "me/documents"
        case .claimTask:
            return "me/task"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login,
             .register,
             .uploadDocument,
             .claimTask:
            return .post
        case .getTasksList:
            return .get
        }
    }
    
    var sampleData: Data {
        return "{}".data(using: .utf8)!
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let params):
            return .requestJSONEncodable(params)
        case .register(let params):
            return .requestJSONEncodable(params)
        case .uploadDocument(let data):
            let mfd = MultipartFormData(provider: .data(data), name: "id_photo", fileName: "filename", mimeType: "image/jpeg")
            return .uploadMultipart([mfd])
        case .getTasksList:
            return .requestParameters(parameters: ["with[]": "user"], encoding: URLEncoding.default)
        case .claimTask(let params):
            return .requestJSONEncodable(params)
        }
    }
    
    enum AuthType {
        case none
        case loggedIn
    }
    
    var headers: [String : String]? {
        switch self.authType {
        case .none:
            return ["Accept": "application/json"]
        case .loggedIn:
            return [HeaderKeys.authorization.rawValue: "Basic \(CredentialsManager.shared.token!)",
                    "Accept": "application/json"]
        }
    }
    
}

// MARK: - Custom

extension Service {
    
    var authType: AuthType {
        switch self {
        case .register,
             .login:
            return .none
        case .uploadDocument,
             .getTasksList,
             .claimTask:
            return .loggedIn
        }
    }
    
}
