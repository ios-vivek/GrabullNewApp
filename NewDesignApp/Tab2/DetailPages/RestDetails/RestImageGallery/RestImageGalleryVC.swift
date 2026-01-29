//
//  RestImageGalleryVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 26/08/24.
//

import UIKit

class RestImageGalleryVC: UIViewController {
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var galleryCollection: UICollectionView!
    var galleryImages: Gallery?
    override func viewDidLoad() {
        super.viewDidLoad()
        navView.backgroundColor = themeBackgrounColor
       // galleryCollection.register(UINib(nibName: "HeaderCollectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionView") //elementKindSectionFooter for footerview
        galleryCollection.backgroundColor = .gGray100
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

}
extension RestImageGalleryVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        galleryImages?.list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCVCell", for: indexPath as IndexPath) as! GalleryCVCell
        cell.backgroundColor = .clear
        cell.updateUI(url: galleryImages?.list[indexPath.row].url ?? "")
        return cell;

    }
    
    
}
extension RestImageGalleryVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 200)
       // return CGSize(width: 20, height: 20)


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
