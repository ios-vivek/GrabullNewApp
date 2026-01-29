//
//  DeliveryAtTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 22/10/24.
//

import UIKit
protocol ChangeAddressDelegate: AnyObject {
    func changeAddress()
    func changePhone()
}
class DeliveryAtTVCell: UITableViewCell {
    @IBOutlet weak var deliveryAtLbl: UILabel!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!

    @IBOutlet weak var changeAddressBtn: UIButton!
    @IBOutlet weak var changePhoneBtn: UIButton!
    weak var delegate: ChangeAddressDelegate?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .white
    }
    @IBAction func changeAddress() {
        self.delegate?.changeAddress()
    }
    @IBAction func changePhone() {
        self.delegate?.changePhone()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
