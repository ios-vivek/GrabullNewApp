//
//  NearYouCollectionViewCell.swift
//  GTB DUBAI
//
//  Created by Omnie Solutions on 02/02/23.
//

import UIKit
import Alamofire
//import SkeletonView

class PromoCVCell: UICollectionViewCell {
    
    @IBOutlet weak var restaurantNameLbl: UILabel!
    @IBOutlet weak var offerLbl: UILabel!
    @IBOutlet weak var restIconImg: UIImageView!
    @IBOutlet weak var cellBackView: UIView!
    @IBOutlet weak var iconBackView: CustomRoundedView!
    override func awakeFromNib() {
       
       
    }
    func configPromoCell(promoRestaurant: Restaurant) {
        restaurantNameLbl.text = promoRestaurant.name
        cellBackView.backgroundColor = UIColor(red: 33/255, green: 41/255, blue: 66/255, alpha: 1)
        cellBackView.layer.cornerRadius = 16
        
        iconBackView.backgroundColor = kOrangeColor

        restIconImg.backgroundColor = .clear
        offerLbl.text = "offer"
        restaurantNameLbl.textColor = .white
        offerLbl.textColor = .yellow
        /*
        if let offers = promoRestaurant.offer, offers.isEmpty == false {
            /*
            let sortedOffers = offers.sorted { lhs, rhs in
                let l = Double(lhs.details) ?? 0
                let r = Double(rhs.details) ?? 0
                return l > r // descending
            }
            if let top = sortedOffers.first {
                offerLbl.text = "\(top.details)\(top.types) off over \(top.minorder)$"
            } else {
                offerLbl.text = ""
            }
            */
            offerLbl.text = "\(promoRestaurant.offer?.first?.title ?? "")"
        } else {
            offerLbl.text = ""
        }
        */
        offerLbl.text = "ABC offer"
        let url = promoRestaurant.offericons
        AF.request( url,method: .get).response{ response in
            switch response.result {
            case .success(let responseData):
                if responseData != nil {
                    self.restIconImg.image = UIImage(data: responseData!)
                    self.restIconImg.contentMode = .scaleToFill
                    if self.restIconImg.image == nil {
                        self.restIconImg.image = UIImage(named: "img_small")
                        self.restIconImg.contentMode = .center
                    }
                }else {
                    self.restIconImg.image = UIImage(named: "img_small")
                    self.restIconImg.contentMode = .center
                }
            case .failure(_):
                self.restIconImg.image = UIImage(named: "img_small")
                self.restIconImg.contentMode = .center
            }
        }
        
       // self.restIconImg.image = UIImage(named: "promo_burger")
    }
  
}
class CustomRoundedView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = UIBezierPath()
        let rect = self.bounds
        
        // custom corner radii
        let topLeftRadius: CGFloat = 40
        let bottomLeftRadius: CGFloat = 40
        let topRightRadius: CGFloat = 16
        let bottomRightRadius: CGFloat = 16
        
        // start from top left
        path.move(to: CGPoint(x: rect.minX + topLeftRadius, y: rect.minY))
        
        // top edge + top-right corner
        path.addLine(to: CGPoint(x: rect.maxX - topRightRadius, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + topRightRadius),
                          controlPoint: CGPoint(x: rect.maxX, y: rect.minY))
        
        // right edge + bottom-right corner
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRightRadius))
        path.addQuadCurve(to: CGPoint(x: rect.maxX - bottomRightRadius, y: rect.maxY),
                          controlPoint: CGPoint(x: rect.maxX, y: rect.maxY))
        
        // bottom edge + bottom-left corner
        path.addLine(to: CGPoint(x: rect.minX + bottomLeftRadius, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY - bottomLeftRadius),
                          controlPoint: CGPoint(x: rect.minX, y: rect.maxY))
        
        // left edge + top-left corner
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeftRadius))
        path.addQuadCurve(to: CGPoint(x: rect.minX + topLeftRadius, y: rect.minY),
                          controlPoint: CGPoint(x: rect.minX, y: rect.minY))
        
        path.close()
        
        // apply mask
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
