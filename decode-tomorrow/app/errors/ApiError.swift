//
//  ApiError.swift
//  decode-tomorrow
//
//  Created by Mark on 10/11/2018.
//  Copyright © 2018 Just Because. All rights reserved.
//

import Foundation

struct ApiError: Decodable {
    let messages: [String]
}

extension ApiError: LocalizedError {
    var localizedDescription: String { return messages.joined() }
}
