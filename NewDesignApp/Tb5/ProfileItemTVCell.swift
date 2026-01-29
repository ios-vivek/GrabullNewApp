//
//  ProfileItemTVCell.swift
//  NewDesignApp
//
//  Created by Vivek Singh on 09/06/1946 Saka.
//

import UIKit

class ProfileItemTVCell: UITableViewCell {
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.accessoryType = .disclosureIndicator

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
