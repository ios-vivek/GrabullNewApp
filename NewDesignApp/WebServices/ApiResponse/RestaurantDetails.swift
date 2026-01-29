//
//  RestaurantDetails.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 01/10/24.
//

import Foundation
struct RestDetailsResponse: Codable {
    let error: String?
    let status: String?
  //  var data: RestaurantDeta?
}
//struct RestaurantDeta: Codable {
//    let banner: String
//    let gallery: Gallery
//    let rating: Rating
//    let featured_item: FeaturedItems
//    let rest_details: RestaurantDetailData
//    let offers: Offers
//    let menutype: [String]
//    let menulist: [MenuList]?
//}
struct Gallery: Codable {
    let heading: String
    let img: Int
    var list = [ImageURL]()
}

struct ImageURL: Codable {
    let url: String
}
struct Rating: Codable {
    let heading1: String
    let heading2: String
    let rate: Float
}
struct FeaturedItems: Codable {
    let heading: String
    let list: [FeaturedItem]
}
struct FeaturedItem: Codable {
    let name: String
    let url: String
}
struct Offers: Codable {
    let heading: String
    let list: [OfferItem]
}
struct OfferItem: Codable {
    let heading1: String
    let heading2: String
}
struct MenuList: Codable {
    let id: String
    let heading: String
    let ctg: String
    let menuid: String?
    let itemlist: [ItemList]?
    let menulist: [MenuList]?
}
struct ItemList: Codable {
   // let sr_no: String?
    let rid: String?
    let id: String
    let pid: String?
    let heading: String
    let details: String?
    let sm: String?
    let md: String?
    let lg: String?
    let ex: String?
    let xl: String?
    let smp: Float?
    let mdp: Float?
    let lgp: Float?
    let exp: Float?
    let xlp: Float?
    let img: String?
    let note: String?
    let qty: Float?
    let icon: String?
    let itp: String?
    let spicy: Float?
    let bogo: Float?
    let taxs: Float?
    let topping: String?
    let sizet: String?
    let status: String?
    let used: Float?
    var getMinimumPrice: Float {
        var arr = [Float]()
        if let smpPrice = smp {
            arr.append(smpPrice)
        }
        if let mdpPrice = mdp {
            arr.append(mdpPrice)
        }
        if let lgpPrice = lgp {
            arr.append(lgpPrice)
        }
        if let expPrice = exp {
            arr.append(expPrice)
        }
        if let xlpPrice = xlp {
            arr.append(xlpPrice)
        }
      //  print(arr.sorted())
       // print(arr.sorted().last)
        return arr.sorted().last!
    }
   
}
struct Sizes1: Codable {
    //let menuType: MenuType
    let manuName: String
    let manuId: String
    let name: String
    let price: String
    var itemQty: Int
    let sizeKey: String
    var isCatering : Bool = false
}
struct Sizes: Codable {
    let menuType: String
    let manuName: String
    let manuId: String
    let name: String
    let price: String
    var itemQty: Int
    let sizeKey: String
    var isCatering : Bool = false
}

struct RestaurantDetailData: Codable {
    let address: String
    let city: String
    let deliverytime: Float
    let distance: Float
    let latitude: String
    let longitude: String
    let name: String
    let open_status: String
    let open_status_heading: String
    let restaurant_id: String
    let state: String
    let street: String
    let zip: String
    let storetype: String
    let timezone: String
    let phone: String
    let paybycard: String
    let paybygift: String
    let pickup: String
    let delivery: String
    let catering: String
    let cateringmiles: Int
    let largorder: Int
    let largordercharge: Int
    let largechargetype: String
    let cateringnotice: Int
    let delcharge: Float
    let delchargetype: String
    let mindelivery: Int
    let minpickup: Int
    let pickuptime: Int
    let tax: Float
    let conv: Int
    let schargemin: Float
    let schargemax: Int
    let schargemaxord: Int
    let serfee: String
    let donatechange: String
    let donateheading: String
    let donatetext: String
}
