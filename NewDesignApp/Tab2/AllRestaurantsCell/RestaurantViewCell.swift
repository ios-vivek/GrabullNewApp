//
//  RestaurantViewCell.swift
//  GTB DUBAI
//
//  Created by Omnie Solutions on 03/02/23.
//

import UIKit
//import SkeletonView
//import AlamofireImage
import Alamofire
protocol RestaurantCellDelegate: AnyObject {
    func closedOptionView()
    func openOptionView(sender: UITapGestureRecognizer)
    func selectedOption(option: Int)
}
class RestaurantViewCell: UITableViewCell {
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restnameLbl: UILabel!
    @IBOutlet weak var deliveryTimeLbl: UILabel!
    @IBOutlet weak var vegNonVegImage: UIImageView!
        @IBOutlet weak var threeDots: UIImageView!
    var selectedIndex = -1
    weak var delegate: RestaurantCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        threeDots.addGestureRecognizer(tap)
        threeDots.isUserInteractionEnabled = true
        
        
        
        updateUI(index: 0)
    }
      
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if selectedIndex >= 0 && selectedIndex == sender?.view?.tag{
            selectedIndex = -1
        } else {
            selectedIndex = sender?.view?.tag ?? -1
        }
        self.delegate?.openOptionView(sender: sender!)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedIndex = -1
        self.delegate?.closedOptionView()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(index: Int){
       // threeDots.isHidden = APPDELEGATE.userLoggedIn() ? false : true
        threeDots.tag = index
        let url = getFoodList()[index]
        AF.request( url,method: .get).response{ response in

          switch response.result {
           case .success(let responseData):
               self.restaurantImage.image = UIImage(data: responseData!, scale:1)

           case .failure(let error):
               print("error--->",error)
           }
       }

    }
    
    func getFoodList()-> [String] {
        let url1 = "https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/978358a0d0caba4f4555b8e2147b467d"
        let url2 = "https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/e0839ff574213e6f35b3899ebf1fc597"
        let url3 = "https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/e3q3szijnit5cfvx6iqu"
        let url4 = "https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/RX_THUMBNAIL/IMAGES/VENDOR/2024/4/17/4a509cf1-ea35-497b-9813-59145c5007c9_514911.JPG"
        let url5="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/d0450ce1a6ba19ea60cd724471ed54a8"
        let url6 = "https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/c99751d54e4e1847186c62b3309c1327"
        let url7 = "https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/978358a0d0caba4f4555b8e2147b467d"
        let url8 = "https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/e0839ff574213e6f35b3899ebf1fc597"
        let url9 = "https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/e3q3szijnit5cfvx6iqu"
        let url10 = "https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/RX_THUMBNAIL/IMAGES/VENDOR/2024/4/17/4a509cf1-ea35-497b-9813-59145c5007c9_514911.JPG"
        let url11 = "https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/d0450ce1a6ba19ea60cd724471ed54a8"
        let url12 = "https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/c99751d54e4e1847186c62b3309c1327"
        return [url1,url2,url3,url4,url5,url6,url7,url8,url9,url10,url11,url12,url1,url2,url3,url4,url5,url6,url7,url8,url9,url10,url11,url12]
    }

}
