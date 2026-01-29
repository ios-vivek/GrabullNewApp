//
//  RestaurantVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 09/08/24.
//

import UIKit
enum RestaurantSection: Int, CaseIterable {
    case banner = 0
    case promoCell
    case cuisine
    case delicious
    case top
    case inspired
    case localTitle
    case localRestaurants
    case dineInTitle
    case dineInRestaurants
}
class RestaurantVC: UIViewController {
    @IBOutlet weak var topConstrains: NSLayoutConstraint!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var userProfileIcon: UIImageView!
    @IBOutlet weak var micSearch: UIImageView!
    @IBOutlet weak var serachImage: UIImageView!
    @IBOutlet weak var serachField: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var restaurationNotAvailableView: UIView!
    @IBOutlet weak var cartLbl: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var locationButton1: UIButton!
    @IBOutlet weak var locationImageview: UIImageView!
    @IBOutlet weak var animationSearchView: UIView!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var searchForLabel: UILabel!

    @IBOutlet weak var homeCollection: UICollectionView!
    private let viewModel = RestaurantViewModel()
    var promoRestList = [Restaurant]()
    var restList = [Restaurant]()
    var topRestList = [Restaurant]()
    var deliciousRestList = [Restaurant]()
    var inspiredRestList = [Restaurant]()
    var cuisineList = [Cuisine]()
    var cuisineHeading = ""
    var restHeading = ""
    var banner = ""
    var selectedCuisines = -1
    var coupons = [Coupon]()
    var gotResponse = false
    
    let strings = ["\'food\'".translated(), "\'restaurants\'".translated(), "\'groceries\'".translated(), "\'beverages\'".translated(), "\'bread\'".translated(), "\'pizza\'".translated(), "\'biryani\'".translated(), "\'burger\'".translated(), "\'bajji\'".translated(), "\'noodles\'".translated(), "\'soup\'".translated(), "\'sandwich\'".translated(), "\'biscuits\'".translated(), "\'chocolates\'".translated()]

    var index = 0
    var timer: Timer?
    
