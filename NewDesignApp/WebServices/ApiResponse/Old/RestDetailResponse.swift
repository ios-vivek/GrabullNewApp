//
//  RestDetailResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 07/11/24.
//

import Foundation

//struct RestMenu: Codable {
//    let id: String
//    let heading: String
//    let url: String
//    let sms: String
//    let mds: String
//    let lgs: String
//    let exs: String
//    let xls: String
//    let submenu: String
//    let itemList2: [RestItemList]?
//    let menulist2: [RestInnerMenu]?
//}
//struct RestInnerMenu: Codable {
//    let id: String
//    let heading: String
//    let url: String
//    let sms: String
//    let mds: String
//    let lgs: String
//    let exs: String
//    let xls: String
//  //  let submenu: String
//    let itemList: [RestItemList]?
//}
struct RestItemList: Codable {
    let completeMeal: Int
    let id: String
    let heading: String
    let details: String?
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
    let minqty: Int
    var getMinimumPrice: [Double] {
        var arr = [Double]()
        if smp > 0 {
            arr.append(smp)
        }
        if mdp > 0 {
            arr.append(mdp)
        }
        if lgp > 0 {
            arr.append(lgp)
        }
        if exp > 0 {
            arr.append(exp)
        }
        if xlp > 0 {
            arr.append(xlp)
        }
      //  print(arr.sorted())
      //  print(arr.sorted().last)
        return arr.sorted()
    }
}
struct RestOffer: Codable {
    let id: String
    let code: String
    let types: String
    let amount: Float
    let minorder: Float
}
struct DineTime: Codable {
    let hour: Int
    let value: String
}
