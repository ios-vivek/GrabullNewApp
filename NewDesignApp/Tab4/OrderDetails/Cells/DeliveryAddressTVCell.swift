//
//  DeliveryAddressTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 30/11/24.
//

import UIKit

class DeliveryAddressTVCell: UITableViewCell {
    @IBOutlet weak var addressTypeLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func updateUI(order: OrderHistory) {
        addressTypeLbl.text = "Deliverd at:"
        addressLbl.text = "\(order.deliveryAddress?.fullAddress ?? "")"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
