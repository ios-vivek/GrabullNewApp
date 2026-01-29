//
//  FoodOptionTVCell.swift
//  Grabul
//
//  Created by Vivek SIngh on 12/07/24.
//  Copyright © 2024 Omnie. All rights reserved.
//

import UIKit
protocol DashBoardSectionDelegate: AnyObject {
    func selectedSection(index: Int)
}
class FoodOptionTVCell: UITableViewCell {
    @IBOutlet weak var onMindCollection: UICollectionView!
    weak var delegate: DashBoardSectionDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        onMindCollection.register(UINib(nibName: "HeaderCollectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionView") //elementKindSectionFooter for footerview
        onMindCollection.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension FoodOptionTVCell: UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnYourMindCollectionViewCell", for: indexPath as IndexPath) as! OnYourMindCollectionViewCell
        cell.backgroundColor = .yellow
        cell.updateUI(index: indexPath.row)
        return cell;

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.selectedSection(index: indexPath.row)
    }
}

extension FoodOptionTVCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (UIScreen.main.bounds.size.width-40)/2-5
        return CGSize(width: size, height: size)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
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

