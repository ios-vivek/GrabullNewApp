//
//  NearYouCollectionViewCell.swift
//  GTB DUBAI
//
//  Created by Omnie Solutions on 02/02/23.
//

import UIKit
import Alamofire
//import SkeletonView
protocol RestSelectedFromHorizontallistDelegate: AnyObject {
    func selectedIndex(restdata: RestData)
    func favSelectedIndex(restID: String, url: String)
}
class DeliciousDealsCVCell: UICollectionViewCell {
    @IBOutlet weak var nearCollection: UICollectionView!
    @IBOutlet weak var headingTitle: UILabel!
var allRestaurant = [Restaurant]()
    weak var delegate: RestSelectedFromHorizontallistDelegate?



    override func awakeFromNib() {
        self.backgroundColor = .white
        headingTitle.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        headingTitle.text = "header title"//"topRatedTitle".localizeString(string: GlobalClass.shared.getLangauge())
        nearCollection.backgroundColor = .white
        nearCollection.register(UINib(nibName: "HeaderCollectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionView") //elementKindSectionFooter for footerview
        nearCollection.backgroundColor = .white
       
    }
    func configDeliciousDeals(restaurants: [Restaurant]) {
        headingTitle.text = "Delicious Deals"
        allRestaurant = restaurants
        headingTitle.textColor = .black

        nearCollection.reloadData()

    }
    func configTopPicks(restaurants: [Restaurant]) {
        headingTitle.text = "Top Picks"
        headingTitle.textColor = .black

        allRestaurant = restaurants
        nearCollection.reloadData()

    }
    func configInspiredFromPast(restaurants: [Restaurant]) {
        headingTitle.text = "Inspired From Past"
        headingTitle.textColor = themeBackgrounColor

        allRestaurant = restaurants
        nearCollection.reloadData()
        self.backgroundColor = .gOrange100
        nearCollection.backgroundColor = .gOrange100

    }
    @objc func favImage(_ sender: UITapGestureRecognizer? = nil) {
        let rest = self.allRestaurant[sender?.view?.tag ?? 0]
        var favStr = OldServiceType.addFavorite
        if rest.favorite == "Yes" {
            favStr = OldServiceType.removeFavorite
        }
        self.delegate?.favSelectedIndex(restID: rest.rid, url: favStr)
    }
  
}
extension DeliciousDealsCVCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 20, height: collectionView.frame.height)
    }
}
extension DeliciousDealsCVCell: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allRestaurant.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearYouCollectionViewCell", for: indexPath as IndexPath) as! NearYouCollectionViewCell
        cell.backgroundColor = .clear
        cell.configUIForDeals(restaurant: allRestaurant[indexPath.row])
        cell.favImage.tag = indexPath.row
        let favImageTab = UITapGestureRecognizer(target: self, action: #selector(self.favImage(_:)))
        cell.favImage.addGestureRecognizer(favImageTab)

        return cell;

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let rest = allRestaurant[indexPath.row]
        self.delegate?.selectedIndex(restdata: RestData(dbname: rest.dbname, restID: rest.rid, restImgUrl: rest.restBannerImage))
    }
    
    
    
}

