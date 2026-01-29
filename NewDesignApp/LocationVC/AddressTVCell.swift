//
//  AddressTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 25/09/24.
//

import UIKit

class AddressTVCell: UITableViewCell {
    @IBOutlet weak var addressTitleLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var seperatorImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 4
        seperatorImg.backgroundColor = .gGray100
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(address: Prediction){
        addressTitleLbl.text = "\(address.description ?? "")"
        img.isHidden = false
        seperatorImg.isHidden = false
        addressTitleLbl.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    }
    
    func recentAddressUpdateUI(address: String){
        addressTitleLbl.text = "\(address)"
        img.isHidden = false
        seperatorImg.isHidden = false
        addressTitleLbl.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    }
    
    func recentTitle(address: String){
        addressTitleLbl.text = "\(address)"
        self.backgroundColor = .gGray100
        img.isHidden = true
        seperatorImg.isHidden = true
        addressTitleLbl.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }

}
