//
//  ItemSizeTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 17/08/24.
//

import UIKit

class ItemSizeTVCell: UITableViewCell {
    @IBOutlet weak var foodTypeImage: UIImageView!
    @IBOutlet weak var sizeNameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var selectedSizeImage: UIImageView!
    @IBOutlet weak var roundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectedSizeImage.layer.cornerRadius = 4
        selectedSizeImage.layer.borderWidth = 1
        selectedSizeImage.layer.borderColor = UIColor.black.cgColor
        selectedSizeImage.image = UIImage.init(named: "checkIcon")
    }
    func updateUIForSelectSize(indexPath: IndexPath, sizes: [Sizes], selectedSize: Int) {
        selectedSizeImage.isHidden = false
        sizeNameLbl.isHidden = false
        if indexPath.row == 0 && sizes.count == 1 {
            roundView.layer.cornerRadius = 10
            roundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else{
            if indexPath.row == 0 {
                roundView.layer.cornerRadius = 10
                roundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
            if indexPath.row == sizes.count - 1 {
                roundView.layer.cornerRadius = 10
                roundView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
        }
        selectedSizeImage.image = UIImage.init(named: "")
        if selectedSize == indexPath.row {
            selectedSizeImage.image = UIImage.init(named: "checkIcon")
        }
        if sizes.count == 1 {
            selectedSizeImage.isHidden = true
            sizeNameLbl.isHidden = true
        }
    }

    func updateUIForSelectOption(indexPath: IndexPath, option: [RestOptionList], isChecked: Bool, sizes: Sizes?) {
       let aOption = option[indexPath.row]
        sizeNameLbl.text = aOption.heading
        priceLbl.text = ""
        selectedSizeImage.isHidden = false
        sizeNameLbl.isHidden = false
        if indexPath.row == 0 && option.count == 1 {
            roundView.layer.cornerRadius = 10
            roundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else{
            if indexPath.row == 0 {
                roundView.layer.cornerRadius = 10
                roundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
            if indexPath.row == option.count - 1 {
                roundView.layer.cornerRadius = 10
                roundView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
        }
        selectedSizeImage.image = UIImage.init(named: "")
        if isChecked {
            selectedSizeImage.image = UIImage.init(named: "checkIcon")
        }
        
        let optionPrice = Cart.shared.getOptionsPrice(option: aOption, sizes: sizes)
        var price = ""
        if  optionPrice > 0  {
            price = " (\(UtilsClass.getCurrencySymbol())\(optionPrice.toString()))"
        }
        sizeNameLbl.text = aOption.heading + price

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
