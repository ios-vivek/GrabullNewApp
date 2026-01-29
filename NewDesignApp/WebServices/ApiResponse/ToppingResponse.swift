//
//  ToppingResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 12/10/24.
//

import Foundation
struct ToppingResponse: Codable {
    let result: String?
    let status: String?
    var data: ToppingData?
}
struct ToppingData: Codable {
    let id: String?
    let topping: [Topping]?
}
struct Topping: Codable {
    let id: String
    let heading: String
    let ch: Float?
  //  let fr: Float?
    let rq: Float?
    let sides: String?
    let option: [Option]?
}
struct Option: Codable {
    let mid: String
    let itemid: String
    let id: String
    let heading: String
    let smp: Float?
    let mdp: Float?
    let lgp: Float?
    let exp: Float?
    let xlp: Float?
    let selected: Int?
   // let status: String?
}
struct SelectedTopping: Codable {
    var toppingHeading: String
    var option: [SelectedOption]
}
struct SelectedOption: Codable {
    var opID: String
    var optionHeading: String
    var price: Float
}
