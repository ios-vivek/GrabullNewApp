//
//  CartVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 15/10/24.
//

import UIKit

class GroceryCartVC: UIViewController {
    
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var addressBtn: UIButton!
    @IBOutlet weak var proceedView: UIView!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var titlelbl: UILabel!
    var completeItemList = [CustMenuCategory]()
    var allDisplayItems = [CustMenuCategory]()
    var isOpen = false
    override func viewDidLoad() {
        super.viewDidLoad()
        var fullText = "Order"
        var firstPart = "Order"
        var secondPart = ""
        titlelbl.text = "Order"
        if GroceryCartData.shared.storeDetails != nil {
            firstPart = ""
            fullText = "\(GroceryCartData.shared.storeDetails?.name ?? "")"
            secondPart = "\(GroceryCartData.shared.storeDetails?.name ?? "")"
            
            if GroceryCartData.shared.userAddress == nil,
               APPDELEGATE.userLoggedIn(),
               let addresses = APPDELEGATE.userResponse?.customer.address {
                
                GroceryCartData.shared.userAddress = addresses.first {
                    $0.zip == APPDELEGATE.selectedLocationAddress.zipcode
                }
            }
            
            
        }
        
        let attributedString = NSMutableAttributedString(string: fullText)

        // First part in red
        attributedString.addAttribute(.foregroundColor,
                                      value: kOrangeColor,
                                       range: NSRange(location: 0, length: firstPart.count))

        // Second part in blue
        attributedString.addAttribute(.foregroundColor,
                                      value: UIColor.black,
                                       range: NSRange(location: firstPart.count, length: secondPart.count))

        titlelbl.attributedText = attributedString
        loginBtn.setRounded(cornerRadius: 8)
        loginBtn.setFontWithString(text: "Proceed with Email/Phone number", fontSize: 12)
        addressBtn.setRounded(cornerRadius: 8)
        addressBtn.setFontWithString(text: "Add or Select address", fontSize: 12)
        loginBtn.backgroundColor = themeBackgrounColor
        addressBtn.backgroundColor = themeBackgrounColor
        proceedBtn.setRounded(cornerRadius: 8)
        proceedBtn.setFontWithString(text: "Add or Select address", fontSize: 12)
        proceedBtn.backgroundColor = themeBackgrounColor
        self.setDefaultBack()
        self.view.backgroundColor = .white
        cartTableView.backgroundColor = .white

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshView()
        /*
        if GroceryCartData.shared.orderType == .delivery {
            self.getAddressesFromApi()
        }
        GroceryCartData.shared.isReward = false
        GroceryCartData.shared.rewardAmount = 0.0
        GroceryCartData.shared.isTips = false
        GroceryCartData.shared.tipsAmount = 0.0
        GroceryCartData.shared.isDonate = false
        GroceryCartData.shared.donateAmount = 0.0
        */
    }
   
    func getAddressesFromApi() {
        let parameters = CommonAPIParams.groceryBase()
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.getAddress, forModelType: AddressListResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            APPDELEGATE.userResponse?.customer.address = success.data.data
           UtilsClass.saveUserDetails()
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
    }
    func refreshView() {
        emptyView.isHidden = !GroceryCartData.shared.cartItems.isEmpty
        cartTableView.isHidden = GroceryCartData.shared.cartItems.isEmpty
        loginView.isHidden = true
        addressView.isHidden = true
        proceedView.isHidden = true
        if !APPDELEGATE.userLoggedIn() {
            loginView.isHidden = cartTableView.isHidden
        }
        if APPDELEGATE.userLoggedIn() {
            addressView.isHidden = cartTableView.isHidden
            let add = GroceryCartData.shared.userAddress?.fullAddress ?? ""
            if GroceryCartData.shared.userAddress == nil || add == "" || add.isEmpty {
                addressView.isHidden = false
            } else {
                addressView.isHidden = true
                proceedView.isHidden = false
            }
        }
        let val = GroceryCartData.shared.total.toString()
        proceedBtn.setFontWithString(text: "Proceed: \(UtilsClass.getCurrencySymbol())\(val)", fontSize: 12)
        getAllItemsForNextVCDisplay()
        self.cartTableView.reloadData()
    }
    func getAllItemsForNextVCDisplay() {
        /*

           allDisplayItems = []

           for cartItem in GroceryCartData.shared.cartData {

               for menu in GroceryCartData.shared.tempAllRestmenu {

                   for itemData in menu.allItems {

                       addItemInCompleteMeal(
                           menuItem: menu,
                           item: cartItem,
                           itemData: itemData
                       )
                   }
               }
           }

           removeItemFromCompleteMealList()
        */
       }
   
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func loginAction() {
        let vc = self.viewController(viewController: ProfileVC.self, storyName: StoryName.Profile.rawValue) as! ProfileVC
        vc.delegate = self
        vc.fromOtherPage = true
        self.present(vc, animated: true)
    }
    @IBAction func addressAction() {
        let story = UIStoryboard.init(name: "Profile", bundle: nil)
        let popupVC = story.instantiateViewController(withIdentifier: "ChooseAddressVC") as! ChooseAddressVC
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.delegate = self
        self.present(popupVC, animated: true)
    }

