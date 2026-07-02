//
//  NearYouCollectionViewCell.swift
//  GTB DUBAI
//
//  Created by Omnie Solutions on 02/02/23.
//

import UIKit
import SDWebImage
class FlowerStoreCVCell: UICollectionViewCell {
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var restName: UILabel!
    @IBOutlet weak var deliveryTimeLbl: UILabel!
    @IBOutlet weak var foodTypeImage: UIImageView!
    @IBOutlet weak var cuisineLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var distantLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!


    @IBOutlet weak var imageLeading: NSLayoutConstraint!
    
    @IBOutlet weak var titleLeading: NSLayoutConstraint!
    
    @IBOutlet weak var titleTrailing: NSLayoutConstraint!
    @IBOutlet weak var imageTrailing: NSLayoutConstraint!
    override func awakeFromNib() {
        foodTypeImage.backgroundColor = .clear
        foodImage.layer.cornerRadius = 8
        foodImage.layer.masksToBounds = true
        foodImage.layer.borderColor = kGrayColor.cgColor
        foodImage.layer.borderWidth = 0.5
    }
    func updateStoreUI(index: Int, store: Store) {
        
        // Layout handling
        let isEven = index % 2 == 0
        
        imageLeading.constant = isEven ? 20 : 10
        imageTrailing.constant = isEven ? 10 : 20
        titleLeading.constant = isEven ? 20 : 10
        titleTrailing.constant = isEven ? 10 : 20

        // UI Setup
        foodImage.layer.cornerRadius = 8
        foodImage.clipsToBounds = true

        favImage.isHidden = true
        favImage.tag = index

        restName.text = store.name

        // Better formatting
        ratingLbl.text = String(format: "%.1f", store.rating)
        deliveryTimeLbl.text = "\(store.showDeliveryTime)"
        deliveryTimeLbl.isHidden = true
        addressLbl.text = store.address
        distantLbl.text = String(format: "%.1f mi", store.distance)
        cuisineLbl.text = "\(store.showDeliveryTime)"//store.cuisine
        self.foodImage.setImage(urlString: store.fullImageURL)

    }

}
