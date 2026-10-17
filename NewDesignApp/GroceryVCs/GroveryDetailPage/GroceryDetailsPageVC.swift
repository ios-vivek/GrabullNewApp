//
//  RestDetailsVC.swift
//  Grabul
//
//  Created by Vivek SIngh on 08/08/24.
//  Copyright © 2024 Omnie. All rights reserved.
// Menu catering Specials Dining

import UIKit
import Lottie

class GroceryDetailsPageVC: UIViewController {
    
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
    //var restDetailsRes: RestDetailsRes?
    var cartView: GroceryCartView!
    var isOpen = false
    var selectedFiler = -1
    var galleryImages = [String]()
    
    ////use things
    var storeDetails: StoreDetails?
    var imageUrl = ""
    private var allSectionsMenus = [ExpandedGroceryMenuCategory]()
    private var displaySectionsMenus = [ExpandedGroceryMenuCategory]()



    override func viewDidLoad() {
        super.viewDidLoad()
 
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
        restaurantTable.register(UINib(nibName: "ItemHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ItemHeaderView")
        restaurantTable.sectionHeaderTopPadding = 0
        menuView.backgroundColor = .gGray100
        menuHeadingCollection.backgroundColor = .clear
        cartView.delegate = self
        self.view.backgroundColor = themeBackgrounColor
        restaurantTable.backgroundColor = .white
        restaurantName.textColor = .white
        restaurantName.text = storeDetails?.name ?? ""
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
        cartLbl.text = "\(GroceryCartData.shared.cartItems.count)"
        cartView.isHidden = GroceryCartData.shared.cartItems.count > 0 ? false : true
        getMenuList()
        getSectionArray()
        setImages()
        GroceryCartData.shared.tempStoreDetails = self.storeDetails

    }
    func getSectionArray() {
        guard let menus = storeDetails?.menuList else {
            allSectionsMenus = []
            displaySectionsMenus = []
            return
        }
        
        allSectionsMenus = expandSubmenuCategories(menus)
        getMenuList()
    }
    
    func expandSubmenuCategories(_ categories: [GroceryMenuCategory]) -> [ExpandedGroceryMenuCategory] {
        var expanded: [ExpandedGroceryMenuCategory] = []
        
        for category in categories {
            if category.hasSuperMenu == true, let submenus = category.itemListSub {
                // Add each submenu as a separate expanded category with parent info
                for submenu in submenus {
                    let expandedCategory = ExpandedGroceryMenuCategory(
                        parentId: category.id,
                        parentHeading: category.heading,
                        subHeadingId: submenu.id,
                        subHeading: submenu.heading,
                        itemList: submenu.itemList
                    )
                    expanded.append(expandedCategory)
                }
            } else {
                // Keep regular categories as is
                let expandedCategory = ExpandedGroceryMenuCategory(
                    parentId: category.id,
                    parentHeading: category.heading,
                    subHeadingId: nil,
                    subHeading: nil,
                    itemList: category.itemList
                )
                expanded.append(expandedCategory)
            }
        }
        
        return expanded
    }
   
    func setImages() {
        galleryImages = Array(Set(
            displaySectionsMenus
                .flatMap { $0.itemList ?? [] }
                .compactMap { $0.itemImage }
                .filter { !$0.isEmpty }
        ))
        if !imageUrl.isEmpty {
            galleryImages.append(imageUrl)
        }
    }
    func getMenuList() {
        if selectedFiler == -1 {
            // Show all sections
            displaySectionsMenus = allSectionsMenus
        } else if selectedFiler >= 0 && selectedFiler < allSectionsMenus.count {
            // Show only the selected section
            displaySectionsMenus = [allSectionsMenus[selectedFiler]]
        } else {
            // Fallback to all sections if index is invalid
            displaySectionsMenus = allSectionsMenus
        }
        
        menuHeadingCollection.reloadData()
        restaurantTable.reloadData()
    }

    @IBAction func allBtnAction() {
        selectedFiler = -1
        self.getMenuList()
    }
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    func navigateToMenuDetails(index: IndexPath) {
        
        let story = UIStoryboard.init(name: "Grocery", bundle: nil)
        let popupVC = story.instantiateViewController(withIdentifier: "ItemSizesPopupVC") as! ItemSizesPopupVC
        let menu = displaySectionsMenus[index.section - sectionOffset]
        
        guard let item = menu.itemList?[index.row] else {
            return // Invalid index or no items
        }
        
        popupVC.groceryMenuWithItem = GroceryMenuWithItem(
            parentId: menu.parentId,
            parentHeading: menu.parentHeading,
            subHeadingId: menu.subHeadingId,
            subHeading: menu.subHeading,
            item: item
        )
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
                menuView.isHidden = yPosition >= -577 ? true : false
            restaurantName.isHidden = yPosition >= -177 ? true : false
            } else if let _ = scrollView as? UICollectionView {
              print("collectionview")
            }
       
    }
    @objc func profileTapAction(_ sender: UITapGestureRecognizer? = nil) {
        let vc = self.viewController(viewController: GroceryCartVC.self, storyName: StoryName.Grocery.rawValue) as! GroceryCartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
extension GroceryDetailsPageVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return GrocerySection.Items.rawValue + displaySectionsMenus.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == GrocerySection.Menu.rawValue {
            return 1
        }
        if section == GrocerySection.Featured.rawValue {
                return 0
        }
        if section == GrocerySection.Deals.rawValue {
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
         //  cell.updateUI(offer: self.restDetailsData?.offer ?? [CustOfferlist]())
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
           
                cell.updateUI(menulist: self.allSectionsMenus, selectedFiler: self.selectedFiler)
                cell.featuredCollection.reloadData()
            return cell
        default:
            if GrocerySection.Items.rawValue >= 0 {
                let menu = displaySectionsMenus[indexPath.section - sectionOffset]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryItemTVCell", for: indexPath) as! GroceryItemTVCell
                    cell.selectionStyle = .none
                    cell.delegate = self
                    cell.selectedIndex = indexPath
                if let item = menu.itemList?[indexPath.row] {
                    cell.updateUI(itemlist: item)
                }
                    cell.dividerImage.isHidden = false
              if indexPath.row + 1 == menu.itemList?.count {
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
            return 50
    }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section >= GrocerySection.Items.rawValue {
            let sec = section - sectionOffset
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ItemHeaderView") as! ItemHeaderView
            let sectionHeader = displaySectionsMenus[sec]
            
            // Build header text with parent and sub heading hierarchy
            if let subHeading = sectionHeader.subHeading {
                headerView.headingLbl.text = "\(subHeading)"
            } else {
                headerView.headingLbl.text = sectionHeader.parentHeading
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
            return allSectionsMenus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodMenuCVCell", for: indexPath as IndexPath) as! FoodMenuCVCell
        cell.backgroundColor = .white
        let menuItem = allSectionsMenus[indexPath.row]
        
        // Show parent heading or parent > sub hierarchy
        if let subHeading = menuItem.subHeading {
            cell.menu.text = "\(subHeading)"
        } else {
            cell.menu.text = menuItem.parentHeading
        }
        
        cell.menu.textColor = selectedFiler == indexPath.row ? themeBackgrounColor : .black
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.clear.cgColor
        return cell

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
        self.getMenuList()
        restaurantTable.reloadData()
        menuHeadingCollection.reloadData()
    }
}
extension GroceryDetailsPageVC: OpenCartViewDelegate {
    func openCartView() {
        let vc = self.viewController(viewController: GroceryCartVC.self, storyName: StoryName.Grocery.rawValue) as! GroceryCartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension GroceryDetailsPageVC: GroceryItemCellDelegate {
    func addItemSelection(index: IndexPath) {
        
        let cart = GroceryCartData.shared
        
        // Helper function to proceed
        func proceed() {
            cart.storeDetails = cart.tempStoreDetails
            self.navigateToMenuDetails(index: index)
        }
        
        // Case 1: No store yet
        guard let currentStore = cart.storeDetails else {
            proceed()
            return
        }
        
        // Case 2: Same store
        if currentStore.rid == cart.tempStoreDetails?.rid {
            proceed()
            return
        }
        
        // Case 3: Different store + cart has items
        if cart.cartItems.count > 0 {
            let alertController = UIAlertController(
                title: "Replace cart item?",
                message: "Your cart contains dishes from \(currentStore.name ?? ""). Do you want to discard the selection and add dishes from \(cart.tempStoreDetails?.name ?? "")?",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                cart.clearCart()
                proceed()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            DispatchQueue.main.async {
                self.present(alertController, animated: true)
            }
            
        } else {
            // Case 4: Different store but empty cart
            proceed()
        }
    }
}
extension GroceryDetailsPageVC: ItemSizesPopupDelegate {
    func openSelectSize(index: IndexPath) {
        self.addItemSelection(index: index)
    }
    
    func itemAddedInTheCart() {
        GroceryCartData.shared.storeDetails = GroceryCartData.shared.tempStoreDetails
        self.showToast(message: "Item added in the cart.", font: .boldSystemFont(ofSize: 14.0))
        cartLbl.text = "\(GroceryCartData.shared.cartItems.count)"
        cartView.isHidden = GroceryCartData.shared.cartItems.count > 0 ? false : true
        cartView.updateUI()
    }
}
    