    @IBAction func proceedAction() {

        let add = GroceryCartData.shared.userAddress?.fullAddress ?? ""
       // let add = "2 Barnsley Rd, Lynnfield, MA 01940, USA"//GroceryCartData.shared.userAddress.fullAddress

            if add == "" {
                refreshView()
            } else {
                checkDeliveryAvailability(restID: GroceryCartData.shared.storeDetails?.rid ?? "", menuType: "Regular", address: add)
            }
      //  contionueAction()
    
    }
    func contionueAction() {
        
        let cart = GroceryCartData.shared
        let minDelivery = cart.storeDetails?.minDelivery ?? 0
        let subtotal = cart.subtotal
        
        // If minimum order not reached
        if Double(minDelivery) > subtotal {
            
            let formattedMin = String(format: "%.2f", Double(minDelivery))
            
            let alertController = UIAlertController(
                title: "Add more items",
                message: "Min order \(UtilsClass.getCurrencySymbol())\(formattedMin) for delivery",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "Add", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            DispatchQueue.main.async {
                self.present(alertController, animated: true)
            }
            
        } else {
            // Proceed to payment
            let vc = self.viewController(
                viewController: GroceryPaymentVC.self,
                storyName: StoryName.Grocery.rawValue
            ) as! GroceryPaymentVC
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func checkDeliveryAvailability(restID: String, menuType: String, address: String) {
        var parameters = CommonAPIParams.groceryBase()
        parameters.merge([
            "rest_id" : restID,
            "address" : address,
            "menutype" : menuType,
            "deliveryMiles" : GroceryCartData.shared.storeDetails?.deliveryMiles ?? 0,
            "addressRest" : GroceryCartData.shared.storeDetails?.fullAddress ?? ""
        ]) { _, new in new }
        
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.getDistance, forModelType: DeliveryAvailabilityResponse.self) { [weak self] success in
            guard let self = self else { return }
            UtilsClass.hideProgressHud(view: self.view)
            let data = success.data
            if(data.isAvailable)
            {
                contionueAction()
            } else {
                showAlert(title: "Out of Delivery Area", msg: "\(data.data?.message ?? "Out of Delivery Area")")
            }
            
        } ErrorHandler: { error in
           // guard let self = self else { return }
            UtilsClass.hideProgressHud(view: self.view)
            self.showAlert(title: "Out of Delivery Area", msg: "\(error)")
        }
    }
    
    func openItemDetails(itemlist: RestItemList, index: IndexPath) {
        if(!isOpen)

           {
               isOpen = true
            let menuVC = self.viewController(viewController: ItemDetailsVC.self, storyName: StoryName.Main.rawValue) as! ItemDetailsVC
            menuVC.itemData = itemlist
            menuVC.index = index

            menuVC.delegate = self
            menuVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
               self.view.addSubview(menuVC.view)
            self.addChild(menuVC)
               menuVC.view.layoutIfNeeded()

               menuVC.view.frame=CGRect(x: 0, y: 0 + UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);

               UIView.animate(withDuration: 0.3, animations: { () -> Void in
                   menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
               }) { completion in
                   self.tabBarController?.tabBar.isHidden = true
               }

           }else if(isOpen)
           {
               closedPopup()
           }
    }
    func closedPopup() {
        isOpen = false
        let viewMenuBack : UIView = view.subviews.last!

          UIView.animate(withDuration: 0.3, animations: { () -> Void in
              var frameMenu : CGRect = viewMenuBack.frame
              frameMenu.origin.y = 1 * UIScreen.main.bounds.size.height
              viewMenuBack.frame = frameMenu
              viewMenuBack.layoutIfNeeded()
              viewMenuBack.backgroundColor = UIColor.clear
          }, completion: { (finished) -> Void in
              viewMenuBack.removeFromSuperview()
              self.tabBarController?.tabBar.isHidden = false

          })
    }

}
extension GroceryCartVC: ReloadAddressDelegate {
    func changedAddress() {
        refreshView()
    }
    
    func addNewAddress() {
        let vc = self.viewController(viewController: AddAddressVC.self, storyName: StoryName.Profile.rawValue) as! AddAddressVC
        vc.isUpdateAddress = false
        vc.fromCheckoutPage = true
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension GroceryCartVC: ReloadNewAddressDelegate {
    func addednewAddress() {
        refreshView()
    }
    
}
extension GroceryCartVC: LoginSuccessDelegate {
    func signupAction() {
        let vc = self.viewController(viewController: SignupVC.self, storyName: StoryName.Profile.rawValue) as! SignupVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loginCompleted() {
        self.refreshView()
//        if GroceryCartData.shared.orderType == .pickup {
//            self.proceedAction()
//    }
    }
}
extension GroceryCartVC: SignupSuccessfullyDelegate {
    func signupCompleted() {
        self.refreshView()
//        if GroceryCartData.shared.orderType == .pickup {
//            self.proceedAction()
//    }

    }
}
extension GroceryCartVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if GroceryCartData.shared.userAddress != nil {
            return 4
        }
        return 3

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return GroceryCartData.shared.cartItems.count + 1
        }
        if section == 1 {
            return completeItemList.count > 0 ? 1 : 0
        }
      return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTitleTVCell", for: indexPath) as! ItemTitleTVCell
                cell.selectionStyle = .none
                cell.backgroundColor = .white
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryCartItemTVCell", for: indexPath) as! GroceryCartItemTVCell
                cell.selectionStyle = .none
                cell.backgroundColor = .white
                cell.delegate = self
                cell.deleteButton.tag = indexPath.row - 1
                cell.updateUI(index: indexPath.row - 1)
                cell.selectionStyle = .none
                return cell
            }
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoreItemTVCell", for: indexPath) as! MoreItemTVCell
        cell.selectionStyle = .none
            cell.suggestedItemList = self.completeItemList
            cell.delegate = self
            cell.itemCollection.reloadData()
        // cell.updateUI(offer: self.restDetailsData?.offer ?? [RestOffer]())
        return cell
    }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryPriceDetailsTVCell", for: indexPath) as! GroceryPriceDetailsTVCell
            cell.selectionStyle = .none
            cell.backgroundColor = .gGray100
            cell.delegate = self
            cell.updateUI(isPlaceOrder: false)
            cell.tipsLbl.isHidden = true
            cell.donateLbl.isHidden = true
            cell.selectionStyle = .none
            return cell
        }
    
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryAtTVCell", for: indexPath) as! DeliveryAtTVCell
            cell.selectionStyle = .none
            if GroceryCartData.shared.cartItems.count > 0 {
                var add = ""
               
                    cell.headingLbl.text = "Delivery At:"
                    let address = GroceryCartData.shared.userAddress
                    let landmark = address!.add2?.isEmpty == false ? "\nLandmark: \(address!.add2 ?? "")" : ""
                    let street = address!.street?.isEmpty == false ? "\(address!.street ?? "") " : ""

                    
                    add = "\(street)\(address!.add1 ?? "") \(landmark) \n\(address!.city ?? ""), \(address!.state ?? ""), \(address!.zip ?? "")"
                    cell.changeAddressBtn.isHidden = false
                    cell.changePhoneBtn.isHidden = false
                    cell.phoneLbl.text = "Phone: \(APPDELEGATE.userResponse?.customer.phone ?? "")"
                    if GroceryCartData.shared.alternateNumber.count == 10 {
                        cell.phoneLbl.text = "Phone: \(GroceryCartData.shared.alternateNumber)"
                    }
                cell.delegate = self
                cell.deliveryAtLbl.text = add
            }
            
             
            return cell
        }
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 195
        }
        return UITableView.automaticDimension
    }
}
extension GroceryCartVC: ChangeAddressDelegate {
    func changeAddress() {
        let story = UIStoryboard.init(name: "Profile", bundle: nil)
        let popupVC = story.instantiateViewController(withIdentifier: "ChooseAddressVC") as! ChooseAddressVC
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.delegate = self
        self.present(popupVC, animated: true)
    }
    
