//
//  RedeemTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 22/11/24.
//

import UIKit
protocol GroceryRedeemDelegate: AnyObject {
    func selectedRedeemAction()
}
class GroceryRedeemTVCell: UITableViewCell {
    @IBOutlet weak var redeemAmountLbl: UILabel!
    @IBOutlet weak var checkBoxImage: UIImageView!
    @IBOutlet weak var checkboxBtn: UIButton!
    var delegate: GroceryRedeemDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .white
        checkBoxImage.layer.cornerRadius = 4
        checkBoxImage.layer.borderWidth = 1
        checkBoxImage.layer.borderColor = UIColor.black.cgColor
        update(amount: "0.0")
    }
    func update(amount: String){
        if GroceryCartData.shared.isRewardAppied {
            checkBoxImage.image = UIImage.init(named: "checkIcon")
        } else {
            checkBoxImage.image = UIImage.init(named: "")
        }
      //  redeemAmountLbl.text = "Reddem GB Bucks Value $ \(amount)"
        redeemAmountLbl.attributedText = self.getAttributedString(fstring: "Redeem GB Bucks Value ", sstring: "$ \(amount)")
    }
    func getAttributedString(fstring: String, sstring: String)-> NSMutableAttributedString {
       // let fmyAttribute = [NSAttributedString.Key.foregroundColor: kBlueColor]
        let font2 = UIFont.boldSystemFont(ofSize: 16)

        let attributes1: [NSAttributedString.Key: Any] = [
        .font: font2,
        .foregroundColor: kBlueColor,
        ]
        let attributes2: [NSAttributedString.Key: Any] = [
        .font: font2,
        .foregroundColor: UIColor.black,
        ]
        let myString = NSMutableAttributedString(string: fstring, attributes: attributes1 )
        let myString1 = NSMutableAttributedString(string: sstring, attributes: attributes2 )
        
        myString.append(myString1)

        return myString
    }
    @IBAction func checkBoxAction() {
        GroceryCartData.shared.isRewardAppied = !GroceryCartData.shared.isRewardAppied
        self.delegate?.selectedRedeemAction()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
