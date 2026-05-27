//
//  GiftNumberTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 22/10/24.
//

import UIKit

class GroceryGiftNumberTVCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var giftTxtFld: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        giftTxtFld.delegate = self
        self.backgroundColor = .white
        giftTxtFld.backgroundColor = .white
        giftTxtFld.textColor = .black
        giftTxtFld.layer.cornerRadius = 8
        giftTxtFld.layer.borderWidth = 1
        giftTxtFld.layer.borderColor = UIColor.gGray100.cgColor
        giftTxtFld.setLeftPaddingPoints(10)
        giftTxtFld.setPlaceHolderColor(.gGray200)

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let text = textField.text, let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)

                GroceryCartData.shared.giftNumber = updatedText
                print(GroceryCartData.shared.giftNumber)
            }

            return true
        }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
