//
//  WebServices.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 23/08/24.
//

import UIKit
import Alamofire
import CoreLocation

enum HomeListAPIResponse {
    case Success(HomeListDataResponse)
    case Fail(APIError) /// Error code, Error message
}

struct APIError: Codable {
    let code: Int
    let message: String
}




struct APIResponse<T: Decodable>: Decodable {
   // var errors: APIError
    var data: T
}

struct CommonAPIParams {

    static func base() -> [String: Any] {
        return [
            "api_id": AppConfig.API_ID,
            "api_key": AppConfig.OldAPI_KEY,
            "devicetoken": APPDELEGATE.deviceToken,
            "devicedetails": APPDELEGATE.getMobileInfo(),
            "appversion": APPDELEGATE.getAppVersion(),
            "devicetype": AppConfig.DeviceType,
            "customer_id": APPDELEGATE.userResponse?.customer.customerId ?? "",
            "dbname" : Cart.shared.dbname,
        ]
    }
}

class WebServices: NSObject {

    public static func placeOrderService(
        parameters: [String: AnyObject],
        successHandler: @escaping (_ successResult: PlaceOrderResponse) -> Void,
        errorHandler: @escaping (_ errorResult: String) -> Void
    ) {

        let requestUrl = OldServiceType.BASE + "add-order/"

        AF.request(
            requestUrl,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default
        )
        .responseData { response in

            switch response.result {

            case .success(let data):
                do {
                    
                    if let raw = String(data: data, encoding: .utf8) {
                        print("🔴 RAW RESPONSE:")
                        print(raw)
                    } else {
                        print("❌ Unable to convert response to String")
                    }
                    
                    let decodedResponse = try JSONDecoder().decode(
                        PlaceOrderResponse.self,
                        from: data
                    )

                    print("Place order response:", decodedResponse)

                    // ✅ SUCCESS
                    if decodedResponse.code == 200,
                       decodedResponse.status == "Success" {
                        successHandler(decodedResponse)
                        return
                    }
                    Cart.shared.orderNumber = decodedResponse.data.oid ?? ""

                    // ❌ API Error
                    errorHandler(
                        decodedResponse.error ?? "Unable to process server response"
                    )

                } catch {
                    print("Decoding error:", error)
                    errorHandler("Invalid server response")
                }

            case .failure(let error):
                print("Network error:", error)
                errorHandler(error.localizedDescription)
            }
        }
    }
    
    public static func loadDataFromServiceWithBaseResponse<T: Codable>(
        parameter: [String: Any],
        servicename: String,
        forModelType modelType: T.Type,
        SuccessHandler: @escaping (APIResponse<T>) -> Void,
        ErrorHandler: @escaping (String) -> Void
    ) {

        let requestUrl = OldServiceType.BASE + servicename
        print("Request url: \(requestUrl) \n Request Data: \(parameter.json) \n===========================================================================")
        AF.request(
            requestUrl,
            method: .post,
            parameters: parameter,
            encoding: URLEncoding.default
        ).responseData { response in

            switch response.result {

            case .success(let data):

                do {
                    
                    if let raw = String(data: data, encoding: .utf8) {
                        print("🔴 RAW RESPONSE:")
                        print(raw)
                    } else {
                        print("❌ Unable to convert response to String")
                    }

                    // 🔹 PRINT RAW JSON RESPONSE
                           APILogger.printResponseJSON(data)
                    
                    // 1️⃣ Decode base response FIRST
                    let baseResponse = try JSONDecoder().decode(BaseAPIResponse.self, from: data)

                    // 2️⃣ Handle Failed status (409, 402, etc.)
                    if baseResponse.status != "Success" {
                        let errorMessage = baseResponse.error ?? "Something went wrong"
                        ErrorHandler(errorMessage)
                        return
                    }

                    // 3️⃣ Decode full model only if Success
                    let fullResponse = try JSONDecoder().decode(modelType.self, from: data)
                    SuccessHandler(APIResponse(data: fullResponse))

                } catch {
                    print("Decoding error:", error)
                    ErrorHandler("Invalid server response")
                }

            case .failure(let error):
                ErrorHandler(error.localizedDescription)
            }
        }
    }

}
struct BaseAPIResponse: Codable {
    let status: String
    let error: String?
    let code: Int?
}
struct APILogger {

    static func printResponseJSON(_ data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyData = try JSONSerialization.data(
                withJSONObject: jsonObject,
                options: [.prettyPrinted]
            )
            let jsonString = String(data: prettyData, encoding: .utf8) ?? ""

            print("""
            ================= RESPONSE =================
            \(jsonString)
            ==========================================
            """)
        } catch {
            print("⚠️ Unable to print JSON response:", error)
        }
    }
}
