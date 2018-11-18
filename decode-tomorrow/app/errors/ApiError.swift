//
//  ApiError.swift
//  decode-tomorrow
//
//  Created by Mark on 10/11/2018.
//  Copyright © 2018 Just Because. All rights reserved.
//

import Foundation

struct ApiError: Decodable {
//    let messages: [String]
    let message: String
}

// The format of the extension below is very important because the error will only be identified generically unless it's applied.

extension ApiError: Swift.Error, LocalizedError {
//    var localizedDescription: String { return messages.joined() }
//    var localizedDescription: String { return message }
    var errorDescription: String? {
        return message
    }
    
}
