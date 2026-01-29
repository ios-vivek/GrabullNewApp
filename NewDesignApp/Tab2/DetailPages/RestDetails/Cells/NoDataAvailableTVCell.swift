//
//  NoDataAvailableTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 20/11/24.
//

import UIKit

class NoDataAvailableTVCell: UITableViewCell {
    @IBOutlet weak var titlelbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func updateUI(msg: String) {
        titlelbl.text = msg
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
