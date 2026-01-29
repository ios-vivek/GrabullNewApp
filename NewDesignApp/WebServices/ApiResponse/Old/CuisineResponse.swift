//
//  CuisineResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 07/11/24.
//

import Foundation
struct SavedLocation: Codable {
    let locations: [Localocation]
}
struct Localocation: Codable {
    let addressID : String!
    let subLocality : String!
    let zipcode : String!
    let city : String!
    let state : String!
    let country : String!
    let lat : String!
    let long : String!
    let locality : String!
    let premise : String!
    let streetNumber : String!
    let route : String!
}
struct CuisineResponse: Codable {
    let code: Int
    let data: CuisineData
    let error: String
    let status: String
}
struct CuisineData: Codable {
    let banner: String
      let slider: [RestSlider]
      let cuisineHeading: String
      let cuisine: [Cuisine]
      let coupon: [Coupon]
}
struct Cuisine: Codable {
    let heading: String
        let url: String
        let img: String
        let imgUrl: String
    var cuisineImage: String {
        return OldServiceType.cuisineImageUrl + img
    }
}
struct RestSlider: Codable {
    let url: String
}
struct Coupon: Codable {
    let heading: String
       let text1: String
       let text2: String
       let text3: String
       let text4: String
       let text5: String
       let code: String
       let amount: Int
       let type: String
       let min: Int
}
struct PastOrderRest: Codable {
    let restId: String
    let count: Int
}

struct SavedAddressInDB: Codable {
    let address: String
    let date: Date
}
