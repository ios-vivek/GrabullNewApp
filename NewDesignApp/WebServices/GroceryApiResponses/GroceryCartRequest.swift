//
//  GroceryCartRequest.swift
//  NewDesignApp
//
//  Created by GitHub Copilot on 26/04/26.
//

import Foundation

struct GroceryCartRequest: Codable {
    let apiId: String
    let apiKey: String
    let restaurantId: String
    let dbname: String
    let customerId: String
    let fname: String
    let lname: String
    let phone: String
    let email: String
    let add1: String
    let add2: String
    let city: String
    let state: String
    let zip: String
    let orderat: String
    let payBy: String
    let stripeId: String
    let giftnumber: String
    let newcard: String
    let addcard: String
    let cardno: String
    let cvv: String
    let expiry: String
    let cardholder: String
    let billingzip: String
    let orderasGift: String
    let recipientname: String
    let recipientphone: String
    let transactionIdentifier: String
    let specialinstruction: String
    let holdtime: String
    let holddate: String
    let orderType: String
    let offerdetails: String
    let offeramount: Double
    let dcharge: String
    let scharge: String
    let tips: String
    let donate: String
    let rewards: String
    let total: String
    let items: [CartItems]
    let isSubstituteItemApplied: Bool


    enum CodingKeys: String, CodingKey {
        case apiId = "api_id"
        case apiKey = "api_key"
        case restaurantId = "restaurant_id"
        case dbname
        case customerId = "customer_id"
        case fname, lname, phone, email, add1, add2, city, state, zip, orderat
        case payBy = "pay_by"
        case stripeId = "stripeId"
        case giftnumber, newcard, addcard, cardno, cvv, expiry, cardholder, billingzip
        case orderasGift = "orderas_gift"
        case recipientname, recipientphone
        case transactionIdentifier = "transaction_identifier"
        case specialinstruction, holdtime, holddate
        case orderType = "order_type"
        case offerdetails, offeramount, dcharge, scharge, tips, donate, rewards, total, items
        case isSubstituteItemApplied = "is_substitute_item_applied"
    }
}

struct CartItems: Codable {
    let id: String
    let mid: String
    let heading: String
    let menu: String
    let size: String
    let sizeh: String
    let tax: Int
    let qty: String
    let price: String
}
