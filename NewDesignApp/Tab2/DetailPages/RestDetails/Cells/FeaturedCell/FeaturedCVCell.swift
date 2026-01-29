//
//  FeaturedCVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 12/08/24.
//

import UIKit
import Alamofire
class FeaturedCVCell: UICollectionViewCell {
    @IBOutlet weak var headingTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    

    func updateUI(featuredItem: FeaturedItem?) {
        headingTitle.text = "\(featuredItem?.name ?? "")"
        
        let url = featuredItem?.url ?? ""
        AF.request( url,method: .get).response{ response in
          switch response.result {
           case .success(let responseData):
               self.imageView.image = UIImage(data: responseData!, scale:1)
              self.imageView.contentMode = .scaleAspectFit
           case .failure(let error):
               print("error--->",error)
           }
       }
    }
}
