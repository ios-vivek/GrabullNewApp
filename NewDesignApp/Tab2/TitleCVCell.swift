//
//  NearYouCollectionViewCell.swift
//  GTB DUBAI
//
//  Created by Omnie Solutions on 02/02/23.
//

import UIKit
import Alamofire
//import SkeletonView

class TitleCVCell: UICollectionViewCell {
    @IBOutlet weak var headingTitle: UILabel!

    override func awakeFromNib() {
        self.backgroundColor = .white
        headingTitle.text = "header title"
        headingTitle.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }
}
