//
//  ItemSizeSelectionPopupVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 16/08/24.
//

import UIKit

// MARK: - Expanded Category with Hierarchy
struct GroceryMenuWithItem {
    let parentId: String?
    let parentHeading: String?
    let subHeadingId: String?
    let subHeading: String?
    let item: GroceryMenuItem
}

protocol ItemSizesPopupDelegate: AnyObject {
    func itemAddedInTheCart()
}
class ItemSizesPopupVC: UIViewController {
    @IBOutlet weak var addItemView: UIView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var itemCountLbl: UILabel!
    @IBOutlet weak var addLblView: UIView!
    @IBOutlet weak var plusMinusView: UIView!
    @IBOutlet weak var addeditmesPriceBtn: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var itemSelectionTbl: UITableView!
    @IBOutlet weak var itemNametLbl: UILabel!
    @IBOutlet weak var soldOutImage: UIImageView!
    
    var groceryMenuWithItem: GroceryMenuWithItem?

    var delegate: ItemSizesPopupDelegate?

    var selectedSize: Int = -1
    var itemQty: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        soldOutImage.isHidden = true
        addItemView.isHidden = false
        addeditmesPriceBtn.isHidden = false
        /*
        if itemData.status == "Sold out for today" {
            soldOutImage.isHidden = false
            soldOutImage.backgroundColor = .clear
            addItemView.isHidden = true
            addeditmesPriceBtn.isHidden = true
        }
        */
        // Do any additional setup after loading the view.
       
