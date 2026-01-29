//
//  UserResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 08/11/24.
//

import Foundation
struct LoginResponse: Codable {
    let status: String
    let error: String
    let code: Int
    let data: UserResponse
}

struct UserResponse: Codable {
    let login: Bool
    let result: String
    var customer: User
}

struct User: Codable {
       let customerId: String
       let firstName: String
       let lastName: String
       let email: String
       let phone: String
       let coupons: String?
       var address: [UserAdd]
       let orders: Int
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

struct Coupons: Codable {
    let amount: String
    let code: String
    let min: String
    let text1: String
    let text2: String
    let text3: String
    let text4: String
    let text5: String
    let type: String
}
struct UserAdd: Codable {

    let id: Int
    let street: String?
    let add1: String?
    let add2: String?
    let add3: String?
    let addtypes: String?
    let city: String?
    let state: String?
    let zip: String?

    var fullAddress: String {
        let components = [
            street,
            add1,
            add2,
            add3,
            city,
            state,
            zip
        ]

        return components
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }
}
struct RemoveAddressResponse: Codable {
    var message: String
    var result: String
}
struct AddedAddressResponse: Codable {
    let status: String
    let error: String
    let code: Int
    let data: DataResult
}
struct DataResult: Codable {
    var result: String
}
struct FavoriteResponse: Codable {
    var message: String
    var result: String
}
struct ChangePasswordResponse: Codable {
    let status: String
       let error: String
       let code: Int
       let data: ResponseMessage
}
struct ResponseMessage: Codable {
    let result: String
}
struct ForgotPasswordResponse: Codable {
    let status: String
       let error: String
       let code: Int
       let data: ForgotMessage
}
struct ForgotMessage: Codable {
    let message: String
}

struct DineBookedResponse: Codable {
    var result: String
    var status: String
    var support: String
    var id: String
}
struct AddressListResponse: Codable {
    let status: String
    let error: String
    let code: Int
    let data: [UserAdd]
}
