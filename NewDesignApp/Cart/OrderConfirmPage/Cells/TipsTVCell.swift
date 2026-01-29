//
//  TipsTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 22/10/24.
//

import UIKit

protocol TipsDelegate: AnyObject {
    func tipsAction()
}

class TipsTVCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var tipsSegment: UISegmentedControl!
    @IBOutlet weak var customTipsTxtFld: UITextField!
    var delegate: TipsDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .white
        tipsSegment.selectedSegmentTintColor = kBlueColor
            tipsSegment.setTextColor()

        tipsSegment.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        tipsSegment.selectedSegmentIndex = 4
        customTipsTxtFld.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        customTipsTxtFld.delegate = self
        customTipsTxtFld.keyboardType = .decimalPad
        customTipsTxtFld.placeholder = "0.0"
        let label = UILabel()
        label.text = " $ "
        label.textColor = .black
        customTipsTxtFld.leftViewMode = .always
        customTipsTxtFld.leftView = label
        
        customTipsTxtFld.textColor = .black
        customTipsTxtFld.backgroundColor = .white
       
        customTipsTxtFld.layer.cornerRadius = 8
        customTipsTxtFld.layer.borderWidth = 1
        customTipsTxtFld.layer.borderColor = UIColor.gGray100.cgColor
        customTipsTxtFld.setPlaceHolderColor(.gGray200)

    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text!.count > 0 {
            tipsSegment.selectedSegmentIndex = -1
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.count > 0 {
            tipsSegment.selectedSegmentIndex = -1
            let tipsAmount = textField.text!
            Cart.shared.isTips = true
            Cart.shared.tipsAmount = Float(tipsAmount)!
        } else {
            Cart.shared.isTips = false
            Cart.shared.tipsAmount = 0.0
        }
        self.delegate?.tipsAction()
    }
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.endEditing(true)
        customTipsTxtFld.text = ""
        switch sender.selectedSegmentIndex {
        case 0:
            Cart.shared.isTips = true
            let tempTotal = Cart.shared.getAllPriceDeatils().subTotal
            let tipsAmount = (tempTotal * 10) / 100
            Cart.shared.tipsAmount = Cart.shared.roundValue2Digit(value: tipsAmount)
        case 1:
            Cart.shared.isTips = true
            let tempTotal = Cart.shared.getAllPriceDeatils().subTotal
            let tipsAmount = (tempTotal * 15) / 100
            Cart.shared.tipsAmount = Cart.shared.roundValue2Digit(value: tipsAmount)
        case 2:
            Cart.shared.isTips = true
            let tempTotal = Cart.shared.getAllPriceDeatils().subTotal
            let tipsAmount = (tempTotal * 20) / 100
            Cart.shared.tipsAmount = Cart.shared.roundValue2Digit(value: tipsAmount)
        case 3:
            Cart.shared.isTips = true
            let tempTotal = Cart.shared.getAllPriceDeatils().subTotal
            let tipsAmount = (tempTotal * 25) / 100
            Cart.shared.tipsAmount = Cart.shared.roundValue2Digit(value: tipsAmount)
        default:
            Cart.shared.isTips = false
            Cart.shared.tipsAmount = 0.0
        }
        self.delegate?.tipsAction()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
