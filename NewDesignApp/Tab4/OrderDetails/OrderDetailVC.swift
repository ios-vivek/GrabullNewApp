//
//  OrderDetailVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 30/11/24.
//

import UIKit

class OrderDetailVC: UIViewController {
    @IBOutlet weak var orderTblView: UITableView!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var taxLbl: UILabel!
    @IBOutlet weak var tipLbl: UILabel!
    @IBOutlet weak var rewardLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var tip2Lbl: UILabel!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var custPhoneLbl: UILabel!
    @IBOutlet weak var billDetailsView: UIView!


    var hOrder: OrderHistory!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        subTotalLbl.text = "\(UtilsClass.getCurrencySymbol())\(hOrder.subtotal)"
        taxLbl.text = "\(UtilsClass.getCurrencySymbol())\(hOrder.taxC)"
        tipLbl.text = "\(UtilsClass.getCurrencySymbol())\(hOrder.tips)"
        //rewardLbl.text = "\(UtilsClass.getCurrencySymbol())\(hOrder.reward)"
        totalLbl.text = "\(UtilsClass.getCurrencySymbol())\(hOrder.total)"
        tip2Lbl.text = "\(UtilsClass.getCurrencySymbol())\(hOrder.tips2)"
        customerNameLbl.text = "Name: \(hOrder.resturant)"
       // custPhoneLbl.text = "Mobile: \(hOrder.mobile)"


    }
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

}
extension OrderDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return hOrder.type == "Pickup" ? 0 : 1
        }
        else if section == 2 {
            return hOrder.orderItems.count + 1
        }
            return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsTVCell", for: indexPath) as! OrderDetailsTVCell
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            cell.updateUI(order: hOrder)
            return cell
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryAddressTVCell", for: indexPath) as! DeliveryAddressTVCell
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            cell.updateUI(order: hOrder)
            return cell
        }
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemsTVCell", for: indexPath) as! OrderItemsTVCell
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            if indexPath.row == 0 {
                cell.updateUIHeading()
            } else {
                //cell.updateUI(item: hOrder.orderItems[indexPath.row - 1])
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemsTVCell", for: indexPath) as! OrderItemsTVCell
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 170
//    }
}

