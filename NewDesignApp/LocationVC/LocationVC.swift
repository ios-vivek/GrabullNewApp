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
    var fromFirstPage = false
    var activeSearch = false
    var recentAddress = [SavedAddressInDB]()
    private var hasCheckedVersion = false
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
        addressTbl.rowHeight = UITableView.automaticDimension
        addressTbl.estimatedRowHeight = 64
        searchTextfiled.setPlaceHolderColor(.gGray200)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !hasCheckedVersion {
            self.view.isUserInteractionEnabled = false
            LocalUtils.showProgressHud(view: self.view)
            checkAppVersionService()
        }
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard hasCheckedVersion else { return }
        // handling code
        let story = UIStoryboard.init(name: "Location", bundle: nil)
        let popupVC = story.instantiateViewController(withIdentifier: "UserLocationMapVC") as! UserLocationMapVC
        self.navigationController?.pushViewController(popupVC, animated: true)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard hasCheckedVersion else { return }
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
            } else if self.fromFirstPage {
                let vc = self.viewController(viewController: TabBarVC.self, storyName: StoryName.Main.rawValue)
                self.navigationController?.pushViewController(vc, animated: true)
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
        address.streetNumber = ""
        address.route = ""
        address.premise = ""
        address.subLocality = ""
        address.city = ""
        address.state = ""
        address.zipcode = ""
        address.country = ""
        address.locality = ""
        address.latLong = CLLocationCoordinate2D(latitude: result.geometry.location.lat,
                                                  longitude: result.geometry.location.lng)

        var county = ""

        for component in result.address_components ?? [] {
            let types = component.types
            if types.contains("street_number") {
                address.streetNumber = component.long_name
            } else if types.contains("route") {
                address.route = component.long_name
            } else if types.contains("premise") || types.contains("subpremise") {
                address.premise = component.long_name
            } else if types.contains("sublocality") || types.contains("sublocality_level_1") || types.contains("neighborhood") {
                address.subLocality = component.long_name
            } else if types.contains("locality") || types.contains("postal_town") {
                address.city = component.long_name
            } else if types.contains("administrative_area_level_2") {
                county = component.long_name
            } else if types.contains("administrative_area_level_1") {
                address.state = component.short_name
            } else if types.contains("postal_code") {
                address.zipcode = component.long_name
            } else if types.contains("country") {
                address.country = component.long_name
            }
        }

        // Fallback for city if locality is missing (e.g. rural roads or unincorporated areas)
        if address.city.isEmpty && !county.isEmpty {
            address.city = county
        }

        // Fallback for premise:
        if address.premise.isEmpty {
            if !address.streetNumber.isEmpty && !address.route.isEmpty {
                address.premise = "\(address.streetNumber) \(address.route)"
            } else if !address.streetNumber.isEmpty {
                address.premise = address.streetNumber
            } else if !address.route.isEmpty {
                address.premise = address.route
            }
        }

        address.city = address.city ?? ""
        address.state = address.state ?? ""
        address.zipcode = address.zipcode ?? ""
        address.country = address.country ?? ""
        address.subLocality = address.subLocality ?? ""
        address.locality = address.city
        APPDELEGATE.selectedLocationAddress = address

        if !address.subLocality.isEmpty {
            LocationManagerClass.shared.firstAddress = address.subLocality
        } else if !address.premise.isEmpty {
            LocationManagerClass.shared.firstAddress = address.premise
        } else {
            LocationManagerClass.shared.firstAddress = address.city ?? ""
        }

        var secondParts: [String] = []
        if !address.subLocality.isEmpty && !address.city.isEmpty {
            secondParts.append(address.city)
        }
        var stateZip = ""
        if !address.state.isEmpty { stateZip += address.state }
        if !address.zipcode.isEmpty {
            stateZip += (stateZip.isEmpty ? "" : " ") + address.zipcode
        }
        if !stateZip.isEmpty { secondParts.append(stateZip) }
        LocationManagerClass.shared.secondAddress = secondParts.joined(separator: ", ")

        NotificationCenter.default.post(name: Notification.Name("location"), object: nil)
        return address
    }
    func getAddress(){
        // No longer needed: we now resolve address via UtilsClass.getAddressDetails(from:)
        // Keeping this method for potential future use.
        if !self.addressWithLatLong.isEmpty {
            self.addressTbl.reloadData()
        }
    }

    // MARK: - App Version Check & Force Update
    func checkAppVersionService() {
        AppVersionManager.shared.checkVersion { [weak self] needsUpdate, data in
            guard let self = self else { return }
            LocalUtils.hideProgressHud(view: self.view)
            if needsUpdate {
                AppVersionManager.shared.presentForceUpdateIfNeeded(on: self)
            } else {
                self.finishVersionCheckAllowed()
            }
        }
    }

    private func finishVersionCheckAllowed() {
        LocalUtils.hideProgressHud(view: self.view)
        self.hasCheckedVersion = true
        self.view.isUserInteractionEnabled = true
    }

    func deleteAddress(addressID: String, index: Int) {
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "id": addressID
        ]) { _, new in new }
        LocalUtils.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.removeAddress, forModelType: AddedAddressResponse.self) { [weak self] success in
            guard let self = self else { return }
            LocalUtils.hideProgressHud(view: self.view)
            guard let customer = APPDELEGATE.userResponse?.customer,
                  index < customer.address.count else { return }
            APPDELEGATE.userResponse?.customer.address.remove(at: index)
            if Cart.shared.userAddress?.id == addressID {
                Cart.shared.userAddress = APPDELEGATE.userResponse?.customer.address.first
            }
            UtilsClass.saveUserDetails()
            self.addressTbl.reloadData()
        } ErrorHandler: { [weak self] error in
            guard let self = self else { return }
            LocalUtils.hideProgressHud(view: self.view)
            if error == "Invalid User Details" {
                self.showAlert(title: "Error", msg: error)
            } else {
                self.showAlert(title: "Error", msg: "Something went wrong, try again later.")
            }
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
        return UITableView.automaticDimension
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
                    cell.deleteButton.isHidden = false
                    
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
        guard hasCheckedVersion else { return }
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
        guard let addresses = APPDELEGATE.userResponse?.customer.address else { return }
        let addressIndex = selectedIndex - 1
        guard addressIndex >= 0 && addressIndex < addresses.count else { return }
        let vc = self.viewController(viewController: AddAddressVC.self, storyName: StoryName.Profile.rawValue) as! AddAddressVC
        vc.isUpdateAddress = true
        vc.updateUserAdd = addresses[addressIndex]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteAddress(selectedIndex: Int) {
        let addressIndex = selectedIndex - 1
        guard let addresses = APPDELEGATE.userResponse?.customer.address,
              addressIndex >= 0 && addressIndex < addresses.count else {
            return
        }
        let alertController = UIAlertController(title: "Delete", message: "Are you sure want to delete address?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Ok", style: .default) { [weak self] action in
            guard let self = self,
                  let currentAddresses = APPDELEGATE.userResponse?.customer.address,
                  addressIndex < currentAddresses.count else { return }
            let addressID = currentAddresses[addressIndex].id
            self.deleteAddress(addressID: addressID, index: addressIndex)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { alert in
            
        }
        alertController.addAction(OKAction)
        alertController.addAction(cancel)
        OperationQueue.main.addOperation {
            self.present(alertController, animated: true,
                         completion:nil)
        }
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
