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
    private static var autocompleteSessionToken: String?

    public static func resetAutocompleteSessionToken() {
        autocompleteSessionToken = nil
    }
    public static func googleAddressSearch<T:Codable>(searchtext: String, forModelType modelType: T.Type, SuccessHandler: @escaping (APIResponse<T>) -> Void, ErrorHandler: @escaping (String) -> Void) {
        if APPDELEGATE.selectedLocationAddress.latLong == nil {
            APPDELEGATE.selectedLocationAddress = LocationAddress()
            let latLong : CLLocationCoordinate2D = CLLocationCoordinate2DMake(0.0, 0.0)
            APPDELEGATE.selectedLocationAddress.latLong = latLong
        }
        // Ensure we have a session token for Places Autocomplete (reuse across a single user session)
        if autocompleteSessionToken == nil {
            autocompleteSessionToken = UUID().uuidString
        }

        var components = URLComponents(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json")!
        components.queryItems = [
            URLQueryItem(name: "input", value: searchtext),
            URLQueryItem(name: "components", value: "country:us"),
            URLQueryItem(name: "types", value: "establishment"),
            URLQueryItem(name: "location", value: "\(APPDELEGATE.selectedLocationAddress.latLong.latitude),\(APPDELEGATE.selectedLocationAddress.latLong.longitude)"),
            URLQueryItem(name: "radius", value: "500"),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "sessiontoken", value: autocompleteSessionToken),
            URLQueryItem(name: "key", value: GoogleApiKey)
        ]

        let url = components.url!
        print("google suggestion requestUrl: \(url.absoluteString)")

        AF.request(url.absoluteString,
                   method: .get,
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
        var components = URLComponents(string: "https://maps.googleapis.com/maps/api/geocode/json")!
        components.queryItems = [
            URLQueryItem(name: "address", value: searchtext),
            URLQueryItem(name: "key", value: "\(GoogleApiKey)")
        ]

        let url = components.url!
        print("google requestUrl: \(url.absoluteString)")
        AF.request(url.absoluteString,
                   method: .post,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   interceptor: nil)
            .response(completionHandler: { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                                       let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: [])
                        print("google Response: \(jsonResponse)")

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
