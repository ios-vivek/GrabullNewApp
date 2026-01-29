//
//  GoogleAddressResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 25/09/24.
//

import Foundation
struct GoogleAddressResponse: Codable {
    let predictions: [Prediction]?
    let status: String?
}
struct Prediction: Codable {
    let description: String?
}

struct GoogleAddressLatLongResponse: Codable {
    let results: [ResultLatLong]?
    let status: String?
}

struct ResultLatLong: Codable {
    let formatted_address: String
    let geometry: GeometryData
    let address_components: [AddressComponents]
}

struct AddressComponents: Codable {
    let long_name: String
    let short_name: String
    let types: [String]
}

struct GeometryData: Codable {
    let location: Location
}

struct Location: Codable {
    let lat: Double
    let lng: Double
}
