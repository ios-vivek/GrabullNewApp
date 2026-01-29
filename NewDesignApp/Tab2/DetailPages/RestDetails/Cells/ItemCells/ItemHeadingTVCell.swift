//
//  ItemHeadingTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 07/10/24.
//

import UIKit

class ItemHeadingTVCell: UITableViewCell {
    @IBOutlet weak var itemHeadingLbl: UILabel!
    @IBOutlet weak var itemSubHeadingLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        itemSubHeadingLbl.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
