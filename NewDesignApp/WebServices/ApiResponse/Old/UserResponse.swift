//
//  UserResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 08/11/24.
//

import Foundation
struct LoginResponse: Codable {
    let status: String
    let error: String
    let code: Int
    let data: UserResponse
}

struct UserResponse: Codable {
    let login: Bool
    let result: String
    var customer: User
}

struct User: Codable {
       let customerId: String
       let firstName: String
       let lastName: String
       let email: String
       let phone: String
       let coupons: String?
       var address: [UserAdd]
       let orders: Int
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

struct Coupons: Codable {
    let amount: String
    let code: String
    let min: String
    let text1: String
    let text2: String
    let text3: String
    let text4: String
    let text5: String
    let type: String
}
struct UserAdd: Codable {

    let id: String
    let street: String?
    let add1: String?
    let add2: String?
    let add3: String?
    let type: String?
    let city: String?
    let state: String?
    let zip: String?

    var fullAddress: String {
        let components = [
            street,
            add1,
            add2,
            add3,
            city,
            state,
            zip
        ]

        return components
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }
}
struct RemoveAddressResponse: Codable {
    var message: String
    var result: String
}
struct AddedAddressResponse: Codable {
    let status: String
    let error: String
    let code: Int
    let data: DataResult
}
struct DataResult: Codable {
    var result: String
}
struct FavoriteResponse: Codable {
    var message: String
    var result: String
}
struct ChangePasswordResponse: Codable {
    let status: String
       let error: String
       let code: Int
       let data: ResponseMessage
}
struct ResponseMessage: Codable {
    let result: String
}
struct ForgotPasswordResponse: Codable {
    let status: String
       let error: String
       let code: Int
       let data: ForgotMessage
}
struct ForgotMessage: Codable {
    let message: String
}

struct DineBookedResponse: Codable {
    var result: String
    var status: String
    var support: String
    var id: String
}
struct AddressListResponse: Codable {
    let status: String
    let error: String
    let code: Int
    let data: [UserAdd]
}

struct DeleteAccountResponse: Codable {
    let status: String?
    let error: String?
    let code: Int?
    let message: String?
    let result: String?
    let data: DeleteAccountData?
}

struct DeleteAccountData: Codable {
    let result: String?
    let message: String?
}

// MARK: - App Version Check Response

struct AppVersionResponse: Codable {
    let status: String?
    let error: String?
    let code: Int?
    let message: String?
    let data: AppVersionData?
}

struct AppVersionData: Codable {
    let latestVersion: String?
    let minimumVersion: String?
    let isForceUpdate: Bool?
    let title: String?
    let message: String?
    let appStoreUrl: String?

    enum CodingKeys: String, CodingKey {
        case latestVersion = "latest_version"
        case latestVersionAlt = "latestVersion"
        case minimumVersion = "minimum_version"
        case minimumVersionAlt = "minimumVersion"
        case isForceUpdate = "is_force_update"
        case forceUpdate = "force_update"
        case isForceUpdateAlt = "isForceUpdate"
        case title
        case message
        case appStoreUrl = "app_store_url"
        case appStoreUrlAlt = "appStoreUrl"
    }

    init(
        latestVersion: String? = nil,
        minimumVersion: String? = nil,
        isForceUpdate: Bool? = nil,
        title: String? = nil,
        message: String? = nil,
        appStoreUrl: String? = nil
    ) {
        self.latestVersion = latestVersion
        self.minimumVersion = minimumVersion
        self.isForceUpdate = isForceUpdate
        self.title = title
        self.message = message
        self.appStoreUrl = appStoreUrl
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        latestVersion = (try? container.decodeIfPresent(String.self, forKey: .latestVersion))
            ?? (try? container.decodeIfPresent(String.self, forKey: .latestVersionAlt))

        minimumVersion = (try? container.decodeIfPresent(String.self, forKey: .minimumVersion))
            ?? (try? container.decodeIfPresent(String.self, forKey: .minimumVersionAlt))

        title = try? container.decodeIfPresent(String.self, forKey: .title)
        message = try? container.decodeIfPresent(String.self, forKey: .message)

        appStoreUrl = (try? container.decodeIfPresent(String.self, forKey: .appStoreUrl))
            ?? (try? container.decodeIfPresent(String.self, forKey: .appStoreUrlAlt))

        var force: Bool? = nil
        for key in [CodingKeys.isForceUpdate, .forceUpdate, .isForceUpdateAlt] {
            if let b = try? container.decodeIfPresent(Bool.self, forKey: key) {
                force = b
                break
            } else if let i = try? container.decodeIfPresent(Int.self, forKey: key) {
                force = (i == 1)
                break
            } else if let s = try? container.decodeIfPresent(String.self, forKey: key) {
                force = (s == "1" || s.lowercased() == "true")
                break
            }
        }
        isForceUpdate = force
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(latestVersion, forKey: .latestVersion)
        try container.encodeIfPresent(minimumVersion, forKey: .minimumVersion)
        try container.encodeIfPresent(isForceUpdate, forKey: .isForceUpdate)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(message, forKey: .message)
        try container.encodeIfPresent(appStoreUrl, forKey: .appStoreUrl)
    }
}
