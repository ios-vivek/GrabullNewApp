//
//  FoodMenuTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 10/08/24.
//

import UIKit
import Lottie
protocol MenuSelectedDelegate {
    func openmenuItemSection(section: Int)
    func showAllData()
}
class FoodMenuTVCell: UITableViewCell {
    var delegate: MenuSelectedDelegate?

    @IBOutlet weak var featuredCollection: UICollectionView!
    @IBOutlet weak var menuImageView: LottieAnimationView!
    @IBOutlet weak var allBtn: UIButton!


    var menulist: [CustMenuCategory]?
    var cateringMenuList = [CustMenuCategory]()
    var selectedmenuType = MenuType.menu
    var selectedFiler = -1
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        menuImageView.play()
        menuImageView.loopMode = .loop
        self.backgroundColor = .white
       // headingTitle.text = "header title"//"topRatedTitle".localizeString(string: GlobalClass.shared.getLangauge())
        featuredCollection.backgroundColor = .white
      //  dealsCollection.register(UINib(nibName: "HeaderCollectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionView") //elementKindSectionFooter for footerview
        featuredCollection.backgroundColor = .white
    }
    @IBAction func allBtnAction() {
        self.delegate?.showAllData()
    }
    func updateUI(menulist: [CustMenuCategory]?, selectedmenuType: MenuType, selectedFiler : Int) {
        self.selectedFiler = selectedFiler
        self.menulist = menulist
        self.selectedmenuType = selectedmenuType
        featuredCollection.reloadData()
        if selectedFiler >= 0 {
            self.featuredCollection.scrollToItem(at:IndexPath(item: selectedFiler, section: 0), at: .right, animated: false)
        }
    }
    func updateCategoryUI(restItemList: [CustMenuCategory], selectedmenuType: MenuType, selectedFiler : Int) {
        self.selectedFiler = selectedFiler
        cateringMenuList = restItemList
        self.selectedmenuType = selectedmenuType
        featuredCollection.reloadData()
        if selectedFiler >= 0 {
            self.featuredCollection.scrollToItem(at:IndexPath(item: selectedFiler, section: 0), at: .right, animated: false)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension FoodMenuTVCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: collectionView.frame.height)
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
extension FoodMenuTVCell: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedmenuType == .catering {
           return self.cateringMenuList.count
        }
        return self.menulist?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodMenuCVCell", for: indexPath as IndexPath) as! FoodMenuCVCell
        cell.backgroundColor = .white
        if selectedmenuType == .catering {
            cell.menu.text = self.cateringMenuList[indexPath.row].heading
        }else{
            cell.menu.text = self.menulist?[indexPath.row].heading ?? ""
        }
        cell.menu.textColor = selectedFiler == indexPath.row ? kOrangeColor : .black
        return cell;

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.openmenuItemSection(section: indexPath.row)
       
    }
    
    
    
}


