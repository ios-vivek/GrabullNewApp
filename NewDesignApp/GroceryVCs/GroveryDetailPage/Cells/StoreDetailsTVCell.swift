//
//  RestDetailTVCell.swift
//  Grabul
//
//  Created by Vivek SIngh on 08/08/24.
//  Copyright © 2024 Omnie. All rights reserved.
//

import UIKit
import Alamofire

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


var restData: CustomRestDetails?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photoCountView.layer.cornerRadius = 12
       
        lblPhotoCount.text = "0 Photos"
        selectedButtonUI()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        photoCountView.addGestureRecognizer(tap)
        
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
    }

    func selectedButtonUI() {
        lblAsap.text = "Pickup, ASAP"
    }
 
    func updateUI(data: CustomRestDetails?, restImage: String, galleryImages: [String]) {
        restData = data
        photoCountView.isHidden = galleryImages.count > 0 ? false : true
        lblPhotoCount.text = "\(galleryImages.count) Photos"
        restName.text = "\(restData?.name ?? "resta neme")"
        deliveryTimeLbl.text = "\(restData?.deliveryTime ?? 0) Mins"
        ratingLbl.text = "\(restData?.rating ?? 0)"
        userRatinglbl.text = "\(restData?.ratingHD1 ?? "")"
        reorderedLbl.text = "\(restData?.ratingHD2 ?? "")"
        
        let url = restImage
        AF.request( url,method: .get).response{ response in
          switch response.result {
           case .success(let responseData):
               self.restImage.image = UIImage(data: responseData!, scale:1)

           case .failure(let error):
               print("error--->",error)
           }
       }
        
        lblAsap.textColor = kGreenColor
        selectedButtonUI()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
