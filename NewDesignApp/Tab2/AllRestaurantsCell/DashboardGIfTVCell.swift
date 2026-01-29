//
//  DashboardGIfTVCell.swift
//  Grabul
//
//  Created by Vivek SIngh on 03/08/24.
//  Copyright © 2024 Omnie. All rights reserved.
//

import UIKit
import Alamofire

class DashboardGIfTVCell: UITableViewCell {
    @IBOutlet weak var gifImage: UIImageView!
    @IBOutlet weak var view1: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func updateUI(imageurl: String) {
       // gifImage.image = UIImage.init(named: "restaurant")
        gifImage.contentMode = .scaleToFill
        gifImage.layer.cornerRadius = 10
        
        let url = imageurl//"https://www.grabull.com//web-api//images//banner-img.jpg"
        AF.request( url,method: .get).response{ response in

          switch response.result {
           case .success(let responseData):
              self.gifImage.image = UIImage(data: responseData!, scale:1)
           case .failure(let error):
               print("error--->",error)
           }
       }
        view1.backgroundColor = themeBackgrounColor
        view1.layer.cornerRadius = 10
        view1.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.backgroundColor = .white
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
