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
    @IBOutlet weak var navigationTitle: UILabel!


    var fromProfile = false
    var fromSearch = false
    var activeSearch = false
    var recentAddress = [SavedAddressInDB]()
//let url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=amoeba&components=country:us&types=establishment&location=37.76999%2C-122.44696&radius=500&key=AIzaSyAcpD8juDqASzLRWCdNP-ns4UzdVph1koU"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationTitle.text = fromProfile ? "Address" : "Address"
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
        let searchText = textField.text ?? ""
        
        if searchText.isEmpty {
            activeSearch = false
            googleAddressResponse = nil // Clear previous search results
            addressTbl.reloadData()
        } else {
            activeSearch = true
            
            // Only search if we have at least 3 characters
            if searchText.count >= 1 {
                getAddressFromApi(text: searchText)
            } else {
                // Show empty search results for 1-2 characters
                addressTbl.reloadData()
            }
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
            self.addressTbl.reloadData()
            
            // Show message if no results found
            if self.activeSearch && (self.googleAddressResponse?.predictions?.isEmpty ?? true) {
                self.showToast(message: "No addresses found. Try a different search.", font: .systemFont(ofSize: 14.0))
            }
            
        } ErrorHandler: { error in
            LocalUtils.hideProgressHud(view: self.view)
            if error.contains("The Internet connection appears to be offline") {
                self.showAlert(title: "Internet", msg: "The Internet connection appears to be offline.")
            } else {
                self.showAlert(title: "Error", msg: "Unable to search addresses. Please try again.")
            }
        }
    }
    func getAddressLatlongFromApi(text: String) {
        self.fromGoogle(text: text)
    }
    func fromGoogle(text: String) {
        
        LocalUtils.showProgressHud(view: self.view)
        GoogleAPisService.googleAddressLatLong(searchtext: text, forModelType: GoogleAddressLatLongResponse.self) { success in
            LocalUtils.hideProgressHud(view: self.view)
            guard let result = success.data.results?.first else {
                self.showAlert(title: "Location", msg: "Unable to resolve this address. Please try a different search.")
                return
            }

            let locationAddress = self.locationAddress(from: result)

            // Navigate after successful Google resolution.
            if self.fromProfile {
                let vc = self.viewController(viewController: AddAddressVC.self, storyName: StoryName.Profile.rawValue) as! AddAddressVC
                vc.isUpdateAddress = false
                vc.locationAddress = locationAddress
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if self.fromSearch {
                self.navigationController?.popViewController(animated: true)
            } else {
                guard let navController = self.navigationController,
                      navController.viewControllers.count > 1,
                      let tabbar = navController.viewControllers[1] as? TabBarVC else {
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                self.navigationController?.popToViewController(tabbar, animated: true)
            }

            LocalUtils.saveAddress(address: SavedAddressInDB(address: result.formatted_address, date: Date()))
        } ErrorHandler: { error in
            LocalUtils.hideProgressHud(view: self.view)
        }
         
    }

    /// Uses the Google Geocoding result already returned for the selected prediction.
    /// Do not re-geocode it through CLGeocoder: business names can resolve differently there.
    private func locationAddress(from result: ResultLatLong) -> LocationAddress {
        let address = LocationAddress()
        address.addressID = UUID().uuidString
        address.latLong = CLLocationCoordinate2D(latitude: result.geometry.location.lat,
                                                  longitude: result.geometry.location.lng)

        for component in result.address_components ?? [] {
            guard let type = component.types.first else { continue }
            switch type {
            case "street_number": address.streetNumber = component.long_name
            case "route": address.route = component.long_name
            case "subpremise": address.premise = component.long_name
            case "sublocality", "neighborhood": address.subLocality = component.long_name
            case "locality": address.city = component.long_name
            case "administrative_area_level_1": address.state = component.short_name
            case "postal_code": address.zipcode = component.long_name
            case "country": address.country = component.long_name
            default: break
            }
        }

        address.city = address.city ?? ""
        address.state = address.state ?? ""
        address.zipcode = address.zipcode ?? ""
        address.country = address.country ?? ""
        address.subLocality = address.subLocality ?? ""
        address.locality = address.city
        APPDELEGATE.selectedLocationAddress = address
        return address
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
            // Recent-address history is intentionally hidden for now.
            return 0
        }
        else {
            // Section 2: Google search results
            if activeSearch {
                guard let addressList = googleAddressResponse?.predictions else {
                    return 0
                }
                return addressList.count
            }
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let isSavedAddressRow = indexPath.section == 0 && !fromProfile && indexPath.row > 0
        let isRecentAddressRow = indexPath.section == 1 && indexPath.row > 0
        return indexPath.section == 2 || isSavedAddressRow || isRecentAddressRow
            ? 64
            : UITableView.automaticDimension
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
                if fromProfile {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AddressListTVCell", for: indexPath) as! AddressListTVCell
                    
                    guard let userResponse = APPDELEGATE.userResponse,
                          indexPath.row - 1 < userResponse.customer.address.count else {
                        return cell
                    }
                    
                    let address = userResponse.customer.address[indexPath.row - 1]
                    let user = userResponse.customer
                    cell.phoneLbl.text = "Phone Number: \(user.phone)"
                    
                    cell.configureUI(address: address)
                    cell.delegate = self
                    cell.editButton.tag = indexPath.row
                    cell.deleteButton.tag = indexPath.row
                    cell.deleteButton.isHidden = true
                    
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTVCell", for: indexPath) as! AddressTVCell
                    cell.selectionStyle = .none
                    cell.backgroundColor = .white
                    
                    guard let userResponse = APPDELEGATE.userResponse,
                          indexPath.row - 1 < userResponse.customer.address.count else {
                        return cell
                    }
                    
                    let address = userResponse.customer.address[indexPath.row - 1]
                    cell.savedAddressUpdateUI(address: address)
                    
                    return cell
                }
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
            // Selecting from saved addresses
            let index = indexPath.row - 1
            if index >= 0 {
                guard let userResponse = APPDELEGATE.userResponse,
                      index < userResponse.customer.address.count else {
                    showAlert(title: "Error", msg: "Unable to load address. Please try again.")
                    return
                }
                
                let address = userResponse.customer.address[index]
                Cart.shared.userAddress = address
                
                if fromProfile {
                    // In profile mode, allow editing saved address
                    let vc = self.viewController(viewController: AddAddressVC.self, storyName: StoryName.Profile.rawValue) as! AddAddressVC
                    vc.isUpdateAddress = true
                    vc.updateUserAdd = address
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    // In search mode, just use the address
                    getAddressLatlongFromApi(text: address.fullAddress)
                }
            }
        }
        else if indexPath.section == 1 {
            // Selecting from recent addresses
            let index = indexPath.row - 1
            if index >= 0 {
                let selectedAddress = recentAddress[index].address
                
                if fromProfile {
                    // A locality/postal-code result is a valid starting point for the
                    // add-address form even though it has no street/route component.
                    getAddressLatlongFromApi(text: selectedAddress)
                } else {
                    getAddressLatlongFromApi(text: selectedAddress)
                }
            }
        } else {
            // Selecting from Google search results
            guard let addressList = googleAddressResponse?.predictions,
                  let selectedAddressText = addressList[indexPath.row].description else {
                return
            }
            
            if fromProfile {
                // Let the user complete a postal-code/locality selection on the
                // Add Address screen instead of rejecting it as incomplete.
                getAddressLatlongFromApi(text: selectedAddressText)
            } else {
                // For non-profile flow, proceed with geocoding
                getAddressLatlongFromApi(text: selectedAddressText)
            }
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
