//
//  AddressTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 28/10/24.
//

import UIKit

class NotificationCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var notificationImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //addressTypeLbl.backgroundColor = .gGray100
        titleLbl.textColor = .darkGray
        subTitleLbl.textColor = .darkGray
        self.selectionStyle = .none
        self.backgroundColor = .white
    }
    func configureUI(notification: NotiFicationModel){
        titleLbl.text = notification.title
        subTitleLbl.text = notification.body
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
