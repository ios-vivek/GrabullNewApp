//
//  GalleryCVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 26/08/24.
//

import UIKit
import Alamofire
class GalleryCVCell: UICollectionViewCell {
    @IBOutlet weak var restImage: UIImageView!

    override func awakeFromNib() {

    }

    func updateUI(url: String) {
        restImage.contentMode = .scaleToFill
        restImage.layer.cornerRadius = 10
        restImage.image = UIImage(named: "restaurant")
        //let url = "https://www.grabull.com//web-api//images//banner-img.jpg"
        AF.request( url,method: .get).response{ response in
          switch response.result {
           case .success(let responseData):
              self.restImage.image = UIImage(data: responseData!, scale:1)
              self.restImage.contentMode = .scaleToFill

           case .failure(let error):
               print("error--->",error)
           }
       }
    }
}
