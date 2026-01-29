//
//  DonateTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 29/10/24.
//

import UIKit

class DonateTVCell: UITableViewCell {
    @IBOutlet weak var donateHeadingText: UILabel!

    @IBOutlet weak var donateText: UILabel!
    @IBOutlet weak var selectedSizeImage: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .white
        selectedSizeImage.layer.cornerRadius = 4
        selectedSizeImage.layer.borderWidth = 1
        selectedSizeImage.layer.borderColor = UIColor.black.cgColor
    }
    func updateUI() {
       // donateHeadingText.text = "\(Cart.shared.restDetails.donateheading)"
        var donate: Float = 0.0
        let total = Cart.shared.getAllPriceDeatils().total + Cart.shared.tipsAmount + Cart.shared.getAllPriceDeatils().deliveryCharge
        let mintotal = Int(total) + 1
        donate = Float(mintotal) - total
        donate = Cart.shared.roundValue2Digit(value: donate)
        Cart.shared.donateAmount = donate
       // donateText.text = "Donate \(UtilsClass.getCurrencySymbol())\(donate) \(Cart.shared.restDetails.donatetext)"
        selectedSizeImage.image = UIImage.init(named: Cart.shared.isDonate == true ? "checkIcon" : "")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
