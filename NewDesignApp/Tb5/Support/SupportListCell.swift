//
//  ReferRestaurantCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 23/08/25.
//

import UIKit

class SupportListCell: UITableViewCell {
    @IBOutlet weak var complainIDLbl: UILabel!

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var subjectLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        complainIDLbl.textColor = kBlueColor
    }
    
    func updateUI(item: ChatData) {
        //dateLbl.text = formatDate(item.date!)
        complainIDLbl.text = "Complain ID: " + item.id!
        dateLbl.text = item.date!
        statusLbl.attributedText = configureSplInstText(text1: "Status: ", text: "\(item.status!)", status: item.status!)
        subjectLbl.text = item.subject
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func configureSplInstText(text1: String, text: String, status: String)-> NSAttributedString {
        //progressView.progress = Float(calorieConsumed / calorieTotal)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0
        
        let titleAttrText = NSMutableAttributedString(string: "")
        titleAttrText.append(NSAttributedString(string: "\(text1)", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]))
        if status == "Open" {
            titleAttrText.append(NSAttributedString(string: "\(text)", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: kGreenColor,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]))
        } else {
            titleAttrText.append(NSAttributedString(string: "\(text)", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]))
        }
        
        return titleAttrText
    }
}
