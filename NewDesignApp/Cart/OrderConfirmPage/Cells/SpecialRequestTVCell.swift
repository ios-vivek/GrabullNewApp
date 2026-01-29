//
//  SpecialRequestTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 22/10/24.
//

import UIKit

class SpecialRequestTVCell: UITableViewCell, UITextViewDelegate {
    @IBOutlet weak var specialTxtView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        specialTxtView.layer.cornerRadius = 8
        specialTxtView.layer.borderWidth = 1
        specialTxtView.layer.borderColor = UIColor.gGray100.cgColor
        specialTxtView.delegate = self
        self.backgroundColor = .white
        specialTxtView.textColor = .black
        specialTxtView.backgroundColor = .white
    }
    func textView(_ textField: UITextView, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let text = textField.text, let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)

                Cart.shared.specialInstructionText = updatedText
                print(Cart.shared.specialInstructionText)
            }

            return true
        }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
