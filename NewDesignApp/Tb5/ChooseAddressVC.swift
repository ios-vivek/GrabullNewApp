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
        //let user = APPDELEGATE.userResponse!.customer
        cell.addressLbl.text = "\(address.add1 ?? "") \(address.add2 ?? ""), \(address.city ?? ""), \(address.state ?? ""), \(address.zip ?? "")"
        cell.addressTypeLbl.text = address.addtypes
        cell.updateUI(selected: selectedAddress?.id == address.id)
       // cell.phoneLbl.text = "Phone Number: \(user.phone)"
       // cell.delegate = self
       // cell.editButton.tag = indexPath.row
       // cell.deleteButton.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let deliveryZipsArray = Cart.shared.restDetails.deliveryzip.components(separatedBy: ",")
//        if !deliveryZipsArray.contains(APPDELEGATE.userResponse!.customer.address![indexPath.row].zip) {
//            self.showAlert(title: "Error", msg: "Oops! Out of Delivery Radius, We Deliver Within 4 Miles Radius..")
//            return
//        }


        Cart.shared.userAddress = APPDELEGATE.userResponse!.customer.address[indexPath.row]
        self.dismiss(animated: true) {
            self.delegate?.changedAddress()
        }
    }
}
