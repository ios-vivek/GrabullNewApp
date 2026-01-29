//
//  CounsinesCVCell.swift
//  Grabul
//
//  Created by Vivek SIngh on 03/08/24.
//  Copyright © 2024 Omnie. All rights reserved.
//

import UIKit
import Alamofire

class CounsinesCVCell: UICollectionViewCell {
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodTypeLbl: UILabel!
   

    override func awakeFromNib() {
       // foodImage.layer.masksToBounds = true
       // foodImage.layer.cornerRadius = foodImage.frame.size.width/2
        foodImage.backgroundColor = .clear
    }

    func updateUI(cousine: CousineList) {
       // self.foodImage.sd_setImage(with: URL(string: getMindList()[index]), placeholderImage: foodTypeLblUIImage(named: ""))
        foodTypeLbl.text = cousine.name
        
        let url = cousine.url//getMindList()[index]
      //  liveItUpImage.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: ""))
        AF.request( url,method: .get).response{ response in

          switch response.result {
           case .success(let responseData):
              self.foodImage.image = UIImage(data: responseData!, scale:1)

           case .failure(let error):
               print("error--->",error)
           }
       }

       
    }
    func updateUIOld(cousine: Cuisine) {
       // self.foodImage.sd_setImage(with: URL(string: getMindList()[index]), placeholderImage: foodTypeLblUIImage(named: ""))
        foodTypeLbl.text = cousine.heading
        
        let url = cousine.cuisineImage//getMindList()[index]
        AF.request( url,method: .get).response{ response in
            switch response.result {
            case .success(let responseData):
                if responseData != nil {
                    self.foodImage.image = UIImage(data: responseData!)
                    self.foodImage.contentMode = .scaleToFill
                    if self.foodImage.image == nil {
                        self.foodImage.image = UIImage(named: "img_small")
                        self.foodImage.contentMode = .center
                    }
                }else {
                    self.foodImage.image = UIImage(named: "img_small")
                    self.foodImage.contentMode = .center
                }
            case .failure(let error):
                self.foodImage.image = UIImage(named: "img_small")
                self.foodImage.contentMode = .center
            }
        }


       
    }
    func getMindList()-> [String]{
    let url1 = "https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1674029856/PC_Creative%20refresh/3D_bau/banners_new/Pizza.png"
        let url2 = "https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1674029845/PC_Creative%20refresh/3D_bau/banners_new/Burger.png"
        let url3 = "https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1675667625/PC_Creative%20refresh/North_Indian_4.png"
        let url4 = "https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1674029844/PC_Creative%20refresh/3D_bau/banners_new/Chole_Bature.png"
        let url5="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1674029853/PC_Creative%20refresh/3D_bau/banners_new/Paratha.png"
        let url6 = "https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1675667625/PC_Creative%20refresh/Biryani_2.png"
        let url7 = "https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1674029856/PC_Creative%20refresh/3D_bau/banners_new/Pizza.png"
        let url8 = "https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1674029845/PC_Creative%20refresh/3D_bau/banners_new/Burger.png"
        let url9 = "https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1675667625/PC_Creative%20refresh/North_Indian_4.png"
        let url10 = "https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1674029844/PC_Creative%20refresh/3D_bau/banners_new/Chole_Bature.png"
        let url11 = "https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1674029853/PC_Creative%20refresh/3D_bau/banners_new/Paratha.png"
        let url12 = "https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1675667625/PC_Creative%20refresh/Biryani_2.png"
    return [url1,url2,url3,url4,url5,url6,url7,url8,url9,url10,url11,url12,url1,url2,url3,url4,url5,url6,url7,url8,url9,url10,url11,url12]
    }
}

