//
//  FavoriteList.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 07/09/24.
//

import Foundation
struct FavoriteListResponse: Codable {
    let result: String?
    let status: String?
    var data: FavData?
}
struct FavData: Codable {
    var rest_list: FavListData
}
struct FavListData: Codable {
    let heading: String
    var list: [RestaurantList]
}

