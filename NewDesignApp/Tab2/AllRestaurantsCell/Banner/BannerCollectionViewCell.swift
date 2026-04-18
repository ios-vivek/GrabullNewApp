//
//  BannerCollectionViewCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 04/11/24.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bannerImage: UIImageView!

    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var bannerWidth: NSLayoutConstraint!


  
    func updateUI(imageUrl: String) {
        bannerImage.layer.masksToBounds = true
        bannerImage.layer.cornerRadius = 10.0
        bannerImage.clipsToBounds = true
        let url = imageUrl
        bannerImage.setImage(urlString: url)
    }
}
