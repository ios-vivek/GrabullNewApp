//
//  AddAddressVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 28/10/24.
//

import UIKit
protocol ReloadNewAddressDelegate: AnyObject {
    func addednewAddress()
}
class AddAddressVC: UIViewController {
    @IBOutlet weak var address1TxtFld: UITextField!
    @IBOutlet weak var address2TxtFld: UITextField!
    @IBOutlet weak var landmarkTxtFld: UITextField!
    @IBOutlet weak var cityTxtFld: UITextField!
    @IBOutlet weak var stateTxtFld: UITextField!
    @IBOutlet weak var zipcodeTxtFld: UITextField!
    @IBOutlet weak var addressType: UISegmentedControl!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    weak var delegate: ReloadNewAddressDelegate?

    var selectedAddressType = "Home"
    var isUpdateAddress: Bool = false
    var fromCheckoutPage: Bool = false
    var updateUserAdd: UserAdd?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addressType.selectedSegmentTintColor = themeBackgrounColor
        addressType.setTextColor()
        addressType.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        if isUpdateAddress {
            address1TxtFld.text = updateUserAdd?.street
            address2TxtFld.text = updateUserAdd?.add1
            cityTxtFld.text = updateUserAdd?.city
            stateTxtFld.text = updateUserAdd?.state
            zipcodeTxtFld.text = updateUserAdd?.zip
            landmarkTxtFld.text = updateUserAdd?.add2
            if updateUserAdd?.type == "Home" {
                addressType.selectedSegmentIndex = 0
            }
            if updateUserAdd?.type == "Office" {
                addressType.selectedSegmentIndex = 1
            }
            if updateUserAdd?.type == "Other" {
                addressType.selectedSegmentIndex = 2
            }
        }
        headerLbl.text = isUpdateAddress ? "Update Address" : "New Address"
        saveBtn.setFontWithString(text: isUpdateAddress ? "UPDATE" : "SAVE", fontSize: 14)
        self.view.backgroundColor = .white
        address1TxtFld.setPlaceHolderColor(.gGray200)
        address2TxtFld.setPlaceHolderColor(.gGray200)
        landmarkTxtFld.setPlaceHolderColor(.gGray200)
        cityTxtFld.setPlaceHolderColor(.gGray200)
        zipcodeTxtFld.setPlaceHolderColor(.gGray200)
        stateTxtFld.setPlaceHolderColor(.gGray200)
        
