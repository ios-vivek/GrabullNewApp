//
//  OrderItemsTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 30/11/24.
//

import UIKit

class OrderItemsTVCell: UITableViewCell {
    @IBOutlet weak var itemLbl: UILabel!
    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func updateUIHeading() {
        itemLbl.text = "ITEMS"
        qtyLbl.text = "QTY"
        priceLbl.text = "PRICE"
        itemLbl.textColor = .white
        qtyLbl.textColor = .white
        priceLbl.textColor = .white
        self.backgroundColor = kBlueColor
    }
    func updateUI(item: OrderItems) {
        itemLbl.textColor = .black
        qtyLbl.textColor = .black
        priceLbl.textColor = .black
        itemLbl.attributedText = self.getAttributedString(fstring: "\(item.item)", sstring: " \(item.extra)")
        qtyLbl.text = "\(item.qty)"
        let price = item.price * item.qty
        priceLbl.text = "\(Cart.shared.roundValue2Digit(value: price))"
        self.backgroundColor = .white
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
