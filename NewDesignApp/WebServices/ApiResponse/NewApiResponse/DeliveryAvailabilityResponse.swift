//
//  RestDetailResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 07/11/24.
//

import Foundation

// MARK: - API Response
struct DeliveryAvailabilityResponse: Codable {
    let status: String
    let error: String?
    let code: Int
    let data: DeliveryAvailabilityData?
    var isAvailable: Bool {
        if code == 200 && data != nil {
            if data!.message.contains("Delivery Available") {
                return true
            }
        }
        return false
    }
}

struct DeliveryAvailabilityData: Codable {
   // let allowedMiles: Int
   // let distance: Int
   // let custAddress: String
   // let menuType: String
    let message: String
}