        itemSelectionTbl.register(UINib(nibName: "OptionsHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "OptionsHeaderView")
        itemSelectionTbl.sectionHeaderTopPadding = 0
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addItemView.layer.cornerRadius = 10
        addItemView.layer.borderColor = UIColor.lightGray.cgColor
        addItemView.layer.borderWidth = 1
        addLblView.backgroundColor = .clear
        addLblView.isHidden = true
        addeditmesPriceBtn.setRounded(cornerRadius: 10)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        addItemView.addGestureRecognizer(tap)
        addeditmesPriceBtn.setTitle("    Add Item | \(UtilsClass.getCurrencySymbol())0.00    ", for: .normal)
        addeditmesPriceBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        UtilsClass.shadow(Vw: cancelView, cornerRadius: 15)
        backView.layer.cornerRadius = 20
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(self.cancelTap(_:)))
        cancelView.addGestureRecognizer(cancelTap)
        itemSelectionTbl.backgroundColor = .clear
        
        itemNametLbl.text = groceryMenuWithItem?.item.heading
        itemNametLbl.textColor = kOrangeColor
        //itemQty = Int(restmenu.items[0].minQty)
//        if GroceryCartData.shared.getAllSizes(menu: restmenu, item: restmenu.items[0], isCatering: selectedMenuType == .catering ? true : false, menuType: GroceryCartData.shared.getMenuType(selectedMenuType: selectedMenuType)).count == 1 {
//            selectedSize = 0
//            GroceryCartData.shared.itemSizes = [Sizes]()
//            GroceryCartData.shared.itemSizes.append(GroceryCartData.shared.getAllSizes(menu: restmenu, item: restmenu.items[0], isCatering: selectedMenuType == .catering ? true : false, menuType: GroceryCartData.shared.getMenuType(selectedMenuType: selectedMenuType))[selectedSize])
//        } else {
//            GroceryCartData.shared.itemSizes = [Sizes]()
//        }
        
       // GroceryCartData.shared.itemSizes = [Sizes]()
        /*
        if RestaurantCartDeatils.shared.addedCartItems != nil && RestaurantCartDeatils.shared.addedCartItems.cartLists.count > 0 {
            print("---\(itemData.id)")
            RestaurantCartDeatils.shared.itemSizes = RestaurantCartDeatils.shared.getItemFromCartList(checkitem: itemData)!.restItemSizes
            RestaurantCartDeatils.shared.selectedTopping = RestaurantCartDeatils.shared.getItemFromCartList(checkitem: itemData)!.restItemTopping
        }
        */
        if groceryMenuWithItem?.item.sizeList?.count == 1 {
            selectedSize = 0
        }
        self.setAmountValue()
      //  customQtySetup()

    }
    func customQtySetup() {
        itemCountLbl.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.customQtyHandleTap(_:)))
        itemCountLbl.addGestureRecognizer(tap)
        
    }
    @objc func customQtyHandleTap(_ sender: UITapGestureRecognizer? = nil) {
        print("working...")
        showAlertWithTextField()
    }
    func showAlertWithTextField() {
        let alert = UIAlertController(title: "Custom Quantity", message: "Please enter quantity", preferredStyle: .alert)
        
        // Add text field
        alert.addTextField { textField in
            textField.placeholder = "Qty"
            textField.keyboardType = .numberPad
            if self.itemQty > 0 {
                textField.text = "\(self.itemQty)"
            }
        }

        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // OK action
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Access the text field value
            if let text = alert.textFields?.first?.text,
               let intValue = Int(text), intValue > 0 {
                print("User entered a valid number: \(intValue)")
                self.itemQty = Int(text)!
                self.setAmountValue()
            } else {
                print("Invalid input: not a number > 0")
                self.showAlert(title: "Invalid Input", msg: "Please enter valid quantity.")
            }
        }
        
        // Add actions to alert
        alert.addAction(cancelAction)
        alert.addAction(okAction)

        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code

    }
    @objc func cancelTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.dismiss(animated: true)
       
    }

    @IBAction func plusAction() {
        itemQty += 1
        setAmountValue()
    }
    @IBAction func minusAction() {
        if itemQty > 1 {
            itemQty -= 1
            setAmountValue()
        }
    }
    @IBAction func addItemInCart() {
       // let option = SelectedOption(optionHeading: topping[indexPath.section - 1].option![indexPath.row].heading, price: "")
        if selectedSize < 0 {
            let alert = UIAlertController(title: "Alert", message: "Please select size", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Add item to cart
        guard let menuItem = groceryMenuWithItem else { return }
        let selectedSizeOption = menuItem.item.sizeList?[selectedSize]
        
        GroceryCartData.shared.addItem(
            menuItem.item,
            size: selectedSizeOption,
            quantity: itemQty,
            parentId: menuItem.parentId,
            parentHeading: menuItem.parentHeading,
            subHeadingId: menuItem.subHeadingId,
            subHeading: menuItem.subHeading
        )
 
        self.dismiss(animated: true) {
            self.delegate?.itemAddedInTheCart()
        }
    }
    func setAmountValue() {
        itemCountLbl.text = "\(itemQty)"
        var price: Double = 0.0
        
        if selectedSize >= 0, let selectedSizeOption = groceryMenuWithItem?.item.sizeList?[selectedSize] {
            price = (selectedSizeOption.price ?? 0.0) * Double(itemQty)
        }
       
        addeditmesPriceBtn.setTitle("    Add Item | \(UtilsClass.getCurrencySymbol())\(String(format: "%.2f", price))    ", for: .normal)

        
    }

}
extension ItemSizesPopupVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryMenuWithItem?.item.sizeList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemSizeTVCell", for: indexPath) as! ItemSizeTVCell

        cell.selectionStyle = .none
        cell.backgroundColor = .white

        if let size = groceryMenuWithItem?.item.sizeList?[indexPath.row] {
            cell.sizeNameLbl.text = size.name ?? ""
            let price = size.price ?? 0.0
            let formattedPrice = String(format: "%.2f", price)
            
            cell.priceLbl.attributedText = cell.priceServeAttributedText(
                price: "\(UtilsClass.getCurrencySymbol())\(formattedPrice)",
                serve: "")
            cell.groceryUpdateUIForSelectSize(indexPath: indexPath, sizes: (groceryMenuWithItem?.item.sizeList)!, selectedSize: selectedSize)
        }

        return cell
        
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectedSize = indexPath.row
         
       
        tableView.reloadData()
        setAmountValue()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 40
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > 0 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "OptionsHeaderView") as! OptionsHeaderView

            return headerView
    }
        return nil
    
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
        
}
