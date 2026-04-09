//
//  RestDetailsVC.swift
//  Grabul
//
//  Created by Vivek SIngh on 08/08/24.
//  Copyright © 2024 Omnie. All rights reserved.
// Menu catering Specials Dining

import UIKit
import Lottie
import SafariServices


class GroceryDetailsPageVC: UIViewController, ItemCellDelegate, ItemAddedInCartDelegate {
    func openSelectSize(index: IndexPath) {
        self.addItemSelection(index: index)
    }
    
    func itemAddedInTheCart() {
        self.showToast(message: "Item added in the cart.", font: .boldSystemFont(ofSize: 14.0))
        cartLbl.text = "\(Cart.shared.cartData.count)"
        cartView.isHidden = Cart.shared.cartData.count > 0 ? false : true
        cartView.updateUI()
    }
    
    func addItemSelection(index: IndexPath) {
        handleCartBeforeAdd(index: index)
        
        if Cart.shared.restDetails == nil {
            Cart.shared.restDetails = Cart.shared.tempRestDetails
            self.navigateToMenuDetails(index: index)
        }
        else if Cart.shared.restDetails.rid != Cart.shared.tempRestDetails.rid {
            if Cart.shared.cartData.count > 0 {
                let alertController = UIAlertController(title: "Replace cart item?", message: "Your cart contains dishes from \(Cart.shared.restDetails.name). Do you want to discart the selection and add dishes from \(Cart.shared.tempRestDetails.name)?", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
                    Cart.shared.cartData.removeAll()
                    Cart.shared.restDetails = Cart.shared.tempRestDetails
                    self.navigateToMenuDetails(index: index)
                    
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
                Cart.shared.restDetails = Cart.shared.tempRestDetails
                self.navigateToMenuDetails(index: index)
            }
                }
        else {
            Cart.shared.restDetails = Cart.shared.tempRestDetails
            self.navigateToMenuDetails(index: index)
        }
        
    }
    func handleCartBeforeAdd(index: IndexPath) {
        guard let currentRest = Cart.shared.restDetails else {
            Cart.shared.restDetails = Cart.shared.tempRestDetails
            navigateToMenuDetails(index: index)
            return
        }

        if currentRest.rid != Cart.shared.tempRestDetails.rid,
           !Cart.shared.cartData.isEmpty {
            showReplaceCartAlert(index: index)
        } else {
            Cart.shared.restDetails = Cart.shared.tempRestDetails
            navigateToMenuDetails(index: index)
        }
    }
    func showReplaceCartAlert(index: IndexPath) {
        let alert = UIAlertController(
            title: "Replace cart item?",
            message: "Your cart contains dishes from \(Cart.shared.restDetails.name).",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            Cart.shared.cartData.removeAll()
            Cart.shared.restDetails = Cart.shared.tempRestDetails
            self.navigateToMenuDetails(index: index)
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @IBOutlet weak var restaurantTable: UITableView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var menuHeadingCollection: UICollectionView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var userProfileIcon: UIImageView!
    @IBOutlet weak var cartLbl: UILabel!
    @IBOutlet weak var menuImageView: LottieAnimationView!
    @IBOutlet weak var allBtn: UIButton!
    
    private let sectionOffset = GrocerySection.Items.rawValue
    var restDetailsRes: RestDetailsRes?
    private var menuSections: [DisplaySection] = []
    private var cateringSections: [DisplaySection] = []
    private var filteredMenuSections: [DisplaySection] = []
    private var specialSections: [DisplaySection] = []

    
    var cartView: CartView!
    var isOpen = false
    var restData: RestData?
    var restDetailsData: CustomRestDetails?
    var allMenuList = [CustMenuCategory]()
    var selectedMenuType: MenuType = .menu
    var isReservationAvailable = false
    var selectedFiler = -1
    var galleryImages = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        if restDetailsData != nil && Cart.shared.tempRestDetails != nil {
            if (restDetailsData!.rid != Cart.shared.tempRestDetails.rid) {
                Cart.shared.resetTime()
            }
        }
        Cart.shared.tempRestDetails = restDetailsData!

        if restDetailsData!.dinein == "Yes" {
            isReservationAvailable = true
        }
        menuImageView.play()
        menuImageView.loopMode = .loop
        navView.backgroundColor = themeBackgrounColor
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(profileTapAction(_:)))
        userProfileIcon.addGestureRecognizer(profileTap)
        cartView = CartView(frame: CGRect(x: 0, y: self.view.frame.size.height - 70, width: self.view.frame.size.width, height: 70))
        self.view.addSubview(cartView)
        cartView.isHidden = true
        menuView.isHidden = true
        restaurantName.isHidden = true
        restaurantName.text = "\(restDetailsData?.name ?? "")"
        restaurantTable.register(UINib(nibName: "ItemHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ItemHeaderView")
        restaurantTable.sectionHeaderTopPadding = 0
        menuView.backgroundColor = .gGray100
        menuHeadingCollection.backgroundColor = .clear
        cartView.delegate = self
        self.view.backgroundColor = themeBackgrounColor
        restaurantTable.backgroundColor = .white
        restaurantName.textColor = .white
        themeSet()
        self.setDefaultBack()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // print("Invalidate timer")
        APPDELEGATE.timr.invalidate()
    }
    func themeSet() {
        cartLbl.textColor = themeTitleColor
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartLbl.text = "\(Cart.shared.cartData.count)"
        self.allMenuList = [CustMenuCategory]()
        if let meuList = self.restDetailsData?.menuList {
            self.allMenuList = meuList
        }
        cartView.isHidden = Cart.shared.cartData.count > 0 ? false : true
        getMenuList()
        setImages()
        getAllDataFromListForTable()

        restaurantTable.reloadData()

    }
    func getAllDataFromListForTable() {
        if let restData = restDetailsRes {
            menuSections = getDataFroDisplayFromList(list: restData.menuList)
            cateringSections = getDataFroDisplayFromList(list: restData.cateringList)
            getAllSpecialDealsMenu()
        }
    }
    func getDataFroDisplayFromList(list : [MenuCategory]) -> [DisplaySection] {
        var sections: [DisplaySection] = []
        cateringSections = list.flatMap { catering in
            // If direct items exist
            if !catering.itemList.isEmpty {
                sections.append(DisplaySection(
                    parentID: catering.id, parent: catering.heading,
                    title: catering.heading,
                    items: catering.itemList
                ))
            }
            
            // Handle submenu (IMPORTANT FIX)
            for subMenu in catering.menuList {
                sections.append(DisplaySection(
                    parentID: catering.id, parent: catering.heading,
                    title: subMenu.heading,
                    items: subMenu.itemList
                ))
            }
            return sections
            
        }
        return sections
    }
    func getAllSpecialDealsMenu() {
        guard let offers = restDetailsData?.offer else { return }
        specialSections = [DisplaySection]()
        var grouped: [String: DisplaySection] = [:]

        for offer in offers {
            guard let itemId = offer.itemId else { continue }

            for section in menuSections {
                if let item = section.items.first(where: { $0.id == itemId }) {
                    if var existing = grouped[section.parentID] {
                        existing.items.append(item)
                        grouped[section.parentID] = existing
                    } else {
                        grouped[section.parentID] = DisplaySection(
                            parentID: section.parentID,
                            parent: section.parent,
                            title: section.title,
                            items: [item]
                        )
                    }
                }
            }
        }

        specialSections = Array(grouped.values)
    }
    func setImages() {
        galleryImages = Array(Set(
            restDetailsData?.menuList
                .flatMap { $0.itemList }
                .compactMap { $0.itemImage }
                .filter { !$0.isEmpty } ?? []
        ))
        galleryImages.append(self.restData?.restImgUrl ?? "")
    }
    func getMenuList() {
        if selectedMenuType == .menu {
            filteredMenuSections = getMenusData()
        }
        else {
            filteredMenuSections = getCategoryData()
        }
        menuHeadingCollection.reloadData()
        restaurantTable.reloadData()
    }
    func getMenusData()-> [DisplaySection]{
        if selectedFiler >= 0 {
            let arr: [DisplaySection] = self.menuSections.filter{ ($0.parent.contains(self.menuSections[selectedFiler].parent)) }
            if arr.count > 0 {
                return arr
            }
        }
        return [DisplaySection]()
    
    }
    
    func getCategoryData()-> [DisplaySection]{
        if selectedFiler >= 0 {
            let arr: [DisplaySection] = self.cateringSections.filter{ ($0.title.contains(self.cateringSections[selectedFiler].title)) }
            if arr.count > 0 {
                return arr
            }
        }
        return [DisplaySection]()
    
    }

    @IBAction func allBtnAction() {
        selectedFiler = -1
        self.getMenuList()
    }
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    func showMenuOption()-> Bool {
        if [.deals, .dineIn].contains(selectedMenuType) {
            return false
        }
        return true
    }
    func navigateToMenuDetails(index: IndexPath) {
        
        let story = UIStoryboard.init(name: "OrderFlow", bundle: nil)
        let popupVC = story.instantiateViewController(withIdentifier: "ItemSizeSelectionPopupVC") as! ItemSizeSelectionPopupVC
        if selectedMenuType == .menu {
            var menu = self.menuSections[index.section - sectionOffset]
            if selectedFiler > 0 {
                menu = self.filteredMenuSections[index.section - sectionOffset]
                popupVC.restmenu = DisplaySection.init(parentID: menu.parentID, parent: menu.parent, title: menu.title, items: [menu.items[index.row]])
            } else {
                popupVC.restmenu = DisplaySection.init(parentID: menu.parentID, parent: menu.parent, title: menu.title, items: [menu.items[index.row]])
            }
        } else if selectedMenuType == .catering {
            var menu = self.cateringSections[index.section - sectionOffset]
            if selectedFiler > 0 {
                menu = self.filteredMenuSections[index.section - sectionOffset]
                popupVC.restmenu = DisplaySection.init(parentID: menu.parentID, parent: menu.parent, title: menu.title, items: [menu.items[index.row]])
            } else {
                popupVC.restmenu = DisplaySection.init(parentID: menu.parentID, parent: menu.parent, title: menu.title, items: [menu.items[index.row]])
            }
        }
        else if selectedMenuType == .deals {
            let menu = self.specialSections[index.section - sectionOffset]
            popupVC.restmenu = DisplaySection.init(parentID: menu.parentID, parent: menu.parent, title: menu.title, items: [menu.items[index.row]])
        }
        popupVC.selectedMenuType = self.selectedMenuType
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        self.present(popupVC, animated: true)
         
        
    }
    func getItem(index: IndexPath, list: [CustMenuCategory])-> CustMenuCategory {
        let itemList = list[index.section - 5]
        let itemm: MenuItem
        if itemList.submenu == "Yes" {
            // Flatten all submenu items
            let allItems = itemList.submenuList?.flatMap { $0.itemList } ?? []
            itemm = allItems[index.row]
        } else {
            itemm = itemList.itemList[index.row]

        }
       // itemData = itemm
        return itemList
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //print("dd")
        self.view.endEditing(true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let _ = scrollView as? UITableView {
            let yPosition = -( scrollView.contentOffset.y+1)
           // print(yPosition)
//            if self.restDetailsData?.menutype[selectedmenuType] != "Specials" {
            if ![.deals, .dineIn].contains(selectedMenuType) {
                menuView.isHidden = yPosition >= -577 ? true : false
            }
//            }
            restaurantName.isHidden = yPosition >= -177 ? true : false
            } else if let _ = scrollView as? UICollectionView {
              print("collectionview")
            }
       
    }
    @objc func profileTapAction(_ sender: UITapGestureRecognizer? = nil) {
        let vc = self.viewController(viewController: CartVC.self, storyName: StoryName.CartFlow.rawValue) as! CartVC
        Cart.shared.tempAllRestmenu = self.allMenuList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func loadURLSafari(dineUrl: String) {
        let trimmedURL = dineUrl.trimmingCharacters(in: .whitespacesAndNewlines)
        print("url: \(trimmedURL)")

        guard let url = URL(string: trimmedURL),
              ["http", "https"].contains(url.scheme?.lowercased() ?? "") else {
            //hideProgress()
            return
        }

        UtilsClass.hideProgressHud(view: self.view)

        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .fullScreen
        present(safariVC, animated: true)
    }

}
extension GroceryDetailsPageVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if selectedMenuType == .menu {
            if selectedFiler > 0 {
                return GrocerySection.Items.rawValue + filteredMenuSections.count
            } else {
                return GrocerySection.Items.rawValue + menuSections.count
            }
        }
        if selectedMenuType == .deals {
            let count = specialSections.count > 0 ? specialSections.count : 1
            return GrocerySection.Items.rawValue + count
        }
        if selectedMenuType == .dineIn {
            return GrocerySection.Items.rawValue + 1
        }
        if selectedMenuType == .catering {
            if selectedFiler > 0 {
                return GrocerySection.Items.rawValue + filteredMenuSections.count
            } else {
                return GrocerySection.Items.rawValue + cateringSections.count
            }
        }
            return GrocerySection.Items.rawValue + menuSections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == GrocerySection.Menu.rawValue {
            return self.showMenuOption() ? 1 : 0
        }
        if section == GrocerySection.Deals.rawValue {
            return self.restDetailsData?.offer?.count ?? 0 > 0 ? 1 : 0
        }
        if section == GrocerySection.Featured.rawValue {
                return 0
        }
        if section >= GrocerySection.Items.rawValue {
            if selectedMenuType == .dineIn {
                return 0
            }
            if selectedMenuType == .deals {
                if specialSections.count == 0 {
                    return 1
                }
               return specialSections[section - sectionOffset].items.count
            }
            if selectedMenuType == .catering {
                if cateringSections.count == 0 {
                       return 1
                   }
                if selectedFiler > 0 {
                    return filteredMenuSections[section - sectionOffset].items.count
                } else {
                    return cateringSections[section - sectionOffset].items.count
                }
            }
            if selectedFiler > 0 {
                return filteredMenuSections[section - sectionOffset].items.count
            }
            return menuSections[section - sectionOffset].items.count
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case GrocerySection.RestDetails.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreDetailsTVCell", for: indexPath) as! StoreDetailsTVCell
            cell.selectionStyle = .none
            cell.updateUI(data: self.restDetailsData, restImage: restData?.restImgUrl ?? "", galleryImages: self.galleryImages)
            return cell
        case GrocerySection.Deals.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DealsTVCell", for: indexPath) as! DealsTVCell
            cell.selectionStyle = .none
            //cell.backgroundColor = .red
           cell.updateUI(offer: self.restDetailsData?.offer ?? [CustOfferlist]())
            return cell
        case GrocerySection.Featured.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedTVCell", for: indexPath) as! FeaturedTVCell
            cell.selectionStyle = .none
         //   cell.updateUI(featuredItems: self.restDetailsData?.featured_item)
            return cell
        case GrocerySection.Menu.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FoodMenuTVCell", for: indexPath) as! FoodMenuTVCell
            cell.selectionStyle = .none
            cell.delegate = self
            if selectedMenuType == .catering{
                cell.updateUI(menulist: self.cateringSections, selectedmenuType: selectedMenuType, selectedFiler: self.selectedFiler)
                cell.featuredCollection.reloadData()
            } else {
                cell.updateUI(menulist: self.menuSections, selectedmenuType: selectedMenuType, selectedFiler: self.selectedFiler)
                cell.featuredCollection.reloadData()
            }
            return cell
        default:
            if GrocerySection.Items.rawValue >= 0 {
                let itemSectionIndex = indexPath.section - sectionOffset

                if selectedMenuType == .deals {
                    if specialSections.count == 0 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataAvailableTVCell", for: indexPath) as! NoDataAvailableTVCell
                        cell.selectionStyle = .none
                        cell.updateUI(msg: "No Quick Meals Available order from Regular Menu")
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTVCell", for: indexPath) as! ItemTVCell

                        let item = self.specialSections[itemSectionIndex].items[indexPath.row]
                        cell.selectionStyle = .none
                        cell.delegate = self
                        cell.selectedIndex = indexPath
                            cell.updateUI(itemlist: item)
                        cell.dividerImage.isHidden = false
                        if indexPath.row + 1 == self.specialSections[itemSectionIndex].items.count {
                            cell.dividerImage.isHidden = true
                        }
                        return cell
                    }
                }

                if selectedMenuType == .dineIn && !isReservationAvailable{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataAvailableTVCell", for: indexPath) as! NoDataAvailableTVCell
                        cell.selectionStyle = .none
                        cell.updateUI(msg: "Does not take Reservations.")
                        return cell
                }
                if selectedMenuType == .catering {
                    if cateringSections.count == 0 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataAvailableTVCell", for: indexPath) as! NoDataAvailableTVCell
                        cell.selectionStyle = .none
                        cell.updateUI(msg: "No Catering Available order from Regular menu")
                        return cell
                    }
                    var menu = self.cateringSections[itemSectionIndex]
                    if selectedFiler > 0 {
                        menu = self.filteredMenuSections[itemSectionIndex]
                    }
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTVCell", for: indexPath) as! ItemTVCell
                    cell.selectionStyle = .none
                    cell.delegate = self
                    cell.selectedIndex = indexPath
                    cell.updateUI(itemlist: menu.items[indexPath.row])
                    cell.dividerImage.isHidden = false
                    if indexPath.row + 1 == menu.items.count {
                        cell.dividerImage.isHidden = true
                    }
                    return cell

                } else {
                    var menu = self.menuSections[itemSectionIndex]
                    if selectedFiler > 0 {
                        menu = self.filteredMenuSections[itemSectionIndex]
                    }

                    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTVCell", for: indexPath) as! ItemTVCell
                    cell.selectionStyle = .none
                    cell.delegate = self
                    cell.selectedIndex = indexPath
                    cell.updateUI(itemlist: menu.items[indexPath.row])
                    cell.dividerImage.isHidden = false
                    if indexPath.row + 1 == menu.items.count {
                        cell.dividerImage.isHidden = true
                    }
                    return cell
                }
           
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemHeadingTVCell", for: indexPath) as! ItemHeadingTVCell
            cell.selectionStyle = .none
            return cell
        }
       
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section >= GrocerySection.Items.rawValue {
            if [.deals, .dineIn].contains(selectedMenuType) {
                return 0
            }
            return 50
    }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section >= GrocerySection.Items.rawValue {
            let sec = section - sectionOffset
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ItemHeaderView") as! ItemHeaderView
            if selectedMenuType == .catering {
                var sectionHeader = self.cateringSections[sec]
                if selectedFiler > 0 {
                    sectionHeader = self.filteredMenuSections[sec]
                }
                    headerView.headingLbl.text = sectionHeader.title
                headerView.headingLbl.textColor = .black
                return headerView
            }
            if selectedMenuType == .deals {
                headerView.headingLbl.text = ""
            }
            else {
                var sectionHeader = self.menuSections[sec]
                if selectedFiler > 0 {
                    sectionHeader = self.filteredMenuSections[sec]
                }
                    headerView.headingLbl.text = sectionHeader.title
            }
            headerView.headingLbl.textColor = .black

            headerView.headerViewBckground.backgroundColor = UIColor.gGray100
            

            return headerView
    }
        return nil
    
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section >= GrocerySection.Items.rawValue {
            self.addItemSelection(index: indexPath)
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case GrocerySection.RestDetails.rawValue:
            return 250
        case GrocerySection.Deals.rawValue:
            return 70
        case GrocerySection.Featured.rawValue:
            return 150
        case GrocerySection.Menu.rawValue:
            return 50
        default:
            
            if indexPath.section >= GrocerySection.Items.rawValue {
                switch selectedMenuType {
                    case .deals:
                        return specialSections.isEmpty ? 100 : 200
                    case .dineIn:
                        return 100
                    default:
                        return 200
                    }
            }
            
            return 200
        }
    }
        
}
extension GroceryDetailsPageVC: GalleryDelegate {
    func scheduleDateAction() {
        let story = UIStoryboard.init(name: "OrderFlow", bundle: nil)
        let popupVC = story.instantiateViewController(withIdentifier: "ScheduleDateTimeVC") as! ScheduleDateTimeVC
        popupVC.delegate = self
        popupVC.isPickupDeliverySettingHide = true
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        self.present(popupVC, animated: true)

    }
    