        // Add tap gesture to state text field
        stateTxtFld.isUserInteractionEnabled = true
        let stateTap = UITapGestureRecognizer(target: self, action: #selector(stateFieldTapped))
        stateTxtFld.addGestureRecognizer(stateTap)



    }
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        //self.delegate?.selectedPaymentType(index: sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 0 {
            selectedAddressType = "Home"
        }
        if sender.selectedSegmentIndex == 1 {
            selectedAddressType = "Office"
        }
        if sender.selectedSegmentIndex == 2 {
            selectedAddressType = "Other"
        }
    }
    
    @objc func stateFieldTapped() {
        let popupVC = StateSelectionPopupVC()
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        self.present(popupVC, animated: true)
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitAction() {
//        if address1TxtFld.text!.isEmpty {
//            self.showAlert(title: "Error", msg: "Please enter address.")
//            return
//        }
         if address2TxtFld.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter address.")
            return
        }
        else if cityTxtFld.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter city.")
            return
        }
        else if stateTxtFld.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter state.")
            return
        }
        else if zipcodeTxtFld.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter zipcode.")
            return
        }
        else {
            if isUpdateAddress {
                let fullAddress = """

                   \(address1TxtFld.text ?? ""),

                   \(address2TxtFld.text ?? ""),

                   \(cityTxtFld.text ?? ""),

                   \(stateTxtFld.text ?? ""),

                   \(zipcodeTxtFld.text ?? "")

                   """

                   validateGoogleAddress(text: fullAddress) { isValid in

                       DispatchQueue.main.async {

                           if isValid {

                               self.updateAddressService()

                           } else {

                               self.showAlert(

                                   title: "Invalid Address",

                                   msg: "Please enter a valid address recognized by Google."

                               )

                           }

                       }

                   }
            }else {
                let fullAddress = """

                   \(address1TxtFld.text ?? ""),

                   \(address2TxtFld.text ?? ""),

                   \(cityTxtFld.text ?? ""),

                   \(stateTxtFld.text ?? ""),

                   \(zipcodeTxtFld.text ?? "")

                   """

                   validateGoogleAddress(text: fullAddress) { isValid in

                       DispatchQueue.main.async {

                           if isValid {

                               self.addAddressService()

                           } else {

                               self.showAlert(

                                   title: "Invalid Address",

                                   msg: "Please enter a valid address recognized by Google."

                               )

                           }

                       }

                   }
            }
           // self.navigationController?.popViewController(animated: true)
        }
    }
    func addAddressService() {
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "street" : address1TxtFld.text ?? "",
            "add1" : address2TxtFld.text!,
            "add2" : landmarkTxtFld.text ?? "",
            "city" : cityTxtFld.text!,
            "state" : stateTxtFld.text!,
            "zip" : zipcodeTxtFld.text!,
            "address_type" : selectedAddressType,
        ]) { _, new in new }
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.addAddress, forModelType: AddedAddressResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            let alertController = UIAlertController(title: "Success", message: "Address added successfully.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
                if self.fromCheckoutPage {
                    let add = UserAdd(id: "0", street: self.address1TxtFld.text ?? "", add1: self.address2TxtFld.text!, add2: self.landmarkTxtFld.text!, add3: "", type: self.selectedAddressType, city: self.cityTxtFld.text!, state: self.stateTxtFld.text!, zip: self.zipcodeTxtFld.text!)
//                    let deliveryZipsArray = Cart.shared.restDetails.deliveryzip.components(separatedBy: ",")
//                    if !deliveryZipsArray.contains(self.zipcodeTxtFld.text!) {
//                        self.showAlert(title: "Error", msg: "Oops! Out of Delivery Radius, We Deliver Within 4 Miles Radius..")
//                        return
//                    }
                    Cart.shared.userAddress = add
                    GroceryCartData.shared.userAddress = add
                    self.delegate?.addednewAddress()
                }
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(OKAction)
            OperationQueue.main.addOperation {
                self.present(alertController, animated: true,
                             completion:nil)
            }
        
            
        } ErrorHandler: { error in
            if error == "Invalid User Details" || error == "Customer already registered" {
                self.showAlert(title: "Error", msg: error)
            } else {
                self.showAlert(title: "Error", msg: "Something went wrong, try again later.")
            }

            UtilsClass.hideProgressHud(view: self.view)
        }
    }
    func updateAddressService() {
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "street" : address1TxtFld.text ?? "",
            "add1" : address2TxtFld.text!,
            "add2" : landmarkTxtFld.text ?? "",
            "city" : cityTxtFld.text!,
            "state" : stateTxtFld.text!,
            "zip" : zipcodeTxtFld.text!,
            "address_type" : selectedAddressType,
            "id" : updateUserAdd?.id as AnyObject,
        ]) { _, new in new }
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.updateAddress, forModelType: AddedAddressResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            let alertController = UIAlertController(title: "Success", message: "Address updated successfully.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(OKAction)
            OperationQueue.main.addOperation {
                self.present(alertController, animated: true,
                             completion:nil)
            }
        
            
        } ErrorHandler: { error in
            if error == "Invalid User Details" || error == "Customer already registered" {
                self.showAlert(title: "Error", msg: error)
            } else {
                self.showAlert(title: "Error", msg: "Something went wrong, try again later.")
            }

            UtilsClass.hideProgressHud(view: self.view)
        }
    }
    func validateGoogleAddress(text: String, completion: @escaping (Bool) -> Void) {

        UtilsClass.showProgressHud(view: self.view)

        GoogleAPisService.googleAddressLatLong(
            searchtext: text,
            forModelType: GoogleAddressLatLongResponse.self
        ) { success in

            UtilsClass.hideProgressHud(view: self.view)

            guard let result = success.data.results?.first else {
                completion(false)
                return
            }

            guard let components = result.address_components else {
                completion(false)
                return
            }

            let types = components.flatMap { $0.types ?? [] }

          //  let hasStreetNumber = types.contains("street_number")
            let hasRoute = types.contains("route")
            let hasCity = types.contains("locality") ||
                          types.contains("administrative_area_level_2")
            let hasState = types.contains("administrative_area_level_1")
            let hasZip = types.contains("postal_code")
            let hasCountry = types.contains("country")

            let isValid = hasRoute &&
                          hasCity &&
                          hasState &&
                          hasZip &&
                          hasCountry

            completion(isValid)

        } ErrorHandler: { error in

            UtilsClass.hideProgressHud(view: self.view)
            completion(false)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddAddressVC: StateSelectionDelegate {
    func didSelectState(_ state: String) {
        stateTxtFld.text = state
    }
}
