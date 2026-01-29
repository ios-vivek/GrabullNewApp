//
//  WelcomeCell.swift
//  Grabul
//
//  Created by Vivek SIngh on 02/08/24.
//  Copyright © 2024 Omnie. All rights reserved.
//

import UIKit

class WelcomeCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var subtitle1Lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLbl.text = "title1".translated()
        subtitleLbl.text = "title2".translated()
        subtitle1Lbl.text = "title3".translated()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
