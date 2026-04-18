//
//  FeaturedCVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 12/08/24.
//

import UIKit
class FeaturedCVCell: UICollectionViewCell {
    @IBOutlet weak var headingTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    

    func updateUI(featuredItem: FeaturedItem?) {
        headingTitle.text = "\(featuredItem?.name ?? "")"
        
        let url = featuredItem?.url ?? ""
        imageView.setImage(urlString: url)
    }
}
