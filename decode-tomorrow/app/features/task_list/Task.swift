//
//  Task.swift
//  decode-tomorrow
//
//  Created by Mark on 10/11/2018.
//  Copyright © 2018 Just Because. All rights reserved.
//

import Foundation

struct User: Decodable {
    var name: String
}

struct Task: Decodable {
    let id: Int?
    let userId: Int?
    let claimedByUserId: Int?
    let amount: String?
    let title: String?
    let description: String?
    let category: String?
    let duration: String?
    let completedAt: String?
    let createdAt: String?
    let updatedAt: String?
    let user: User?
}
