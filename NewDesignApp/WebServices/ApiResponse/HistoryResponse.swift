//
//  HistoryResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 28/11/24.
//

import Foundation
struct HisoryResponse: Codable {
    let status: String
       let error: String
       let code: Int
       let data: [OrderHistory]
}
struct OrderHistory: Codable {
    let order: String
        let resturantID: String
        let timeZone: String
        let resturant: String
        let date: String
        let type: String
        let deliveryAddress: [String]
        let holdtime: String
        let holddate: String?
        let trackorder: String
        let name: String
        let phone: String
        let email: String
        let status: String

        let subtotal: Double
        let discount: Double
        let offer: String
        let taxM: Double
        let taxC: Double
        let scharge: Double
        let deliveryCharge: Double
        let tips: Double
        let tips2: Double
        let reward: Double
        let total: Double

        let details: String
        let orderItems: [OrderItem]
        let addedItems: [OrderItem]
    let recipientphone: String
    let recipientname: String

        enum CodingKeys: String, CodingKey {
            case order
            case resturantID = "resturant_id"
            case timeZone
            case resturant
            case date
            case type
            case deliveryAddress
            case holdtime
            case holddate
            case trackorder
            case name
            case phone
            case email
            case status
            case subtotal
            case discount
            case offer
            case taxM
            case taxC
            case scharge
            case deliveryCharge
            case tips
            case tips2
            case reward
            case total
            case details
            case orderItems
            case addedItems
            case recipientphone
            case recipientname
        }
}
struct OrderItem: Codable {
    let item: String
    let instruction: String
    let qty: Int
    let price: Double
    let extra: String
    let examount: Double
    let extraCahrge: Double
    let menuType: String
    let menu: String
}


struct OrderItems: Codable {
    let item: String
    let instruction: String
    let qty: Float
    let price: Float
    let extra: String
    let examount: Float
}
struct CardDetailsResponse: Codable {
    let status: String
       let error: String
       let code: Int
       let data: [SavedCard]
}

struct SavedCard: Codable {
    let id: String
        let cardholder: String
        let cardn: String
        let cvv: String?
        let expdate: String?
        let zip: String
        let isDefault: Bool

        enum CodingKeys: String, CodingKey {
            case id
            case cardholder
            case cardn
            case cvv
            case expdate
            case zip
            case isDefault = "default"
        }
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            id = try container.decode(String.self, forKey: .id)
            cardholder = try container.decode(String.self, forKey: .cardholder)

            // cardn can come as Int or String
            if let cardNumber = try? container.decode(String.self, forKey: .cardn) {
                cardn = cardNumber
            } else {
                cardn = String(try container.decode(Int.self, forKey: .cardn))
            }

            // zip can come as Int or String
            if let zipString = try? container.decode(String.self, forKey: .zip) {
                zip = zipString
            } else {
                zip = String(try container.decode(Int.self, forKey: .zip))
            }

            cvv = try? container.decode(String.self, forKey: .cvv)
            expdate = try? container.decode(String.self, forKey: .expdate)

            let defaultValue = try container.decode(String.self, forKey: .isDefault)
            isDefault = defaultValue.lowercased() == "yes"
        }
}

struct SaveCardResponse: Codable {
    let status: String
        let error: String
        let code: Int
        let data: RemoveCardData
}
struct RemoveCardData: Codable {
    let result: String
}
struct ReferFriendResponse: Codable {
    let status: String
        let code: Int
        let data: UserAlreadyRegisteredData?
        let error: String?
}
struct UserAlreadyRegisteredData: Codable {
    let email: String
}
struct ReferFriendListResponse: Codable {
     let status: String
       let code: Int
       let data: ReferFriendListData
       let error: String
}
struct ReferFriendListData: Codable {
    let result: String
    let refertList: [ReferList]
}
struct ReferList: Codable {
    let date: String?
    let email: String?
    let gb: String?
    let status: String?
}

struct ReferRestaurantListResponse: Codable {
    let status: String
       let code: Int
       let data: [ReferRestaurantList]
       let error: String?
}

struct ReferRestaurantList: Codable {
    let address: String?
    let date: String?
    let details: String?
    let email: String?
    let gb: String?
    let name: String?
    let owner: String?
    let phone: String?
    let status: String?
    let website: String?
}
struct ReferRestaurantResponse: Codable {
    let status: String
       let code: Int
       let data: NameData?
       let error: String?
}
struct NameData: Codable {
    let name: String
}

struct SupportConcernResponse: Codable {
    let status: String
       let code: Int
       let data: ComplaintSubmitData?
       let error: String?
}

struct ComplaintSubmitData: Codable {
    let complaintId: String
    let message: String
}

struct SupportListResponse: Codable {
    let result: String?
    let message: String?
    let custList: [CustList]
}
struct CustList: Codable {
    let cstatus: String?
    let date: String?
    let details: String?
    let id: String?
    let subject: String?
    let type: String?
    let user: String?
}

struct SupportDetailResponse: Codable {
       let status: String
       let code: Int
       let data: [ChatData]?
       let error: String?
}
struct ChatData: Codable {
    let id: String?
    let date: String?
    let subject: String?
    let status: String?
    let chatList: [ChatList]
}
struct ChatList: Codable {
    let type: String?
    let date: String?
    let subject: String?
    let details: String?
}
