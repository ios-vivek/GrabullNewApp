//
//  FinalOrderPageVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 13/12/24.
//

import UIKit

class FinalOrderPageVC: UIViewController {
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

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        tbl.backgroundColor = .white
        UtilsClass.savePastOrderRest(pastOrderRest: PastOrderRest(restId: "\(Cart.shared.orderNumber)", count: 1))
        orderNumberLbl.text = "Order # \(Cart.shared.orderNumber)"
        backToHomeBtn.backgroundColor = themeBackgrounColor
        backToHomeBtn.setRounded(cornerRadius: 10)
        backToHomeBtn.setFontWithString(text: "BACK TO HOME", fontSize: 16)
        restaurantNameLbl.text = Cart.shared.restDetails.name
        restaurantContactLbl.text = "Restaurant Contact : \(Cart.shared.restDetails.phone)"
        supportContactLbl.text = "Restaurant Support : \(Cart.shared.supportNumber)"
        if Cart.shared.orderType == .pickup {
            orderTypeLbl.text = "Pickup from:"
            orderSummeryLbl.text = "Pickup Order Summary"
            
            let add = Cart.shared.restDetails.address + " " +  Cart.shared.restDetails.city + " " +  Cart.shared.restDetails.state + " " +  Cart.shared.restDetails.zip
            addressLbl.text = add
            pickTime()
        } else {
            orderTypeLbl.text = "Delivery To:"
            orderSummeryLbl.text = "Delivery Order Summary"
            deliveryTime()
            let address = Cart.shared.userAddress

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
        }

    }
    
    func pickTime() {
        switch Cart.shared.orderDate {
        case .ASAP:
           // deliveryPickupTimeLbl.text = "Order Approx. Ready for pickup within " + "\(Cart.shared.restDetails.restPickupTime)" + " Min"
            break
        case .Today:
           // print(Cart.shared.selectedTime.heading)
//            let todayDate = UtilsClass.getCurrentDateInStringDDMMM()
//            let tempTime = todayDate + " at " + AddToCartItmesData.shared.deliveryTime
//            estimateTimeLabel.text = "Order Approx. Ready for pickup within " + tempTime
            deliveryPickupTimeLbl.text = "Order Approx. Ready for pickup within " + Cart.shared.selectedTime.heading

            break
        default:
//            let tempDate = UtilsClass.getStringDateFromStringInDDMM(stringDate: AddToCartItmesData.shared.deliveryDate, stringTime: AddToCartItmesData.shared.deliveryTime) + " at " + AddToCartItmesData.shared.deliveryTime
//            print(AddToCartItmesData.shared.deliveryTime)
//            print(tempDate)

            deliveryPickupTimeLbl.text = "Order Approx. Ready for pickup within " + Cart.shared.selectedTime.heading
            break
        }
    }
    func deliveryTime() {
        switch Cart.shared.orderDate {
        case .ASAP:
           // deliveryPickupTimeLbl.text = "Order Approx. Out for Delivery within " + "\(Cart.shared.restDetails.deliverytime)" + " Min"
                           break
        case .Today:
//             let todayDate = UtilsClass.getCurrentDateInStringDDMMM()
//            let tempTime = todayDate + " at " + AddToCartItmesData.shared.deliveryTime
            deliveryPickupTimeLbl.text = "Order Approx. Out for Delivery within " + Cart.shared.selectedTime.heading
                           break
        default:
//            let tempDate = UtilsClass.getStringDateFromStringInDDMM(stringDate: AddToCartItmesData.shared.deliveryDate, stringTime: AddToCartItmesData.shared.deliveryTime) + " at " + AddToCartItmesData.shared.deliveryTime
//            print(AddToCartItmesData.shared.deliveryTime)
//            print(tempDate)
            deliveryPickupTimeLbl.text = "Order Approx. Out for Delivery within " + Cart.shared.selectedTime.heading
            break
                       }
    }
    
    @IBAction func backToHomeNavigation () {
        Cart.shared.refreshCartData()
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
extension FinalOrderPageVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
            return Cart.shared.cartData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemTVCell", for: indexPath) as! CartItemTVCell
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            //cell.delegate = self
            cell.deleteButton.tag = indexPath.row
            cell.updateUI(index: indexPath.row)
            cell.selectionStyle = .none
            return cell
        } else {
         let cell = tableView.dequeueReusableCell(withIdentifier: "CartPriceDetailsTVCell", for: indexPath) as! CartPriceDetailsTVCell
         cell.selectionStyle = .none
         cell.backgroundColor = .white
         cell.emptyCartButton.isHidden = true
         //cell.delegate = self
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
