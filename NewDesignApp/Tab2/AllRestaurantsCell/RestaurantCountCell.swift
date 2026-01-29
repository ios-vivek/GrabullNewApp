//
//  RestaurantCountCell.swift
//  GTB DUBAI
//
//  Created by Omnie Solutions on 03/02/23.
//

import UIKit

class RestaurantCountCell: UITableViewCell {
    @IBOutlet weak var headingTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        headingTitle.text = "1500 Restaurants to explore".uppercased()//"exploreTitle".localizeString(string: GlobalClass.shared.getLangauge())
        self.backgroundColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
