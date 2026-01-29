//
//  RestaurantListResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 07/11/24.
//

import Foundation
struct RestaurantListResponse: Codable {
    var error: String
    var status: String
    var data: RestaurantL
}
struct RestaurantL: Codable {
    var address: String
    var restaurants: [Restaurant]
}
struct Restaurant: Codable {
    
    let rid: String
    let name: String
    let address: String
    let catering: String
    let delivery: String
    let dinein: String

    let deliveryTime: Int
    let pickupTime: Int
    let pickup: String
    let minDelivery: Int

    let rating: Float?
    var favorite: String
    let cuisine: String
    let img: String
    let imgUrl: String?
    let imgUrlM: String?

    let offer: [Offer]
    let offerIconsUrl: String?
    let offericons: String

    let distance: Float?
    let dbname: String
    
    var isFav: Bool {
        if self.favorite == "Yes" {
            return true
        }
        return false
    }
    var restImage: String {
        return (self.imgUrlM ?? "") + self.img
    }
    var restBannerImage: String {
        return (self.imgUrl ?? "") + self.img
    }
}

struct Offer: Codable {
    let appliesTo: String
  //  let discountValue: Int
  //  let minAmount: Int
    let type: String
    let title: String
}

