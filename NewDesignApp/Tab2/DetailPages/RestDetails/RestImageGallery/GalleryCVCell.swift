//
//  GalleryCVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 26/08/24.
//

import UIKit
class GalleryCVCell: UICollectionViewCell {
    @IBOutlet weak var restImage: UIImageView!

    override func awakeFromNib() {
        self.layer.cornerRadius = 10
    }

    func updateUI(url: String) {
        restImage.contentMode = .scaleToFill
        restImage.layer.cornerRadius = 10
        restImage.backgroundColor = .gGray100
        restImage.setImage(urlString: url)
        
    }
}
