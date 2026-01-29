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
            address1TxtFld.text = updateUserAdd?.add1
            address2TxtFld.text = updateUserAdd?.add2
            cityTxtFld.text = updateUserAdd?.city
            stateTxtFld.text = updateUserAdd?.state
            zipcodeTxtFld.text = updateUserAdd?.zip
            if updateUserAdd?.addtypes == "Home" {
                addressType.selectedSegmentIndex = 0
            }
            if updateUserAdd?.addtypes == "Office" {
                addressType.selectedSegmentIndex = 1
            }
            if updateUserAdd?.addtypes == "Other" {
                addressType.selectedSegmentIndex = 2
            }
        }
        headerLbl.text = isUpdateAddress ? "Update Address" : "New Address"
        saveBtn.setFontWithString(text: isUpdateAddress ? "UPDATE" : "SAVE", fontSize: 14)
        self.view.backgroundColor = .white
        address1TxtFld.setPlaceHolderColor(.gGray200)
        address2TxtFld.setPlaceHolderColor(.gGray200)
        cityTxtFld.setPlaceHolderColor(.gGray200)
        zipcodeTxtFld.setPlaceHolderColor(.gGray200)
        stateTxtFld.setPlaceHolderColor(.gGray200)



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
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitAction() {
        if address1TxtFld.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter address1.")
            return
        }
        else if address2TxtFld.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter address2.")
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
                self.updateAddressService()
            }else {
                self.addAddressService()
            }
           // self.navigationController?.popViewController(animated: true)
        }
    }
    func addAddressService() {
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "add1" : address1TxtFld.text!,
            "add2" : address2TxtFld.text!,
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
                    let add = UserAdd(id: 0, street: "", add1: self.address1TxtFld.text!, add2: self.address2TxtFld.text!, add3: "", addtypes: self.selectedAddressType, city: self.cityTxtFld.text!, state: self.stateTxtFld.text!, zip: self.zipcodeTxtFld.text!)
//                    let deliveryZipsArray = Cart.shared.restDetails.deliveryzip.components(separatedBy: ",")
//                    if !deliveryZipsArray.contains(self.zipcodeTxtFld.text!) {
//                        self.showAlert(title: "Error", msg: "Oops! Out of Delivery Radius, We Deliver Within 4 Miles Radius..")
//                        return
//                    }
                    Cart.shared.userAddress = add
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
            "add1" : address1TxtFld.text!,
            "add2" : address2TxtFld.text!,
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
