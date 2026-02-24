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
        self.layer.cornerRadius = 10
    }

    func updateUI(url: String) {
        restImage.contentMode = .scaleToFill
        restImage.layer.cornerRadius = 10
        restImage.backgroundColor = .gGray100
        
        AF.request( url,method: .get).response{ response in
            switch response.result {
            case .success(let responseData):
                if responseData != nil {
                    self.restImage.image = UIImage(data: responseData!)
                    self.restImage.contentMode = .scaleToFill
                    if self.restImage.image == nil {
                        self.restImage.image = UIImage(named: "restaurant_placeholder")
                        self.restImage.contentMode = .center
                    }
                }else {
                    self.restImage.image = UIImage(named: "restaurant_placeholder")
                    self.restImage.contentMode = .center
                }
            case .failure(let error):
                self.restImage.image = UIImage(named: "restaurant_placeholder")
                self.restImage.contentMode = .center
            }
        }
    }
}
