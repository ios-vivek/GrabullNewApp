//
//  SpecialRequestTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 22/10/24.
//

import UIKit
protocol SpecialInstructionDelegate: AnyObject {
    func typedInstruction(msgTyped: String)
}
class SpecialRequestTVCell: UITableViewCell, UITextViewDelegate {
    @IBOutlet weak var specialTxtView: UITextView!
    var delegate: SpecialInstructionDelegate?


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
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return true }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= 60
    }

    func textViewDidChange(_ textView: UITextView) {
        self.delegate?.typedInstruction(msgTyped: textView.text ?? "")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
