//
//  SearchDetailVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 29/01/25.
//

import UIKit
import SafariServices

class GroceryVC: UIViewController {
    var viewModel = GroceryViewModel()
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cartLabel: UILabel!
    @IBOutlet weak var cartView: UIView!

    @IBOutlet weak var homeCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cartLabel.textColor = kOrangeColor
        titleLbl.text = "Groceries"
        self.view.backgroundColor = .white
        homeCollection.backgroundColor = .white
        homeCollection.register(UINib(nibName: "HeaderCollectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionView") //elementKindSectionFooter for footerview
        let cartTap = UITapGestureRecognizer(target: self, action: #selector(cartTapAction))
        cartView.addGestureRecognizer(cartTap)
        setupBindings()
    }
    @objc func cartTapAction() {
        // handling code
        let vc = self.viewController(viewController: GroceryCartVC.self, storyName: StoryName.Grocery.rawValue) as! GroceryCartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.storeList.count == 0 {
            UtilsClass.showProgressHud(view: self.view)
            viewModel.getStorelistFromApi()
        }
        cartLabel.text = "\(GroceryCartData.shared.cartItems.count)"

    }
    private func setupBindings() {
        viewModel.onUpdate = { [weak self] in
            guard let self = self else { return }
            UtilsClass.hideProgressHud(view: self.view)
            self.homeCollection.reloadData()
        }
        viewModel.onError = { [weak self] _ in
            guard let self = self else { return }
            UtilsClass.hideProgressHud(view: self.view)
        }
    }

    func getRestDetailFromApi(restid: String, dbname: String, storeImage: String) {
        GroceryCartData.shared.dbname = dbname
        UtilsClass.showProgressHud(view: self.view)
        viewModel.getRestDetailFromApi(restid: restid, dbname: dbname) { [weak self] response in
            guard let self = self else { return }
            UtilsClass.hideProgressHud(view: self.view)
            guard let successData = response else { return }
            let story = UIStoryboard.init(name: "Grocery", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "GroceryDetailsPageVC") as! GroceryDetailsPageVC
            vc.storeDetails = successData.data
            vc.imageUrl = storeImage
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension GroceryVC: RestCellDelegate {
    func clickedFavAction(index: Int) {
        
    }
    
    func openOptionView(sender: UITapGestureRecognizer, index: Int) {
        let point = sender.location(in: self.view)
        let popupVC = self.viewController(viewController: RestaurantPoupVC.self, storyName: StoryName.Main.rawValue) as! RestaurantPoupVC

        popupVC.pointY = Float(point.y)
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        self.present(popupVC, animated: true)
    }
}
extension GroceryVC: SelectOptionDelegate {
    func selectedOption(restIndex: Int, index: Int) {
        
    }
}

extension GroceryVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
}
extension GroceryVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.storeList.count == 0 &&  self.viewModel.gotResponseFromService {
            return 1
        }
        return viewModel.storeList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if viewModel.storeList.count > 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreCVCell", for: indexPath as IndexPath) as! StoreCVCell
                    cell.updateStoreUI(index: indexPath.row, store: viewModel.storeList[indexPath.row])
                cell.backgroundColor = .white
                return cell;
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoRestFoundCVCell", for: indexPath as IndexPath) as! NoRestFoundCVCell
                return cell
            }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.storeList.count > 0 {
            let store = self.viewModel.storeList[indexPath.row]
            self.getRestDetailFromApi(restid: store.rid, dbname: store.dbname, storeImage: store.fullImageURL)
        } else {
                let vc = self.viewController(viewController: LocationVC.self, storyName: StoryName.Location.rawValue) as! LocationVC
            vc.fromSearch = true
                self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
      
            if viewModel.storeList.count > 0 {
                return CGSize(width: width/2 , height: 240)
            } else {
                return CGSize(width: width , height: 300)
            }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
    