    func changePhone() {
        let story = UIStoryboard.init(name: "CartFlow", bundle: nil)
        let popupVC = story.instantiateViewController(withIdentifier: "ChangePhoneVC") as! ChangePhoneVC
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.delegate = self
        self.present(popupVC, animated: true)
    }
}
extension GroceryCartVC: ChangePhoneNumberDelegate {
    func changesNumber(updatedNumber: String) {
        GroceryCartData.shared.alternateNumber = updatedNumber
        cartTableView.reloadData()
    }
}
extension GroceryCartVC: GroceryCartItemDelegate {
    func deleteItem(index: Int) {
        guard GroceryCartData.shared.cartItems.indices.contains(index) else { return }
        let itemId = GroceryCartData.shared.cartItems[index].id
        GroceryCartData.shared.removeItem(with: itemId)
        self.refreshView()
    }

    func refreshItemList() {
        self.refreshView()
    }

    func updateQuantity(index: Int, change: Int) {
        guard GroceryCartData.shared.cartItems.indices.contains(index) else { return }
        let cartItem = GroceryCartData.shared.cartItems[index]
        let newQuantity = cartItem.quantity + change

        if newQuantity <= 0 {
            GroceryCartData.shared.removeItem(with: cartItem.id)
        } else {
            GroceryCartData.shared.updateQuantity(for: cartItem.id, newQuantity: newQuantity)
        }

        self.refreshView()
    }
}
extension GroceryCartVC: GroceryCheckoutDelegate {
    func emptyAction() {
        let alertController = UIAlertController(title: "Empty cart", message: "Are you sure want to empty?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
            GroceryCartData.shared.clearCart()
            self.refreshView()
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
    
    func checkoutAction() {
       
    }
   
}
extension GroceryCartVC: DateChangedDelegate {
    func dateChanged() {
        self.proceedAction()
    }
}
extension GroceryCartVC: ItemDetailsDelegate {
    func itemClosed() {
        closedPopup()
    }
    
    func openSelectSize(index: IndexPath) {
        self.addItemSelection(index: index)
    }
    
    func addItemSelection(index: IndexPath) {
        /*
        if GroceryCartData.shared.restDetails == nil {
            GroceryCartData.shared.restDetails = GroceryCartData.shared.tempRestDetails
            //self.navigateToMenuDetails(index: index)
            self.closedPopup()
        }
        else if GroceryCartData.shared.restDetails.rid != GroceryCartData.shared.tempRestDetails.rid {
            if GroceryCartData.shared.cartData.count > 0 {
                let alertController = UIAlertController(title: "Replace cart item?", message: "Your cart contains dishes from \(GroceryCartData.shared.restDetails.name). Do you want to discart the selection and add dishes from \(GroceryCartData.shared.tempRestDetails.name)?", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
                    GroceryCartData.shared.cartData.removeAll()
                    GroceryCartData.shared.restDetails = GroceryCartData.shared.tempRestDetails
                   // self.navigateToMenuDetails(index: index)
                    self.closedPopup()
                    
                }
                let cancel = UIAlertAction(title: "Cancel", style: .cancel) { alert in
                    
                }
                alertController.addAction(OKAction)
                alertController.addAction(cancel)
                OperationQueue.main.addOperation {
                    self.present(alertController, animated: true,
                                 completion:nil)
                }
            } else {
                GroceryCartData.shared.restDetails = GroceryCartData.shared.tempRestDetails
                //self.navigateToMenuDetails(index: index)
                self.closedPopup()
            }
                }
        else {
            
            let newItem = completeItemList[index.section].itemList[index.row]
            GroceryCartData.shared.itemData = newItem
            var newSize = GroceryCartData.shared.getAllSizes(menu: GroceryCartData.shared.tempRestmenu, item: newItem, isCatering: false, menuType: "")[0]
            newSize.itemQty = 1
            GroceryCartData.shared.itemSizes = [Sizes]()
            GroceryCartData.shared.itemSizes.append(newSize)
            GroceryCartData.shared.selectedTopping = [SelectedTopping]()
            GroceryCartData.shared.itemExtra = 0.0
            GroceryCartData.shared.instructionText = ""
            GroceryCartData.shared.itemExtra = 0.0
            GroceryCartData.shared.addInCart()
            self.closedPopup()
            self.refreshView()
        }
        */
    }
}
extension GroceryCartVC: OpenItemDetailDelegate {
    func addItemInList(index: IndexPath) {
        /*
        let menu = completeItemList[index.section]
        let newItem = completeItemList[index.section].itemList[index.row]
        let displaySection = DisplaySection.init(parentID: menu.id, parent: menu.heading, title: newItem.heading, items: [newItem])
        GroceryCartData.shared.itemData = newItem
        var newSize = GroceryCartData.shared.getAllSizes(menu: displaySection, item: newItem, isCatering: false, menuType: "")[0]
            newSize.itemQty = 1
            GroceryCartData.shared.itemSizes = [Sizes]()
            GroceryCartData.shared.itemSizes.append(newSize)
            GroceryCartData.shared.selectedTopping = [SelectedTopping]()
        GroceryCartData.shared.itemExtra = 0.0
        GroceryCartData.shared.instructionText = ""
        GroceryCartData.shared.itemExtra = 0.0
        GroceryCartData.shared.addInCart()
        self.refreshView()
        */
        
    }
    
    func selectedItem(index: IndexPath) {
        //self.openItemDetails(itemlist: completeItemList[index.section].itemList[index.row], index: index)
    }
    
}
