//
//  CardNumberTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 22/10/24.
//

import UIKit

class CardNumberTVCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var cardTxtFld: UITextField!
    @IBOutlet weak var expiryTxtFld: UITextField!
    @IBOutlet weak var cvvTxtFld: UITextField!
    @IBOutlet weak var zipTxtFld: UITextField!
    @IBOutlet weak var cardHolderTxtFld: UITextField!


    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        // Initialization code
        cardTxtFld.delegate = self
        expiryTxtFld.delegate = self
        cvvTxtFld.delegate = self
        zipTxtFld.delegate = self
        cardHolderTxtFld.delegate = self
        
        cardTxtFld.keyboardType = .numberPad
        expiryTxtFld.keyboardType = .numberPad
        cvvTxtFld.keyboardType = .numberPad
        
        cardTxtFld.backgroundColor = .white
        expiryTxtFld.backgroundColor = .white
        cvvTxtFld.backgroundColor = .white
        zipTxtFld.backgroundColor = .white
        cardHolderTxtFld.backgroundColor = .white
        
        cardTxtFld.textColor = .black
        expiryTxtFld.textColor = .black
        cvvTxtFld.textColor = .black
        zipTxtFld.textColor = .black
        cardHolderTxtFld.textColor = .black
        
        cardTxtFld.layer.cornerRadius = 8
        cardTxtFld.layer.borderWidth = 1
        cardTxtFld.layer.borderColor = UIColor.gGray100.cgColor
        
        cvvTxtFld.layer.cornerRadius = 8
        cvvTxtFld.layer.borderWidth = 1
        cvvTxtFld.layer.borderColor = UIColor.gGray100.cgColor
        
        cardHolderTxtFld.layer.cornerRadius = 8
        cardHolderTxtFld.layer.borderWidth = 1
        cardHolderTxtFld.layer.borderColor = UIColor.gGray100.cgColor
        
        zipTxtFld.layer.cornerRadius = 8
        zipTxtFld.layer.borderWidth = 1
        zipTxtFld.layer.borderColor = UIColor.gGray100.cgColor
        
        expiryTxtFld.layer.cornerRadius = 8
        expiryTxtFld.layer.borderWidth = 1
        expiryTxtFld.layer.borderColor = UIColor.gGray100.cgColor
        
        cardTxtFld.setLeftPaddingPoints(10)
        expiryTxtFld.setLeftPaddingPoints(10)
        cvvTxtFld.setLeftPaddingPoints(10)
        zipTxtFld.setLeftPaddingPoints(10)
        cardHolderTxtFld.setLeftPaddingPoints(10)
        
        cardHolderTxtFld.text = "\(APPDELEGATE.userResponse?.customer.fullName ?? "")"
        
        cardTxtFld.setPlaceHolderColor(.gGray200)
        expiryTxtFld.setPlaceHolderColor(.gGray200)
        cvvTxtFld.setPlaceHolderColor(.gGray200)
        zipTxtFld.setPlaceHolderColor(.gGray200)




    }
    func updateCardUI() {
        cardTxtFld.text = Cart.shared.cardNumber
        cardHolderTxtFld.text = Cart.shared.cardHolder
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let text = textField.text, let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)
                if textField == cardTxtFld {
                    if updatedText.count <= 19 {
                        Cart.shared.cardNumber = updatedText
                    } else {
                        return false
                    }
                }
                if textField == expiryTxtFld {
                    if updatedText.count <= 4 {
                        Cart.shared.cardExpiry = updatedText
                    }
                    else {
                        return false
                    }
                }
                if textField == cvvTxtFld {
                    if updatedText.count <= 4 {
                        Cart.shared.cardCvv = updatedText
                    } else {
                        return false
                    }
                }
                if textField == zipTxtFld {
                    Cart.shared.cardZip = updatedText
                }
                if textField == cardHolderTxtFld {
                    Cart.shared.cardHolder = updatedText
                }
               // print(Cart.shared.giftNumber)
            }

            return true
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
