//
//  AddressVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 31/08/24.
//

import UIKit

class AddressVC: UIViewController {
    @IBOutlet weak var addressTbl: UITableView!
    var address = [UserAdd]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        addressTbl.backgroundColor = .clear
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAddressesFromApi()
    }
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    func getAddressesFromApi() {
        let parameters = CommonAPIParams.base()
       
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.getAddress, forModelType: AddressListResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            self.address = success.data.data
            APPDELEGATE.userResponse?.customer.address = self.address
            self.addressTbl.reloadData()
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
    }
    @IBAction func addNewAddressAction() {
        let vc = self.viewController(viewController: AddAddressVC.self, storyName: StoryName.Profile.rawValue) as! AddAddressVC
        vc.isUpdateAddress = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func deleteAddress(addressID: String, index: Int) {
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "id" : addressID
        ]) { _, new in new }
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.removeAddress, forModelType: AddedAddressResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
             APPDELEGATE.userResponse?.customer.address.remove(at: index)
            UtilsClass.saveUserDetails()
            self.addressTbl.reloadData()
            
        } ErrorHandler: { error in
            if error == "Invalid User Details" {
                self.showAlert(title: "Error", msg: error)
            } else {
                self.showAlert(title: "Error", msg: "Something went wrong, try again later.")
            }
            UtilsClass.hideProgressHud(view: self.view)
        }
    }

}
extension AddressVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let favList = favoriteListResponse?.data?.rest_list else {
//            return 0
//        }
        return APPDELEGATE.userResponse?.customer.address.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressListTVCell", for: indexPath) as! AddressListTVCell
       
        let address = APPDELEGATE.userResponse!.customer.address[indexPath.row]
        let user = APPDELEGATE.userResponse!.customer
        cell.phoneLbl.text = "Phone Number: \(user.phone)"

        cell.configureUI(address: address)
        cell.delegate = self
        cell.editButton.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 170
//    }
}
extension AddressVC: AddressDelegate {
    func editAddress(selectedIndex: Int) {
        let vc = self.viewController(viewController: AddAddressVC.self, storyName: StoryName.Profile.rawValue) as! AddAddressVC
        vc.isUpdateAddress = true
        vc.updateUserAdd = APPDELEGATE.userResponse?.customer.address[selectedIndex]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteAddress(selectedIndex: Int) {
        let alertController = UIAlertController(title: "Delete", message: "Are you sure want to delete address?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
            self.deleteAddress(addressID: APPDELEGATE.userResponse!.customer.address[selectedIndex].id.toString(), index: selectedIndex)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { alert in
            
        }
        alertController.addAction(OKAction)
        alertController.addAction(cancel)
        OperationQueue.main.addOperation {
            self.present(alertController, animated: true,
                         completion:nil)
        }
    }
    
    
}
