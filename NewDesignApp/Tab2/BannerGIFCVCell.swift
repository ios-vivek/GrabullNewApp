//
//  NearYouCollectionViewCell.swift
//  GTB DUBAI
//
//  Created by Omnie Solutions on 02/02/23.
//

import UIKit
import Alamofire
//import SkeletonView
class BannerGIFCVCell: UICollectionViewCell {
    
    @IBOutlet weak var gifImage: UIImageView!
    @IBOutlet weak var view1: UIView!
    private let imageLoader = UIActivityIndicatorView(style: .large)



    override func awakeFromNib() {
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
        
        setupImageLoader()
       
    }
    func hideSkeletonCell(){
//        [foodImage,restName,deliveryTimeLbl,foodTypeImage].forEach{
//            $0?.hideSkeleton()
//        }
    }
   
    func updateUI(imageurl: String) {
       // gifImage.image = UIImage.init(named: "restaurant")
        gifImage.contentMode = .scaleToFill
        gifImage.layer.cornerRadius = 10
        let fallbackURL = "https://www.grabull.com/web-api/images/banner-img.jpg"
        loadImage(from: imageurl, fallback: fallbackURL)
        
        view1.backgroundColor = themeBackgrounColor
        view1.layer.cornerRadius = 10
        view1.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.backgroundColor = .white
    }
    
    func loadImage(from url: String, fallback: String? = nil) {

        imageLoader.startAnimating()   // 🔄 SHOW LOADER

        AF.request(url).responseData { [weak self] response in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch response.result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        self.gifImage.image = image
                        self.imageLoader.stopAnimating() // ✅ HIDE LOADER
                    } else if let fallback = fallback {
                        self.loadImage(from: fallback)
                    } else {
                        self.imageLoader.stopAnimating()
                    }

                case .failure:
                    if let fallback = fallback {
                        self.loadImage(from: fallback)
                    } else {
                        self.imageLoader.stopAnimating()
                    }
                }
            }
        }
    }
    
    func setupImageLoader() {
        imageLoader.center = gifImage.center
        imageLoader.hidesWhenStopped = true
        imageLoader.color = .gray
        self.contentView.addSubview(imageLoader)
    }

  
}
