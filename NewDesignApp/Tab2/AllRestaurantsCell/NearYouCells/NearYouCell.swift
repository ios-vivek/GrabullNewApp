//
//  NearYouCell.swift
//  GTB DUBAI
//
//  Created by Omnie Solutions on 02/02/23.
//

import UIKit
//protocol RestSelectedFromHorizontallistDelegate: AnyObject {
//    func selectedIndex(restID: String)
//    func favSelectedIndex(restID: String, url: String)
//}
class NearYouCell: UITableViewCell {
    @IBOutlet weak var nearCollection: UICollectionView!
    @IBOutlet weak var headingTitle: UILabel!
var allRestaurant = [Restaurant]()
   // weak var delegate: RestSelectedFromHorizontallistDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .white
        headingTitle.text = "header title"//"topRatedTitle".localizeString(string: GlobalClass.shared.getLangauge())
        nearCollection.backgroundColor = .white
        nearCollection.register(UINib(nibName: "HeaderCollectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionView") //elementKindSectionFooter for footerview
        nearCollection.backgroundColor = .white

    }
    func configDeliciousDeals(restaurants: [Restaurant]) {
        headingTitle.text = "Delicious Deals"
        allRestaurant = restaurants
        nearCollection.reloadData()

    }
    func configTopPicks(restaurants: [Restaurant]) {
        headingTitle.text = "Top Picks"
        allRestaurant = restaurants
        nearCollection.reloadData()

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func favImage(_ sender: UITapGestureRecognizer? = nil) {
        let rest = self.allRestaurant[sender?.view?.tag ?? 0]
        var favStr = OldServiceType.addFavorite
        if rest.favorite == "Yes" {
            favStr = OldServiceType.removeFavorite
        }
       // self.delegate?.favSelectedIndex(restID: rest.id, url: favStr)
    }


}
extension NearYouCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 20, height: collectionView.frame.height)
    }
}
extension NearYouCell: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allRestaurant.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearYouCollectionViewCell", for: indexPath as IndexPath) as! NearYouCollectionViewCell
        cell.backgroundColor = .white
        cell.configUI(restaurant: allRestaurant[indexPath.row])
        cell.favImage.tag = indexPath.row
        let favImageTab = UITapGestureRecognizer(target: self, action: #selector(self.favImage(_:)))
        cell.favImage.addGestureRecognizer(favImageTab)

        return cell;

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // self.delegate?.selectedIndex(restID: allRestaurant[indexPath.row].id)
    }
    
    
    
}

