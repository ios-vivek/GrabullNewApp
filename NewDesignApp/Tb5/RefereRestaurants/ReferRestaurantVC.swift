//
//  ReferVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 20/08/25.
//

import UIKit
//POST /web-api-ios/refer-restaurant-list/
// {"api_id":"123","api_key":"abc","customer_id":"Customer_id"}

    class ReferRestaurantVC: UIViewController {
        @IBOutlet weak var tbl: UITableView!
        @IBOutlet weak var referRestBth: UIButton!


        var restaurantList: [ReferRestaurantList] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = pageBackgroundColor
            tbl.backgroundColor = .clear
            referRestBth.setRounded(cornerRadius: 4)
            referRestBth.setFontWithString(text: "Refer A Restaurant", fontSize: 16)
            referRestBth.backgroundColor = kBlueColor
        }
        override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
            getRestaurantList()
        }
        @IBAction func backAction() {
            self.navigationController?.popViewController(animated: true)
        }
        @IBAction func referRestaurantAction() {
            let vc = self.viewController(viewController: ReferRestaurantFromVC.self, storyName: StoryName.Profile.rawValue) as! ReferRestaurantFromVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        private func getRestaurantList() {
            let parameters = CommonAPIParams.base()
            
            UtilsClass.showProgressHud(view: self.view)
            WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.referRestaurantList, forModelType: ReferRestaurantListResponse.self) { success in
                UtilsClass.hideProgressHud(view: self.view)
                self.restaurantList = success.data.data
                self.tbl.reloadData()
            } ErrorHandler: { error in
                UtilsClass.hideProgressHud(view: self.view)
                self.showAlert(title: "Error", msg: "Failed to load restaurant list.")
            }
        }

    }
    
    extension ReferRestaurantVC: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return restaurantList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReferRestaurantCell", for: indexPath) as! ReferRestaurantCell

            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            
            cell.updateUI(item: restaurantList[indexPath.row])
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let restaurant = restaurantList[indexPath.row]
            // Handle restaurant selection if needed
        }
        
//        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            return 80 // Adjust height as needed
//        }
    }
