//
//  RestDetailTVCell.swift
//  Grabul
//
//  Created by Vivek SIngh on 08/08/24.
//  Copyright © 2024 Omnie. All rights reserved.
//

import UIKit
import Alamofire

protocol GalleryDelegate: AnyObject {
    func selectedGalleryView()
    func scheduleDateAction()
}

class RestDetailTVCell: UITableViewCell {
    @IBOutlet weak var restImage: UIImageView!
    @IBOutlet weak var restName: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var userRatinglbl: UILabel!
    @IBOutlet weak var reorderedLbl: UILabel!
    @IBOutlet weak var pickupBtn: UILabel!
    @IBOutlet weak var deliveryBtn: UILabel!
    @IBOutlet weak var toggleView: UIView!
    @IBOutlet weak var deliveryTimeLbl: UILabel!
    @IBOutlet weak var scheduleDateBtn: UIButton!
    @IBOutlet weak var photoCountView: UIView!
    @IBOutlet weak var lblPhotoCount: UILabel!
    @IBOutlet weak var lblAsap: UILabel!
 //   @IBOutlet weak var deliveryPickupTitleLbl: UILabel!


    weak var delegate: GalleryDelegate?
var restData: CustomRestDetails?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pickupBtn?.layer.masksToBounds = true
        deliveryBtn?.layer.masksToBounds = true

        toggleView.layer.cornerRadius = 17
        deliveryBtn.layer.cornerRadius = 17
        pickupBtn.layer.cornerRadius = 17
        toggleView.layer.borderWidth = 1
        toggleView.layer.borderColor = UIColor.lightGray.cgColor
        photoCountView.layer.cornerRadius = 12
        scheduleDateBtn.layer.cornerRadius = 8
        scheduleDateBtn.addTarget(self, action: #selector(scheduleAction), for: .touchUpInside)
       // pickupBtn.addTarget(self, action: #selector(pickupBtnAction), for: .touchUpInside)
        lblPhotoCount.text = "0 Photos"
        selectedButtonUI()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        photoCountView.addGestureRecognizer(tap)
        
        let pickuptap = UITapGestureRecognizer(target: self, action: #selector(self.pickupBtnAction))
        pickupBtn.addGestureRecognizer(pickuptap)
        pickupBtn.isUserInteractionEnabled = true
        
        let deliverytap = UITapGestureRecognizer(target: self, action: #selector(self.deliveryBtnAction))
        deliveryBtn.addGestureRecognizer(deliverytap)
        deliveryBtn.isUserInteractionEnabled = true
        
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.delegate?.selectedGalleryView()
    }
    @objc func deliveryBtnAction() {
        Cart.shared.orderType = .delivery
        selectedButtonUI()
    }
    @objc func pickupBtnAction() {
        Cart.shared.orderType = .pickup
        selectedButtonUI()
    }
    @objc func scheduleAction() {
        self.delegate?.scheduleDateAction()
    }
    func selectedButtonUI() {
        let isDelivery = !(Cart.shared.orderType == .pickup)
        var pcolor: UIColor = isDelivery ? .white : .black
        var dcolor: UIColor = !isDelivery ? .black : .white
        if isDelivery {
            pcolor = .black
            dcolor = .white
            pickupBtn.backgroundColor = .white
            deliveryBtn.backgroundColor = kGreenColor
        } else {
            pcolor = .white
            dcolor = .black
            pickupBtn.backgroundColor = kGreenColor
            deliveryBtn.backgroundColor = .white
        }
        
        deliveryBtn.textColor = dcolor
        pickupBtn.textColor = pcolor
        if isDelivery {
            deliveryTimeLbl.text = "\(restData?.deliveryTime ?? 0) Mins"
            lblAsap.text = "Delivery, ASAP"
        } else {
            deliveryTimeLbl.text = "\(restData?.pickupTime ?? 0) Mins"
            lblAsap.text = "Pickup, ASAP"
        }
        setDate()
        guard let rest = Cart.shared.tempRestDetails else { return }
        /*
        if !rest.isRestaurantOpen && Cart.shared.orderDate == .ASAP {
            lblAsap.text = Cart.shared.tempRestDetails.openstatus
            lblAsap.textColor = .red
        }
        */
    }
    func setDate() {
        
        var result = Cart.shared.selectedTime.heading
            result = result.replacingOccurrences(of: "Delivery", with: "")
            result = result.replacingOccurrences(of: "Pickup", with: "")

         if Cart.shared.orderType == .pickup {
             lblAsap.text = "Pickup\(result)"
         }
         if Cart.shared.orderType == .delivery {
             lblAsap.text = "Delivery\(result)"
         }
    }
    func updateUI(data: CustomRestDetails?, restImage: String) {
        restData = data
//                if restData?.gallery.list.count == 0 {
//                    photoCountView.isHidden = true
//                } else {
//                    photoCountView.isHidden = false
//                }
       // lblPhotoCount.text = "\(restData?.gallery.list.count ?? 0) Photos"
        restName.text = "\(restData?.name ?? "resta neme")"
        deliveryTimeLbl.text = "\(restData?.deliveryTime ?? 0) Mins"
        ratingLbl.text = "\(restData?.rating ?? 0)"
        userRatinglbl.text = "\(restData?.ratingHD1 ?? "")"
        reorderedLbl.text = "\(restData?.ratingHD2 ?? "")"
        
        let url = restImage
        AF.request( url,method: .get).response{ response in
          switch response.result {
           case .success(let responseData):
               self.restImage.image = UIImage(data: responseData!, scale:1)

           case .failure(let error):
               print("error--->",error)
           }
       }
      
        deliveryBtn.isUserInteractionEnabled = false
        pickupBtn.isUserInteractionEnabled = false
        
        if restData!.isDelivery {
            deliveryBtn.isUserInteractionEnabled = true
            //selectedButtonUI(isDelivery: true)
        }
        if restData!.isPickup  {
            pickupBtn.isUserInteractionEnabled = true
        }
        lblAsap.textColor = kGreenColor
        selectedButtonUI()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
