//
//  ChooseAddressTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 15/11/24.
//

import UIKit

class ChooseAddressTVCell: UITableViewCell {
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var selectedAddressImg: UIImageView!
    @IBOutlet weak var addressTypeLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addressTypeLbl.backgroundColor = .gGray100
        addressTypeLbl.textColor = .darkGray
        selectedAddress(selected: false)
    }
    func selectedAddress(selected: Bool) {
        selectedAddressImg.layer.borderWidth = 1
        selectedAddressImg.layer.cornerRadius = 7
        selectedAddressImg.layer.borderColor = UIColor.gGray100.cgColor
        selectedAddressImg.layer.backgroundColor = selected ? themeBackgrounColor.cgColor : UIColor.white.cgColor
    }
    func updateUI(selected: Bool) {
        selectedAddress(selected: selected)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
