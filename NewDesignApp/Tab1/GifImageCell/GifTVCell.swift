//
//  GifTVCell.swift
//  GTB DUBAI
//
//  Created by Vivek SIngh on 09/07/24.
//

import UIKit

class GifTVCell: UITableViewCell {
    @IBOutlet weak var gifImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }
    
    func updateUI() {
//        let img = UIImage.gifImageWithURL("https://gifbin.com/bin/4802swswsw04.gif")
//        gifImage.image = img
        gifImage.image = UIImage.init(named: "grocery_image")
        gifImage.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
