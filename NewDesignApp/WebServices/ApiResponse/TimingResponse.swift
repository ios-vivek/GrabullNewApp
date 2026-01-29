//
//  TimingResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 26/10/24.
//

import Foundation

struct RestTimingResponse: Codable {
    let status: String
    let data: RestTiming
    let error: String
}
struct RestTiming: Codable {
    let date: String
    let Delivery: String
    let Pickup: String
    let deliveryTime: [String]
    let pickupTime: [String]
   // let timeData: TimeData
}
struct Times: Codable {
    let ht: String
    let t: String
    let a: String
}
struct TimeToday: Codable {
    let timeToday: String
    let t: String
    let a: String
}
struct DayDateList: Codable {
    let day: String
    let date: String
    let currectDateInFormate: String
}

struct TimeSlots: Codable {
    let time: String
    let date: Date
}

struct TimeData: Codable {
    let timeSlot: [TimeSlot]
    let timedata: [TimeDataInner]
    let pickupList: [String]
    let deliveryList: [String]
    //let c-time: String
    let ctime: String
    let openstatus: String
    let openstatuslater: String
    let timeToday: TimeTodays

}
struct TimeTodays: Codable {
    let pickup: String
    let delivery: String
    let deliveryc: String
    let pickupc: String
    let time: String
    let slotsDelivery: [Int]
    let slotsPickup: [Int]
}

struct TimeSlot: Codable {
    let frif: String
    let frit: String
    let monf: String
    let mont: String
    let satf: String
    let satt: String
    let sunf: String
    let sunt: String
    let thuf: String
    let thut: String
    let tuef: String
    let tuet: String
    let wedf: String
    let wedt: String
}
struct TimeDataInner: Codable {
    let delivery: String?
    let frif: String?
    let frit: String?
    let monf: String?
    let mont: String?
    let pickup: String?
    let rid: String?
    let satf: String?
    let satt: String?
    let slot: String?
    let sr_no: String?
    let sunf: String?
    let sunt: String?
    let thuf: String?
    let thut: String?
    let tuef: String?
    let tuet: String?
    let wedf: String?
    let wedt: String?
}
//struct SeletedTime: Codable {
//    let ht: String
//    let t: String
//    let a: String
//    let finalTimeAndDate: String
//    let heading: String
//}
struct SeletedTime: Codable {
    let date: String
    let time: String
    let heading: String
}
