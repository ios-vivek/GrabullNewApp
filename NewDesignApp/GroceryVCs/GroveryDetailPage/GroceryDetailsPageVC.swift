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


class GroceryDetailsPageVC: UIViewController, GroceryItemCellDelegate, ItemSizesPopupDelegate {
    func openSelectSize(index: IndexPath) {
        self.addItemSelection(index: index)
    }
    
    func itemAddedInTheCart() {
        self.showToast(message: "Item added in the cart.", font: .boldSystemFont(ofSize: 14.0))
        cartLbl.text = "\(GroceryCartData.shared.cartData.count)"
        cartView.isHidden = GroceryCartData.shared.cartData.count > 0 ? false : true
        cartView.updateUI()
    }
    
    func addItemSelection(index: IndexPath) {
        handleCartBeforeAdd(index: index)
        
        if GroceryCartData.shared.restDetails == nil {
            GroceryCartData.shared.restDetails = GroceryCartData.shared.tempRestDetails
            self.navigateToMenuDetails(index: index)
        }
        else if GroceryCartData.shared.restDetails.rid != GroceryCartData.shared.tempRestDetails.rid {
            if GroceryCartData.shared.cartData.count > 0 {
                let alertController = UIAlertController(title: "Replace cart item?", message: "Your cart contains dishes from \(GroceryCartData.shared.restDetails.name). Do you want to discart the selection and add dishes from \(GroceryCartData.shared.tempRestDetails.name)?", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
                    GroceryCartData.shared.cartData.removeAll()
                    GroceryCartData.shared.restDetails = GroceryCartData.shared.tempRestDetails
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
                GroceryCartData.shared.restDetails = GroceryCartData.shared.tempRestDetails
                self.navigateToMenuDetails(index: index)
            }
                }
        else {
            GroceryCartData.shared.restDetails = GroceryCartData.shared.tempRestDetails
            self.navigateToMenuDetails(index: index)
        }
        
    }
    func handleCartBeforeAdd(index: IndexPath) {
        guard let currentRest = GroceryCartData.shared.restDetails else {
            GroceryCartData.shared.restDetails = GroceryCartData.shared.tempRestDetails
            navigateToMenuDetails(index: index)
            return
        }

        if currentRest.rid != GroceryCartData.shared.tempRestDetails.rid,
           !GroceryCartData.shared.cartData.isEmpty {
            showReplaceCartAlert(index: index)
        } else {
            GroceryCartData.shared.restDetails = GroceryCartData.shared.tempRestDetails
            navigateToMenuDetails(index: index)
        }
    }
    func showReplaceCartAlert(index: IndexPath) {
        let alert = UIAlertController(
            title: "Replace cart item?",
            message: "Your cart contains dishes from \(GroceryCartData.shared.restDetails.name).",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            GroceryCartData.shared.cartData.removeAll()
            GroceryCartData.shared.restDetails = GroceryCartData.shared.tempRestDetails
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
    
    var cartView: GroceryCartView!
    var isOpen = false
   // var restData: RestData?
    var restDetailsData: CustomRestDetails?
    var allMenuList = [CustMenuCategory]()
    var selectedMenuType: MenuType = .menu
    var isReservationAvailable = false
    var selectedFiler = -1
    var galleryImages = [String]()
    
    ////use things
    var storeDetails: StoreDetails?
    var imageUrl = ""
    private var displaySectionsMenus = [GroceryMenuCategory]()



    override func viewDidLoad() {
        super.viewDidLoad()
        if restDetailsData != nil && GroceryCartData.shared.tempRestDetails != nil {
            if (restDetailsData!.rid != GroceryCartData.shared.tempRestDetails.rid) {
                GroceryCartData.shared.resetTime()
            }
        }
       // GroceryCartData.shared.tempRestDetails = restDetailsData!

//        if restDetailsData!.dinein == "Yes" {
//            isReservationAvailable = true
//        }
        menuImageView.play()
        menuImageView.loopMode = .loop
        navView.backgroundColor = themeBackgrounColor
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(profileTapAction(_:)))
        userProfileIcon.addGestureRecognizer(profileTap)
        cartView = GroceryCartView(frame: CGRect(x: 0, y: self.view.frame.size.height - 70, width: self.view.frame.size.width, height: 70))
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
        cartLbl.text = "\(GroceryCartData.shared.cartData.count)"
        self.allMenuList = [CustMenuCategory]()
        if let meuList = self.restDetailsData?.menuList {
            self.allMenuList = meuList
        }
        cartView.isHidden = GroceryCartData.shared.cartData.count > 0 ? false : true
        getMenuList()
        setImages()
        getAllDataFromListForTable()

        getSectionArray()

    }
    func getSectionArray() {
        guard let menus = storeDetails?.menuList else {
            displaySectionsMenus = []
            return
        }
        
        displaySectionsMenus = menus
        restaurantTable.reloadData()
    }
    func getAllDataFromListForTable() {
        if let restData = restDetailsRes {
            menuSections = getDataFroDisplayFromList(list: restData.menuList)
        }
    }
    func getDataFroDisplayFromList(list : [MenuCategory]) -> [DisplaySection] {
        var sections: [DisplaySection] = []
       
        return sections
    }
   
    func setImages() {
        galleryImages = Array(Set(
            restDetailsData?.menuList
                .flatMap { $0.itemList }
                .compactMap { $0.itemImage }
                .filter { !$0.isEmpty } ?? []
        ))
        galleryImages.append(imageUrl)
    }
    func getMenuList() {
        if selectedMenuType == .menu {
           // filteredMenuSections = getMenusData()
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
        
        let story = UIStoryboard.init(name: "Grocery", bundle: nil)
        let popupVC = story.instantiateViewController(withIdentifier: "ItemSizesPopupVC") as! ItemSizesPopupVC
            var menu = self.menuSections[index.section - sectionOffset]
            if selectedFiler > 0 {
               // menu = self.filteredMenuSections[index.section - sectionOffset]
               // popupVC.restmenu = DisplaySection.init(parentID: menu.parentID, parent: menu.parent, title: menu.title, items: [menu.items[index.row]])
            } else {
               // popupVC.restmenu = DisplaySection.init(parentID: menu.parentID, parent: menu.parent, title: menu.title, items: [menu.items[index.row]])
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
        let vc = self.viewController(viewController: GroceryCartVC.self, storyName: StoryName.Grocery.rawValue) as! GroceryCartVC
        GroceryCartData.shared.tempAllRestmenu = self.allMenuList
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
extension GroceryDetailsPageVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
       // if selectedMenuType == .menu {
            //if selectedFiler > 0 {
               // return GrocerySection.Items.rawValue + filteredMenuSections.count
           // } else {
        return GrocerySection.Items.rawValue + displaySectionsMenus.count
       //     }
      //  }
      //      return GrocerySection.Items.rawValue + menuSections.count
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
            let itemCount = displaySectionsMenus[section - sectionOffset].itemList?.count ?? 0
            return itemCount
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case GrocerySection.RestDetails.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreDetailsTVCell", for: indexPath) as! StoreDetailsTVCell
            cell.selectionStyle = .none
            cell.updateUI(data: self.storeDetails, restImage: imageUrl, galleryImages: self.galleryImages)
            cell.delegate = self
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryMenuTVCell", for: indexPath) as! GroceryMenuTVCell
            cell.selectionStyle = .none
            cell.delegate = self
           
                cell.updateUI(menulist: self.displaySectionsMenus, selectedFiler: self.selectedFiler)
                cell.featuredCollection.reloadData()
            return cell
        default:
            if GrocerySection.Items.rawValue >= 0 {
                let menu = displaySectionsMenus[indexPath.section - sectionOffset]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryItemTVCell", for: indexPath) as! GroceryItemTVCell
                    cell.selectionStyle = .none
                    //cell.delegate = self
                    cell.selectedIndex = indexPath
                cell.updateUI(itemlist: menu.itemList![indexPath.row])
                    cell.dividerImage.isHidden = false
              if indexPath.row + 1 == menu.itemList!.count {
                        cell.dividerImage.isHidden = true
                }
                    return cell
                
           
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
                let sectionHeader = displaySectionsMenus[sec]
                    headerView.headingLbl.text = sectionHeader.heading
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
                    default:
                        return 200
                    }
            }
            
            return 200
        }
    }
        
}
extension GroceryDetailsPageVC: GroceryGalleryDelegate {
    
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
            return displaySectionsMenus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodMenuCVCell", for: indexPath as IndexPath) as! FoodMenuCVCell
        cell.backgroundColor = .white
            cell.menu.text = displaySectionsMenus[indexPath.row].heading//self.allMenuList[indexPath.row].heading
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
extension GroceryDetailsPageVC: GroceryMenuSelectedDelegate {
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
    }
}
extension GroceryDetailsPageVC: OpenCartViewDelegate {
    func openCartView() {
        let vc = self.viewController(viewController: GroceryCartVC.self, storyName: StoryName.Grocery.rawValue) as! GroceryCartVC
        GroceryCartData.shared.tempAllRestmenu = self.allMenuList
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
