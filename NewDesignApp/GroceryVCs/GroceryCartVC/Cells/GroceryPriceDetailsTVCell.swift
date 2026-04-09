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
        if GroceryCartData.shared.restDetails != nil {
            donateLbl.isHidden = true
            tipsLbl.isHidden = true
            var temp: Float = 0.0
            let details = GroceryCartData.shared.getAllPriceDeatils()
            let subt = GroceryCartData.shared.roundValue2Digit(value: details.subTotal)
            let dist = GroceryCartData.shared.roundValue2Digit(value: details.discount)
            let taxt = GroceryCartData.shared.roundValue2Digit(value: details.tax)

            subtotalValueLbl.text = "\(UtilsClass.getCurrencySymbol())\(subt.toString())"
            discountValueLbl.text = "-\(UtilsClass.getCurrencySymbol())\(dist.toString())"
            taxesValueLbl.text = "\(UtilsClass.getCurrencySymbol())\(taxt.toString())"
            totalValueLbl.text = "\(UtilsClass.getCurrencySymbol())\(GroceryCartData.shared.roundValue2Digit(value: details.total).toString())"
            let str = isPlaceOrder ? "Place Order" : "Checkout"
            checkoutButton.setFontWithString(text: "\(str): \(UtilsClass.getCurrencySymbol())\(GroceryCartData.shared.roundValue2Digit(value: details.total))", fontSize: 16)
            let tax = details.tax - details.serviceCharge
            taxLbl.text = "Taxes, Fee Apllied: \(UtilsClass.getCurrencySymbol())\(GroceryCartData.shared.roundValue2Digit(value: tax).toString())"
            serviceLbl.text = "Service Fee \(UtilsClass.getCurrencySymbol())\(details.serviceCharge.toString())"
            helpLbl.text = "The Service fee help us"
            technologyLbl.text = "technology & support charges"
            temp = details.total
            if GroceryCartData.shared.isTips {
                tipsLbl.isHidden = false
                tipsLbl.text = "🌟 \(UtilsClass.getCurrencySymbol())\(GroceryCartData.shared.tipsAmount.toString()) added tips"
                totalValueLbl.text = "\(UtilsClass.getCurrencySymbol())\(temp.toString())"
                checkoutButton.setFontWithString(text: "\(str): \(UtilsClass.getCurrencySymbol())\(temp.toString())", fontSize: 16)
            }
            print("\(GroceryCartData.shared.orderType)")
            deliveryChargeLbl.isHidden = GroceryCartData.shared.orderType == .delivery ? false : true
            deliveryChargeValueLbl.isHidden = GroceryCartData.shared.orderType == .delivery ? false : true
            deliveryStackView.isHidden = GroceryCartData.shared.orderType == .delivery ? false : true

           // if !isPlaceOrder {
           //     deliveryChargeLbl.isHidden = true
            //    deliveryChargeValueLbl.isHidden = true
           // }
            if GroceryCartData.shared.orderType == .delivery {
                deliveryChargeValueLbl.text = "\(UtilsClass.getCurrencySymbol())\(details.deliveryCharge.toString())"
            }
            if GroceryCartData.shared.isDonate {
               // temp = details.total + GroceryCartData.shared.donateAmount + GroceryCartData.shared.tipsAmount + details.deliveryCharge
               // temp = GroceryCartData.shared.roundValue2Digit(value: temp)
                totalValueLbl.text = "\(UtilsClass.getCurrencySymbol())\(temp.toString())"
                checkoutButton.setFontWithString(text: "\(str): \(UtilsClass.getCurrencySymbol())\(temp.toString())", fontSize: 16)
                donateLbl.isHidden = false
                donateLbl.text = "🌟 \(UtilsClass.getCurrencySymbol())\(GroceryCartData.shared.donateAmount) added for donate."
                
            }
            totalLbl.text = "Total"
            if GroceryCartData.shared.isReward {
                totalValueLbl.numberOfLines = 0
                totalLbl.numberOfLines = 0
                totalLbl.attributedText = self.configurerewadTextTotal(text1: "Reward", text: "\nTotal")
                var rewaramount = temp
                let payValue = (temp) - GroceryCartData.shared.rewardAmount
                if payValue.isLess(than: 0.0){
                    temp = 0
                } else {
                    temp = payValue
                    rewaramount = GroceryCartData.shared.rewardAmount
                }
                temp = GroceryCartData.shared.roundValue2Digit(value: temp)
                rewaramount = GroceryCartData.shared.roundValue2Digit(value: rewaramount)
                totalValueLbl.text = "\(UtilsClass.getCurrencySymbol())\(temp.toString())"
               // totalValueLbl.text = "-\(UtilsClass.getCurrencySymbol())\(rewaramount)\n\(UtilsClass.getCurrencySymbol())\(temp)"
                totalValueLbl.attributedText = self.configurerewadText(text1: "-\(UtilsClass.getCurrencySymbol())\(rewaramount.toString())", text: "\n\(UtilsClass.getCurrencySymbol())\(temp.toString())")

                checkoutButton.setFontWithString(text: "\(str): \(UtilsClass.getCurrencySymbol())\(temp.toString())", fontSize: 16)
            }
        }
        checkoutButton.isHidden = !APPDELEGATE.userLoggedIn()
        if GroceryCartData.shared.orderType == .delivery && GroceryCartData.shared.userAddress == nil {
            checkoutButton.isHidden = true
        }
        checkoutButton.isHidden = !isPlaceOrder
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
