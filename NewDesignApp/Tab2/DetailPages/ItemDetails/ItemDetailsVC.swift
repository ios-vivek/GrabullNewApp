//
//  ItemDetailsVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 12/08/24.
//

import UIKit
import Alamofire
protocol ItemDetailsDelegate {
    func itemClosed()
    func openSelectSize(index: IndexPath)
}

class ItemDetailsVC: UIViewController {
    var delegate : ItemDetailsDelegate?
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var restImage: UIImageView!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var pricePlusLbl: UILabel!
    @IBOutlet weak var allSizesWithPriceLbl: UILabel!


    @IBOutlet weak var addItemView: UIView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var itemCountLbl: UILabel!
    @IBOutlet weak var addLblView: UIView!
    @IBOutlet weak var plusMinusView: UIView!
    @IBOutlet weak var bogoImage: UIImageView!
    @IBOutlet weak var soldOutImage: UIImageView!

    var itemData: RestItemList!
    var index: IndexPath!
    var allSizesWithPrice = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.restImage.backgroundColor = .gGray100
        self.restImage.image = UIImage(named: "restaurant_placeholder")
        self.restImage.contentMode = .center
        backgroundView.layer.cornerRadius = 15
        restImage.layer.cornerRadius = 15
        restImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        addItemView.layer.cornerRadius = 10
        addLblView.backgroundColor = .clear
        plusMinusView.isHidden = true
        self.shadow(Vw: addItemView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        addItemView.addGestureRecognizer(tap)
        itemNameLbl.text = itemData.heading
        itemNameLbl.textColor = kOrangeColor
        bogoImage.isHidden = true
        /*
        if itemData?.bogo == 1 {
            bogoImage.isHidden = false
        }
        */
        soldOutImage.isHidden = true
        /*
        if itemData.status == "Sold out for today" {
            soldOutImage.isHidden = false
            soldOutImage.backgroundColor = .clear
        }
        */
        priceLbl.text = "\(UtilsClass.getCurrencySymbol())\(itemData?.getMinimumPrice.first ?? 0.0)"
        pricePlusLbl.isHidden = itemData!.getMinimumPrice.count > 1 ? false : true
        allSizesWithPriceLbl.numberOfLines = 0
        allSizesWithPriceLbl.text = "(\(allSizesWithPrice))"
        allSizesWithPriceLbl.isHidden = itemData!.getMinimumPrice.count > 1 ? false : true

        /*
        if let size = itemData?.sizet {
            if UtilsClass.isMultipleSizeAvailable(sizeType: size) {
                priceLbl.text = "\(UtilsClass.getCurrencySymbol())\(itemData?.getMinimumPrice ?? 0.0)"
                pricePlusLbl.isHidden = false
            } else {
                priceLbl.text = "\(UtilsClass.getCurrencySymbol())\(itemData?.getMinimumPrice ?? 0.0)"
                pricePlusLbl.isHidden = true
            }
        }
        */
        descLbl.text = itemData.details ?? ""
        let url = ""//"\(ServiceType.imageUrl)\(itemData.img ?? "")"
        AF.request( url,method: .get).response{ response in
            switch response.result {
            case .success(let responseData):
                if responseData != nil {
                    self.restImage.image = UIImage(data: responseData!)
                    self.restImage.contentMode = .scaleToFill
                    if self.restImage.image == nil {
                        self.restImage.image = UIImage(named: "restaurant_placeholder")
                        self.restImage.contentMode = .center
                    }
                }
            case .failure(let error):
                self.restImage.image = UIImage(named: "restaurant_placeholder")
                self.restImage.contentMode = .center
            }
        }
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
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
//        let vc: ItemSizeSelectionPopupVC = self.viewController(viewController: ItemSizeSelectionPopupVC.self, storyName: StoryName.OrderFlow.rawValue) as! ItemSizeSelectionPopupVC
//        vc.itemData = itemData
//        vc.delegate = self
//        self.present(vc, animated: true)
        self.delegate?.openSelectSize(index: index)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.itemClosed()
    }
}
extension ItemDetailsVC: ItemAddedInCartDelegate {
    func itemAddedInTheCart() {
              self.showToast(message: "Item added in the cart.", font: .systemFont(ofSize: 14.0))

    }
}

