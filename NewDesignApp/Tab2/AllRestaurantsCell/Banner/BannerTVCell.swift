//
//  BannerTVCell.swift
//  GTB DUBAI
//
//  Created by Vivek SIngh on 09/07/24.
//

import UIKit

class BannerTVCell: UITableViewCell {
    @IBOutlet weak var bannerCollection: UICollectionView!
static let identifire = "BannerTVCell"
    @IBOutlet weak var pageControl: UIPageControl!
   // let numberOfBanner = 6
    var sliders: [Slider] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .white
        bannerCollection.backgroundColor = .white
       // offerCollection.isSkeletonable = true
       // offerCollection.showAnimatedGradientSkeleton()
        let indexPath = IndexPath(item: 0, section: 0)
        let scrollPosition: UICollectionView.ScrollPosition = orientation.isPortrait ? .centeredHorizontally : .centeredVertically
       // self.bannerCollection.scrollToItem(at: indexPath, at: scrollPosition, animated: false)
        pageControl.numberOfPages = 0

    }

    fileprivate var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(slider: [Slider]) {
        pageControl.numberOfPages = slider.count
        sliders = slider
        bannerCollection.reloadData()
    }

}
extension BannerTVCell: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCVCell.identifire, for: indexPath as IndexPath) as! BannerCVCell
        //cell.backgroundColor = .red
        pageControl.currentPage = indexPath.row
        cell.updateUI(imageUrl: sliders[indexPath.row].url)

        return cell;

    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    }
    
    
}

