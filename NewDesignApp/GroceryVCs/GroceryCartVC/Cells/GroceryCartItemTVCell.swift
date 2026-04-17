//
//  CartItemTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 15/10/24.
//

import UIKit

protocol GroceryCartItemDelegate: AnyObject {
    func deleteItem(index: Int)
    func refreshItemList()
    func updateQuantity(index: Int, change: Int)
}

class GroceryCartItemTVCell: UITableViewCell {
    @IBOutlet weak var itemQtyLbl: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemToppings: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var instructionLbl: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusMinusView: UIView!
    private var cartIndex: Int = 0
    weak var delegate: GroceryCartItemDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        plusMinusView.layer.cornerRadius = 10
        plusMinusView.layer.borderColor = UIColor.lightGray.cgColor
        plusMinusView.layer.borderWidth = 1

    }
    func updateUI(index: Int) {
        cartIndex = index
        let item = GroceryCartData.shared.cartItems[index]

        itemName.text = item.item.heading
        itemQtyLbl.text = "\(item.quantity)"
        itemPrice.text = "\(UtilsClass.getCurrencySymbol())\(item.totalPrice.toString())"
        instructionLbl.text = ""
        itemToppings.text = ""
    }

    @IBAction func plusAction() {
        delegate?.updateQuantity(index: cartIndex, change: 1)
    }

    @IBAction func minusAction() {
        delegate?.updateQuantity(index: cartIndex, change: -1)
    }
   
    @IBAction func deleteItem(sender: UIButton) {
        delegate?.deleteItem(index: sender.tag)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func configureSplInstText(text1: String, text: String)-> NSAttributedString {
        //progressView.progress = Float(calorieConsumed / calorieTotal)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0
        
        let titleAttrText = NSMutableAttributedString(string: "")
        titleAttrText.append(NSAttributedString(string: "\(text1)", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.gSkyBlue
        ]))
        titleAttrText.append(NSAttributedString(string: "\(text)", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]))
        
        return titleAttrText
    }

}
