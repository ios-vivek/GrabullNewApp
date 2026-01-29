//
//  OrderDetailsTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 30/11/24.
//

import UIKit

class OrderDetailsTVCell: UITableViewCell {
    @IBOutlet weak var restNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var ordernumberLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func updateUI(order: OrderHistory) {
        ordernumberLbl.text = "Order #\(order.order)"
        restNameLbl.text = order.resturant
        restNameLbl.textColor = kOrangeColor
       // addressLbl.text = order.type == "Pickup" ? "\(order.pickup_address)" : order.address
        priceLbl.text = "Price \(UtilsClass.getCurrencySymbol())\(order.total)"
       // let text = order.type == "Pickup" ? "Order picked on" : "Order delivered on"
       // dateLbl.text = "\(text) \(order.date2)"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
