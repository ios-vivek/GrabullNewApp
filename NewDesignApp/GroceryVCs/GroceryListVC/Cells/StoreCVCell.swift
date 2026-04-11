//
//  NearYouCollectionViewCell.swift
//  GTB DUBAI
//
//  Created by Omnie Solutions on 02/02/23.
//

import UIKit
import Alamofire
//import SkeletonView
class HomeRestCVCell: UICollectionViewCell {
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var restName: UILabel!
    @IBOutlet weak var deliveryTimeLbl: UILabel!
    @IBOutlet weak var foodTypeImage: UIImageView!
    @IBOutlet weak var cuisineLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var distantLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!


    @IBOutlet weak var imageLeading: NSLayoutConstraint!
    
    @IBOutlet weak var titleLeading: NSLayoutConstraint!
    
    @IBOutlet weak var titleTrailing: NSLayoutConstraint!
    @IBOutlet weak var imageTrailing: NSLayoutConstraint!
    override func awakeFromNib() {
        foodTypeImage.backgroundColor = .clear
        foodImage.layer.cornerRadius = 8
        foodImage.layer.masksToBounds = true
        foodImage.layer.borderColor = kGrayColor.cgColor
        foodImage.layer.borderWidth = 0.5
//        [foodImage,restName,deliveryTimeLbl,foodTypeImage].forEach{
//            $0?.isSkeletonable = true
//        }
//        [foodImage,restName,deliveryTimeLbl,foodTypeImage].forEach{
//            $0?.showAnimatedGradientSkeleton()
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
//            self.hideSkeletonCell()
//        }
       // let imageView = UIImageView(frame: CGRectMake(0, 0, 100, 100))
       // updateUI()
       
    }
    func hideSkeletonCell(){
//        [foodImage,restName,deliveryTimeLbl,foodTypeImage].forEach{
//            $0?.hideSkeleton()
//        }
    }
    func updateUIWithOld(index: Int, restaurant: Restaurant){
        if index%2 == 0 {
            imageLeading.constant = 20.0
            imageTrailing.constant = 10.0
            titleLeading.constant = 20.0
            titleTrailing.constant = 10.0
        } else {
            imageLeading.constant = 10.0
            imageTrailing.constant = 20.0
            titleLeading.constant = 10.0
            titleTrailing.constant = 20.0
        }
        foodImage.layer.cornerRadius = 8
        foodImage.layer.masksToBounds = true
        favImage.isHidden = true//APPDELEGATE.userLoggedIn() ? false : true
      //  threeDots.isHidden = true//APPDELEGATE.userLoggedIn() ? false : true
        favImage.image = UIImage.init(named: restaurant.isFav ? "favoriteSelected" : "favorite")
       // threeDots.tag = index
        favImage.tag = index
        restName.text = restaurant.name
        ratingLbl.text = "\(restaurant.rating ?? 0.0)"
        deliveryTimeLbl.text = "\(restaurant.pickupTime) mins"
        addressLbl.text = "\(restaurant.address)"
        distantLbl.text = "\(restaurant.distance ?? 0.0)mi"
        cuisineLbl.text = "\(restaurant.cuisine)"
        let url = restaurant.restImage
        AF.request( url,method: .get).response{ response in
            switch response.result {
            case .success(let responseData):
                if responseData != nil {
                    self.foodImage.image = UIImage(data: responseData!)
                    self.foodImage.contentMode = .scaleAspectFill
                    if self.foodImage.image == nil {
                        self.foodImage.image = UIImage(named: "img_midium")
                        self.foodImage.contentMode = .center
                    }
                }else {
                    self.foodImage.image = UIImage(named: "img_midium")
                    self.foodImage.contentMode = .center
                }
            case .failure(let error):
                self.foodImage.image = UIImage(named: "img_midium")
                self.foodImage.contentMode = .center
            }
        }

    }

}
