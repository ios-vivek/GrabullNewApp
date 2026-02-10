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
        addressLbl.text = order.type == "Pickup" ? "\("order.pickup_address")" : order.deliveryAddress.first?.fullAddress ?? ""
        priceLbl.text = "Price \(UtilsClass.getCurrencySymbol())\(order.total)"
        let text = order.type == "Pickup" ? "Order picked on" : "Order delivered on"
        if order.holddate == "Yes" {
            //dateLbl.text = "\(text) \(order.holddate ?? "")"
            dateLbl.attributedText = getAttributedString(fstring: "\(text) ", sstring: "\(order.holddate ?? "")")
        } else {
            dateLbl.attributedText = getAttributedString(fstring: "\(text) ", sstring: "\(order.date)")
        }
    }
    func getAttributedString(fstring: String, sstring: String)-> NSMutableAttributedString {
       // let fmyAttribute = [NSAttributedString.Key.foregroundColor: kBlueColor]
        let font1 = UIFont.boldSystemFont(ofSize: 16)
        let font2 = UIFont.systemFont(ofSize: 14)

        let attributes1: [NSAttributedString.Key: Any] = [
        .font: font1,
        .foregroundColor: UIColor.black,
        ]
        let attributes2: [NSAttributedString.Key: Any] = [
        .font: font2,
        .foregroundColor: UIColor.darkGray,
        ]
        let myString = NSMutableAttributedString(string: fstring, attributes: attributes1 )
        let myString1 = NSMutableAttributedString(string: sstring, attributes: attributes2 )
        
        myString.append(myString1)

        return myString
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
