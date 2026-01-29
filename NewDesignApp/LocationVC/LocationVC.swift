//
//  LocationVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 25/08/24.
//

import UIKit
import CoreLocation

class LocationVC: UIViewController {
    @IBOutlet weak var searchTextfiled: UITextField!
    @IBOutlet weak var searchView: UIView!
    var googleAddressResponse: GoogleAddressResponse?
    var addressWithLatLong = [ResultLatLong]()
    @IBOutlet weak var addressTbl: UITableView!
    @IBOutlet weak var userLocationView: UIView!
    @IBOutlet weak var seperatorimg: UIImageView!


    var fromSearch = false
    var activeSearch = false
    var recentAddress = [SavedAddressInDB]()
//let url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=amoeba&components=country:us&types=establishment&location=37.76999%2C-122.44696&radius=500&key=AIzaSyAcpD8juDqASzLRWCdNP-ns4UzdVph1koU"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let searchicon = UIImage(systemName: "magnifyingglass")

        searchTextfiled.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
       // let image = UIImage(named: "imageName")
        imageView.image = searchicon
        searchTextfiled.leftView = imageView
        searchTextfiled.tintColor = .black
        searchView.layer.cornerRadius = 10
        searchView.layer.borderWidth = 1
        searchView.layer.borderColor = UIColor.black.cgColor
        searchTextfiled.text = ""
        searchTextfiled.placeholder = "Search your location"
        searchTextfiled.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        userLocationView.addGestureRecognizer(tap)
        recentAddress =  UtilsClass.getAddress()
        seperatorimg.isHidden = !activeSearch
        self.view.backgroundColor = .white
        addressTbl.backgroundColor = .white
        searchTextfiled.setPlaceHolderColor(.gGray200)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        let story = UIStoryboard.init(name: "Location", bundle: nil)
        let popupVC = story.instantiateViewController(withIdentifier: "UserLocationMapVC") as! UserLocationMapVC
        self.navigationController?.pushViewController(popupVC, animated: true)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text!.count >= 3 {
            getAddressFromApi(text: textField.text ?? "")
        }
        if textField.text!.isEmpty {
            activeSearch = false
            addressTbl.reloadData()
        } else {
            activeSearch = true
            addressTbl.reloadData()
        }
        seperatorimg.isHidden = !activeSearch
    }
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    func getAddressFromApi(text: String) {
        UtilsClass.showProgressHud(view: self.view)
        GoogleAPisService.googleAddressSearch(searchtext: text, forModelType: GoogleAddressResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            self.googleAddressResponse = success.data
          //  print(\(res.status))
            self.addressTbl.reloadData()
            
        } ErrorHandler: { error in
            if error.contains("The Internet connection appears to be offline")
            {
                self.showAlert(title: "Internet", msg: "The Internet connection appears to be offline.")
            }
            UtilsClass.hideProgressHud(view: self.view)
        }
    }
    func getAddressLatlongFromApi(text: String) {
        UtilsClass.getAddressDetails(from: text) { address in
            guard let address = address else {
                self.fromGoogle(text: text)
                return
            }
            self.addressTbl.reloadData()
            if self.fromSearch {
                self.navigationController?.popViewController(animated: true)
            } else {
                let tabbar = self.navigationController?.viewControllers[1] as! TabBarVC
                self.navigationController?.popToViewController(tabbar, animated: true)
            }
            UtilsClass.saveAddress(address: SavedAddressInDB(address: text, date: Date()))
        }
        
    }
    func fromGoogle(text: String) {
        
        UtilsClass.showProgressHud(view: self.view)
        GoogleAPisService.googleAddressLatLong(searchtext: text, forModelType: GoogleAddressLatLongResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            guard let address = success.data.results else {
                return
            }
            self.addressWithLatLong = address
            print("Address list- \(self.addressWithLatLong.count)")
            self.addressTbl.reloadData()
            self.getAddress()
            UtilsClass.saveAddress(address: SavedAddressInDB(address: text, date: Date()))

        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
         
    }
    func getAddress(){
        if !self.addressWithLatLong.isEmpty {
            UtilsClass.setGlobalAddress(addressWithLatLong: self.addressWithLatLong)
            if fromSearch {
                self.navigationController?.popViewController(animated: true)
            } else {
                let tabbar = self.navigationController?.viewControllers[1] as! TabBarVC
                self.navigationController?.popToViewController(tabbar, animated: true)
            }
        }
        }

}
extension LocationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !activeSearch {
            return recentAddress.count > 5 ? 6 : recentAddress.count + 1
        } else {
            guard let addressList = googleAddressResponse?.predictions else {
                return 0
            }
            return addressList.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTVCell", for: indexPath) as! AddressTVCell
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        if activeSearch {
            guard let addList = googleAddressResponse?.predictions else {
                return cell
            }
            cell.updateUI(address: addList[indexPath.row])
        } else {
            if indexPath.row == 0 {
                cell.recentTitle(address: "Recent Addresses")
            } else {
                cell.recentAddressUpdateUI(address: recentAddress[indexPath.row - 1].address)
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if activeSearch {
            guard let addressList = googleAddressResponse?.predictions else {
                return
            }
            getAddressLatlongFromApi(text: addressList[indexPath.row].description ?? "")
        } else {
            getAddressLatlongFromApi(text: recentAddress[indexPath.row - 1].address)
        }
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 170
//    }
}
