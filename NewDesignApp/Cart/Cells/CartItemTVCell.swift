//
//  CartItemTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 15/10/24.
//

import UIKit

protocol DeleteDelegate: AnyObject {
    func deleteItem(index: Int)
    func refereshItemList()
}

class CartItemTVCell: UITableViewCell {
    @IBOutlet weak var itemQtyLbl: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemToppings: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var instructionLbl: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusMinusView: UIView!
var index = 0
    weak var delegate: DeleteDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        plusMinusView.layer.cornerRadius = 10
        plusMinusView.layer.borderColor = UIColor.lightGray.cgColor
        plusMinusView.layer.borderWidth = 1

    }
    func updateUI(index: Int) {
        self.index = index
        let item = Cart.shared.cartData[index]
        let size = item.restItemSizes.first!
        itemName.text = item.restItem.heading + " (\(size.manuName))\(size.isCatering ? " (Caterging)" : "")"
        itemQtyLbl.text = "\(size.itemQty)"
        let price = self.setAmountValue(sizes: size, toppings: item.restItemTopping)
        let pt = Cart.shared.roundValue2Digit(value: (price + item.extra))

        itemPrice.text = "\(UtilsClass.getCurrencySymbol())\(pt.toString())"
        
        var toppings = ""
        for topping in item.restItemTopping {
            for option in topping.option {
                var opPrice = ""
                if option.price > 0 {
                    opPrice = " $\(option.price)"
                }
                if toppings.count == 0 {
                    toppings = "\(option.optionHeading)\(opPrice)"
                } else {
                    toppings = "\(toppings) | \(option.optionHeading)\(opPrice)"
                }
            }
        }
        itemToppings.text = toppings
        itemToppings.isHidden = false
        if itemToppings.text?.count == 0 {
            itemToppings.isHidden = true
        }
        instructionLbl.text = ""
        if item.instructionText.count > 0 {
            instructionLbl.attributedText = self.configureSplInstText(text1: "Spl Inst: ", text: "\(item.instructionText)")
        }
    }
    @IBAction func plusAction() {
        var item = Cart.shared.cartData[index]
        var size = item.restItemSizes.first!
        size.itemQty = size.itemQty + 1
        itemQtyLbl.text = "\(size.itemQty)"
        Cart.shared.cartData.remove(at: index)
        item.restItemSizes.remove(at: 0)
        item.restItemSizes.append(size)
        Cart.shared.cartData.insert(item, at: index)
        self.delegate?.refereshItemList()
    }
    @IBAction func minusAction() {
        print("index: \(index)")
        var item = Cart.shared.cartData[index]
        var size = item.restItemSizes.first!
        size.itemQty = size.itemQty - 1
        itemQtyLbl.text = "\(size.itemQty)"
        
        if  size.itemQty == 0 {
            delegate?.deleteItem(index: index)
        } else {
            Cart.shared.cartData.remove(at: index)
            item.restItemSizes.remove(at: 0)
            item.restItemSizes.append(size)
            Cart.shared.cartData.insert(item, at: index)
            self.delegate?.refereshItemList()
        }
    }
    func setAmountValue(sizes: Sizes, toppings: [SelectedTopping])-> Float {
        var price: Float = 0.0
        price = Float(sizes.price)! * Float(sizes.itemQty)

        var toppingsPrice: Float = 0.0
        for topping in toppings {
            for option in topping.option {
                toppingsPrice = toppingsPrice + (Float(option.price) * Float(sizes.itemQty))
            }
        }
       price = price + toppingsPrice
        
        return price

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
class ItemTitleTVCell: UITableViewCell {
    @IBOutlet weak var itemTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        itemTitle.text = "Order Details:"
     

    }
}
