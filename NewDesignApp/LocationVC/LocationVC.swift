//
//  LocationVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 25/08/24.
//

import UIKit
import CoreLocation
import Contacts

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
        recentAddress =  LocalUtils.getAddress()
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
        LocalUtils.showProgressHud(view: self.view)
        GoogleAPisService.googleAddressSearch(searchtext: text, forModelType: GoogleAddressResponse.self) { success in
            LocalUtils.hideProgressHud(view: self.view)
            self.googleAddressResponse = success.data
          //  print(\(res.status))
            self.addressTbl.reloadData()
            
        } ErrorHandler: { error in
            if error.contains("The Internet connection appears to be offline")
            {
                self.showAlert(title: "Internet", msg: "The Internet connection appears to be offline.")
            }
            LocalUtils.hideProgressHud(view: self.view)
        }
    }
    func getAddressLatlongFromApi(text: String) {
        self.fromGoogle(text: text)
        /*
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
        */
        
    }
    func fromGoogle(text: String) {
        
        LocalUtils.showProgressHud(view: self.view)
        GoogleAPisService.googleAddressLatLong(searchtext: text, forModelType: GoogleAddressLatLongResponse.self) { success in
            LocalUtils.hideProgressHud(view: self.view)
            // We avoid relying on GoogleAddressResult internals; instead geocode the human-readable text.
            LocalUtils.getAddressDetails(from: text) { locationAddress in
                guard let _ = locationAddress else {
                    // If geocoding fails, keep the list for display but don't crash.
                    self.addressWithLatLong = success.data.results ?? []
                    self.addressTbl.reloadData()
                    if self.addressWithLatLong.isEmpty {
                        self.showAlert(title: "Location", msg: "Unable to resolve this address. Please try a different search.")
                    }
                    return
                }

                // Navigate after successful resolution
                if self.fromSearch {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    let tabbar = self.navigationController?.viewControllers[1] as! TabBarVC
                    self.navigationController?.popToViewController(tabbar, animated: true)
                }

                // Persist the typed address
                LocalUtils.saveAddress(address: SavedAddressInDB(address: text, date: Date()))
            }
        } ErrorHandler: { error in
            LocalUtils.hideProgressHud(view: self.view)
        }
         
    }
    func getAddress(){
        // No longer needed: we now resolve address via UtilsClass.getAddressDetails(from:)
        // Keeping this method for potential future use.
        if !self.addressWithLatLong.isEmpty {
            self.addressTbl.reloadData()
        }
    }

}

extension LocationVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if activeSearch {
                return 0
            }
            let count = APPDELEGATE.userResponse?.customer.address.count ?? 0
            return count > 0 ? count + 1 : 0
        }
        if section == 1 {
            return 0
            /*
            if activeSearch {
                return 0
            }
            return recentAddress.count > 5 ? 6 : recentAddress.count + 1
            */
        }
        else {
                guard let addressList = googleAddressResponse?.predictions else {
                    return 0
                }
                return addressList.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTVCell", for: indexPath) as! AddressTVCell
                cell.selectionStyle = .none
                cell.backgroundColor = .white
                        cell.recentTitle(address: "Saved Addresses")
                        return cell
            } else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "AddressListTVCell", for: indexPath) as! AddressListTVCell
