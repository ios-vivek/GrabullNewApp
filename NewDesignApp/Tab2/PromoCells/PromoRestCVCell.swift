//
//  NearYouCollectionViewCell.swift
//  GTB DUBAI
//
//  Created by Omnie Solutions on 02/02/23.
//

import UIKit
import Alamofire

protocol PromoCellDelegate: AnyObject {
    func didSelectPromoCell(promoRestaurant: Restaurant)
}

class PromoRestCVCell: UICollectionViewCell {
    
    @IBOutlet weak var bannerCV: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    weak var delegate: PromoCellDelegate?

   // var sliders: [RestSlider] = []
   // var coupons: [Coupon] = []

var promoRestaurants = [Restaurant]()
    override func awakeFromNib() {
        bannerCV.isPagingEnabled = true
        pageControl.numberOfPages = 0
        bannerCV.backgroundColor = .white
       
    }

    func configPromoCell(promoRestaurants: [Restaurant]) {
        self.promoRestaurants = promoRestaurants
        pageControl.numberOfPages = self.promoRestaurants.count >= 6 ? 6 : self.promoRestaurants.count
        bannerCV.reloadData()
        configAutoscrollTimer()
    }
    func configAutoscrollTimer()
        {
            if !APPDELEGATE.timr.isValid && pageControl.numberOfPages > 1 {
                APPDELEGATE.timr=Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
            }
        }
       
    @objc func onTimer()
        {
            autoScrollView()
        }
    var isActive: Bool = false   // Make it property
    func autoScrollView() {
            if self.pageControl.currentPage < pageControl.numberOfPages {
                
                // ✅ If at last page
                if self.pageControl.currentPage == pageControl.numberOfPages - 1 {
                    print("Reached last page \(self.pageControl.currentPage)")
                    
                    self.moveCell(index: 0) // back to first
                    self.pageControl.currentPage = 0
                    isActive = false
                } else {
                    // ✅ Scroll to next page
                    self.moveCell(index: self.pageControl.currentPage + 1)
                    self.pageControl.currentPage += 1
                    isActive = true
                }
            }
        }
    func moveCell(index: Int) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations:
                        {
            self.bannerCV.scrollToItem(at: IndexPath(row: index,section:0), at: .centeredHorizontally, animated: false)
        }, completion: nil)
    }
  
}
extension PromoRestCVCell: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.promoRestaurants.count >= 6 ? 6 : self.promoRestaurants.count//self.coupons.count + sliders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromoCVCell", for: indexPath as IndexPath) as! PromoCVCell
        cell.backgroundColor = .clear
        pageControl.currentPage = indexPath.row
        cell.configPromoCell(promoRestaurant: self.promoRestaurants[indexPath.row])
        return cell

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectPromoCell(promoRestaurant: self.promoRestaurants[indexPath.row])
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    }
    func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAt indexPath: IndexPath) -> CGSize {
                let kWhateverHeightYouWant = collectionView.bounds.size.height //100
        let width = collectionView.frame.width

                return CGSize(width: width, height: CGFloat(kWhateverHeightYouWant))
    }
    func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0.0
    }
    
}
