//
//  GiftNumberTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 22/10/24.
//

import UIKit

class RecipientTVCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var PhoneLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .white
       
    }
    func updateUI(fullName: String, phone: String) {
        nameLbl.text = fullName
        PhoneLbl.text = phone
        //nameLbl.attributedText = getString(firstPart: "Name: ", secondPart: "", fullText: "Name: \(fullName)")
       // PhoneLbl.attributedText = getString(firstPart: "Phone: ", secondPart: "", fullText: "Phone: \(phone)")
    }
    func getString(firstPart: String, secondPart: String, fullText: String)-> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: fullText)

        // First part in red
        attributedString.addAttribute(.foregroundColor,
                                      value: kOrangeColor,
                                       range: NSRange(location: 0, length: firstPart.count))

        // Second part in blue
        attributedString.addAttribute(.foregroundColor,
                                      value: UIColor.black,
                                       range: NSRange(location: firstPart.count, length: secondPart.count))
        return attributedString

      //  titlelbl.attributedText = attributedString
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
