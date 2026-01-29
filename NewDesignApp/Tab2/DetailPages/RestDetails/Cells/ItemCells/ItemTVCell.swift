//
//  ItemTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 10/08/24.
//

import UIKit
import Alamofire
protocol ItemCellDelegate {
    func addItemSelection(index: IndexPath)
}

class ItemTVCell: UITableViewCell {
    @IBOutlet weak var vegNonVegFoodImage: UIImageView!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemPriceLbl: UILabel!
    @IBOutlet weak var itemDesLbl: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var addItemView: UIView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var itemCountLbl: UILabel!
    @IBOutlet weak var pricePlusLbl: UILabel!
    @IBOutlet weak var addLblView: UIView!
    @IBOutlet weak var plusMinusView: UIView!
    @IBOutlet weak var dividerImage: UIImageView!
    @IBOutlet weak var bogoImage: UIImageView!
    @IBOutlet weak var soldOutImage: UIImageView!


    var selectedIndex: IndexPath!
     var delegate: ItemCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        itemPriceLbl.text = "\(UtilsClass.getCurrencySymbol())0"
        vegNonVegFoodImage.layer.cornerRadius = 4
        itemImage.layer.cornerRadius = 10
        addItemView.layer.cornerRadius = 10
        addLblView.backgroundColor = .clear
        plusMinusView.isHidden = true
        UtilsClass.shadow(Vw: addItemView, cornerRadius: 15)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        addItemView.addGestureRecognizer(tap)
        self.backgroundColor = .white
        itemImage.backgroundColor = .white
    }
   
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        delegate?.addItemSelection(index: selectedIndex)
    }
    func updateUI(itemlist: MenuItem) {
        itemImage.backgroundColor = .gGray100
        itemNameLbl.text = itemlist.heading
        itemNameLbl.textColor = kOrangeColor
        itemDesLbl.text = "\(itemlist.details)"
        bogoImage.isHidden = true
        /*
        if itemlist?.bogo == 1 {
            bogoImage.isHidden = false
            bogoImage.image = UIImage(named: "bogo")
        }
        */
        soldOutImage.isHidden = true
        /*
        if itemlist?.status == "Sold out for today" {
            soldOutImage.isHidden = false
            soldOutImage.backgroundColor = .clear
        }
        */
        pricePlusLbl.isHidden = itemlist.sortedPriceList.count > 1 ? false : true
        let price = itemlist.sortedPriceList.first!
        itemPriceLbl.text = "\(UtilsClass.getCurrencySymbol())\(price.price.to2Decimal())"

        /*
        if let size = itemlist?.sizet {
            if UtilsClass.isMultipleSizeAvailable(sizeType: size) {
                itemPriceLbl.text = "\(UtilsClass.getCurrencySymbol())\(itemlist?.getMinimumPrice ?? 0.0)"
                pricePlusLbl.isHidden = false
            } else {
                itemPriceLbl.text = "\(UtilsClass.getCurrencySymbol())\(itemlist?.getMinimumPrice ?? 0.0)"
                pricePlusLbl.isHidden = true
            }
        }
        */
        
        let url = ""//"\(ServiceType.imageUrl)\(itemlist?. ?? "")"
        AF.request( url,method: .get).response{ response in
            switch response.result {
            case .success(let responseData):
                if responseData != nil {
                    self.itemImage.image = UIImage(data: responseData!)
                    self.itemImage.contentMode = .scaleToFill
                    if self.itemImage.image == nil {
                        self.itemImage.image = UIImage(named: "restaurant_placeholder")
                        self.itemImage.contentMode = .center
                    }
                }else {
                    self.itemImage.image = UIImage(named: "restaurant_placeholder")
                    self.itemImage.contentMode = .center
                }
            case .failure(let error):
                self.itemImage.image = UIImage(named: "restaurant_placeholder")
                self.itemImage.contentMode = .center
            }
        }

       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
