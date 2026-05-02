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
//        if GroceryCartData.shared.orderType == .pickup {
//            orderTypeLbl.text = "Pickup from:"
//            orderSummeryLbl.text = "Pickup Order Summary"
//            
//            let add = GroceryCartData.shared.storeDetails?.address + " " +  GroceryCartData.shared.storeDetails?.city + " " +  GroceryCartData.shared.storeDetails?.state + " " +  GroceryCartData.shared.storeDetails?.zip
//            addressLbl.text = add
//            pickTime()
//        } else {
            orderTypeLbl.text = "Delivery To:"
            orderSummeryLbl.text = "Delivery Order Summary"
            deliveryTime()
            let address = GroceryCartData.shared.userAddress

            let parts = [
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
   //     }

    }
    
    func pickTime() {
        deliveryPickupTimeLbl.text = "Order Approx. Ready for pickup within "
//        switch GroceryCartData.shared.orderDate {
//        case .ASAP:
//           // deliveryPickupTimeLbl.text = "Order Approx. Ready for pickup within " + "\(GroceryCartData.shared.restDetails.restPickupTime)" + " Min"
//            break
//        case .Today:
//           // print(GroceryCartData.shared.selectedTime.heading)
////            let todayDate = UtilsClass.getCurrentDateInStringDDMMM()
////            let tempTime = todayDate + " at " + AddToCartItmesData.shared.deliveryTime
////            estimateTimeLabel.text = "Order Approx. Ready for pickup within " + tempTime
//            deliveryPickupTimeLbl.text = "Order Approx. Ready for pickup within " + GroceryCartData.shared.selectedTime.heading
//
//            break
//        default:
////            let tempDate = UtilsClass.getStringDateFromStringInDDMM(stringDate: AddToCartItmesData.shared.deliveryDate, stringTime: AddToCartItmesData.shared.deliveryTime) + " at " + AddToCartItmesData.shared.deliveryTime
////            print(AddToCartItmesData.shared.deliveryTime)
////            print(tempDate)
//
//            deliveryPickupTimeLbl.text = "Order Approx. Ready for pickup within " + GroceryCartData.shared.selectedTime.heading
//            break
//        }
    }
    func deliveryTime() {
        deliveryPickupTimeLbl.text = "Order Approx. Out for Delivery within "
//        switch GroceryCartData.shared.orderDate {
//        case .ASAP:
//                           break
//        case .Today
//            deliveryPickupTimeLbl.text = "Order Approx. Out for Delivery within " + GroceryCartData.shared.selectedTime.heading
//                           break
//        default:
//            deliveryPickupTimeLbl.text = "Order Approx. Out for Delivery within " + GroceryCartData.shared.selectedTime.heading
//            break
//                       }
    }
    
    @IBAction func backToHomeNavigation () {
        GroceryCartData.shared.refreshCartData()
        let tabbar = self.navigationController?.viewControllers[1] as! TabBarVC
        self.navigationController?.popToViewController(tabbar, animated: true)
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
extension GroceryFinalOrderPageVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
            return 0//GroceryCartData.shared.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryCartItemTVCell", for: indexPath) as! GroceryCartItemTVCell
            cell.selectionStyle = .none
            cell.backgroundColor = .white
          //  cell.delegate = self
            cell.deleteButton.tag = indexPath.row - 1
            cell.updateUI(index: indexPath.row - 1)
            cell.selectionStyle = .none
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
