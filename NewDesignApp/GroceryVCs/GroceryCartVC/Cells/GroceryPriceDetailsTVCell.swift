//
//  CartPriceDetailsTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 17/10/24.
//

import UIKit

protocol GroceryCheckoutDelegate: AnyObject {
    func checkoutAction()
    func emptyAction()
}

class GroceryPriceDetailsTVCell: UITableViewCell {
    @IBOutlet weak var subtotalLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var taxesLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var emptyCartButton: UIButton!
    @IBOutlet weak var subtotalValueLbl: UILabel!
    @IBOutlet weak var discountValueLbl: UILabel!
    @IBOutlet weak var taxesValueLbl: UILabel!
    @IBOutlet weak var totalValueLbl: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var deliveryChargeLbl: UILabel!
    @IBOutlet weak var deliveryChargeValueLbl: UILabel!

    
    @IBOutlet weak var taxLbl: UILabel!
    @IBOutlet weak var serviceLbl: UILabel!
    @IBOutlet weak var helpLbl: UILabel!
    @IBOutlet weak var technologyLbl: UILabel!
    @IBOutlet weak var infobtn: UIButton!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var donateLbl: UILabel!
    @IBOutlet weak var tipsLbl: UILabel!
    weak var delegate: GroceryCheckoutDelegate?

    @IBOutlet weak var deliveryStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkoutButton.setRounded(cornerRadius: 8)
        checkoutButton.backgroundColor = themeBackgrounColor
        checkoutButton.setFontWithString(text: "", fontSize: 16)
        infoView.isHidden = true
        infoView.backgroundColor = kBlueColor
        infoView.layer.cornerRadius = 10
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(self.cancelTap(_:)))
        cancelView.addGestureRecognizer(cancelTap)
        infobtn.backgroundColor = kBlueColor
        infobtn.setTitleColor(color: .white)
        infobtn.tintColor = .white
        infobtn.frame.size.width = 20
        infobtn.layer.cornerRadius = 10
        infobtn.layer.masksToBounds = true
    }
    func updateUI(isPlaceOrder: Bool) {
        if GroceryCartData.shared.cartItems.count > 0 {
            let subtotal = GroceryCartData.shared.subtotal
            let taxAmount = GroceryCartData.shared.taxAmount
            let serviceAmount = GroceryCartData.shared.serviceAmount
            let convAmount = GroceryCartData.shared.convAmount
            let deliveryAmount = GroceryCartData.shared.deliveryAmount
            let total = GroceryCartData.shared.total
            let taxWithCon = convAmount + taxAmount + serviceAmount
            
            subtotalValueLbl.text = "\(UtilsClass.getCurrencySymbol())\(subtotal.toString())"
            discountValueLbl.text = "\(UtilsClass.getCurrencySymbol())\(0.00)"
            deliveryChargeValueLbl.text = "\(UtilsClass.getCurrencySymbol())\(deliveryAmount.toString())"
            taxesValueLbl.text = "\(UtilsClass.getCurrencySymbol())\(taxWithCon.toString())"
            totalValueLbl.text = "\(UtilsClass.getCurrencySymbol())\(total.toString())"
        } else {
            subtotalValueLbl.text = ""
            discountValueLbl.text = ""
            deliveryChargeValueLbl.text = ""
            taxesValueLbl.text = ""
            totalValueLbl.text = ""
        }
        checkoutButton.isHidden = !APPDELEGATE.userLoggedIn()
        checkoutButton.isHidden = !isPlaceOrder
        tipsLbl.isHidden = true
        donateLbl.isHidden = true
       // let str = isPlaceOrder ? "Place Order" : "Checkout"
        checkoutButton.setFontWithString(text: "Checkout: \(UtilsClass.getCurrencySymbol())\(GroceryCartData.shared.total.toString())", fontSize: 16)
        setPopupData()
        if isPlaceOrder {
            var total = GroceryCartData.shared.total
            tipsLbl.isHidden = GroceryCartData.shared.tips > 0.0 ? false : true
            tipsLbl.text = "🌟 \(UtilsClass.getCurrencySymbol())\(GroceryCartData.shared.tips.toString()) added tips"
            total = total + GroceryCartData.shared.tips
            totalValueLbl.text = "\(UtilsClass.getCurrencySymbol())\(total.toString())"
           // let str = isPlaceOrder ? "Place Order" : "Checkout"
            checkoutButton.setFontWithString(text: "Place Order: \(UtilsClass.getCurrencySymbol())\(total.toString())", fontSize: 16)
        }
    }
    func setPopupData() {
        let tax = GroceryCartData.shared.taxAmount + GroceryCartData.shared.convAmount
        taxLbl.text = "Taxes, Fee Apllied: \(UtilsClass.getCurrencySymbol())\(tax.toString())"
        serviceLbl.text = "Service Fee \(UtilsClass.getCurrencySymbol())\(GroceryCartData.shared.serviceAmount.toString())"
        helpLbl.text = "The Service fee help us"
        technologyLbl.text = "technology & support charges"
    }
    @IBAction func infoIconClicked() {
        infoView.isHidden.toggle()
    }
    @objc func cancelTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        infoView.isHidden.toggle()
    }
    @IBAction func checkoutAction() {
        self.delegate?.checkoutAction()
    }
    @IBAction func emptyItemAction() {
        self.delegate?.emptyAction()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func configurerewadText(text1: String, text: String)-> NSAttributedString {
        //progressView.progress = Float(calorieConsumed / calorieTotal)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        paragraphStyle.alignment = .right
        
        let titleAttrText = NSMutableAttributedString(string: "")
        titleAttrText.append(NSAttributedString(string: "\(text1)", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.red
        ]))
        titleAttrText.append(NSAttributedString(string: "\(text)", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]))
        
        return titleAttrText
    }
    private func configurerewadTextTotal(text1: String, text: String)-> NSAttributedString {
        //progressView.progress = Float(calorieConsumed / calorieTotal)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        paragraphStyle.alignment = .left
        
        let titleAttrText = NSMutableAttributedString(string: "")
        titleAttrText.append(NSAttributedString(string: "\(text1)", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.red
        ]))
        titleAttrText.append(NSAttributedString(string: "\(text)", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]))
        
        return titleAttrText
    }

}
