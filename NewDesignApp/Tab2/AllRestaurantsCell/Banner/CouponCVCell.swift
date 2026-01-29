//
//  CouponCVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 07/01/25.
//

import UIKit

class CouponCVCell: UICollectionViewCell {
    @IBOutlet weak var couponOfferView: UIView!
    @IBOutlet weak var colorImageView: UIImageView!

    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var subHeadingLbl: UILabel!

    
    func updateUI(coupon: Coupon) {
        self.couponOfferView.layer.masksToBounds = true
        self.couponOfferView.layer.cornerRadius = 10.0
        self.couponOfferView.clipsToBounds = true
        self.couponOfferView.backgroundColor = UIColor.gOrange100
        self.colorImageView.backgroundColor = .clear//UIColor.gGray100

        headingLbl.text = "Get $\(coupon.amount) Off"
        headingLbl.font = UIFont.boldSystemFont(ofSize: 25)
        subHeadingLbl.text = "your order of $\(coupon.min) or more"
        subHeadingLbl.font = UIFont.boldSystemFont(ofSize: 25)
        headingLbl.textColor = .gSkyBlue
        subHeadingLbl.textColor = .gSkyBlue

        //setGradientBackground()
    }
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.colorImageView.bounds
                
        self.colorImageView.layer.insertSublayer(gradientLayer, at:0)
        
        
        
    }
}
