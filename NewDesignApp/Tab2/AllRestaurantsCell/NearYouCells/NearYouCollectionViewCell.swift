//
//  NearYouCollectionViewCell.swift
//  GTB DUBAI
//
//  Created by Omnie Solutions on 02/02/23.
//

import UIKit
import Alamofire
//import SkeletonView
class NearYouCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var restName: UILabel!
    @IBOutlet weak var deliveryTimeLbl: UILabel!
    @IBOutlet weak var foodTypeImage: UIImageView!
    @IBOutlet weak var cuisineLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var distantLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!




    override func awakeFromNib() {
//        [foodImage,restName,deliveryTimeLbl,foodTypeImage].forEach{
//            $0?.isSkeletonable = true
//        }
//        [foodImage,restName,deliveryTimeLbl,foodTypeImage].forEach{
//            $0?.showAnimatedGradientSkeleton()
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            self.hideSkeletonCell()
        }
       // let imageView = UIImageView(frame: CGRectMake(0, 0, 100, 100))
        updateUI()
       
    }
    func hideSkeletonCell(){
//        [foodImage,restName,deliveryTimeLbl,foodTypeImage].forEach{
//            $0?.hideSkeleton()
//        }
       updateUI()
    }
    func updateUI(){
        //foodImage.image = UIImage.init(named: "")
        foodImage.layer.masksToBounds = true
        foodImage.layer.cornerRadius = 12
        self.foodImage.backgroundColor = .gGray100
    }
    
    func configUI(restaurant: Restaurant) {
        favImage.isHidden = true//APPDELEGATE.userLoggedIn() ? false : true
        ratingLbl.text = "\(restaurant.rating ?? 0.0)"
        restName.text = restaurant.name
        cuisineLbl.text = "\(restaurant.cuisine)"
        deliveryTimeLbl.text = "\(restaurant.pickupTime) mins"
        addressLbl.text = "\(restaurant.address)"
        distantLbl.text = "\(restaurant.distance ?? 0.0)mi"
        favImage.image = UIImage.init(named: restaurant.isFav ? "favoriteSelected" : "favorite")
        let url = restaurant.restImage
        AF.request( url,method: .get).response{ response in
            switch response.result {
            case .success(let responseData):
                if responseData != nil {
                    self.foodImage.image = UIImage(data: responseData!)
                    self.foodImage.contentMode = .scaleToFill
                    if self.foodImage.image == nil {
                        self.foodImage.image = UIImage(named: "img_midium")
                        self.foodImage.contentMode = .center
                    }
                }else {
                    self.foodImage.image = UIImage(named: "img_midium")
                    self.foodImage.contentMode = .center
                }
            case .failure:
                self.foodImage.image = UIImage(named: "img_midium")
                self.foodImage.contentMode = .center
            }
        }

        
    }
    func configUIForDeals(restaurant: Restaurant) {
        // Safely unwrap offers and sort by minorder descending (convert String to Double)
        /*
        if let offers = restaurant.offer, offers.isEmpty == false {
            /*
            let sortedOffers = offers.sorted { lhs, rhs in
                let l = Double(lhs.details) ?? 0
                let r = Double(rhs.details) ?? 0
                return l > r // descending
            }
            if let top = sortedOffers.first {
               // cuisineLbl.text = "\(top.details)\(top.types) off over \(top.minorder)$"
                cuisineLbl.text = "\(top.details)\(top.types) off"
            } else {
                cuisineLbl.text = ""
            }
            */
            cuisineLbl.text = "\(restaurant.offer?.first?.title ?? "")"
        } else {
            cuisineLbl.text = ""
        }
        */
        cuisineLbl.text = "ABC offer"
        cuisineLbl.textColor = .red
        cuisineLbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        cuisineLbl.adjustsFontSizeToFitWidth = true
        favImage.isHidden = true//APPDELEGATE.userLoggedIn() ? false : true
        restName.text = restaurant.name
        deliveryTimeLbl.text = "\(restaurant.pickupTime) mins"
        addressLbl.text = "\(restaurant.address)"
        distantLbl.text = "\(restaurant.distance ?? 0.0)mi"
        favImage.image = UIImage.init(named: restaurant.isFav ? "favoriteSelected" : "favorite")
        let url = restaurant.restImage
        AF.request( url,method: .get).response{ response in
            switch response.result {
            case .success(let responseData):
                if responseData != nil {
                    self.foodImage.image = UIImage(data: responseData!)
                    self.foodImage.contentMode = .scaleToFill
                    if self.foodImage.image == nil {
                        self.foodImage.image = UIImage(named: "img_midium")
                        self.foodImage.contentMode = .center
                    }
                }else {
                    self.foodImage.image = UIImage(named: "img_midium")
                    self.foodImage.contentMode = .center
                }
            case .failure:
                self.foodImage.image = UIImage(named: "img_midium")
                self.foodImage.contentMode = .center
            }
        }

        
    }
}
