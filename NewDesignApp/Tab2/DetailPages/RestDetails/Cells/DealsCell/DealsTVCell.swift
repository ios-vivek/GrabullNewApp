//
//  DealsTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 10/08/24.
//

import UIKit

class DealsTVCell: UITableViewCell {
    @IBOutlet weak var dealsCollection: UICollectionView!
    @IBOutlet weak var countTitle: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var roundView: UIView!
    var w:CGFloat=0.0
var offer = [CustOfferlist]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .white
       // headingTitle.text = "header title"//"topRatedTitle".localizeString(string: GlobalClass.shared.getLangauge())
      //  dealsCollection.register(UINib(nibName: "HeaderCollectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionView") //elementKindSectionFooter for footerview
        dealsCollection.backgroundColor = .white
      //  dealsCollection.register(DealCVCell.self, forCellWithReuseIdentifier: "DealCVCell"); //register custom UICollectionViewCell class.
        roundView.layer.masksToBounds = true
        roundView.layer.borderWidth = 1
        roundView.layer.cornerRadius = 20
        roundView.layer.borderColor = UIColor.lightGray.cgColor
        dealsCollection.backgroundColor = .clear
        
        self.pageControl.currentPageIndicatorTintColor = themeBackgrounColor
        self.pageControl.pageIndicatorTintColor = kGrayColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(offer: [CustOfferlist]) {
        self.offer = offer
        countTitle.textColor = kOrangeColor
        countTitle.text = "1/\(self.offer.count)"
        self.pageControl.currentPage = 0
        self.pageControl.numberOfPages = self.offer.count
        dealsCollection.reloadData()
        configAutoscrollTimer()
    }
       
    
    
    func configAutoscrollTimer()
        {
            APPDELEGATE.timr.invalidate()
            if !APPDELEGATE.timr.isValid && self.offer.count > 1 {
                APPDELEGATE.timr=Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
            }
        }
       
    @objc func onTimer()
        {
            autoScrollView()
        }

        func autoScrollView()
        {
            print("timer is on")
            if self.pageControl.currentPage < self.offer.count - 1 {
                self.moveCell(index: self.pageControl.currentPage + 1)
            } else {
                self.moveCell(index: 0)
            }
        }
    func moveCell(index: Int) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations:
                        {
            self.dealsCollection.scrollToItem(at: IndexPath(row: index,section:0), at: .centeredHorizontally, animated: false)
        }, completion: nil)
    }

}
extension DealsTVCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
 
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        
//        switch kind {
//            
//        case UICollectionView.elementKindSectionHeader:
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCollectionView", for: indexPath)
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
extension DealsTVCell: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.offer.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DealsAndServiesCV", for: indexPath as IndexPath) as! DealsAndServiesCV
        cell.backgroundColor = .clear
        cell.headingTitle.text = "Get $0 delivery fees with DashPass"
//        cell.roundView.layer.cornerRadius = 10
//        cell.roundView.layer.borderColor = UIColor.lightGray.cgColor
//        cell.roundView.layer.borderWidth = 1
        cell.updateUI(offerItem: self.offer[indexPath.row])
        return cell;

    }
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//       // print("index: -- \(indexPath.row)")
//        self.countTitle.text = "\(indexPath.row+1)/\(self.offer.count)"
//        self.pageControl.currentPage = indexPath.row
//    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        print("index: -- \(indexPath.row)")
//        self.countTitle.text = "\(indexPath.row+1)/\(self.offer.count)"
//        self.pageControl.currentPage = indexPath.row
//    }
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let pageWidth = scrollView.frame.width
           let currentPage = Int((scrollView.contentOffset.x + (0.5 * pageWidth)) / pageWidth)
        self.countTitle.text = "\(currentPage + 1)/\(self.offer.count)"
        self.pageControl.currentPage = currentPage
       }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       // deconfigAutoscrollTimer()
    }
}


