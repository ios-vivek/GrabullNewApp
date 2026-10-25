//
//  RestSearchVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 29/08/24.
//

import UIKit

class RestSearchVC: UIViewController {
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var micSearch: UIImageView!
    @IBOutlet weak var serachImage: UIImageView!
    @IBOutlet weak var serachField: UITextField!
    @IBOutlet weak var restSearchTable: UITableView!

    var searchtext: String = ""
    var selectedCuisines = -1
    var searchActive = false
    var restaurantList = [String]()
    
    var cuisine = ""
    var searchString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        micSearch.isUserInteractionEnabled = true
        serachImage.isUserInteractionEnabled = true
        serachField.isUserInteractionEnabled = true
        serachField.placeholder = "Search"
        serachField.textColor = .black
        searchView.layer.cornerRadius = 10
        searchView.layer.borderColor = UIColor.lightGray.cgColor
        searchView.layer.borderWidth = 1
        serachField.backgroundColor = .clear
        searchView.backgroundColor = .clear
        serachField.text = searchtext
        serachField.textColor = .black
        serachField.delegate = self
        serachField.returnKeyType = .search
        
        let searchTap = UITapGestureRecognizer(target: self, action: #selector(micTapAction(tapGestureRecognizer:)))
        micSearch.addGestureRecognizer(searchTap)
        
        let searchTap1 = UITapGestureRecognizer(target: self, action: #selector(searchTapAction(tapGestureRecognizer:)))
        serachImage.addGestureRecognizer(searchTap1)
        
        serachField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.activeFilter()
        self.view.backgroundColor = .white
        restSearchTable.backgroundColor = .white
        getCuisinesFromApi()
        serachField.setPlaceHolderColor(.gGray200)
    }
    
    func getCuisinesFromApi() {
        let parameters = CommonAPIParams.base()
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.cuisine, forModelType: CuisineResponse.self) { [weak self] success in
            guard let self = self else { return }
            print(success)
            APPDELEGATE.cusines = success.data
            UtilsClass.saveCousines()
            self.refreshData()
        } ErrorHandler: { _ in
        }
    }
    
    func refreshData() {
        UtilsClass.getCousines()
        let allRestaurants = APPDELEGATE.getRestaurants()
        if searchActive {
            print(serachField.text ?? "")
            restaurantList = allRestaurants.filter({ $0.lowercased().contains(serachField.text!.lowercased())})
            print(restaurantList.count)
        } else {
            restaurantList = allRestaurants
        }
        restSearchTable.reloadData()
    }

    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func searchTapAction(tapGestureRecognizer: UITapGestureRecognizer? = nil) {
        performSearch()
    }

    func performSearch() {
        self.view.endEditing(true)
        let text = (serachField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        selectedCuisines = -1
        let allRestaurants = APPDELEGATE.getRestaurants()
        if let matched = allRestaurants.first(where: { $0.caseInsensitiveCompare(text) == .orderedSame }) {
            self.cuisine = matched
        } else if let matched = restaurantList.first(where: { $0.caseInsensitiveCompare(text) == .orderedSame }) {
            self.cuisine = matched
        } else {
            self.cuisine = text
        }

        getRestDataFromApi()
    }

    @objc func micTapAction(tapGestureRecognizer: UITapGestureRecognizer? = nil) {
        micAction()
    }

    func micAction() {
        let vc = self.viewController(viewController: MicSearchVC.self, storyName: StoryName.Main.rawValue) as! MicSearchVC
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext

        self.present(vc, animated: true)
        
        vc.completion = { [weak self] searchedText in
            guard let self = self else { return }
            print("TestClosureClass is done")
            if searchedText.count > 0 {
                self.serachField.text = searchedText
                self.activeFilter()
                self.dismiss(animated: true)
            }
        }
    }

    func activeFilter() {
        let text = self.serachField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.searchString = text
        self.cuisine = text
        if text.count > 0 {
            self.searchActive = true
        } else {
            self.searchActive = false
        }
        self.refreshData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func getRestDataFromApi() {
        if selectedCuisines >= 0 && restaurantList.count > selectedCuisines {
            cuisine = restaurantList[self.selectedCuisines]
        }
       
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
            UtilsClass.hideProgressHud(view: self.view)
            
            let story = UIStoryboard.init(name: "FoodSearch", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "SearchDetailVC") as! SearchDetailVC
            vc.listResponse = success.data.data.restaurants
            vc.cuisine = self.cuisine
            vc.gotResponseFromService = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        } ErrorHandler: { [weak self] error in
            guard let self = self else { return }
            UtilsClass.hideProgressHud(view: self.view)
            let story = UIStoryboard.init(name: "FoodSearch", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "SearchDetailVC") as! SearchDetailVC
            vc.listResponse = [Restaurant]()
            vc.cuisine = self.cuisine
            vc.gotResponseFromService = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        selectedCuisines = -1
        activeFilter()
    }
}

extension RestSearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        performSearch()
        return true
    }
}

extension RestSearchVC: MicSearchDelegate {
    func searchDone(search: String) {
        print(search)
    }
}

extension RestSearchVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTVCell", for: indexPath) as! SearchTVCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.titleLbl.text = restaurantList[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        selectedCuisines = indexPath.row
        cuisine = restaurantList[indexPath.row]
        serachField.text = cuisine
        getRestDataFromApi()
    }
}
