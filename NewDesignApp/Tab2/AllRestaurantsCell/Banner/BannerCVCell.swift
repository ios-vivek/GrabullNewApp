//
//  BannerCVCell.swift
//  GTB DUBAI
//
//  Created by Vivek SIngh on 09/07/24.
//

import UIKit
import Alamofire

class BannerCVCell: UICollectionViewCell {
    static let identifire = "BannerCVCell"
    @IBOutlet weak var bannerImage: UIImageView!
    override func awakeFromNib() {
    }
    func updateUI(imageUrl: String){
        bannerImage.layer.masksToBounds = true
        bannerImage.layer.cornerRadius = 10.0
        bannerImage.clipsToBounds = true
        let url = imageUrl
        AF.request( url,method: .get).response{ response in
          switch response.result {
           case .success(let responseData):
              self.bannerImage.image = UIImage(data: responseData!)
              self.bannerImage.contentMode = .scaleAspectFit
           case .failure(let error):
               print("error--->",error)
           }
       }
    }
}
