//
//  BannerTableViewCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 04/11/24.
//

import UIKit

class BannerTableViewCell: UITableViewCell {
    @IBOutlet weak var bannerCV: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!

    var sliders: [RestSlider] = []
    var coupons: [Coupon] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bannerCV.isPagingEnabled = true
        pageControl.numberOfPages = 0

    }
    func updateUI(slider: [RestSlider], coupons: [Coupon]) {
        pageControl.numberOfPages = slider.count + coupons.count
        sliders = slider
        self.coupons = coupons
        bannerCV.reloadData()
        configAutoscrollTimer()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configAutoscrollTimer()
        {
            if !APPDELEGATE.timr.isValid && pageControl.numberOfPages > 1 {
                APPDELEGATE.timr=Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
            }
        }
       
    @objc func onTimer()
        {
            autoScrollView()
        }

        func autoScrollView()
        {
           // print("timer is on")
            if self.pageControl.currentPage < pageControl.numberOfPages - 1 {
                self.moveCell(index: self.pageControl.currentPage + 1)
            } else {
                self.moveCell(index: 0)
            }
        }
    func moveCell(index: Int) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations:
                        {
            self.bannerCV.scrollToItem(at: IndexPath(row: index,section:0), at: .centeredHorizontally, animated: false)
        }, completion: nil)
    }

}
extension BannerTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.coupons.count + sliders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.coupons.count > 0 && indexPath.row < self.coupons.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponCVCell", for: indexPath as IndexPath) as! CouponCVCell
            cell.backgroundColor = .clear
            pageControl.currentPage = indexPath.row
            cell.updateUI(coupon: self.coupons[indexPath.row])
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath as IndexPath) as! BannerCollectionViewCell
        cell.backgroundColor = .clear
        cell.bannerImage.backgroundColor = .clear
        pageControl.currentPage = indexPath.row
        if UIScreen.main.bounds.size.width >= 430 {
            cell.bannerHeight.constant = 150
            cell.bannerWidth.constant = 394

        } else {
            cell.bannerHeight.constant = 150
            cell.bannerWidth.constant = 354.0
        }
        cell.updateUI(imageUrl: sliders[indexPath.row - self.coupons.count].url)

        return cell;

    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    }
    func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAt indexPath: IndexPath) -> CGSize {
                let kWhateverHeightYouWant = collectionView.bounds.size.height //100
                return CGSize(width: collectionView.bounds.size.width, height: CGFloat(kWhateverHeightYouWant))
    }
    func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0.0
    }
    
}