    func selectedGalleryView() {
        let vc = self.viewController(viewController: RestImageGalleryVC.self, storyName: StoryName.Main.rawValue) as! RestImageGalleryVC

        vc.galleryImages = self.galleryImages
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension GroceryDetailsPageVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: collectionView.frame.height)
    }

}
extension GroceryDetailsPageVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return self.allMenuList.count
        if selectedMenuType == .catering {
            return cateringSections.count
        } else {
            return menuSections.count
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodMenuCVCell", for: indexPath as IndexPath) as! FoodMenuCVCell
        cell.backgroundColor = .white
        if selectedMenuType == .catering {
            cell.menu.text = cateringSections[indexPath.row].title//self.allMenuList[indexPath.row].heading
        } else {
            cell.menu.text = menuSections[indexPath.row].title//self.allMenuList[indexPath.row].heading
        }
            cell.menu.textColor = selectedFiler == indexPath.row ? themeBackgrounColor : .black
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.clear.cgColor
        return cell;

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedFiler = indexPath.row
        self.getMenuList()
    }
    
    
    
}
extension GroceryDetailsPageVC: MenuSelectedDelegate {
    func showAllData() {
        selectedFiler = -1
        self.getMenuList()
    }
    
    func openmenuItemSection(section: Int) {
        selectedFiler = section
        self.getMenuList()
    }
}
extension GroceryDetailsPageVC: MenuTypeSelectedDelegate {
    func selectedMenuType(menuType: MenuType) {
        selectedFiler = -1
        self.selectedMenuType = menuType
        self.getMenuList()
        restaurantTable.reloadData()
        menuHeadingCollection.reloadData()
        if menuType == .dineIn && isReservationAvailable {
            self.selectedMenuType = .menu
            self.restaurantTable.reloadData()
            loadURLSafari(dineUrl: "\(self.restDetailsData?.dineUrl ?? "")/\(APPDELEGATE.userResponse?.customer.customerId ?? "")")
            /*
            let story = UIStoryboard.init(name: "OrderFlow", bundle: nil)
            let popupVC = story.instantiateViewController(withIdentifier: "DineInVC") as! DineInVC
          print("DineIn url: \(self.restDetailsData?.dineUrl ?? "")/\(APPDELEGATE.userResponse?.customer.customerId ?? "")")
            popupVC.dineUrl = "\(self.restDetailsData?.dineUrl ?? "")/\(APPDELEGATE.userResponse?.customer.customerId ?? "")"
            self.selectedMenuType = .menu
            self.restaurantTable.reloadData()
            self.navigationController?.pushViewController(popupVC, animated: true)
            */
        }
    }
}
extension GroceryDetailsPageVC: OpenCartViewDelegate {
    func openCartView() {
        let vc = self.viewController(viewController: CartVC.self, storyName: StoryName.CartFlow.rawValue) as! CartVC
        Cart.shared.tempAllRestmenu = self.allMenuList
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension GroceryDetailsPageVC: DateChangedDelegate {
    func dateChanged() {
        restaurantTable.reloadData()
    }
    
}
