//
//  UtilsClass.swift
//  Grabul
//
//  Created by Omnie on 2/11/19.
//  Copyright © 2019 Omnie. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MBProgressHUD
//import GoogleSignIn
//import FBSDKLoginKit
import Contacts
class UtilsClass: NSObject {
    public static func isRestaurantClosedToday(_ dateinstring: String)-> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let result = formatter.string(from: Date())
        print(result)
        print(dateinstring)
        if result == dateinstring {
            return true
        }
            return false
    }
    public static func getLocalLanuage() -> String {
        let locale = NSLocale.current.language.languageCode?.identifier
        return locale ?? "en"
    }
    public static func getFullAddress()-> String {
        var fullAddress = ""
        var premise = APPDELEGATE.selectedLocationAddress.premise
        let local = APPDELEGATE.selectedLocationAddress.subLocality ?? ""
        let city = APPDELEGATE.selectedLocationAddress.city ?? ""
        var mainAdd = ""
        if premise.count > 0 {
            premise = "\(premise), "
        }
        if local.count > 0 {
            mainAdd = "\(premise)\(local), \(city)"
        }
        else if city.count > 0 {
            mainAdd = "\(city)"
        }
        
        fullAddress = "\(mainAdd), \(APPDELEGATE.selectedLocationAddress.state ?? ""), \(APPDELEGATE.selectedLocationAddress.zipcode ?? "")"
        return fullAddress
    }
    public static func saveUserDetails() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(APPDELEGATE.userResponse) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SavedPerson")
        }
    }
    public static func getuserDetails() {
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: "SavedPerson") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(UserResponse.self, from: savedPerson) {
               // print(loadedPerson.customer.fname)
                APPDELEGATE.userResponse = loadedPerson
            }
        }
    }
