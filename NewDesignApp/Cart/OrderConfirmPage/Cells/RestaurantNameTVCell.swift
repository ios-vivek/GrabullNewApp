//
//  RestaurantNameTVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 22/10/24.
//

import UIKit

class RestaurantNameTVCell: UITableViewCell {
    @IBOutlet weak var restNameLbl: UILabel!
    @IBOutlet weak var restStatusLbl: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .white
    }
    func updateUI () {
        restNameLbl.text = Cart.shared.restDetails.name
//        if Cart.shared.restDetails.openstatus == "Open Now" {
//            restStatusLbl.text = "Restaurant Open Now"//Cart.shared.restuarant.open_status_heading
//            restStatusLbl.textColor = kGreenColor
//        } else {
//            restStatusLbl.text = Cart.shared.restDetails.openstatus
//            restStatusLbl.textColor = .red
//        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
