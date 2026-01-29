//
//  RestDetailResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 07/11/24.
//

import Foundation

// MARK: - API Response
struct RestDetailsApiResponse: Codable {
    let status: String
    let error: String
    let code: Int
    let data: RestDetailsRes
}

// MARK: - Restaurant Details
struct RestDetailsRes: Codable {

       let rid: String
       let name: String

       let street: String
       let address: String
       let city: String
       let state: String
       let zip: String
       let country: String

       let cuisine: String
       let timezone: String
       let longitude: String
       let latitude: String
       let phone: String

       let payByCash: String
       let payByGift: String
       let payByCard: String

       let pickup: String
       let delivery: String
       let dinein: String
       let catering: String
       let dineUrl: String
       let cateringMiles: Int
       let largeOrder: Int
       let largeOrderCharge: Int
       let largeOrderType: String
       let cateringNotice: String

       let pickupTime: Int
       let gbDelivery: String
       let gbDeliveryCharge: Double

       let deliveryMiles: Int
       let deliveryMilesWise: Int
       let deliveryMilesList: [Int]

       let minDelivery: Float
       let minPickup: Int
       let deliveryCharge: Int
       let deliveryChargeType: String
       let deliveryTime: Int

       let tax: Double
       let conv: Int
       let gbconv: Int
       let scharged: Double
       let schargeo: Int
       let schargev: Int

       let stopToday: String
       let dineStop: String
       let dineStopR: String

       let serviceFee: String
       let donateChange: String

       let note: String
       let noteAmount: Int

       let rating: Double
       let completeMeal: [String]

       let openStatus: OpenStatus
       let donateHeading: String
       let donateText: String

       let ratingHD1: String
       let ratingHD2: String

       let extraCharge: Double
       let img: String?
       let imgurl: String

    let menuList: [MenuCategory]
    let cateringList: [MenuCategory]
    let offer: [CustOfferlist]?

}
// MARK: - Menu Category
struct OpenStatus: Codable {
    let status: String
    let nextTime: String
}

// MARK: - Menu Category
struct MenuCategory: Codable {
    let id: String
        let heading: String
        let status: String
        let items: Int
        let bogo: Int
        let subMenu: String
        let itemList: [MenuItem]
        let menuList: [MenuCategory]
}

// MARK: - Menu Item
struct MenuItem: Codable {
    let id: String
       let heading: String
       let details: String
       let status: String
       let bogo: Int

       let sm: String
       let md: String
       let lg: String
       let ex: String
       let xl: String

       let smp: Double
       let mdp: Double
       let lgp: Double
       let exp: Double
       let xlp: Double

       let minQty: Int
       let tax: Int
       let used: Int
       let completeMeal: Int

       enum CodingKeys: String, CodingKey {
           case id, heading, details, status, bogo
           case sm, md, lg, ex, xl
           case smp, mdp, lgp, exp, xlp
           case minQty
           case tax, used, completeMeal
       }
    
}
struct Offerlist: Codable {
    let type: String
    let title: String
    let appliesTo: String
    let buyQty: Int
    let getQty: Int
    let itemId: String
    let itemName: String
    let size: String
}

extension MenuCategory {

    func hasSubmenu() -> Bool {
        return subMenu.lowercased() == "yes"
    }

    /// Always returns items regardless of submenu YES / NO
    func allItems() -> [MenuItem] {
        if hasSubmenu() {
            return menuList.flatMap { $0.itemList }
        } else {
            return itemList
        }
    }
}

extension MenuItem {

    var sortedPriceList: [ItemPrice] {

        var list: [ItemPrice] = []

        if !sm.isEmpty, smp > 0 {
            list.append(ItemPrice(size: sm, price: smp))
        }

        if !md.isEmpty, mdp > 0 {
            list.append(ItemPrice(size: md, price: mdp))
        }

        if !lg.isEmpty, lgp > 0 {
            list.append(ItemPrice(size: lg, price: lgp))
        }

        if !ex.isEmpty, exp > 0 {
            list.append(ItemPrice(size: ex, price: exp))
        }

        if !xl.isEmpty, xlp > 0 {
            list.append(ItemPrice(size: xl, price: xlp))
        }

        return list.sorted { $0.price < $1.price }
    }
}
struct ItemPrice {
    let size: String
    let price: Double
}

