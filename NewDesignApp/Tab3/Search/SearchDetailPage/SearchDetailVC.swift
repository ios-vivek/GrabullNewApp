//
//  SearchDetailVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 29/01/25.
//

import UIKit
import SafariServices

class SearchDetailVC: UIViewController {
    var listResponse = [Restaurant]()
    var cuisine = ""
    var isDineFilter = false
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var homeCollection: UICollectionView!

    var gotResponseFromService = false
    private var isFetchingRestaurants = false

    private var lastLat: Double = APPDELEGATE.selectedLocationAddress.latLong.latitude
    private var lastLong: Double = APPDELEGATE.selectedLocationAddress.latLong.longitude
    private var lastAddress: String = UtilsClass.getFullAddress()

    override func viewDidLoad() {
        super.viewDidLoad()

        lastLat = APPDELEGATE.selectedLocationAddress.latLong.latitude
        lastLong = APPDELEGATE.selectedLocationAddress.latLong.longitude
        lastAddress = UtilsClass.getFullAddress()

        NotificationCenter.default.addObserver(self, selector: #selector(locationUpdatedNotification(_:)), name: Notification.Name("location"), object: nil)

        titleLbl.text = isDineFilter ? "Dine In Restaurants" : "Restaurants"
        self.view.backgroundColor = .white
        homeCollection.backgroundColor = .white
        homeCollection.register(UINib(nibName: "HeaderCollectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionView")
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("location"), object: nil)
    }

    @objc func locationUpdatedNotification(_ notification: Notification) {
        lastLat = APPDELEGATE.selectedLocationAddress.latLong.latitude
        lastLong = APPDELEGATE.selectedLocationAddress.latLong.longitude
        lastAddress = UtilsClass.getFullAddress()
        getRestDataFromApi(forceRefresh: true)
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let currentLat = APPDELEGATE.selectedLocationAddress.latLong.latitude
        let currentLong = APPDELEGATE.selectedLocationAddress.latLong.longitude
        let currentAddress = UtilsClass.getFullAddress()

        let locationChanged = (currentLat != lastLat || currentLong != lastLong || currentAddress != lastAddress)

        if locationChanged {
            lastLat = currentLat
            lastLong = currentLong
            lastAddress = currentAddress
            getRestDataFromApi(forceRefresh: true)
        } else if listResponse.count == 0 && !gotResponseFromService {
            getRestDataFromApi(forceRefresh: false)
        }
    }

    func getRestDataFromApi(forceRefresh: Bool = false) {
        guard !isFetchingRestaurants else { return }
        isFetchingRestaurants = true

        self.gotResponseFromService = false
        self.listResponse = []
        self.homeCollection.reloadData()

        var parameters = CommonAPIParams.base()
        parameters.merge([
            "cust_lat": "\(APPDELEGATE.selectedLocationAddress.latLong.latitude)",
            "cust_long": "\(APPDELEGATE.selectedLocationAddress.latLong.longitude)",
            "cuisine_type" : cuisine,
            "address" : "\(UtilsClass.getFullAddress())"
        ]) { _, new in new }

        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.resturantList, forModelType: RestaurantListResponse.self) { [weak self] success in
            guard let self = self else { return }
            self.isFetchingRestaurants = false
            UtilsClass.hideProgressHud(view: self.view)
            self.gotResponseFromService = true
            self.listResponse = success.data.data.restaurants
            self.dineFilter()
            self.homeCollection.reloadData()
        } ErrorHandler: { [weak self] error in
            guard let self = self else { return }
            self.isFetchingRestaurants = false
            self.gotResponseFromService = true
            UtilsClass.hideProgressHud(view: self.view)
            self.listResponse = []
            self.homeCollection.reloadData()
        }
    }

    func dineFilter() {
        if isDineFilter {
            let filtered = self.listResponse.filter { $0.dinein.contains("Yes") }
            self.listResponse = filtered
        }
        self.homeCollection.reloadData()
    }

    func getRestDetailFromApi(restid: String, dbname: String, bannerImage: String = "") {
        Cart.shared.dbname = dbname
       
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "rest_id": restid
        ]) { _, new in new }
        
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.restaurantDetail, forModelType: RestDetailsApiResponse.self) { [weak self] success in
            guard let self = self else { return }
            UtilsClass.hideProgressHud(view: self.view)
            let story = UIStoryboard.init(name: "OrderFlow", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "RestDetailsVC") as! RestDetailsVC
            let customModel = success.data.toCustomModel()
            vc.restDetailsData = customModel
            vc.restDetailsRes = success.data.data
            let finalImage = bannerImage.isEmpty ? ((success.data.data.imgurl) + (success.data.data.img ?? "")) : bannerImage
            vc.restData = RestData(dbname: dbname, restID: restid, restImgUrl: finalImage)
            self.navigationController?.pushViewController(vc, animated: true)
            
        } ErrorHandler: { [weak self] error in
            guard let self = self else { return }
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

extension SearchDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if listResponse.count == 0 && self.gotResponseFromService {
            return 1
        }
        return listResponse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if listResponse.count > 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRestCVCell", for: indexPath as IndexPath) as! HomeRestCVCell
            cell.updateUIWithOld(index: indexPath.row, restaurant: listResponse[indexPath.row])
            cell.backgroundColor = .white
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoRestFoundCVCell", for: indexPath as IndexPath) as! NoRestFoundCVCell
            cell.isHidden = !self.gotResponseFromService
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if listResponse.count > 0 {
            if isDineFilter {
                loadURLSafari(dineUrl: "\(listResponse[indexPath.row].dineUrl ?? "")/\(APPDELEGATE.userResponse?.customer.customerId ?? "")")
            } else {
                let rest = self.listResponse[indexPath.row]
                self.getRestDetailFromApi(restid: rest.rid, dbname: rest.dbname, bannerImage: rest.restBannerImage)
            }
        } else if gotResponseFromService {
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
        } else if gotResponseFromService {
            return CGSize(width: width , height: 300)
        } else {
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
