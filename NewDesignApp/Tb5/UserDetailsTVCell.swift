//
//  UserDetailsTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 31/08/24.
//

import UIKit
protocol EditProfileDelegate: AnyObject {
    func editProfileSelected()
}
class UserDetailsTVCell: UITableViewCell {
        @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    weak var delegate: EditProfileDelegate?
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }
    @IBAction func editProfile() {
        self.delegate?.editProfileSelected()
    }
    func updateUI() {
        guard let user = APPDELEGATE.userResponse else {
            return
        }
        nameLbl.text = "\(user.customer.fullName)"
        phoneLbl.text = user.customer.phone
        emailLbl.text = user.customer.email
    }
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }

    }

