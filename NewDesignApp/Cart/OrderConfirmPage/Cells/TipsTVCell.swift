//
//  TipsTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 22/10/24.
//

import UIKit

protocol TipsDelegate: AnyObject {
    func tipsAction(isTips: Bool, tipsAmount: Double)
}

class TipsTVCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var tipsSegment: UISegmentedControl!
    @IBOutlet weak var customTipsTxtFld: UITextField!
    var delegate: TipsDelegate?
    var totalPrice = 0.0
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
    func updateValue(itemPrice: Double) {
        totalPrice = itemPrice
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
            self.delegate?.tipsAction(isTips: true, tipsAmount: Double(tipsAmount)!)
        } else {
            self.delegate?.tipsAction(isTips: false, tipsAmount: 0.0)
        }
    }
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.endEditing(true)
        customTipsTxtFld.text = ""
        switch sender.selectedSegmentIndex {
        case 0:
            let tipsAmount = (totalPrice * 10) / 100
            self.delegate?.tipsAction(isTips: true, tipsAmount: Double(tipsAmount))
        case 1:
            let tipsAmount = (totalPrice * 15) / 100
            self.delegate?.tipsAction(isTips: true, tipsAmount: Double(tipsAmount))
        case 2:
            let tipsAmount = (totalPrice * 20) / 100
            self.delegate?.tipsAction(isTips: true, tipsAmount: Double(tipsAmount))
        case 3:
            let tipsAmount = (totalPrice * 25) / 100
            self.delegate?.tipsAction(isTips: true, tipsAmount: Double(tipsAmount))
        default:
            self.delegate?.tipsAction(isTips: false, tipsAmount: 0.0)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
