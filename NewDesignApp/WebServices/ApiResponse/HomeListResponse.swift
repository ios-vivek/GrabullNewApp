//
//  HomeListResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 07/09/24.
//

import Foundation
struct HomeListDataResponse: Codable {
    let result: String?
    let status: String?
    let data: RestListData?
    /// This is a list of users, we might have pagination information, thus struct comes in handy in holding that information
}
struct RestListData: Codable {
    let banner: String
    let slider: [Slider]
    let cousine: [Cousine]
    var rest_list: RestList
}

struct Slider: Codable {
    let url: String
}
struct Cousine: Codable {
    let heading: String
    let list: [CousineList]
}
struct CousineList: Codable {
    let name: String
    let url: String
}
struct RestList: Codable {
    let heading: String
    var list: [RestaurantList]
}
struct RestaurantList: Codable {
    let address: String
    let city: String
    let deliverytime: String
    let distance: String
    let image: String
    let latitude: String
    let longitude: String
    let name: String
    let state: String
    let street: String
    let zip: String
    var favorite: Int
    let restaurant_id: String
}
