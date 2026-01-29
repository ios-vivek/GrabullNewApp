//
//  ReferRestaurantCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 23/08/25.
//

import UIKit

class GrubullChatCell: UITableViewCell {
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var subjectLbl: UILabel!
    @IBOutlet weak var chatView: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI(item: ChatList, id: String) {
        if item.type == "Customer" {
            //red
            chatView.backgroundColor = kchatCustomerColor
            dateLbl.textColor = kcustomerTextColor
            messageLbl.textColor = kcustomerTextColor
            subjectLbl.textColor = kcustomerTextColor
            dateLbl.textAlignment = .left
            messageLbl.textAlignment = .left
            subjectLbl.textAlignment = .left
        } else {
            //green
            chatView.backgroundColor = kchatGrabull
            dateLbl.textColor = kGreenColor
            messageLbl.textColor = kGreenColor
            subjectLbl.textColor = kGreenColor
            dateLbl.textAlignment = .left
            messageLbl.textAlignment = .left
            subjectLbl.textAlignment = .left
        }
        dateLbl.text = "\(item.date!)"
        messageLbl.text = item.details
        subjectLbl.text = item.subject
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
