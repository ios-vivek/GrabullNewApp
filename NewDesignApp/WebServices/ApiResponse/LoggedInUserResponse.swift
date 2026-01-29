//
//  LoggedInResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 06/11/24.
//

import Foundation
struct LoggedInUserResponse: Codable {
    let result: String?
    let status: String?
    var data: UserData?
}
struct UserData: Codable {
   // let address: [UserAddress]?
   // let coupons: String?
    let customer_id: String?
    let email: String?
    let fname: String?
    let lname: String?
    let order: Int?
    let phone: String?
}
struct UserAddress: Codable {
    let address: String?
    let city: String?
    let details: String?
    let id: String?
    let landmark: String?
    let state: String?
    let street: String?
    let type: String?
    let zip: String?
}
