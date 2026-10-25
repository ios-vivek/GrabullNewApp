//
//  RestDetailTVCell.swift
//  Grabul
//
//  Created by Vivek SIngh on 08/08/24.
//  Copyright © 2024 Omnie. All rights reserved.
//

import UIKit
import SDWebImage

protocol GroceryGalleryDelegate: AnyObject {
    func selectedGalleryView()
}
class StoreDetailsTVCell: UITableViewCell {
    @IBOutlet weak var restImage: UIImageView!
    @IBOutlet weak var restName: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var userRatinglbl: UILabel!
    @IBOutlet weak var reorderedLbl: UILabel!
    @IBOutlet weak var deliveryTimeLbl: UILabel!
    @IBOutlet weak var photoCountView: UIView!
    @IBOutlet weak var lblPhotoCount: UILabel!
    @IBOutlet weak var lblAsap: UILabel!
    var delegate: GroceryGalleryDelegate?


//var restData: CustomRestDetails?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photoCountView.layer.cornerRadius = 12
       
        lblPhotoCount.text = "0 Photos"
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        photoCountView.addGestureRecognizer(tap)
        
    }
    // ✅ ADD HERE
       override func prepareForReuse() {
           super.prepareForReuse()
           
           // Reset image to avoid flickering / wrong image
           restImage.sd_cancelCurrentImageLoad()
           restImage.image = UIImage(named: "img_midium")
       }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.delegate?.selectedGalleryView()
    }
 
    func updateUI(data: StoreDetails?, restImage: String, galleryImages: [String]) {
       // restData = data
        photoCountView.isHidden = galleryImages.count > 0 ? false : true
        lblPhotoCount.text = "\(galleryImages.count) Photos"
        restName.text = "\(data?.name ?? "Name")"
        deliveryTimeLbl.text = data?.showDeliveryTime
        ratingLbl.text = "\(data?.rating ?? 0)"
       // userRatinglbl.text = "\(data?.ratingHD1 ?? "")"
      //  reorderedLbl.text = "\(data?.ratingHD2 ?? "")"
        self.restImage.setImage(urlString: restImage)
        
        lblAsap.textColor = kGreenColor
        lblAsap.text = data?.storeAvailable
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
