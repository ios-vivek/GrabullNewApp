//
//  RatingVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 07/02/25.
//

import UIKit
import Lottie


class RatingVC: UIViewController {
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var reviewView: UIView!
    var starRatingView: StarRatingView!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var orderCompleteImageView: LottieAnimationView!

    
    var orderID = ""
    var updateApi = false
    override func viewDidLoad() {
        super.viewDidLoad()
        successView.isHidden = true
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        reviewTextView.layer.masksToBounds = true
        reviewTextView.layer.cornerRadius = 8
        reviewTextView.layer.borderWidth = 0.1
        reviewTextView.layer.borderColor = UIColor.gGray100.cgColor
        
        reviewView.layer.masksToBounds = true
        reviewView.layer.cornerRadius = 8
        
        postBtn.setRounded(cornerRadius: 8)
        
        starRatingView = StarRatingView(frame: CGRect(origin: .init(x: (self.view.bounds.size.width / 2) - 100, y: 80), size: CGSize(width: 200, height: 40)), rating: 0.0, color: .gGray100, starRounding: .roundToHalfStar)
        starRatingView.starColor = themeBackgrounColor
        starRatingView.rating = 0.0
        reviewView.addSubview(starRatingView)
        getRating()
    }
    func getRating() {
        
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "order" : orderID,
        ]) { _, new in new }
        
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.getReview, forModelType: ReviewResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            self.reviewSetData(response: success.data)
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
    }
    func reviewSetData(response: ReviewResponse) {
        if response.status != "Failed" {
            reviewTextView.text = response.comment
            starRatingView.rating = Float(response.rating!) ?? 0.0
            postBtn.setTitle("EDIT REVIEW", for: .normal)
            starRatingView.isUserInteractionEnabled = false
            reviewTextView.isUserInteractionEnabled = false
            reviewTextView.backgroundColor = .white
        } else {
            starRatingView.isUserInteractionEnabled = true
            reviewTextView.isUserInteractionEnabled = true
            postBtn.setTitle("POST REVIEW", for: .normal)
            reviewTextView.backgroundColor = .gGray100
        }
    }
    func addRating() {
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "order" : orderID,
            "rating" : "\(starRatingView.rating)",
            "comment" : "\(reviewTextView.text ?? "")",
        ]) { _, new in new }
        
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.addReview, forModelType: ReviewResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            if success.data.status == "success" {
                self.msgLbl.text = "Review Added Successfully."
                self.successView.isHidden = false
                self.starRatingView.isHidden = true
                self.orderCompleteImageView.play()
                self.orderCompleteImageView.loopMode = .loop
            }
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
    }
    func updateRating() {
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "order" : orderID,
            "rating" : "\(starRatingView.rating)",
            "comment" : "\(reviewTextView.text ?? "")",
        ]) { _, new in new }
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.updateReview, forModelType: ReviewResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            if success.data.status == "success" {
                self.msgLbl.text = "Review Updated Successfully."
                self.successView.isHidden = false
                self.starRatingView.isHidden = true
                self.orderCompleteImageView.play()
                self.orderCompleteImageView.loopMode = .loop
            }
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
    }



    @IBAction func backAction() {
        self.dismiss(animated: true)
    }
    
    @IBAction func postAction(sender: UIButton) {
        if sender.titleLabel?.text == "POST REVIEW" {
            if updateApi {
                self.updateRating()
            } else {
                self.addRating()
            }
        } else {
            updateApi = true
            starRatingView.isUserInteractionEnabled = true
            reviewTextView.isUserInteractionEnabled = true
            postBtn.setTitle("POST REVIEW", for: .normal)
            reviewTextView.backgroundColor = .gGray100
        }
    }

}
