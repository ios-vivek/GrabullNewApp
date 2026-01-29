//
//  FavListResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 09/11/24.
//

import Foundation
struct FavListResponse: Codable {
    var restaurant: [Restaurant]
}
//struct FavRestaurant: Codable {
//    let id: String
//    let name: String
//    let address: String
//    let city: String
//    let state: String
//    let zip: String
//    let deliveryzip: String
//    let deliverymiles: String
//    let deliverytime: String
//    let pickuptime: String
//    let delcharge: String
//    let dchargetype: String?
//    let mindelivery: String
//    let budget: String
//    let details: String
//    let status: String
//    let stopyoday: String?
//    let openstatus: String
//    let rating: Float?
//    var favorite: String
//    let cuisine: String
//    let ordertypes: String
//    let img: String
//    let imgurl: String?
//    let offer: [Offer]?
//    var isFav: Bool {
//        if self.favorite == "Yes" {
//            return true
//        }
//        return false
//    }
//    var restImage: String {
//        return (self.imgurl ?? "") + self.img
//    }
//}
