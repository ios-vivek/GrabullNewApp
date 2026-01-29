//
//  RestDetailCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 26/08/24.
//

import UIKit
import Alamofire
protocol RestCellDelegate: AnyObject {
    func openOptionView(sender: UITapGestureRecognizer, index: Int)
    func clickedFavAction(index: Int)
}
class RestDetailCell: UITableViewCell {
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restnameLbl: UILabel!
    @IBOutlet weak var deliveryTimeLbl: UILabel!
    @IBOutlet weak var vegNonVegImage: UIImageView!
    @IBOutlet weak var threeDots: UIImageView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var foodType: UILabel!
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var distantLbl: UILabel!

    weak var delegate: RestCellDelegate?

    var selectedIndex = -1
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        threeDots.addGestureRecognizer(tap)
        threeDots.isUserInteractionEnabled = true
        
        let favImageTab = UITapGestureRecognizer(target: self, action: #selector(self.favImage(_:)))
        favImage.addGestureRecognizer(favImageTab)
        favImage.isUserInteractionEnabled = true
        restaurantImage.layer.cornerRadius = 10
        restaurantImage.backgroundColor = .gGray100
    }
    @objc func favImage(_ sender: UITapGestureRecognizer? = nil) {
        self.delegate?.clickedFavAction(index: sender?.view?.tag ?? 0)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
            selectedIndex = sender?.view?.tag ?? -1
        self.delegate?.openOptionView(sender: sender!, index: selectedIndex)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUIWithOld(index: Int, restaurant: Restaurant){
        favImage.isHidden = true//APPDELEGATE.userLoggedIn() ? false : true
        threeDots.isHidden = true//APPDELEGATE.userLoggedIn() ? false : true
        favImage.image = UIImage.init(named: restaurant.isFav ? "favoriteSelected" : "favorite")
        threeDots.tag = index
        favImage.tag = index
        restnameLbl.text = restaurant.name
        deliveryTimeLbl.text = "\(restaurant.pickupTime) mins"
        address.text = "\(restaurant.address)"
        //distantLbl.text = "\(restaurant.distance ?? "")mi"
        foodType.text = "\(restaurant.cuisine)"
        let url = restaurant.restImage
        AF.request( url,method: .get).response{ response in
            switch response.result {
            case .success(let responseData):
                if responseData != nil {
                    self.restaurantImage.image = UIImage(data: responseData!)
                    self.restaurantImage.contentMode = .scaleAspectFill
                    if self.restaurantImage.image == nil {
                        self.restaurantImage.image = UIImage(named: "img_midium")
                        self.restaurantImage.contentMode = .center
                    }
                }else {
                    self.restaurantImage.image = UIImage(named: "img_midium")
                    self.restaurantImage.contentMode = .center
                }
            case .failure(let error):
                self.restaurantImage.image = UIImage(named: "img_midium")
                self.restaurantImage.contentMode = .center
            }
        }

    }

}
