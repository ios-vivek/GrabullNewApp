//
//  RestDetailResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 07/11/24.
//

import Foundation

// MARK: - Restaurant Details
struct CustomRestDetails: Codable {
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

    let menuList: [CustMenuCategory]
    let cateringList: [CustMenuCategory]
    let offer: [CustOfferlist]?
    
    var isDelivery: Bool {
        return self.delivery == "Yes"
    }
    var isPickup: Bool {
        return self.pickup == "Yes"
    }
    var isRestaurantOpenToday: Bool {
        return self.openStatus.status == "Open Now"
    }
}

// MARK: - Menu Category
struct CustMenuCategory: Codable {
    let id: String
    let heading: String
    let subid: String
    let subheading: String
    let submenu: String
    let itemList: [MenuItem]
}

extension RestDetailsApiResponse {

    func toCustomModel() -> CustomRestDetails {
        return data.toCustomModel()
    }
}
extension RestDetailsRes {

    func toCustomModel() -> CustomRestDetails {

        return CustomRestDetails(
            rid: rid,
            name: name,

            street: street,
            address: address,
            city: city,
            state: state,
            zip: zip,
            country: country,
            
            cuisine: cuisine,
            timezone: timezone,
            longitude: longitude,
            latitude: latitude,
            phone: phone,
           
            payByCash: payByCash,
            payByGift: payByGift,
            payByCard: payByCard,

            pickup: pickup,
            delivery: delivery,
            dinein: dinein,
            catering: catering,
            
            dineUrl: dineUrl,

            cateringMiles: cateringMiles,
            largeOrder: largeOrder,
            largeOrderCharge: largeOrderCharge,
            largeOrderType: largeOrderType,
            cateringNotice: cateringNotice,
            
            pickupTime: pickupTime,
            gbDelivery: gbDelivery,
            gbDeliveryCharge: gbDeliveryCharge,
            
            deliveryMiles: deliveryMiles,
            deliveryMilesWise: deliveryMilesWise,
            deliveryMilesList: deliveryMilesList,
            
            minDelivery: minDelivery,
            minPickup: minPickup,
            deliveryCharge: deliveryCharge,
            deliveryChargeType: deliveryChargeType,
            deliveryTime: deliveryTime,
            
            tax: tax,
            conv: conv,
            gbconv: gbconv,
            scharged: scharged,
            schargeo: schargeo,
            schargev: schargev,

            stopToday: stopToday,
            dineStop: dineStop,
            dineStopR: dineStopR,
            
            serviceFee: serviceFee,
            donateChange: donateChange,

            note: note,
            noteAmount: noteAmount,

            rating: rating,
            completeMeal: completeMeal,

            openStatus: openStatus,
            donateHeading: donateHeading,
            donateText: donateText,

            ratingHD1: ratingHD1,
            ratingHD2: ratingHD2,
            
            menuList: menuList.flatMap { $0.toCustomCategories() },
            cateringList: cateringList.flatMap { $0.toCustomCategories() },
            offer: offer


        )
    }
}
extension MenuCategory {

    func toCustomCategories() -> [CustMenuCategory] {

        // Case 1: submenu = NO → direct category
        if subMenu.lowercased() == "no" {
            return [
                CustMenuCategory(
                    id: id,
                    heading: heading,
                    subid: "",
                    subheading: "",
                    submenu: subMenu,
                    itemList: itemList
                )
            ]
        }

        // Case 2: submenu = YES → flatten menulist
        return menuList.map { sub in
            CustMenuCategory(
                id: id,
                heading: heading,
                subid: sub.id,
                subheading: sub.heading,
                submenu: subMenu,
                itemList: sub.itemList
            )
        }
    }
}

// MARK: - Offer
struct CustOfferlist: Codable {
    let type: String
      let title: String
      let appliesTo: String
      let time: OfferTime

      // Item-based
      let buyQty: Int?
      let getQty: Int?
      let itemId: String?
      let itemName: String?
      let size: String?

      // Order-based
      let discountValue: Int?
      let discountType: String?
      let minAmount: Int?

      // Buy / Free (getFree type)
      let buy: CustOfferItem?
      let free: CustOfferItem?
}

struct OfferTime: Codable {
    let type: String
   // let days: OfferDays?
}
struct OfferDays: Codable {
    let sun: OfferDay?
    let mon: OfferDay?
    let tue: OfferDay?
    let wed: OfferDay?
    let thu: OfferDay?
    let fri: OfferDay?
    let sat: OfferDay?
}
struct OfferDay: Codable {
    let status: String
    let open: String
    let close: String
}

struct CustOfferItem: Codable {
    let itemId: String
    let itemName: String
    let size: String
}
