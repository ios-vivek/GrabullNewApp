//
//  GiftNumberTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 22/10/24.
//

import UIKit

class AsGiftTVCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var seperatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .white
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
