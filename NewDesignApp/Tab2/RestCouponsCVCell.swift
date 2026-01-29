//
//  NearYouCollectionViewCell.swift
//  GTB DUBAI
//
//  Created by Omnie Solutions on 02/02/23.
//

import UIKit
import Alamofire
//import SkeletonView
protocol CousineDelegate: AnyObject {
    func selectedCuisine(selsectedindex: Int)
}
class RestCouponsCVCell: UICollectionViewCell {
    @IBOutlet weak var onMindCollection: UICollectionView!
    @IBOutlet weak var headingTitle: UILabel!
    var cousines: [Cousine] = []
    var cuisines: [Cuisine] = []
    var selectedCuisines = -1
    weak var delegate: CousineDelegate?


    override func awakeFromNib() {
        onMindCollection.register(UINib(nibName: "HeaderCollectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionView") //elementKindSectionFooter for footerview
        headingTitle.text = "".uppercased()
        onMindCollection.backgroundColor = .white
      //  self.contentView.backgroundColor = .white
       
    }
    func updateUIOld(cuisine: [Cuisine], heading: String) {
        if cuisine.count > 0 {
            cuisines = cuisine
            let text = heading
            headingTitle.text = text.uppercased()
            onMindCollection.reloadData()
        }
    }
   
  
}
extension RestCouponsCVCell: UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if cuisines.count > 0 {
         return 1
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cuisines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CounsinesCVCell", for: indexPath as IndexPath) as! CounsinesCVCell
       
        cell.updateUIOld(cousine: cuisines[indexPath.row])
        cell.foodTypeLbl.textColor = .black
       // cell.foodTypeLbl.transform = .identity
      // cell.foodImage.transform = .identity
        if self.selectedCuisines == indexPath.row {
            cell.foodTypeLbl.textColor = kOrangeColor
            UIView.animate(withDuration: 0.1) {
                cell.foodTypeLbl.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
            }
//            UIView.animate(withDuration: 0.1) {
//                cell.foodImage.transform = CGAffineTransform(scaleX: 1.09, y: 1.09)
//            }
        }
        cell.backgroundColor = .white
        return cell;

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         if self.selectedCuisines == indexPath.row {
             selectedCuisines = -1
         } else {
             selectedCuisines = indexPath.row
         }
             onMindCollection.reloadData()
         self.delegate?.selectedCuisine(selsectedindex: self.selectedCuisines)
        
    }
    
}
extension RestCouponsCVCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: collectionView.frame.height/2-10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        switch kind {
//
//        case UICollectionView.elementKindSectionHeader:
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCollectionView", for: indexPath)
//            headerView.backgroundColor = .white
//            return headerView
//
//
//
//
//        default:
//            assert(false, "Unexpected element kind")
//        }
//    }
}

