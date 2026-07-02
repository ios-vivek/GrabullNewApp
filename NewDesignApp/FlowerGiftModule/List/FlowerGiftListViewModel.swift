//
//  GroceryViewModel.swift
//  NewDesignApp
//
//  Created by GitHub Copilot on behalf of user.
//

import Foundation

class FlowerGiftListViewModel {
    private(set) var storeList = [Store]()
    private(set) var gotResponseFromService = false

    var onUpdate: (() -> Void)?
    var onError: ((Any?) -> Void)?

    func getStorelistFromApi() {
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "cust_lat": "\(APPDELEGATE.selectedLocationAddress.latLong.latitude)",
            "cust_long": "\(APPDELEGATE.selectedLocationAddress.latLong.longitude)",
            "cuisine_type" : "",
            "address" : "\(UtilsClass.getFullAddress())"

        ]) { _, new in new }

        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.groceryList, forModelType: StoreResponse.self) { [weak self] success in
            guard let self = self else { return }
            self.gotResponseFromService = true
            if success.data.data.restaurants.count > 0 {
                self.storeList = success.data.data.restaurants
            }
            DispatchQueue.main.async {
                self.onUpdate?()
            }
        } ErrorHandler: { [weak self] error in
            guard let self = self else { return }
            self.gotResponseFromService = true
            DispatchQueue.main.async {
                self.onError?(error)
                self.onUpdate?()
            }
        }
    }

    func getRestDetailFromApi(restid: String, dbname: String, completion: @escaping (StoreDetailsResponse?) -> Void) {
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "rest_id": restid,
            "dbname" : dbname
        ]) { _, new in new }

        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.storeDetailByID, forModelType: StoreDetailsResponse.self) { success in
            completion(success.data)
        } ErrorHandler: { error in
            completion(nil)
        }
    }
}