//    public static func saveAddress(address: SavedAddressInDB) {
//        var myArray = self.getAddress()
//        if !myArray.contains(address){
//            let arr = Array(myArray.prefix(4).reversed())
//            myArray = arr
//            myArray.append(address)
//        }
//
//        // Save to UserDefaults
//        UserDefaults.standard.set(myArray, forKey: "savedAddress")
//
//        // Retrieve from UserDefaults
//        if let savedArray = UserDefaults.standard.stringArray(forKey: "savedAddress") {
//            print(savedArray)
//        }
//    }
    public static func saveAddress(address: SavedAddressInDB) {
        var savedPastAddresses: [SavedAddressInDB] = self.getAddress()
        if let index = savedPastAddresses.firstIndex(where: { $0.address == address.address }) {
            // If exists, increment count and move to front
            var updatedRest = savedPastAddresses[index]
            updatedRest = SavedAddressInDB(address: updatedRest.address, date: Date())
            savedPastAddresses.remove(at: index)
            savedPastAddresses.insert(updatedRest, at: 0)
        } else {
            // If not exists, insert new at front
            savedPastAddresses.insert(address, at: 0)
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(savedPastAddresses) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "savedAddress")
        }
    }
   
    public static func getAddress() -> [SavedAddressInDB] {
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.data(forKey: "savedAddress") {
            let decoder = JSONDecoder()
            do {
                let loadedObject = try decoder.decode([SavedAddressInDB].self, from: savedData)
                return loadedObject.sorted { $0.date > $1.date }
            } catch {
                print("Decoding error:", error)
            }
        }
        return []
    }
    public static func saveInspairedPast(restID: String) {
        var allRest = self.getInspairedPast()
        if let index = allRest.firstIndex(of: restID) {
            allRest.remove(at: index)
            allRest.insert(restID, at: 0)
        } else {
            allRest.insert(restID, at: 0)
        }
        UserDefaults.standard.set(allRest, forKey: "inspairedPast")
    }
    public static func getInspairedPast() -> [String] {
        var restList:[String] = []
        let defaults = UserDefaults.standard
        if let savedAdd = defaults.object(forKey: "inspairedPast") as? [String] {
            restList = savedAdd
        }
        return restList
    }
    public static func savePastOrderRest(pastOrderRest: PastOrderRest) {
        var savedPastOrderRest: [PastOrderRest] = self.getPastOrdersRest()
        if let index = savedPastOrderRest.firstIndex(where: { $0.restId == pastOrderRest.restId }) {
            // If exists, increment count and move to front
            var updatedRest = savedPastOrderRest[index]
            updatedRest = PastOrderRest(restId: updatedRest.restId, count: updatedRest.count + 1)
            savedPastOrderRest.remove(at: index)
            savedPastOrderRest.insert(updatedRest, at: 0)
        } else {
            // If not exists, insert new at front
            savedPastOrderRest.insert(pastOrderRest, at: 0)
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(savedPastOrderRest) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "PastOrderRest")
        }
    }
    public static func getPastOrdersRest() -> [PastOrderRest] {
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.data(forKey: "PastOrderRest") {
            let decoder = JSONDecoder()
            do {
                let loadedObject = try decoder.decode([PastOrderRest].self, from: savedData)
                return loadedObject.sorted { $0.count > $1.count }
            } catch {
                print("Decoding error:", error)
            }
        }
        return []
    }
    public static func saveCousines() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(APPDELEGATE.cusines) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "Cousine")
        }
    }
    public static func getCousines() {
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: "Cousine") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(CuisineResponse.self, from: savedPerson) {
               // print(loadedPerson.customer.fname)
                APPDELEGATE.cusines = loadedPerson
            }
        }
    }
    public static func showProgressHud(view: UIView) {
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    public static func hideProgressHud(view: UIView) {
        MBProgressHUD.hide(for: view, animated: true)
    }
    public static func getCurrencySymbol()-> String {
        let locale = Locale.current
        let currencySymbol = locale.currencySymbol!
        return currencySymbol
    }
    public static func shadow(Vw : UIView, cornerRadius: CGFloat?)
    {
        Vw.clipsToBounds = true
        Vw.layer.masksToBounds = false
        Vw.layer.shadowColor =  UIColor.lightGray.cgColor
        Vw.layer.shadowOffset = CGSize(width: 1, height: 1)
        Vw.layer.shadowRadius = 5.0
        Vw.layer.shadowOpacity = 15.0
        Vw.layer.cornerRadius = cornerRadius ?? 15
    }
    public static func isMultipleSizeAvailable(sizeType: String)-> Bool {
        return sizeType == "Multiple" ? true : false
    }
public static func getAttributedString(str1: String, str2: String) -> NSMutableAttributedString{
    let myString1:NSString = str1 as NSString
    let myString2:NSString = str2 as NSString
    var myMutableString1 = NSMutableAttributedString()
    myMutableString1 = NSMutableAttributedString(string: myString1 as String, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14.0)])
    myMutableString1.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: NSRange(location:0,length:myString1.length))
    
    var myMutableString2 = NSMutableAttributedString()
    myMutableString2 = NSMutableAttributedString(string: myString2 as String, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 10.0)])
    myMutableString2.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: NSRange(location:0,length:myString2.length))
    
    let combination = NSMutableAttributedString()
    
    combination.append(myMutableString1)
    combination.append(myMutableString2)
    return combination
}
    
    public static func getOptionAttributedString(str1: String, str2: String) -> NSMutableAttributedString{
        let myString1:NSString = str1 as NSString
        let myString2:NSString = str2 as NSString
        var myMutableString1 = NSMutableAttributedString()
        myMutableString1 = NSMutableAttributedString(string: myString1 as String, attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16.0)])
       // myMutableString1.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: NSRange(location:0,length:myString1.length))
        
        var myMutableString2 = NSMutableAttributedString()
       // myMutableString2 = NSMutableAttributedString(string: myString2 as String, attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 17.0)])
        //myMutableString2.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:0,length:myString2.length))
        myMutableString2.addAttributes([NSAttributedString.Key.backgroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0)], range: NSRange(location: 0, length: myMutableString2.length))

        
        
        let combination = NSMutableAttributedString()
        
        combination.append(myMutableString1)
        combination.append(myMutableString2)
        return combination
    }

    public static func getFloatFromString(stringNumber: String) -> Float{
        if let value = Float(stringNumber){
            return value
        }
        return 0.0
    }
    public static func getStingFromFloat(floatNumber: Float) -> String{
        return NSString(format: "%.2f", floatNumber) as String
    }
    
    public static func getBoolValue(boolsstring: String) -> Bool {
            switch boolsstring.lowercased() {
            case "true", "t", "yes", "y", "1":
                return true
            case "false", "f", "no", "n", "0":
                return false
            default:
                return false
            }
    }
   
    public static func getAddressFromLatlong(text: String) {
        GoogleAPisService.googleAddressFromLatLong(searchtext: text, forModelType: GoogleAddressLatLongResponse.self) { success in
            guard let address = success.data.results else {
                return
            }
            if !address.isEmpty {
                UtilsClass.setGlobalAddress(addressWithLatLong: address)
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "location"), object: nil)
        } ErrorHandler: { error in
           // UtilsClass.hideProgressHud(view: self.view)
        }
    }
        public static func getAddressFromLoaction(userLocation: CLLocation, successHandler: @escaping (_ successResult: String) -> Void) {
            UtilsClass.getAddressFromLatlong(text: "\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)")
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
                if (error != nil){
                    print("error in reverseGeocode")
                }
                if(placemarks != nil){
                    let placemark = placemarks! as [CLPlacemark]
                    if placemark.count>0{
                        let placemark = placemarks![0]
//                        print(placemark.name!)
//                        //print(placemark.thoroughfare!)
//                       // print(placemark.subThoroughfare!)
//                       print(placemark.locality!)
//                        print(placemark.administrativeArea!)
//                        print(placemark.country!)
//                        print(placemark.postalCode!)
                        
                       // address = placemark.postalCode!
                        // self.addresslabel.text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
                        let address = LocationAddress()
                       // print(placemark.subLocality!)
                        if placemark.thoroughfare != nil{
                            address.premise = placemark.thoroughfare!
                        }
                        if placemark.subLocality != nil{
                            address.subLocality = placemark.subLocality!
                        }
                        
                        address.city = placemark.locality!
                        address.state = ""
                        if placemark.administrativeArea != nil{
                        address.state = placemark.administrativeArea!
                        }
                        address.zipcode = placemark.postalCode ?? ""
                        address.country = placemark.country!
                        address.latLong = placemark.location?.coordinate
                      //  address.locality = placemark.location?.coordinate
                        APPDELEGATE.selectedLocationAddress = address
                       // AddToCartItmesData.shared.locationAddressArray = [address]
                        successHandler(placemark.postalCode ?? "")
                    }
                }
            }
    }

    public static func getAddressDetails(
        from address: String,
        completion: @escaping (_ locationAddress: LocationAddress?) -> Void
    ) {

        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(address) { placemarks, error in

            if let error = error {
                print("Geocoding error:", error)
                completion(nil)
                return
            }

            guard let placemark = placemarks?.first,
                  let location = placemark.location else {
                completion(nil)
                return
            }

            let locationAddress = LocationAddress()

            // MARK: - Basic Info
            locationAddress.addressID = UUID().uuidString
            locationAddress.city = placemark.locality
            locationAddress.state = placemark.administrativeArea
            locationAddress.country = placemark.country
            locationAddress.zipcode = placemark.postalCode

            // MARK: - Area Info
            locationAddress.subLocality = placemark.subLocality
            locationAddress.locality = placemark.locality

            // MARK: - Street Details
            locationAddress.streetNumber = placemark.subThoroughfare ?? ""
            locationAddress.route = placemark.thoroughfare ?? ""
            locationAddress.premise = placemark.name ?? ""

            // MARK: - Coordinates
            locationAddress.latLong = location.coordinate
            
            APPDELEGATE.selectedLocationAddress = LocationAddress()
            APPDELEGATE.selectedLocationAddress.subLocality = locationAddress.subLocality
            APPDELEGATE.selectedLocationAddress.latLong = locationAddress.latLong
           
                    APPDELEGATE.selectedLocationAddress.premise = locationAddress.premise
               
                    APPDELEGATE.selectedLocationAddress.country = locationAddress.country
                
                    APPDELEGATE.selectedLocationAddress.zipcode = locationAddress.zipcode
               
                    APPDELEGATE.selectedLocationAddress.city = locationAddress.city
               
                    APPDELEGATE.selectedLocationAddress.state = locationAddress.state
               
                    APPDELEGATE.selectedLocationAddress.subLocality = locationAddress.subLocality
               
                    APPDELEGATE.selectedLocationAddress.streetNumber = locationAddress.streetNumber
                
                    APPDELEGATE.selectedLocationAddress.route = locationAddress.route
            if APPDELEGATE.selectedLocationAddress.premise.isEmpty {
                APPDELEGATE.selectedLocationAddress.premise = APPDELEGATE.selectedLocationAddress.streetNumber
            }
            if APPDELEGATE.selectedLocationAddress.subLocality.isEmpty {
                APPDELEGATE.selectedLocationAddress.subLocality = APPDELEGATE.selectedLocationAddress.route
            }

            completion(locationAddress)
        }
    }

    public static func getLatLongFromAddress(address: String, successHandler: @escaping (_ successResult: CLLocationCoordinate2D) -> Void) {
        let geocoder = CLGeocoder()
        let params: [String: Any] = [CNPostalAddressPostalCodeKey: address as Any, CNPostalAddressISOCountryCodeKey: "US"]
        geocoder.geocodeAddressDictionary(params) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            if(placemarks != nil){
                let placemark = placemarks! as [CLPlacemark]
                if placemark.count>0{
                    let placemark = placemarks![0]
                    // print(placemark.locality!)
                    // print(placemark.administrativeArea!)
                    // print(placemark.country!)
                    print(placemark.location?.coordinate as Any)
                    
                    
                    successHandler((placemark.location?.coordinate)!)
                }
            }
        }
        
    }
    public static func setGlobalAddress(addressWithLatLong: [ResultLatLong]) {

        guard let result = addressWithLatLong.first else { return }

        let location = CLLocation(
            latitude: result.geometry.location.lat,
            longitude: result.geometry.location.lng
        )

        let coordinate = location.coordinate

        let address = LocationAddress()
        address.latLong = coordinate
        address.subLocality = ""

        for component in result.address_components {

            let types = component.types

            if types.contains("premise") {
                address.premise = component.short_name
            } else if types.contains("country") {
                address.country = component.short_name
            } else if types.contains("postal_code") {
                address.zipcode = component.short_name
            } else if types.contains("locality") {
                address.city = component.short_name
            } else if types.contains("administrative_area_level_1") {
                address.state = component.short_name
            } else if types.contains("sublocality_level_1") {
                address.subLocality = component.short_name
            } else if types.contains("street_number") {
                address.streetNumber = component.short_name
            } else if types.contains("route") {
                address.route = component.short_name
            }
        }

        // 🔹 Fallback logic
        if address.premise.isEmpty {
            address.premise = address.streetNumber
        }

        if address.subLocality.isEmpty {
            address.subLocality = address.route
        }

        // 🔹 Assign once
        APPDELEGATE.selectedLocationAddress = address
    }
    public static func getStringDateFromString(stringDate: String) -> String {
        let currentTimeZone = TimeZone.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: currentTimeZone.identifier) // set locale to reliable US_POSIX
        let finaldateFrom = dateFormatter.date(from:stringDate)!
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "dd-MMM-yyyy hh:mm a"
        formatter.timeZone = TimeZone(identifier: currentTimeZone.identifier)
        //formatter.timeZone = TimeZone(identifier: "UTC")
        let fromString = formatter.string(from: finaldateFrom) // string purpose I add here
        return fromString
    }
    public static func getStringDateFromStringInMMMDD(stringDate: String) -> String {
        if stringDate.contains("Select Day"){
        return ""
        }
        let currentTimeZone = TimeZone.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, EEEE"
        dateFormatter.locale = Locale(identifier: currentTimeZone.identifier) // set locale to reliable US_POSIX
        let finaldateFrom = dateFormatter.date(from:stringDate)!
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "MMM dd"
        formatter.timeZone = TimeZone(identifier: currentTimeZone.identifier)
        //formatter.timeZone = TimeZone(identifier: "UTC")
        let fromString = formatter.string(from: finaldateFrom) // string purpose I add here
        return fromString
    }
    public static func getStringDateFromStringInyyyyMMdd(stringDate: String) -> String {
        let currentTimeZone = TimeZone.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, EEEE"
        dateFormatter.locale = Locale(identifier: currentTimeZone.identifier) // set locale to reliable US_POSIX
        let finaldateFrom = dateFormatter.date(from:stringDate)!
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: currentTimeZone.identifier)
        //formatter.timeZone = TimeZone(identifier: "UTC")
        let fromString = formatter.string(from: finaldateFrom) // string purpose I add here
        let d = fromString
        let last6 = d.suffix(6)
        return UtilsClass.getCurrentYearInString() + last6
    }
    public static func compaireTwoDates(firstDate: String, secondDate: String) -> Bool {
       // let currentTimeZone = TimeZone.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
       // dateFormatter.locale = Locale(identifier: currentTimeZone.identifier) // set locale to reliable US_POSIX
        let fDate: Date = dateFormatter.date(from:firstDate)!
        let sDate: Date = dateFormatter.date(from:secondDate)!
        
        if sDate > fDate {
            return true
        }
        return false
    }
    public static func getStringDateFromStringInDDMM(stringDate: String, stringTime: String) -> String {
           let currentTimeZone = TimeZone.current
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "MMM dd, EEEE"
           dateFormatter.locale = Locale(identifier: currentTimeZone.identifier) // set locale to reliable US_POSIX
           let finaldateFrom = dateFormatter.date(from:stringDate)!
           
           let formatter = DateFormatter()
           // initially set the format based on your datepicker date / server String
           formatter.dateFormat = "dd MMM"
           //formatter.timeZone = TimeZone(identifier: currentTimeZone.identifier)
           //formatter.timeZone = TimeZone(identifier: "UTC")
           let fromString = formatter.string(from: finaldateFrom) // string purpose I add here
           //let d = fromString
          // let last6 = d.suffix(6)
//        let formattertime = DateFormatter()
//        formattertime.dateFormat = "HH:mm a"
//        let result = formattertime.date(from: stringTime)
//        print(result as Any)
           return fromString
       }
    public static func getDayInEEE(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        let result = formatter.string(from: date)
        return "\(result)"
    }
    public static func getStringDateHHMMSS(stringTime: String) -> String {
           let currentTimeZone = TimeZone.current
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "HH:mm:ss"
           dateFormatter.locale = Locale(identifier: currentTimeZone.identifier) // set locale to reliable US_POSIX
           let finaldateFrom = dateFormatter.date(from:stringTime)!
           let formatter = DateFormatter()
           formatter.dateFormat = "hh:mm a"
           let fromString = formatter.string(from: finaldateFrom) // string purpose I add here
           return fromString
       }
    public static func getDates() -> [DayDateList] {
        var dayList = [DayDateList]()
        for i in (0 ..< 19) {
            let currentDate = self.dateAddingDay(value: i)
            let day = self.getDayInEEE(date: currentDate)
            let  date = self.getDateInDDMMM(date: currentDate)
            let finalDay = DayDateList.init(day: day, date: date, currectDateInFormate: self.getCurrentDateInString(date: currentDate))
            dayList.append(finalDay)
        }
        return dayList
    }
    public static func dateAddingDay(value: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: value, to: Date()) ?? Date()
    }
    public static func getTimeSlotForDate(day: String) -> [TimeSlots] {
        var timeSlot = [TimeSlots]()
        let currentTimeZone = TimeZone.current

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm a"
        formatter.locale = Locale(identifier: currentTimeZone.identifier) // set locale to reliable US_POSIX

        
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "hh:mm a"
        formatter2.locale = Locale(identifier: currentTimeZone.identifier) // set locale to reliable US_POSIX

        
        let startDate = "\(day) 10:30 am"
        let endDate = "\(day) 11:59 pm"
        
//        let todayformatter = DateFormatter()
//        todayformatter.dateFormat = "yyyy-MM-dd hh:mm a"
        let result = formatter.string(from: Date().addingTimeInterval(TimeInterval(30*60)))

        
        let date1 = formatter.date(from: startDate)
        let date2 = formatter.date(from: endDate)
        let todayDate = formatter.date(from: result)
        
        var i = 1
        while true {
            let date = date1?.addingTimeInterval(TimeInterval(i*30*60))
            let time = formatter2.string(from: date!)

            if date! >= date2! {
                break;
            }

            i += 1
            let slot = TimeSlots.init(time: time, date: date!)
          
            if date! > todayDate! {
                timeSlot.append(slot)
            }
        }
        print("slots---\(timeSlot.count)")
        return timeSlot

    }
    public static func getDateInDDMMM(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        let result = formatter.string(from: date)
        return "\(result)"
    }
    public static func getTodayDateInString() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        let result = formatter.string(from: date)
        return "\(result) today"
    }
    public static func getCurrentTime() -> String {
        let date = Date().addingTimeInterval(60*15)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let result = formatter.string(from: date)
        return "\(result)"
    }
    public static func getCurrentDateInString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        return result
    }
    public static func getCurrentDateInStringDDMMM() -> String {
           let date = Date()
           let formatter = DateFormatter()
           formatter.dateFormat = "dd MMM"
           let result = formatter.string(from: date)
           return result
       }
    public static func getCurrentTimeInString() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a"
        let result = formatter.string(from: date)
        return result
    }
    public static func getCurrentYearInString() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let result = formatter.string(from: date)
        return result
    }
    public static func tenDaysfromNow() -> [String] {
        var dateArray = [String]()
        for i in 1...15
        {
            //  let monthsToAdd = 2
            let daysToAdd = i
            // let yearsToAdd = 1
            let currentDate = Date()
            
            var dateComponent = DateComponents()
            
            //dateComponent.month = monthsToAdd
            dateComponent.day = daysToAdd
            // dateComponent.year = yearsToAdd
            
            let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd, EEEE"
            let result = formatter.string(from: futureDate!)
            dateArray.append(result)
        }
        
        return dateArray
    }
   
    public static func setDefaultView(senderView: UIView, senderLabel: UILabel) {
        
        
        senderView.layer.masksToBounds = true
        senderView.layer.cornerRadius = 5
        senderView.layer.borderColor = kBlueColor.cgColor
        senderView.layer.borderWidth = 1
        senderView.backgroundColor = .white
        senderLabel.textColor = kBlueColor
    }
    public static func setSelectedView(senderView: UIView, senderLabel: UILabel) {
        
        senderView.layer.masksToBounds = true
        senderView.layer.cornerRadius = 5
        senderView.layer.borderColor = UIColor.white.cgColor
        senderView.layer.borderWidth = 1
        senderView.backgroundColor = kBlueColor
        senderLabel.textColor = .white
    }
    func dialNumber(number : String) {
        
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
    }
}

