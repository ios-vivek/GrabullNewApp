//
//  WebServices.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 23/08/24.
//

import UIKit
import Alamofire
import CoreLocation

class GoogleAPisService: NSObject {
    public static func googleAddressSearch<T:Codable>(searchtext: String, forModelType modelType: T.Type, SuccessHandler: @escaping (APIResponse<T>) -> Void, ErrorHandler: @escaping (String) -> Void) {
        if APPDELEGATE.selectedLocationAddress.latLong == nil {
            APPDELEGATE.selectedLocationAddress = LocationAddress()
            let latLong : CLLocationCoordinate2D = CLLocationCoordinate2DMake(0.0, 0.0)
            APPDELEGATE.selectedLocationAddress.latLong = latLong
        }
        let requestUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(searchtext)&components=country:us&types=establishment&location=\(APPDELEGATE.selectedLocationAddress.latLong.latitude)%2C\(APPDELEGATE.selectedLocationAddress.latLong.longitude)&radius=500&key=\(GoogleApiKey)"
        AF.request(requestUrl,
                   method: .post,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   interceptor: nil)
            .response(completionHandler: { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                                       let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: [])
                        print(jsonResponse)

                        let listData = try JSONDecoder().decode(modelType.self, from: JSONSerialization.data(withJSONObject: jsonResponse))
                        print(listData)
                                       print(jsonResponse as! NSDictionary)
                        SuccessHandler(APIResponse(data: listData))
                                   }
                                   catch let error
                                   {
                                       print(error)
                                       ErrorHandler("")
                                   }
                    
                case .failure(let error):
                               /// Handle request failure
                    ErrorHandler(error.localizedDescription)
                           }
            })
    }
    public static func googleAddressLatLong<T:Codable>(searchtext: String, forModelType modelType: T.Type, SuccessHandler: @escaping (APIResponse<T>) -> Void, ErrorHandler: @escaping (String) -> Void) {
        let requestUrl = "https://maps.googleapis.com/maps/api/geocode/json?address=\(searchtext)&key=\(GoogleApiKey)"
               
        AF.request(requestUrl,
                   method: .post,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   interceptor: nil)
            .response(completionHandler: { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                                       let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: [])
                        print(jsonResponse)

                        let listData = try JSONDecoder().decode(modelType.self, from: JSONSerialization.data(withJSONObject: jsonResponse))
                        print(listData)
                                       print(jsonResponse as! NSDictionary)
                        SuccessHandler(APIResponse(data: listData))
                                   }
                                   catch let error
                                   {
                                       print(error)
                                       ErrorHandler("")
                                   }
                    
                case .failure(let error):
                               /// Handle request failure
                    ErrorHandler(error.localizedDescription)
                           }
            })
    }
    
    public static func googleAddressFromLatLong<T:Codable>(searchtext: String, forModelType modelType: T.Type, SuccessHandler: @escaping (APIResponse<T>) -> Void, ErrorHandler: @escaping (String) -> Void) {
               let requestUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(searchtext)&key=\(GoogleApiKey)"
               
        AF.request(requestUrl,
                   method: .post,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   interceptor: nil)
            .response(completionHandler: { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                                       let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: [])
                        print(jsonResponse)

                        let listData = try JSONDecoder().decode(modelType.self, from: JSONSerialization.data(withJSONObject: jsonResponse))
                        print(listData)
                                       print(jsonResponse as! NSDictionary)
                        SuccessHandler(APIResponse(data: listData))
                                   }
                                   catch let error
                                   {
                                       print(error)
                                       ErrorHandler("")
                                   }
                    
                case .failure(let error):
                               /// Handle request failure
                    ErrorHandler(error.localizedDescription)
                           }
            })
    }
}
