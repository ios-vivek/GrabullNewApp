//
//  DineInHistoryResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 17/12/24.
//

import Foundation

struct BookingHistoryResponse: Codable {
    let status: String
    let code: Int
    let data: [BookingItem]
    let error: String
}
struct BookingItem: Codable {
    let booking: String
    let status: String
    let phone: String
    let details: String
    let occasion: String
    let reply: String?
    let restaurantName: String
    let peopleCount: Int
    let bookingRaw: String
    let dateRaw: String
    let date: String
    let replyDate: String?
    let email: String
    let name: String
    let payment: String
}

struct ReviewResponse: Codable {
    let comment: String?
    let date: String?
    let name: String?
    let rating: String?
    let reply: String?
    let status: String?
}

