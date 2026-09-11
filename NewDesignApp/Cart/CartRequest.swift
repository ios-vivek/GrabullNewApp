//
//  CartData.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 15/10/24.
//

import Foundation
struct CartRequest: Codable {

    let name: String
    let recipientphone: String
    let email: String
    let orderType: String
    let customerId: String
    let add2: String
    let devicetype: String
    let holddate: String
    let dcharge: String
    let holdtime: String
    let items: [CartItem]
    let apiKey: String
    let apiId: String
    let offeramount: Float
    let state: String
    let recipientname: String
    let total: String
    let tips: String
    let transactionIdentifier: String
    let dbname: String
    let city: String
    let payBy: String
    let orderasGift: String
    let scharge: String
    let restaurantId: String
    let donate: String
    let orderat: String
    let did: String
    let rewards: String
    let specialinstruction: String
    let phone: String
    let add1: String
    let offerdetails: String
    let zip: String
    let giftnumber: String

    enum CodingKeys: String, CodingKey {
        case name, recipientphone, email
        case orderType = "order_type"
        case customerId = "customer_id"
        case add2, devicetype, holddate, dcharge, holdtime, items
        case apiKey = "api_key"
        case apiId = "api_id"
        case offeramount, state, recipientname
        case total, tips, transactionIdentifier, dbname, city
        case payBy = "pay_by"
        case orderasGift
        case scharge
        case restaurantId = "restaurant_id"
        case donate, orderat, did, rewards
        case specialinstruction, phone, add1, offerdetails, zip, giftnumber
    }
}
struct CartItem: Codable {

    let toppingList: String
    let free: String
    let freenote: String
    let extamount: String
    let extracharge: String
    let menu: String
    let mid: String
    let extra: String
    let tax: Int
    let menutype: String
    let addedInst: String
    let sizeh: String
    let id: String
    let size: String
    let price: String
    let heading: String
    let qty: String
}
