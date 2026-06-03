//
//  ChooseAddressVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 15/11/24.
//

import UIKit
protocol ReloadAddressDelegate: AnyObject {
    func changedAddress()
    func addNewAddress()
}
class ChooseAddressVC: UIViewController {
    @IBOutlet weak var addressTbl: UITableView!
    weak var delegate: ReloadAddressDelegate?

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
        self.dismiss(animated: true) {
            
        }
    }
    @IBAction func addNewAddressAction() {
        self.dismiss(animated: true) {
            self.delegate?.addNewAddress()
        }
    }
    func getAddressesFromApi() {
        let parameters = CommonAPIParams.base()
       
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.getAddress, forModelType: AddressListResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            APPDELEGATE.userResponse?.customer.address = success.data.data
            UtilsClass.saveUserDetails()
            self.addressTbl.reloadData()
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
    }

}
extension ChooseAddressVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let favList = favoriteListResponse?.data?.rest_list else {
//            return 0
//        }
        return APPDELEGATE.userResponse?.customer.address.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseAddressTVCell", for: indexPath) as! ChooseAddressTVCell
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        let address = APPDELEGATE.userResponse!.customer.address[indexPath.row]
        let selectedAddress = Cart.shared.userAddress
        
        let street = address.street?.isEmpty == false ? "\(address.street!) " : ""
        let baseFont = cell.addressLbl.font ?? UIFont.systemFont(ofSize: 14)
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: baseFont
        ]
        let semiboldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: baseFont.pointSize, weight: .semibold)
        ]

        let addressString = NSMutableAttributedString()
        addressString.append(NSAttributedString(
            string: "\(street)\(address.add1 ?? "")\n\(address.city ?? ""), \(address.state ?? ""), \(address.zip ?? "")",
            attributes: regularAttributes
        ))
        if let landmark = address.add2, !landmark.isEmpty {
            addressString.append(NSAttributedString(string: "\nLandmark: ", attributes: semiboldAttributes))
            addressString.append(NSAttributedString(string: landmark, attributes: regularAttributes))
        }
        cell.addressLbl.attributedText = addressString
        
        cell.addressTypeLbl.text = address.type
        cell.updateUI(selected: selectedAddress?.id == address.id)
  
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let deliveryZipsArray = Cart.shared.restDetails.deliveryzip.components(separatedBy: ",")
//        if !deliveryZipsArray.contains(APPDELEGATE.userResponse!.customer.address![indexPath.row].zip) {
//            self.showAlert(title: "Error", msg: "Oops! Out of Delivery Radius, We Deliver Within 4 Miles Radius..")
//            return
//        }


        Cart.shared.userAddress = APPDELEGATE.userResponse!.customer.address[indexPath.row]
        GroceryCartData.shared.userAddress = APPDELEGATE.userResponse!.customer.address[indexPath.row]
        self.dismiss(animated: true) {
            self.delegate?.changedAddress()
        }
    }
}
