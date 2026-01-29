//
//  AddressTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 28/10/24.
//

import UIKit
protocol AddressDelegate: AnyObject {
    func editAddress(selectedIndex: Int)
    func deleteAddress(selectedIndex: Int)
}
class AddressListTVCell: UITableViewCell {
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addressTypeLbl: UILabel!
    @IBOutlet weak var addressImage: UIImageView!
    weak var delegate: AddressDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //addressTypeLbl.backgroundColor = .gGray100
        addressTypeLbl.textColor = .darkGray
        self.selectionStyle = .none
        self.backgroundColor = .white
    }
    func configureUI(address: UserAdd){
        addressLbl.text = "\(address.add1 ?? "") \(address.add2 ?? ""), \(address.city ?? ""), \(address.state ?? ""), \(address.zip ?? "")"
        if address.addtypes == "Home" {
            addressImage.image = UIImage.init(named: "homeAddress")
        }
        else if address.addtypes == "Work" {
            addressImage.image = UIImage.init(named: "officeAddress")
        } else {
            addressImage.image = UIImage.init(named: "otherAddress")
        }
        addressTypeLbl.text = address.addtypes?.uppercased()
    }
    @IBAction func editAddressAction(sender: UIButton) {
        self.delegate?.editAddress(selectedIndex: sender.tag)
    }
    @IBAction func deleteAction(sender: UIButton) {
        self.delegate?.deleteAddress(selectedIndex: sender.tag)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
