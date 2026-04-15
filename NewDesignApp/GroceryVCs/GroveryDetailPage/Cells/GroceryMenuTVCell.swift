//
//  FoodMenuTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 10/08/24.
//

import UIKit
import Lottie
protocol GroceryMenuSelectedDelegate {
    func openmenuItemSection(section: Int)
    func showAllData()
}
class GroceryMenuTVCell: UITableViewCell {
    var delegate: GroceryMenuSelectedDelegate?

    @IBOutlet weak var featuredCollection: UICollectionView!
    @IBOutlet weak var menuImageView: LottieAnimationView!
    @IBOutlet weak var allBtn: UIButton!


    var menulist = [GroceryMenuCategory]()
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
    func updateUI(menulist: [GroceryMenuCategory], selectedFiler : Int) {
        self.selectedFiler = selectedFiler
            self.menulist = menulist
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
extension GroceryMenuTVCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: collectionView.frame.height)
    }
}
extension GroceryMenuTVCell: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menulist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodMenuCVCell", for: indexPath as IndexPath) as! FoodMenuCVCell
        cell.backgroundColor = .white
            cell.menu.text = self.menulist[indexPath.row].heading
        cell.menu.textColor = selectedFiler == indexPath.row ? kOrangeColor : .black
        return cell;

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.openmenuItemSection(section: indexPath.row)
       
    }
    
    
    
}


