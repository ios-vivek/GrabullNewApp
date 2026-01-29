//
//  OnYourMindCollectionViewCell.swift
//  GTB DUBAI
//
//  Created by Omnie Solutions on 03/02/23.
//

import UIKit
//import Alamofire
struct ChooseOptions {
    let title: String
    let imageName: String
    let subTitle: String
}
class OnYourMindCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodTypeLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var roundView: UIView!
    var typeList : [ChooseOptions] = [ChooseOptions]()
    override func awakeFromNib() {
        let chooseOptions1 = ChooseOptions.init(title: "Food Delivery", imageName: "food_image", subTitle: "From Restaurants")
        let chooseOptions2 = ChooseOptions.init(title: "Catering", imageName: "catering_image", subTitle: "From Catering Restaurants")
        let chooseOptions3 = ChooseOptions.init(title: "Dine in", imageName: "dine_in", subTitle: "Local Fine Dine Place's")
        let chooseOptions4 = ChooseOptions.init(title: "Grocery", imageName: "grocery_image", subTitle: "From Local Stores")
        typeList.append(chooseOptions1)
        typeList.append(chooseOptions2)
        typeList.append(chooseOptions3)
        typeList.append(chooseOptions4)
        
        self.shadow(Vw: roundView)
        self.backgroundColor = .clear
    }
    func shadow(Vw : UIView)
    {
        Vw.clipsToBounds = true
        Vw.layer.masksToBounds = false
        Vw.layer.shadowColor =  UIColor.lightGray.cgColor
        Vw.layer.shadowOffset = CGSize(width: 1, height: 1)
        Vw.layer.shadowRadius = 5.0
        Vw.layer.shadowOpacity = 15.0
        Vw.layer.cornerRadius = 10.0
        
    }
    func updateUI(index: Int) {
        foodTypeLbl.text = typeList[index].title.uppercased()
        foodImage.image = UIImage.init(named: typeList[index].imageName)
        subTitleLbl.text = typeList[index].subTitle.uppercased()
        subTitleLbl.textColor = .darkGray
        foodImage.contentMode = .scaleToFill
       // foodTypeLbl.font = UIFont.boldSystemFont(ofSize: 18)
        subTitleLbl.font = UIFont.systemFont(ofSize: 8)
    }
}
