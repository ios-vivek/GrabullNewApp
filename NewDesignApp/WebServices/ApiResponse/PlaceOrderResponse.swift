//
//  DineInHistoryResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 17/12/24.
//

import Foundation
struct PlaceOrderResponse: Codable {
    let code: Int
    let status: String
    let error: String?
    let data: OrderData
}

struct OrderData: Codable {
    let oid: String?
    let orderId: String
    let support: String
    let gateway: GatewayData?
}

struct GatewayData: Codable {
    let customer: String
    let ephemeralKey: String
    let paymentIntent: String
    let publishableKey: String
    let code: String
    let message: String
    let chargeAmount: Float
}

struct StripeConfirmRequest: Codable {
    let restaurantId: String
    var orderId: String
    var oid: String
    var transaction: String
}

struct StripeConfirmResponse: Codable {
    let status: String
    let error: String
    let code: Int
    let data: FinalOrderData
}
struct FinalOrderData: Codable {
    let oid: String
    let orderId: String
    let payment: String
    let status: String
    let message: String
    let support: String
}