    override func viewDidLoad() {

        super.viewDidLoad()

        homeCollection.backgroundColor = .white
        homeCollection.register(UINib(nibName: "HeaderCollectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionView") //elementKindSectionFooter for footerview
        
        micSearch.isUserInteractionEnabled = true
        serachField.isUserInteractionEnabled = false
        serachField.text = ""
        serachField.textColor = .gray
        searchView.layer.cornerRadius = 10
        searchView.layer.borderColor = UIColor.lightGray.cgColor
        searchView.layer.borderWidth = 1
        serachField.backgroundColor = .clear
       
        let searchTap = UITapGestureRecognizer(target: self, action: #selector(searchTapAction))
        searchView.addGestureRecognizer(searchTap)
        let searchTap1 = UITapGestureRecognizer(target: self, action: #selector(searchTapAction))
        animationSearchView.addGestureRecognizer(searchTap1)
        
        let micTap = UITapGestureRecognizer(target: self, action: #selector(micTapAction(tapGestureRecognizer:)))
        micSearch.addGestureRecognizer(micTap)
        getdata()
        self.getCuisinesFromApi()
        searchForLabel.text = "title4".translated()
        serachField.setPlaceHolderColor(.gGray200)

    }
    func getdata() {
        self.cuisineList = APPDELEGATE.getCousins()
        self.cuisineHeading = APPDELEGATE.getCusineheading()
        self.banner = APPDELEGATE.getBanner()
        //self.sliderList = APPDELEGATE.getSlider()
        self.coupons = APPDELEGATE.getCoupons()
    }

    func themeSet() {
        self.view.backgroundColor = themeBackgrounColor
        view1.backgroundColor = themeBackgrounColor
        view2.backgroundColor = themeBackgrounColor
        searchView.backgroundColor = .white
        self.headingLabel.textColor = themeTitleColor
        self.locationButton.setTitleColor(themeTitleColor, for: .normal)
        cartLbl.textColor = themeTitleColor
        locationImageview.tintColor = themeTitleColor

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedCuisines = -1
        checkViewHidden()
        cartLbl.text = "\(Cart.shared.cartData.count)"
        themeSet()
        animateListOfLabels()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    func checkViewHidden() {
        var premise = APPDELEGATE.selectedLocationAddress.premise
        let local = APPDELEGATE.selectedLocationAddress.subLocality ?? ""
        let city = APPDELEGATE.selectedLocationAddress.city ?? ""
        var mainAdd = ""
        if premise.count > 0 {
            premise = "\(premise), "
        }
        if local.count > 0 {
            mainAdd = "\(premise)\(local), \(city)"
        }
        else if city.count > 0 {
            mainAdd = "\(city)"
        }
        
        self.locationButton.setTitle(mainAdd, for: .normal)
        self.headingLabel.text = "\(APPDELEGATE.selectedLocationAddress.state ?? ""), \(APPDELEGATE.selectedLocationAddress.zipcode ?? "")"
    }

    func getRestDataFromApi() {
        var cuisine = ""
        if selectedCuisines >= 0 {
            cuisine = cuisineList[self.selectedCuisines].heading
            if self.restList.count > 0 {
                let sortedList = sortRestaurants(by: cuisine, in: restList)
                self.restList = sortedList
                self.setAllRestdata()
                return
            }
        }
       
           if restList.isEmpty {
               UtilsClass.showProgressHud(view: view)
           }

           viewModel.fetchRestaurants(cuisine: cuisine) { [weak self] result in
               guard let self else { return }
               UtilsClass.hideProgressHud(view: self.view)

               switch result {
               case .success(let restaurants):
                   self.restList = restaurants
                   self.setAllRestdata()
                   self.gotResponse = true

               case .failure:
                   self.restList.removeAll()
                   self.setAllRestdata()
                   self.gotResponse = true
               }
           }
        
    }
    func sortRestaurants(by cuisine: String, in list: [Restaurant]) -> [Restaurant] {
        return list.sorted { r1, r2 in
            let r1Contains = r1.cuisine.localizedCaseInsensitiveContains(cuisine)
            let r2Contains = r2.cuisine.localizedCaseInsensitiveContains(cuisine)
            
            if r1Contains && !r2Contains {
                return true
            } else if !r1Contains && r2Contains {
                return false
            } else {
                // If both contain (or both don’t), sort alphabetically by cuisine
                return r1.cuisine.localizedCaseInsensitiveCompare(r2.cuisine) == .orderedAscending
            }
        }
    }
    func setAllRestdata() {
        topRestList = restList.sorted { ($0.rating ?? 0) > ($1.rating ?? 0) }

		// Delicious list: only restaurants with offers
        /*
		let offered = self.restList.filter { ($0.offer?.isEmpty == false) }
		self.deliciousRestList = offered
        let promoOffered = self.restList.filter { ($0.offerdeals == 1) && ($0.offer?.isEmpty == false)}
        self.promoRestList = promoOffered
        */
		self.inspiredRestList = [Restaurant]()
        inspiredRestList = uniqueInspiredRestaurants()
		/*
		if self.restList.count > 0 {
		   let restids = UtilsClass.getPastOrdersRest()
			if restids.count > 0 {
				for restid in restids {
					if let found = restList.first(where: { $0.rid == restid.restId }) {
						self.inspiredRestList.append(found)
					} else {
						print("Not found")
					}
				}
			}
		}
		
		if self.restList.count > 0 {
		   let restids = UtilsClass.getInspairedPast()
			if restids.count > 0 {
				for restid in restids {
                    if inspiredRestList.first(where: { $0.rid == restid }) != nil {
						print("already added")
					} else {
						if let found = restList.first(where: { $0.rid == restid }) {
								self.inspiredRestList.append(found)
						} else {
							print("Not found")
						}
					}
				}
			}
		}
        */
		self.homeCollection.reloadData()

	}
    private func uniqueInspiredRestaurants() -> [Restaurant] {
        let pastIds = Set(
            UtilsClass.getPastOrdersRest().map { $0.restId } +
            UtilsClass.getInspairedPast()
        )

        return restList.filter { pastIds.contains($0.rid) }
    }
    
    func getCuisinesFromApi() {
        let parameters = CommonAPIParams.base()
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.cuisine, forModelType: CuisineResponse.self) { [weak self] success in
            guard let self = self else { return }
            self.cuisineList = success.data.data.cuisine
            APPDELEGATE.cusines = success.data
            self.cuisineHeading = success.data.data.cuisineHeading
            self.banner = success.data.data.banner
            self.coupons = success.data.data.coupon
            self.homeCollection.reloadData()
            UtilsClass.saveCousines()
            
        } ErrorHandler: { _ in
        }
    }
    func setFavRestaurant(index: Int) {
        /*
        var rest = self.restList[index]
        var tempList = self.restList
        var favStr = OldServiceType.addFavorite
        if rest.favorite == "Yes" {
            favStr = OldServiceType.removeFavorite
        }
        let parameters: [String: AnyObject] = [
            "api_id" : AppConfig.API_ID as AnyObject,
            "api_key" : AppConfig.OldAPI_KEY as AnyObject,
            "devicetoken" : AppConfig.DeviceToken as AnyObject,
            "app_version" : "1.0" as AnyObject,
            "devicetype" : AppConfig.DeviceType as AnyObject,
            "customer_id" : APPDELEGATE.userResponse?.customer.customer_id as AnyObject,
            "restaurant_id" : rest.id as AnyObject        ]
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromService(parameter: parameters, servicename: favStr, forModelType: FavoriteResponse.self) { [weak self] success in
            guard let self = self else { return }
            UtilsClass.hideProgressHud(view: self.view)
            if favStr == OldServiceType.addFavorite {
                rest.favorite = "Yes"
            } else {
                rest.favorite = "No"
            }
            tempList.remove(at: index)
            tempList.insert(rest, at: index)
            self.restList = tempList
        } ErrorHandler: { [weak self] _ in
            guard let self = self else { return }
            UtilsClass.hideProgressHud(view: self.view)
        }
        */
    }
    func setHiddenRestaurant(index: Int) {
        /*
        var tempList = restData?.rest_list.list
        let rest = restData?.rest_list.list[index]
        let favStr = "Add"
        let parameters: [String: AnyObject] = [
            "api_id" : AppConfig.API_ID as AnyObject,
            "api_key" : AppConfig.API_KEY as AnyObject,
            "devicetoken" : AppConfig.DeviceToken as AnyObject,
            "app_version" : "1.0" as AnyObject,
            "service_type" : ServiceType.hiddenRest as AnyObject,
            "devicetype" : AppConfig.DeviceType as AnyObject,
            "customer_id" : "21080312075829" as AnyObject,
            "restaurant_id" : rest?.restaurant_id as AnyObject,
            "hiddenType" : favStr as AnyObject
        ]
        print(parameters)
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadData(parameter: parameters, forModelType: AddRemoveFavRestResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            //let addRemoveFavRestResponse = success.data.result
            tempList?.remove(at: index)
            self.restData?.rest_list.list = tempList!
            self.restaurantTable.reloadData()
            //self.showAlert(msg: addRemoveFavRestResponse ?? "")
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
        */
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.locationButton.setTitle(LocationManagerClass.shared.firstAddress, for: .normal)
                self.headingLabel.text = LocationManagerClass.shared.secondAddress
                self.checkViewHidden()

        serachField.delegate = self
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(profileTapAction(_:)))
        userProfileIcon.addGestureRecognizer(profileTap)
       
        let serachTap = UITapGestureRecognizer(target: self, action: #selector(searchTapAction))
        serachImage.addGestureRecognizer(serachTap)
        getRestDataFromApi()


    }
    @objc func profileTapAction(_ sender: UITapGestureRecognizer? = nil) {
        let vc = self.viewController(viewController: CartVC.self, storyName: StoryName.CartFlow.rawValue) as! CartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func micTapAction(tapGestureRecognizer: UITapGestureRecognizer? = nil) {
        // handling code
        micAction()
    }
    @objc func searchTapAction() {
        // handling code
        navigateToSearchController(withText: "")
    }
    func stopTimer() {
        timer?.invalidate()
    }
    
    func resumeTimer() {
        if index > strings.count - 1 { index = 0 }
        if !strings.isEmpty {
            currentLabel.text = strings[index]
        }
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in
            self?.updateLabels()
        }
    }
    
    func animateListOfLabels() {
        if index > strings.count - 1 { index = 0 }
        if !strings.isEmpty {
            currentLabel.text = strings[index]
        }
        nextLabel.alpha = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in
            self?.updateLabels()
        }    }
    
    @objc func updateLabels() {
        if index < strings.count {
            nextLabel.text = strings[index]
            nextLabel.alpha = 0
            nextLabel.transform = CGAffineTransform(translationX: 0, y: searchView.frame.height / 2)
            
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.currentLabel.alpha = 0
                self.currentLabel.transform = CGAffineTransform(translationX: 0, y: -self.searchView.frame.height / 2)
                self.nextLabel.alpha = 1
                self.nextLabel.transform = .identity
            }, completion: { _ in
                // Swap the labels
                self.currentLabel.text = self.nextLabel.text
                self.currentLabel.alpha = 1
                self.currentLabel.transform = .identity
                
                // Reset next label
                self.nextLabel.alpha = 0
                self.nextLabel.transform = CGAffineTransform(translationX: 0, y: self.searchView.frame.height / 2)
            })
            
            index += 1
        } else {
            index  = 0
        }
    }
    func micAction(){
        let vc = self.viewController(viewController: MicSearchVC.self, storyName: StoryName.Main.rawValue) as! MicSearchVC
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext


        self.present(vc, animated: true);
        
       
        vc.completion = { [weak self] searchedText in
            guard let self = self else { return }
            if searchedText.count > 0{
                self.dismiss(animated: true) {
                    self.navigateToSearchController(withText: searchedText)
                }
            }
        }
    } 
    func getRestDetailFromApi(restData: RestData) {
        Cart.shared.dbname = restData.dbname//"grabull_strore1"//dbname
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "rest_id" : restData.restID
        ]) { _, new in new }
        
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.restaurantDetail, forModelType: RestDetailsApiResponse.self) { [weak self] success in
            guard let self = self else { return }
            UtilsClass.hideProgressHud(view: self.view)
            let story = UIStoryboard.init(name: "OrderFlow", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "RestDetailsVC") as! RestDetailsVC
            //let apiResponse = try JSONDecoder().decode(RestDetailsApiResponse.self, from: data)

            let customModel = success.data.toCustomModel()
/*
            print(customModel.menu.count)
            for item in customModel.menu {
                print(item.heading)
                print(item.subheading)
                print(item.itemList.count)
                print("--------")
            }
            print(customModel.offer?.count ?? 0)
            */
            vc.restDetailsData = customModel
            vc.restData = restData
//            ForEach(success.data.resolvedItems) { item in
//                print("\(item.name ?? "")")
//            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        } ErrorHandler: { [weak self] _ in
            guard let self = self else { return }
            UtilsClass.hideProgressHud(view: self.view)
        }
    }
    func loadJson(filename fileName: String) -> RestDetailsRes? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
               // decoder.keyDecodingStrategy = .convertFromSnakeCase
                let jsonData = try decoder.decode(RestDetailsRes.self, from: data)
                print("success:\(jsonData)")
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    @IBOutlet weak var headingLabel: UILabel!
   
    @IBAction func changeLang(_ sender: Any) {
        moveToLocationPage()
    }
    func moveToLocationPage() {
        let vc = self.viewController(viewController: LocationVC.self, storyName: StoryName.Location.rawValue) as! LocationVC

        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToSearchController(withText: String){
        self.view.endEditing(true)
        let vc = self.viewController(viewController: RestSearchVC.self, storyName: StoryName.Main.rawValue) as! RestSearchVC

        vc.searchtext = withText
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
extension RestaurantVC: RestCellDelegate {
    func clickedFavAction(index: Int) {
        setFavRestaurant(index: index)
    }
    
    func openOptionView(sender: UITapGestureRecognizer, index: Int) {
        
        let point = sender.location(in: self.view)
        let popupVC = self.viewController(viewController: RestaurantPoupVC.self, storyName: StoryName.Main.rawValue) as! RestaurantPoupVC

        let rest = restList[index]
        if rest.isFav {
            popupVC.numberOfItem = 2
            popupVC.textOne = "Show similar restaurants"
            popupVC.textTwo = "Remove from favourites"
            popupVC.textThree = ""
            popupVC.firstImg = UIImage.init(named: "similarIcon")
            popupVC.secondImg = UIImage.init(named: "favorite")
            popupVC.thirdImg = UIImage.init(named: "")
        } else {
            popupVC.numberOfItem = 3
            popupVC.textOne = "Show similar restaurants"
            popupVC.textTwo = "Add to favourites"
            popupVC.textThree = "Hide this restaurant"
            popupVC.firstImg = UIImage.init(named: "similarIcon")
            popupVC.secondImg = UIImage.init(named: "favorite")
            popupVC.thirdImg = UIImage.init(named: "hidden")
        }
        popupVC.restIndex = index
        popupVC.pointY = Float(point.y)
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        self.present(popupVC, animated: true)
         
    }
    
}

extension RestaurantVC: MicSearchDelegate {
    func searchDone(search: String){
        print(search)
        navigateToSearchController(withText: search)
    }
}
// This string extension appears unused in this controller; consider moving to a shared utils if needed.
extension RestaurantVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        navigateToSearchController(withText: "")
    }
}
extension RestaurantVC: SelectOptionDelegate {
    func selectedOption(restIndex: Int, index: Int) {
        print("selected index -\(restIndex)-- \(index)")
        if index == 1 {
            let vc = self.viewController(viewController: SimilarRestaurantVC.self, storyName: StoryName.Main.rawValue) as! SimilarRestaurantVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if index == 2 {
            self.setFavRestaurant(index: restIndex)
        }
        if index == 3 {
            self.setHiddenRestaurant(index: restIndex)
        }
    }
}
extension RestaurantVC: CousineDelegate {
    func selectedCuisine(selsectedindex: Int) {
        self.selectedCuisines = selsectedindex
        self.getRestDataFromApi()
    }
    
}
extension RestaurantVC: RestSelectedFromHorizontallistDelegate {
    func selectedIndex(restdata: RestData) {
        UtilsClass.saveInspairedPast(restID: restdata.restID)
        self.getRestDetailFromApi(restData: restdata)
    }
    
