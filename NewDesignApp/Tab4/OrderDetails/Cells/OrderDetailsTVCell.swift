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
    private let statusLbl = UILabel()


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupStatusLabel()
    }
    private func setupStatusLabel() {
        statusLbl.translatesAutoresizingMaskIntoConstraints = false
        statusLbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        statusLbl.textColor = .gSkyBlue
        statusLbl.textAlignment = .right
        statusLbl.numberOfLines = 1

        contentView.addSubview(statusLbl)

        NSLayoutConstraint.activate([
            statusLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            statusLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    func updateUI(order: OrderHistory) {
        ordernumberLbl.textColor = .black
        statusLbl.text = order.status.uppercased()
        ordernumberLbl.text = "Order #\(order.order)"
        restNameLbl.text = order.resturant
        restNameLbl.textColor = kOrangeColor
       // addressLbl.text = order.type == "Pickup" ? "📍 \(order.resturantAddress ?? "")" : "📍 \(order.deliveryAddress?.fullAddress ?? "")"
        addressLbl.text = "📍 \(order.resturantAddress ?? "")"
        priceLbl.text = "Price \(UtilsClass.getCurrencySymbol())\(order.total)"
        dateLbl.text = "\(order.displayStatus ?? "")"
        /*
        var text = order.type == "Pickup" ? "Order picked on" : "Order delivered on"
        if order.status == "Delivered" || order.status == "Picked Up" || order.status == "Refund" || order.status == "Cancel" {
            text = "Order \(order.status)"
        } else {
            if order.holddate == "Yes" {
                if order.readyTime != nil || order.readyTime != "" {
                    dateLbl.attributedText = getAttributedString(fstring: "\(order.readyTime ?? "")", sstring: "")
                } else {
                    dateLbl.attributedText = getAttributedString(fstring: "\(text) ", sstring: "\(order.holddate ?? "")")
                }
            } else {
                //order.readyTime
                if order.readyTime != nil || order.readyTime != "" {
                    dateLbl.attributedText = getAttributedString(fstring: "\(order.readyTime ?? "")", sstring: "")
                } else {
                    dateLbl.attributedText = getAttributedString(fstring: "ASAP", sstring: "")
                }
            }
        }
        */
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
