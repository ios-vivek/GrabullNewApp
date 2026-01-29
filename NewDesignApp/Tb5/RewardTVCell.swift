//
//  RewardTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 18/02/25.
//

import UIKit

class RewardTVCell: UITableViewCell {
    @IBOutlet weak var rewardTypeLbl: UILabel!
    @IBOutlet weak var rewardPointLbl: UILabel!
    @IBOutlet weak var rewardBucksLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
