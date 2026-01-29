//
//  DealsTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 10/08/24.
//

import UIKit
protocol OpenItemDetailDelegate: AnyObject {
    func selectedItem(index: IndexPath)
    func addItemInList(index: IndexPath)
}
class MoreItemTVCell: UITableViewCell, MoreItemCVCellDelegate {
    func didTapAddButton(indexPath: IndexPath) {
        self.delegate?.addItemInList(index: indexPath)
    }
    
    @IBOutlet weak var itemCollection: UICollectionView!
    @IBOutlet weak var titleLbl: UILabel!
    var suggestedItemList = [CustMenuCategory]()
    weak var delegate: OpenItemDetailDelegate?

var offer = [RestOffer]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .white
       // headingTitle.text = "header title"//"topRatedTitle".localizeString(string: GlobalClass.shared.getLangauge())
      //  dealsCollection.register(UINib(nibName: "HeaderCollectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionView") //elementKindSectionFooter for footerview
        itemCollection.backgroundColor = .white
      //  dealsCollection.register(DealCVCell.self, forCellWithReuseIdentifier: "DealCVCell"); //register custom UICollectionViewCell class.
        titleLbl.text = "COMPLETE YOUR MEAL"
        itemCollection.backgroundColor = .clear
        titleLbl.textColor = .lightGray

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(offer: [RestOffer]) {
        self.offer = offer
        titleLbl.textColor = .lightGray
        itemCollection.reloadData()
    }

}
extension MoreItemTVCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 85, height: 165)
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
extension MoreItemTVCell: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggestedItemList[section].itemList.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return suggestedItemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreItemCVCell", for: indexPath as IndexPath) as! MoreItemCVCell
        cell.backgroundColor = .clear
        let item = suggestedItemList[indexPath.section].itemList[indexPath.row]
        cell.headingTitle.text = "     \(item.heading)"
       // cell.subHeadingTitle.text = "\(UtilsClass.getCurrencySymbol())\(item.getMinimumPrice[0])"
        cell.delegate = self
        cell.indexPath = indexPath
        cell.updateUI()
        return cell;

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.selectedItem(index: indexPath)
    }
 
    
    
}


