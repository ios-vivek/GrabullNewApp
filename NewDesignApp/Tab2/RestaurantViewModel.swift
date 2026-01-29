import UIKit
import Foundation

final class RestaurantViewModel {
    var restList: [Restaurant] = []
    var cuisineList: [Cuisine] = []

    func fetchRestaurants(
        cuisine: String?,
        completion: @escaping (Result<[Restaurant], Error>) -> Void
    ) {
        var params = CommonAPIParams.base()
        //"cust_lat": "\(APPDELEGATE.selectedLocationAddress.latLong.latitude)",
        //"cust_long": "\(APPDELEGATE.selectedLocationAddress.latLong.longitude)",
       // params["cust_lat"] = "42.5094913" as AnyObject
       // params["cust_long"] = "-71.132736399" as AnyObject
        params["cust_lat"] = "\(APPDELEGATE.selectedLocationAddress.latLong.latitude)"
        params["cust_long"] = "\(APPDELEGATE.selectedLocationAddress.latLong.longitude)"
        params["cuisine_type"] = cuisine as AnyObject?
        params["address"] = "\(UtilsClass.getFullAddress())" as AnyObject
        
        WebServices.loadDataFromServiceWithBaseResponse(
            parameter: params,
            servicename: OldServiceType.resturantList,
            forModelType: RestaurantListResponse.self
        ) { success in
            completion(.success(success.data.data.restaurants))
        } ErrorHandler: { error in
            completion(.failure(error as! Error))
        }
    }
}
