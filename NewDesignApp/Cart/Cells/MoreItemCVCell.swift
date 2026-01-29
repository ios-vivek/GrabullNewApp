//
//  DealsAndServiesCV.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 15/08/24.
//

import UIKit
protocol MoreItemCVCellDelegate: AnyObject {
    func didTapAddButton(indexPath: IndexPath)
}
class MoreItemCVCell: UICollectionViewCell {
    @IBOutlet weak var headingTitle: UILabel!
    @IBOutlet weak var subHeadingTitle: UILabel!
    @IBOutlet weak var restItemImage: UIImageView!
    @IBOutlet weak var addbutton: UIButton!

    var indexPath: IndexPath!
    weak var delegate: MoreItemCVCellDelegate?
    @IBOutlet weak var roundView: UIView!
    
    func updateUI() {
        roundView.backgroundColor = .clear
        addbutton.layer.masksToBounds = true
        addbutton.layer.cornerRadius = 6
        addbutton.layer.borderWidth = 1
        
        restItemImage.layer.masksToBounds = true
        restItemImage.layer.cornerRadius = 12
        
        addbutton.layer.borderColor = UIColor.lightGray.cgColor
        addbutton.backgroundColor = .white
        addbutton.titleLabel?.textColor = kGreenColor
        addbutton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
    }
    @objc func addButtonAction(sender: UIButton!) {
        self.delegate?.didTapAddButton(indexPath: self.indexPath)
    }

}
