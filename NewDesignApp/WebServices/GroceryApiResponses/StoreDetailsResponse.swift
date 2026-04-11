import Foundation

struct StoreDetailsResponse: Codable {
    let status: String?
    let error: String?
    let code: Int?
    let data: StoreDetails?
}

struct StoreDetails: Codable {
    let rid: String?
    let name: String?
    let street: String?
    let address: String?
    let city: String?
    let state: String?
    let zip: String?
    let country: String?
    let timezone: String?
    let longitude: String?
    let latitude: String?
    let phone: String?
    let payByCash: String?
    let payByGift: String?
    let deliveryMiles: Int?
    let deliveryMilesWise: Int?
    let minDelivery: Int?
    let deliveryCharge: Double?
    let deliveryChargeType: String?
    let deliveryTime: Int?
    let tax: Double?
    let conv: Double?
    let scharged: Double?
    let schargeo: Double?
    let schargev: Double?
    let serviceFee: String?
    let donateChange: String?
    let rating: Double?
    let details: String?
    let payByCard: String?
    let menuList: [GroceryMenuCategory]?
}

struct GroceryMenuCategory: Codable {
    let id: String?
    let heading: String?
    let status: String?
    let itemList: [GroceryMenuItem]?
}

struct GroceryMenuItem: Codable {
    let id: String?
    let heading: String?
    let details: String?
    let status: String?
    let ptype: String?
    let itemImage: String?
    let sizeList: [SizeOption]?
}

struct SizeOption: Codable {
    let id: String?
    let heading: String?
    let details: String?
    let price: Double?
    let status: String?
}