class LocationAddress: NSObject {
    var addressID : String!
    var subLocality : String!
    var zipcode : String!
    var city : String!
    var state : String!
    var country : String!
    var latLong : CLLocationCoordinate2D!
    var locality : String!
    var premise : String = ""
    var streetNumber : String = ""
    var route : String = ""
    
    override init() {
        
    }
    init(json: NSDictionary) { // Dictionary object
        self.zipcode = json["zipcode"] as? String
        self.city = json["city"] as? String
        self.state = json["state"] as? String // Location of the JSON file
        self.country = json["country"] as? String // Location of the JSON file
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.zipcode = aDecoder.decodeObject(forKey: "zipcode") as? String;
        self.city = aDecoder.decodeObject(forKey: "city") as? String;
        self.state = aDecoder.decodeObject(forKey: "state") as? String;
        self.country = aDecoder.decodeObject(forKey: "country") as? String;
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.zipcode, forKey: "zipcode");
        aCoder.encode(self.city, forKey: "city");
        aCoder.encode(self.state, forKey: "state");
        aCoder.encode(self.country, forKey: "country");
    }
    
    /// Full formatted address
        var fullAddress: String {
            let components = [
                premise,
                streetNumber,
                route,
                subLocality,
                locality,
                city,
                state,
                zipcode,
                country
            ]

            return components
                .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
                .joined(separator: ", ")
        }
}

extension String {
    func translated() -> String {
        //return NSLocalizedString(self, comment: "")
        if let path = Bundle.main.path(forResource: LocalizeDefaultLaunchLanguage, ofType: "lproj"), let bundle = Bundle(path: path) {
            return NSLocalizedString(self, bundle: bundle, comment: "")
        }
        return ""
    }
}

extension BinaryFloatingPoint {
    func to2Decimal() -> String {
        String(format: "%.2f", Double(self))
    }
}
