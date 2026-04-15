//
//  ItemTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 10/08/24.
//

import UIKit

class Testvc: UITableViewCell {
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
    }
    func updateUI(itemlist: GroceryMenuItem) {
        itemImage.backgroundColor = .gGray100
        itemNameLbl.text = itemlist.heading
        itemNameLbl.textColor = kOrangeColor
        itemDesLbl.text = ""
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
        let sizes = itemlist.sizeList?.sortedByPrice() ?? []

        pricePlusLbl.isHidden = sizes.count <= 1
        let price = sizes.first?.price?.to2Decimal() ?? "0.00"
        itemPriceLbl.text = "\(UtilsClass.getCurrencySymbol())\(price)"

        itemImage.setImage(urlString: itemlist.itemImage)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
