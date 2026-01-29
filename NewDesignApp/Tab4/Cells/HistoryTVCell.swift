//
//  HistoryTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 28/10/24.
//

import UIKit
import Alamofire

class HistoryTVCell: UITableViewCell {
    @IBOutlet weak var reOrderBtn: UIButton!
    @IBOutlet weak var rateBtn: UIButton!
    @IBOutlet weak var orderNoLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var deliveryTypeLbl: UILabel!
    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var viewDetailLbl: UILabel!


    var starRatingView: StarRatingView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        orderNoLbl.font = UIFont.boldSystemFont(ofSize: 18)
        orderNoLbl.textColor = kBlueColor
        
        viewDetailLbl.font = UIFont.boldSystemFont(ofSize: 16)
        viewDetailLbl.textColor = kBlueColor
        
        priceLbl.font = UIFont.boldSystemFont(ofSize: 18)
        priceLbl.textColor = .black
        
        reOrderBtn.setRounded(cornerRadius: 4)
        rateBtn.setRounded(cornerRadius: 4)
        reOrderBtn.layer.borderWidth = 1
        reOrderBtn.layer.borderColor = themeBackgrounColor.cgColor
        rateBtn.layer.borderWidth = 1
        rateBtn.layer.borderColor = themeBackgrounColor.cgColor
        
        let size = UIScreen.main.bounds.size.width
        if size == 430.0 {
            //iphone plus
            starRatingView = StarRatingView(frame: CGRect(origin: .init(x: (self.bounds.size.width) - 85, y: self.bounds.size.height - 70), size: CGSize(width: 100, height: 40)), rating: 0.0, color: .gGray100, starRounding: .roundToHalfStar)
        }
        else if size == 440.0 {
            //iphone pro max
            starRatingView = StarRatingView(frame: CGRect(origin: .init(x: (self.bounds.size.width) - 75, y: self.bounds.size.height - 70), size: CGSize(width: 100, height: 40)), rating: 0.0, color: .gGray100, starRounding: .roundToHalfStar)

        }
        else if size == 402 {
            //iphone pro
            starRatingView = StarRatingView(frame: CGRect(origin: .init(x: (self.bounds.size.width) - 115, y: self.bounds.size.height - 70), size: CGSize(width: 100, height: 40)), rating: 0.0, color: .gGray100, starRounding: .roundToHalfStar)

        }
        else {
            starRatingView = StarRatingView(frame: CGRect(origin: .init(x: (self.bounds.size.width) - 125, y: self.bounds.size.height - 70), size: CGSize(width: 100, height: 40)), rating: 0.0, color: .gGray100, starRounding: .roundToHalfStar)
        }
        starRatingView.starColor = themeBackgrounColor
        starRatingView.rating = 0.0
        starRatingView.isUserInteractionEnabled = false
        starRatingView.isHidden = true
        self.contentView.addSubview(starRatingView)
    }
    func updateUI(order: OrderHistory) {
    
       // starRatingView.rating = Float(order.rating ?? "0.0") ?? 0.0
        orderNoLbl.text = "Order #\(order.order)"
        priceLbl.text = "\(UtilsClass.getCurrencySymbol())\(order.total)"
        dateLbl.text = order.date
        dateLbl.attributedText = self.configureSplInstText(text1: "Order Time: ", text: "\(order.date)")
        if order.type == "Delivery" {
            deliveryTypeLbl.attributedText = self.configureSplInstText(text1: "Delivered at: ", text: "\(order.deliveryAddress)")
        } else {
            deliveryTypeLbl.attributedText = self.configureSplInstText(text1: "Pickup by: ", text: "\(order.name) 📞\("order.mobile")")
        }
        if !order.orderItems.isEmpty {
            qtyLbl.text = "\(order.orderItems[0].qty)"
            itemNameLbl.text = "\(order.orderItems[0].item)"
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func configureSplInstText(text1: String, text: String)-> NSAttributedString {
        //progressView.progress = Float(calorieConsumed / calorieTotal)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0
        
        let titleAttrText = NSMutableAttributedString(string: "")
        titleAttrText.append(NSAttributedString(string: "\(text1)", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]))
        titleAttrText.append(NSAttributedString(string: "\(text)", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]))
        
        return titleAttrText
    }

}
