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
    let status: String
    var storeAvailable: String {
        return status == "Active" ? "" : "Store does not take online orders"
    }
    var showDeliveryTime: String {
        guard let deliveryTime = deliveryTime, deliveryTime > 0 else {
            return ""
        }

        if deliveryTime == 1 {
            return "Next day delivery"
        } else {
            return "\(deliveryTime) days delivery"
        }
    }
    var fullAddress: String {
        let parts = [
            street,
            address,
            city,
            state,
            zip,
            country
        ]
        
        return parts
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }
}

struct GroceryMenuCategory: Codable {
    let id: String?
    let heading: String?
    let status: String?
    let hasSuperMenu: Bool?
    let itemList: [GroceryMenuItem]?
    let itemListSub: [GroceryMenuCategory]?
}

extension GroceryMenuCategory {
    var allItems: [GroceryMenuItem] {
        if hasSuperMenu == true {
            return itemListSub?.flatMap { $0.itemList ?? [] } ?? []
        }
        return itemList ?? []
    }
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
    let name: String?
    let size: String?
    let price: Double?
}
extension Array where Element == SizeOption {
    func sortedByPrice() -> [SizeOption] {
        return self.sorted {
            ($0.price ?? 0) < ($1.price ?? 0)
        }
    }
}

// MARK: - Expanded Category with Hierarchy
struct ExpandedGroceryMenuCategory {
    let parentId: String?
    let parentHeading: String?
    let subHeadingId: String?
    let subHeading: String?
    let itemList: [GroceryMenuItem]?
}