//               
//                let address = APPDELEGATE.userResponse!.customer.address[indexPath.row - 1]
//                let user = APPDELEGATE.userResponse!.customer
//                cell.phoneLbl.text = "Phone Number: \(user.phone)"
//
//                cell.configureUI(address: address)
//                cell.delegate = self
//                cell.editButton.tag = indexPath.row
//                cell.deleteButton.tag = indexPath.row
//                cell.deleteButton.isHidden = true
//          
//                return cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTVCell", for: indexPath) as! AddressTVCell
                cell.selectionStyle = .none
                cell.backgroundColor = .white
                let address = APPDELEGATE.userResponse!.customer.address[indexPath.row - 1]
                cell.recentAddressUpdateUI(address: address.fullAddress)

                        return cell
            }
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTVCell", for: indexPath) as! AddressTVCell
            cell.selectionStyle = .none
            cell.backgroundColor = .white
                if indexPath.row == 0 {
                    cell.recentTitle(address: "Recent Addresses")
                } else {
                    cell.recentAddressUpdateUI(address: recentAddress[indexPath.row - 1].address)
                }
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTVCell", for: indexPath) as! AddressTVCell
            cell.selectionStyle = .none
            cell.backgroundColor = .white
                guard let addList = googleAddressResponse?.predictions else {
                    return cell
                }
                cell.updateUI(address: addList[indexPath.row])
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let index = indexPath.row - 1
            if index >= 0 {
                let address = APPDELEGATE.userResponse!.customer.address[indexPath.row - 1]

                Cart.shared.userAddress = address
                getAddressLatlongFromApi(text: address.fullAddress)
            }
        }
        else if indexPath.section == 1 {
            let index = indexPath.row - 1
            if index >= 0 {
                getAddressLatlongFromApi(text: recentAddress[index].address)
            }
        } else {
                guard let addressList = googleAddressResponse?.predictions else {
                    return
                }
                getAddressLatlongFromApi(text: addressList[indexPath.row].description ?? "")
        }
    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if activeSearch {
            guard let addressList = googleAddressResponse?.predictions else {
                return
            }
            getAddressLatlongFromApi(text: addressList[indexPath.row].description ?? "")
        } else {
            let index = indexPath.row - 1
            if index >= 0 {
                getAddressLatlongFromApi(text: recentAddress[index].address)
            }
        }
    }
    */
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 170
//    }
}
extension LocationVC: AddressDelegate {
    func editAddress(selectedIndex: Int) {
        let vc = self.viewController(viewController: AddAddressVC.self, storyName: StoryName.Profile.rawValue) as! AddAddressVC
        vc.isUpdateAddress = true
        vc.updateUserAdd = APPDELEGATE.userResponse?.customer.address[selectedIndex - 1]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteAddress(selectedIndex: Int) {
        /*
        let alertController = UIAlertController(title: "Delete", message: "Are you sure want to delete address?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
            self.deleteAddress(addressID: APPDELEGATE.userResponse!.customer.address[selectedIndex].id, index: selectedIndex)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { alert in
            
        }
        alertController.addAction(OKAction)
        alertController.addAction(cancel)
        OperationQueue.main.addOperation {
            self.present(alertController, animated: true,
                         completion:nil)
        }
        */
    }
    
}

private enum LocalUtils {
    // Simple blocking overlay to indicate progress
    static func showProgressHud(view: UIView) {
        let tag = 987654
        if view.viewWithTag(tag) != nil { return }
        let overlay = UIActivityIndicatorView(style: .large)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.color = .gray
        overlay.tag = tag
        view.addSubview(overlay)
        NSLayoutConstraint.activate([
            overlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            overlay.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        overlay.startAnimating()
    }

    static func hideProgressHud(view: UIView) {
        let tag = 987654
        if let overlay = view.viewWithTag(tag) as? UIActivityIndicatorView {
            overlay.stopAnimating()
            overlay.removeFromSuperview()
        }
    }

    // Geocode an address string into LocationAddress-like data and update globals similarly to UtilsClass.getAddressDetails
    static func getAddressDetails(from address: String, completion: @escaping (_ locationAddress: LocationAddress?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let _ = error {
                completion(nil)
                return
            }
            guard let placemark = placemarks?.first, let location = placemark.location else {
                completion(nil)
                return
            }
            let locationAddress = LocationAddress()
            locationAddress.addressID = UUID().uuidString
            locationAddress.city = placemark.locality
            locationAddress.state = placemark.administrativeArea
            locationAddress.country = placemark.country
            locationAddress.zipcode = placemark.postalCode
            locationAddress.subLocality = placemark.subLocality ?? ""
            locationAddress.locality = placemark.locality ?? ""
            locationAddress.streetNumber = placemark.subThoroughfare ?? ""
            locationAddress.route = placemark.thoroughfare ?? ""
            locationAddress.premise = placemark.name ?? ""
            locationAddress.latLong = location.coordinate

            APPDELEGATE.selectedLocationAddress = LocationAddress()
            APPDELEGATE.selectedLocationAddress.subLocality = locationAddress.subLocality
            APPDELEGATE.selectedLocationAddress.latLong = locationAddress.latLong
            APPDELEGATE.selectedLocationAddress.premise = locationAddress.premise
            APPDELEGATE.selectedLocationAddress.country = locationAddress.country
            APPDELEGATE.selectedLocationAddress.zipcode = locationAddress.zipcode
            APPDELEGATE.selectedLocationAddress.city = locationAddress.city
            APPDELEGATE.selectedLocationAddress.state = locationAddress.state
            APPDELEGATE.selectedLocationAddress.subLocality = locationAddress.subLocality
            APPDELEGATE.selectedLocationAddress.streetNumber = locationAddress.streetNumber
            APPDELEGATE.selectedLocationAddress.route = locationAddress.route

            if APPDELEGATE.selectedLocationAddress.premise.isEmpty {
                APPDELEGATE.selectedLocationAddress.premise = APPDELEGATE.selectedLocationAddress.streetNumber
            }
            if let loc = APPDELEGATE.selectedLocationAddress.subLocality, loc.isEmpty {
                APPDELEGATE.selectedLocationAddress.subLocality = APPDELEGATE.selectedLocationAddress.route
            }

            completion(locationAddress)
        }
    }

    // Persist and retrieve recent addresses like UtilsClass.saveAddress/getAddress
    static func saveAddress(address: SavedAddressInDB) {
        var saved: [SavedAddressInDB] = getAddress()
        if let index = saved.firstIndex(where: { $0.address == address.address }) {
            var updated = saved[index]
            updated = SavedAddressInDB(address: updated.address, date: Date())
            saved.remove(at: index)
            saved.insert(updated, at: 0)
        } else {
            saved.insert(address, at: 0)
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(saved) {
            UserDefaults.standard.set(encoded, forKey: "savedAddress")
        }
    }

    static func getAddress() -> [SavedAddressInDB] {
        if let data = UserDefaults.standard.data(forKey: "savedAddress") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([SavedAddressInDB].self, from: data) {
                return decoded.sorted { $0.date > $1.date }
            }
        }
        return []
    }
}

