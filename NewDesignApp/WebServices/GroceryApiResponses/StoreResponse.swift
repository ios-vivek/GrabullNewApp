//
//  RestDetailResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 07/11/24.
//

import Foundation

// MARK: - Root Response
struct StoreResponse: Codable {
    let status: String
    let error: String
    let code: Int
    let data: StoreData
}

// MARK: - Data
struct StoreData: Codable {
    let address: String
    let latitude: Double
    let longitude: Double
    let radius: Int
    let count: Int
    let restaurants: [Store]
}

// MARK: - Restaurant
struct Store: Codable {
    let rid: String
    let name: String
    let address: String
    let cuisine: String
    let rating: Double
    let minDelivery: Int
    let dbname: String
    let img: String
    let pickup: String
    let delivery: String
    let dinein: String
    let catering: String
    let pickupTime: Int
    let deliveryTime: Int
    let offericons: String
    let distance: Double
    let dineUrl: String
    let imgUrl: String
    let imgUrlM: String
    let offerIconsUrl: String
    let favorite: String
    let offer: [GroceryOffer]   // empty array currently
    var fullImageURL: String {
        return imgUrl + img
    }
}

// MARK: - Offer (empty for now but future-proof)
struct GroceryOffer: Codable {
    // Add fields when API provides data
}

