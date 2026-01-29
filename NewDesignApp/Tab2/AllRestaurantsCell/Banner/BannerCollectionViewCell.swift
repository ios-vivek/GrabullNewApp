//
//  BannerCollectionViewCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 04/11/24.
//

import UIKit
import Alamofire

class BannerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bannerImage: UIImageView!

    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var bannerWidth: NSLayoutConstraint!


  
    func updateUI(imageUrl: String) {
        bannerImage.layer.masksToBounds = true
        bannerImage.layer.cornerRadius = 10.0
        bannerImage.clipsToBounds = true
        let url = imageUrl
        AF.request( url,method: .get).response{ response in
          switch response.result {
           case .success(let responseData):
              self.bannerImage.image = UIImage(data: responseData!)
              self.bannerImage.contentMode = .scaleAspectFill
           case .failure(let error):
               print("error--->",error)
           }
       }
    }
}
