//
//  DealsAndServiesCV.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 15/08/24.
//

import UIKit
import Lottie
class DealsAndServiesCV: UICollectionViewCell {
    @IBOutlet weak var headingTitle: UILabel!
    @IBOutlet weak var subHeadingTitle: UILabel!
    @IBOutlet weak var offerImageView: LottieAnimationView!


    @IBOutlet weak var roundView: UIView!
    
    func updateUI(offerItem: CustOfferlist?) {
        offerImageView.play()
        offerImageView.loopMode = .loop
        roundView.backgroundColor = .clear
        headingTitle.textColor = .black
        headingTitle.text = offerItem?.title
        headingTitle.numberOfLines = 0

        subHeadingTitle.text = ""//offerItem?.title
        subHeadingTitle.numberOfLines = 0

//        if offerItem?.discType == "%" {
//            headingTitle.text = "Flat \(offerItem?.disc ?? "0.0")\(offerItem?.discType ?? "") OFF"
//
//        }
//        if offerItem?.discType == "$" {
//            headingTitle.text = "Flat \(offerItem?.discType ?? "0.0")\(offerItem?.disc ?? "") OFF"
//
//        }
//        else {
//           // headingTitle.text = "Flat \(offerItem?.type ?? "")\(offerItem?.amount ?? 0.0) OFF"
//        }
        //subHeadingTitle.text = "Minimim purchase of \(UtilsClass.getCurrencySymbol())\(offerItem?.purchase ?? "") "
    }
}