    func favSelectedIndex(restID: String, url: String) {
        //self.fav
    }
    
}
extension RestaurantVC: TopPicksRestSelectedDelegate {
    func topSelectedIndex(restData: RestData) {
        UtilsClass.saveInspairedPast(restID: restData.restID)
        self.getRestDetailFromApi(restData: restData)
    }
    
}

extension RestaurantVC: InspiredFromPastDelegate {
    func pastSlectedIndex(restData: RestData) {
        UtilsClass.saveInspairedPast(restID: restData.restID)
        self.getRestDetailFromApi(restData: restData)
    }
    
//    func favSelectedIndex(restID: String, url: String) {
//        //self.fav
//    }
    
}


extension RestaurantVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
}
extension RestaurantVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        RestaurantSection.allCases.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = RestaurantSection(rawValue: section) else { return 0 }

        switch section {
        case .banner:
            return self.banner.count > 0 ? 1 : 0
        case .promoCell:
            let allCount = self.promoRestList.count
                return allCount > 0 ? 1 : 0
        case .cuisine:
            return cuisineList.count > 0 ? 1 : 0
        case .delicious:
            return deliciousRestList.count > 0 ? 1 : 0
        case .top:
            return topRestList.count > 0 ? 1 : 0
        case .inspired:
            return inspiredRestList.count > 0 ? 1 : 0
        case .localTitle:
            return 1
        case .localRestaurants:
            return self.restList.count
        case .dineInTitle:
            return 0//self.restList.count > 0 ? 1 : 0
        default:
            return 0//self.restList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = RestaurantSection(rawValue: indexPath.section) else {
               fatalError("Unknown section \(indexPath.section)")
           }
           
           switch section {
           case .banner:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerGIFCVCell", for: indexPath as IndexPath) as! BannerGIFCVCell
            cell.backgroundColor = .clear
            cell.updateUI(imageurl: self.banner)
            return cell;

           case .promoCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromoRestCVCell", for: indexPath as IndexPath) as! PromoRestCVCell
                cell.backgroundColor = .white
               cell.delegate = self
               cell.configPromoCell(promoRestaurants: self.promoRestList)
            return cell;

           case .cuisine:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestCouponsCVCell", for: indexPath as IndexPath) as! RestCouponsCVCell
            cell.selectedCuisines = self.selectedCuisines
            cell.updateUIOld(cuisine: cuisineList, heading: self.cuisineHeading)
            cell.delegate = self
            cell.backgroundColor = .white
            return cell;
           case .delicious:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeliciousDealsCVCell", for: indexPath as IndexPath) as! DeliciousDealsCVCell
            cell.backgroundColor = .white
            cell.configDeliciousDeals(restaurants: deliciousRestList)
            cell.delegate = self
            return cell
           case .top:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopPicksCVCell", for: indexPath as IndexPath) as! TopPicksCVCell
            cell.backgroundColor = .white
            cell.configTopPicks(restaurants: topRestList)
            cell.delegate = self
            return cell
           case .inspired:
            if inspiredRestList.count == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoRestFoundCVCell", for: indexPath as IndexPath) as! NoRestFoundCVCell
                    return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InspiredFromPastCVCell", for: indexPath as IndexPath) as! InspiredFromPastCVCell
                cell.backgroundColor = .white
                cell.configInspiredFromPast(restaurants: inspiredRestList)
                cell.delegate = self
                return cell
            }
           case .localTitle:
            if restList.count > 0 {
                let titleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCVCell", for: indexPath as IndexPath) as! TitleCVCell
                titleCell.headingTitle.text = "Local Restaurants"
                titleCell.backgroundColor = .white
                return titleCell;
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoRestFoundCVCell", for: indexPath as IndexPath) as! NoRestFoundCVCell
                cell.isHidden = !self.gotResponse
                    return cell
            }
           case .localRestaurants:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRestCVCell", for: indexPath as IndexPath) as! HomeRestCVCell

                if restList.count > 0 {
                    cell.updateUIWithOld(index: indexPath.row, restaurant: restList[indexPath.row])
                }
                cell.backgroundColor = .white
                return cell;
           case .dineInTitle:
            if restList.count > 0 {
                let titleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCVCell", for: indexPath as IndexPath) as! TitleCVCell
                titleCell.headingTitle.text = "DineIn and deals"
                titleCell.backgroundColor = .white
                return titleCell;
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoRestFoundCVCell", for: indexPath as IndexPath) as! NoRestFoundCVCell
                    return cell
            }
           case .dineInRestaurants:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRestCVCell", for: indexPath as IndexPath) as! HomeRestCVCell

                if restList.count > 0 {
                    cell.updateUIWithOld(index: indexPath.row, restaurant: restList[indexPath.row])
                }
                cell.backgroundColor = .white
                return cell;
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = RestaurantSection(rawValue: indexPath.section) else { return }
        switch section {
        case .localRestaurants:
            let rest = self.restList[indexPath.row]
            UtilsClass.saveInspairedPast(restID: rest.rid)
            self.getRestDetailFromApi(restData: RestData(dbname: rest.dbname, restID: rest.rid, restImgUrl: rest.restBannerImage))
        case .localTitle:
            if restList.count == 0 {
                self.moveToLocationPage()
            }
        default:
            break
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        guard let section = RestaurantSection(rawValue: indexPath.section) else {
               fatalError("Unknown section \(indexPath.section)")
           }
        switch section {
        case .banner:
            return CGSize(width: width , height: 150)
        case .promoCell:
            return CGSize(width: width , height: 135)
        case .cuisine:
            return CGSize(width: width , height: 270)
        case .delicious:
            return CGSize(width: width , height: 280)
        case .top:
            return CGSize(width: width , height: 280)
        case .inspired:
            return CGSize(width: width , height: self.inspiredRestList.count > 0 ? 280 : 5)
        case .localTitle:
            if restList.count > 0 {
                return CGSize(width: width , height: 60)
            } else {
                return CGSize(width: width , height: 300)
            }
        case .localRestaurants:
            return CGSize(width: width/2 , height: 240)
        case .dineInTitle:
            if restList.count > 0 {
                return CGSize(width: width , height: 60)
            } else {
                return CGSize(width: width , height: 300)
            }
        case .dineInRestaurants:
            return CGSize(width: width/2 , height: 240)
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
extension RestaurantVC: PromoCellDelegate {
    func didSelectPromoCell(promoRestaurant: Restaurant) {
        UtilsClass.saveInspairedPast(restID: promoRestaurant.rid)
        self.getRestDetailFromApi(restData: RestData(dbname: promoRestaurant.dbname, restID: promoRestaurant.rid, restImgUrl: promoRestaurant.imgUrl ?? ""))
    }
}
