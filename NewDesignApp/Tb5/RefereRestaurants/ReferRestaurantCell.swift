//
//  ReferRestaurantCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 23/08/25.
//

import UIKit

class ReferRestaurantCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var gbLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func updateUI(item: ReferRestaurantList) {
        nameLbl.text = item.name
        statusLbl.text = item.status
        gbLbl.text = item.gb
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
