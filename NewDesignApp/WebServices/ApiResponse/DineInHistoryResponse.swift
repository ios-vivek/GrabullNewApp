//
//  DineInHistoryResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 17/12/24.
//

import Foundation
struct DineInHistoryResponse: Codable {
    let result: String?
    let status: String?
    var dinein: [DineInOrder]
}
struct DineInOrder: Codable {
    let booking: String
    let comment: String?
    let date: String
    let people: String
    let restaurant: String
    let status: String
}

struct ReviewResponse: Codable {
    let comment: String?
    let date: String?
    let name: String?
    let rating: String?
    let reply: String?
    let status: String?
}

