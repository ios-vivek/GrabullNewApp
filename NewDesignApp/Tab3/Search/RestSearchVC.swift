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
  //  var localListResponse = [Restaurant]()

    var searchtext: String = ""
    var selectedCuisines = -1
    var searchActive = false
    var cuisineList = [Cuisine]()
    
    var cuisine = ""
    var searchString = ""
  //  var justCameOnPage = false

    override func viewDidLoad() {
        super.viewDidLoad()
       // justCameOnPage = true
        // Do any additional setup after loading the view.
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
        let searchTap = UITapGestureRecognizer(target: self, action: #selector(micTapAction(tapGestureRecognizer:)))
        micSearch.addGestureRecognizer(searchTap)
        
        let searchTap1 = UITapGestureRecognizer(target: self, action: #selector(searchTapAction(tapGestureRecognizer:)))
        serachImage.addGestureRecognizer(searchTap1)
        
        serachField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.activeFilter()
        self.view.backgroundColor = .white
        restSearchTable.backgroundColor = .white
       // getFirsttimeRestDataFromApi()
        serachField.setPlaceHolderColor(.gGray200)

    }
    func refreshData() {
        UtilsClass.getCousines()
        if searchActive {
            print(serachField.text ?? "")
            cuisineList = APPDELEGATE.getCousins().filter({ $0.heading.lowercased().contains(serachField.text!.lowercased())})
            print(cuisineList.count)
        } else {
            cuisineList = APPDELEGATE.getCousins()
        }
        restSearchTable.reloadData()
    }
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func searchTapAction(tapGestureRecognizer: UITapGestureRecognizer? = nil) {
        // handling code
        getRestDataFromApi()
    }
    @objc func micTapAction(tapGestureRecognizer: UITapGestureRecognizer? = nil) {
        // handling code
        micAction()
    }
    func micAction(){
               let vc = self.viewController(viewController: MicSearchVC.self, storyName: StoryName.Main.rawValue) as! MicSearchVC

       // self.modalPresentationStyle = UIModalPresentationCurrentContext;
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext


        self.present(vc, animated: true);
        
       
        vc.completion = { searchedText in
                    print("TestClosureClass is done")
            if searchedText.count > 0{
                self.serachField.text = searchedText
                self.activeFilter()
                self.dismiss(animated: true)
            }
                }
        
    }
    func activeFilter() {
        if self.serachField.text!.count > 0 {
            self.searchActive = true
        } else {
            self.searchActive = false
        }
        self.refreshData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    /*
    func getFirsttimeRestDataFromApi() {
        let parameters: [String: AnyObject] = [
            "api_id" : AppConfig.API_ID as AnyObject,
            "api_key" : AppConfig.OldAPI_KEY as AnyObject,
            "DeviceToken" : AppConfig.DeviceToken as AnyObject,
            "DeviceVersoin" : "1.0" as AnyObject,
            "rest_zip" : "\(APPDELEGATE.selectedLocationAddress.zipcode ?? "")" as AnyObject,
           // "rest_zip" : "01801" as AnyObject,

            "cust_lat" : "\(APPDELEGATE.selectedLocationAddress.latLong.latitude)" as AnyObject,
            "cust_long" : "\(APPDELEGATE.selectedLocationAddress.latLong.longitude)" as AnyObject,
            "devicetype" : AppConfig.DeviceType as AnyObject,
            "customer_id" : APPDELEGATE.userResponse?.customer.customer_id as AnyObject,
            //"cuisine_type" : cuisine as AnyObject,
            //"name" : searchString as AnyObject,
            "address" : "\(UtilsClass.getFullAddress())" as AnyObject

        ]
            UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromService(parameter: parameters, servicename: OldServiceType.resturantList, forModelType: RestaurantListResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
                self.justCameOnPage = false
                self.localListResponse = success.data.restaurant
        } ErrorHandler: { error in
            self.justCameOnPage = false
            UtilsClass.hideProgressHud(view: self.view)

        }
        
    }
    */
    func getRestDataFromApi() {
        if selectedCuisines >= 0 && cuisineList.count > 0 {
            cuisine = cuisineList[self.selectedCuisines].heading
        }
       
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "cust_lat": "\(APPDELEGATE.selectedLocationAddress.latLong.latitude)",
            "cust_long": "\(APPDELEGATE.selectedLocationAddress.latLong.longitude)",
            "cuisine_type" : cuisine,
            "address" : "\(UtilsClass.getFullAddress())",
            "name" : searchString

        ]) { _, new in new }
        
            UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.resturantList, forModelType: RestaurantListResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            /*
                if success.data.restaurant.count > 0 {
                    let story = UIStoryboard.init(name: "FoodSearch", bundle: nil)
                    let vc = story.instantiateViewController(withIdentifier: "SearchDetailVC") as! SearchDetailVC
                    vc.listResponse = success.data.restaurant
                    vc.cuisine = self.cuisine
                    self.navigationController?.pushViewController(vc, animated: true)
            }
            */
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
            let story = UIStoryboard.init(name: "FoodSearch", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "SearchDetailVC") as! SearchDetailVC
            vc.listResponse = [Restaurant]()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text!.count > 0 {
            searchActive = true
            searchString = textField.text!
        } else {
            searchActive = false
            searchString = ""
        }
        self.refreshData()
    }
}

extension RestSearchVC: MicSearchDelegate {
    func searchDone(search: String){
        print(search)
        
    }
}
extension RestSearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cuisineList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTVCell", for: indexPath) as! SearchTVCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.titleLbl.text = cuisineList[indexPath.row].heading
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCuisines = indexPath.row
        getRestDataFromApi()
    }
}
