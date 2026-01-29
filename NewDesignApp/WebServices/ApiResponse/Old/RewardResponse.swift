//
//  RewardResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 09/11/24.
//

import Foundation
struct RewardsResponse: Codable {
    let status: String
    let error: String
    let code: Int
    let data: RewardsData
}

struct RewardsData: Codable {
    let friendCount: Int
    let friendGb: Float
    let points: Float
    let pointsGb: Float
    let restaurantCount: Int
    let restaurantGb: Float
    let rewards: Float
    let rewardsLog: [RewardsLog]
}

struct RewardsLog: Codable {
    let date: String
    let gb: String
    let log: String
    let type: RewardLogType
}

enum RewardLogType: String, Codable {
    case redeemed = "Redeemed"
    case reward = "Reward"
    case orderPoints = "Order Points"
}
