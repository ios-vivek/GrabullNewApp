//
//  SearchDetailVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 29/01/25.
//

import UIKit

class SearchDetailVC: UIViewController {
    var listResponse = [Restaurant]()
    var cuisine = ""
    var isDineFilter = false
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var homeCollection: UICollectionView!


var gotResponseFromService = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLbl.text = isDineFilter ? "Dine In Restaurants" : "Restaurants"
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
            "cuisine_type" : cuisine,
            "address" : "\(UtilsClass.getFullAddress())"

        ]) { _, new in new }
            UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.resturantList, forModelType: RestaurantListResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            self.gotResponseFromService = true
            print(success.data.data)
//            if success.data.restaurant.count > 0 {
//                self.listResponse = success.data.restaurant
//                self.dineFilter()
//            }
        } ErrorHandler: { error in
            self.gotResponseFromService = true
            UtilsClass.hideProgressHud(view: self.view)
            self.homeCollection.reloadData()

        }
        
    }
    func dineFilter() {
        /*
        if isDineFilter {
            let filtered = self.listResponse.filter { $0.ordertypes.contains("Reservation") }
           // print(filtered.count)
           // print(self.listResponse.count)
            self.listResponse = filtered
           // print(self.listResponse.count)
        }
         */
        self.homeCollection.reloadData()

    }
    func getRestDetailFromApi(restid: String, dbname: String) {
        Cart.shared.dbname = dbname
       
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "rest_id": restid
        ]) { _, new in new }
        
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.restaurantDetail, forModelType: RestDetailsApiResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            let story = UIStoryboard.init(name: "OrderFlow", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "RestDetailsVC") as! RestDetailsVC
           // vc.restDetailsData = success.data.restaurant
            self.navigationController?.pushViewController(vc, animated: true)
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
    }

}

extension SearchDetailVC: RestCellDelegate {
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
extension SearchDetailVC: SelectOptionDelegate {
    func selectedOption(restIndex: Int, index: Int) {
        
    }
}

extension SearchDetailVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
}
extension SearchDetailVC: UICollectionViewDelegate,UICollectionViewDataSource{
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
            if isDineFilter {
//                            let vc = self.viewController(viewController: DineInReservationVC.self, storyName: StoryName.DineIn.rawValue) as! DineInReservationVC
//                            self.navigationController?.pushViewController(vc, animated: true)
                let story = UIStoryboard.init(name: "OrderFlow", bundle: nil)
                let popupVC = story.instantiateViewController(withIdentifier: "DineInVC") as! DineInVC
                popupVC.restaurantID = listResponse[indexPath.row].rid
                popupVC.comeFromDashBoard = true
                self.navigationController?.pushViewController(popupVC, animated: true)
            } else {
                let rest = self.listResponse[indexPath.row]
                self.getRestDetailFromApi(restid: rest.rid, dbname: rest.dbname)
            }
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
    
