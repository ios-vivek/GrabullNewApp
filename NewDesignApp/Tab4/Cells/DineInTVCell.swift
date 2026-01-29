//
//  DineInTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 17/12/24.
//

import UIKit

class DineInTVCell: UITableViewCell {
    @IBOutlet weak var restaurantLbl: UILabel!
    @IBOutlet weak var peopleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var bookingDateForLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var resionCommentLbl: UILabel!



    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusLbl.font = UIFont.boldSystemFont(ofSize: 18)
        statusLbl.textColor = kBlueColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(order: DineInOrder) {
        statusLbl.text = order.status
        bookingDateForLbl.attributedText = self.configureSplInstText(text1: "DineIn Time: ", text: "\(order.date)")

        restaurantLbl.attributedText = self.configureSplInstText(text1: "Restaurant: ", text: "\(order.restaurant)")
        dateLbl.attributedText = self.configureSplInstText(text1: "Booking Time: ", text: "\(order.booking)")

        peopleLbl.attributedText = self.configureSplInstText(text1: "Number Of People: ", text: "\(order.people)")

        commentLbl.numberOfLines = 0
        commentLbl.attributedText = self.configureSplInstText(text1: "Comment: ", text: "\(order.comment ?? "")")
        resionCommentLbl.attributedText = self.configureSplInstText(text1: "Reason: ", text: "\(order.comment ?? "")")

        resionCommentLbl.isHidden = true


    }
    private func configureSplInstText(text1: String, text: String)-> NSAttributedString {
        //progressView.progress = Float(calorieConsumed / calorieTotal)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0
        
        let titleAttrText = NSMutableAttributedString(string: "")
        titleAttrText.append(NSAttributedString(string: "\(text1)", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]))
        titleAttrText.append(NSAttributedString(string: "\(text)", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]))
        
        return titleAttrText
    }

}
