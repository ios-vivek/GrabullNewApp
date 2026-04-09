//
//  SearchDetailVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 29/01/25.
//

import UIKit
import SafariServices

class GroceryVC: UIViewController {
    var listResponse = [Restaurant]()
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var homeCollection: UICollectionView!


var gotResponseFromService = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLbl.text = "Groceries"
        self.view.backgroundColor = .white
        homeCollection.backgroundColor = .white
        homeCollection.register(UINib(nibName: "HeaderCollectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionView") //elementKindSectionFooter for footerview
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if listResponse.count == 0 {
            getRestDataFromApi()
        }
    }
    func getRestDataFromApi() {
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "cust_lat": "\(APPDELEGATE.selectedLocationAddress.latLong.latitude)",
            "cust_long": "\(APPDELEGATE.selectedLocationAddress.latLong.longitude)",
            "cuisine_type" : "",
            "address" : "\(UtilsClass.getFullAddress())"

        ]) { _, new in new }
            UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.resturantList, forModelType: RestaurantListResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            self.gotResponseFromService = true
            //print(success.data.data)
            if success.data.data.restaurants.count > 0 {
                self.listResponse = success.data.data.restaurants
            }
            self.homeCollection.reloadData()
        } ErrorHandler: { error in
            self.gotResponseFromService = true
            UtilsClass.hideProgressHud(view: self.view)
            self.homeCollection.reloadData()

        }
        
    }

    func getRestDetailFromApi(restid: String, dbname: String) {
        GroceryCartData.shared.dbname = dbname
       
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "rest_id": restid,
            "dbname" : dbname
        ]) { _, new in new }
        
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.restaurantDetail, forModelType: RestDetailsApiResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            let story = UIStoryboard.init(name: "Grocery", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "GroceryDetailsPageVC") as! GroceryDetailsPageVC
            let customModel = success.data.toCustomModel()
            vc.restDetailsData = customModel
            vc.restDetailsRes = success.data.data
            self.navigationController?.pushViewController(vc, animated: true)
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
    }
    private func loadURLSafari(dineUrl: String) {
        let trimmedURL = dineUrl.trimmingCharacters(in: .whitespacesAndNewlines)
        print("url: \(trimmedURL)")

        guard let url = URL(string: trimmedURL),
              ["http", "https"].contains(url.scheme?.lowercased() ?? "") else {
            showAlert(title: "Url not found", msg: "Please try later.")
            return
        }

        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .fullScreen
        present(safariVC, animated: true)
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
        if listResponse.count == 0 &&  self.gotResponseFromService {
            return 1
        }
        return listResponse.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if listResponse.count > 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRestCVCell", for: indexPath as IndexPath) as! HomeRestCVCell
                    cell.updateUIWithOld(index: indexPath.row, restaurant: listResponse[indexPath.row])
                cell.backgroundColor = .white
                return cell;
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoRestFoundCVCell", for: indexPath as IndexPath) as! NoRestFoundCVCell
                return cell
            }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if listResponse.count > 0 {
                let rest = self.listResponse[indexPath.row]
                self.getRestDetailFromApi(restid: rest.rid, dbname: rest.dbname)
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
      
            if listResponse.count > 0 {
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
    
