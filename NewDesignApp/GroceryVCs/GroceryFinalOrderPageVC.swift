//
//  FinalOrderPageVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 13/12/24.
//

import UIKit

class GroceryFinalOrderPageVC: UIViewController {
    @IBOutlet weak var orderNumberLbl: UILabel!
    @IBOutlet weak var orderTypeLbl: UILabel!
    @IBOutlet weak var restaurantNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var restaurantContactLbl: UILabel!
    @IBOutlet weak var supportContactLbl: UILabel!
    @IBOutlet weak var deliveryPickupTimeLbl: UILabel!
    @IBOutlet weak var orderSummeryLbl: UILabel!
    @IBOutlet weak var backToHomeBtn: UIButton!
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var headerView: UIView!


    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        headerView.backgroundColor = themeBackgrounColor
        tbl.backgroundColor = .white
        UtilsClass.savePastOrderRest(pastOrderRest: PastOrderRest(restId: "\(GroceryCartData.shared.orderNumber)", count: 1))
        orderNumberLbl.text = "Order # \(GroceryCartData.shared.orderNumber)"
        backToHomeBtn.backgroundColor = themeBackgrounColor
        backToHomeBtn.setRounded(cornerRadius: 10)
        backToHomeBtn.setFontWithString(text: "BACK TO HOME", fontSize: 16)
        restaurantNameLbl.text = GroceryCartData.shared.storeDetails?.name
        restaurantContactLbl.text = "Restaurant Support : \(GroceryCartData.shared.storeDetails?.phone ?? "")"
        supportContactLbl.text = "Grabull Support : \(GroceryCartData.shared.supportNumber)"
            orderTypeLbl.text = "Delivery To:"
            orderSummeryLbl.text = "Delivery Order Summary"
            let address = GroceryCartData.shared.userAddress

            let parts = [
                address?.street ?? "",
                address?.add1 ?? "",
                address?.add2 ?? "",
                address?.city ?? "",
                address?.state ?? "",
                address?.zip ?? ""
            ]

            addressLbl.text = parts
                .compactMap { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
                .joined(separator: ", ")
        
        deliveryPickupTimeLbl.text = "Order will be delivered \(GroceryCartData.shared.storeDetails?.showDeliveryTimeOnFinalPage ?? "")"

    }
    
    @IBAction func backToHomeNavigation () {
        GroceryCartData.shared.refreshCartData()
        let tabbar = self.navigationController?.viewControllers[1] as! TabBarVC
        self.navigationController?.popToViewController(tabbar, animated: true)
    }

}
extension GroceryFinalOrderPageVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
            return GroceryCartData.shared.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryCartItemTVCell", for: indexPath) as! GroceryCartItemTVCell
            cell.selectionStyle = .none
            cell.backgroundColor = .white
          //  cell.delegate = self
            cell.deleteButton.tag = indexPath.row
            cell.updateUI(index: indexPath.row)
            cell.selectionStyle = .none
            cell.plusMinusView.isHidden = true
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryPriceDetailsTVCell", for: indexPath) as! GroceryPriceDetailsTVCell
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            cell.emptyCartButton.isHidden = true
            cell.updateUI(isPlaceOrder: true)
            cell.checkoutButton.isHidden = true
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 1 {
//            return 250
//        }
        return UITableView.automaticDimension
    }
}
