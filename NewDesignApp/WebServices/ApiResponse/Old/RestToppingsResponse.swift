//
//  RestToppingsResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 10/11/24.
//

import Foundation

struct ToppingsResponse: Codable {
        let status: String
        let error: String
        let code: Int
        let data: [RestToppingsResponse]
}

struct RestToppingsResponse: Codable {
    let id: String
    let heading: String
    let choice: String
    let free: String?
  //  let charge: String
    let sides: String
    let required: String
    let optionList: [RestOptionList]?
    var restChoice: Int {
      return Int(choice) ?? 0
    }
}
struct RestOptionList: Codable {
    let id: String
       let heading: String
       let selected: Int
       let smp: Float
       let mdp: Float
       let lgp: Float
       let exp: Float
       let xlp: Float
}
