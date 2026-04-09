//
//  ItemSizeSelectionPopupVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 16/08/24.
//

import UIKit
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

    var delegate: ItemSizesPopupDelegate?
//let arr = ["Half", "Medium", "Full"]
    var restmenu: DisplaySection!
    //var restmenu: CustMenuCategory!

    var selectedSize: Int = -1
    var itemQty: Int = 1
    var selectedMenuType: MenuType = .menu

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
        addeditmesPriceBtn.setTitle("    Add Item | \(UtilsClass.getCurrencySymbol())220    ", for: .normal)
        addeditmesPriceBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        UtilsClass.shadow(Vw: cancelView, cornerRadius: 15)
        backView.layer.cornerRadius = 20
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(self.cancelTap(_:)))
        cancelView.addGestureRecognizer(cancelTap)
        itemSelectionTbl.backgroundColor = .clear
        
        itemNametLbl.text = restmenu.items[0].heading
        itemNametLbl.textColor = kOrangeColor
        itemQty = Int(restmenu.items[0].minQty)
        if Cart.shared.getAllSizes(menu: restmenu, item: restmenu.items[0], isCatering: selectedMenuType == .catering ? true : false, menuType: Cart.shared.getMenuType(selectedMenuType: selectedMenuType)).count == 1 {
            selectedSize = 0
            Cart.shared.itemSizes = [Sizes]()
            Cart.shared.itemSizes.append(Cart.shared.getAllSizes(menu: restmenu, item: restmenu.items[0], isCatering: selectedMenuType == .catering ? true : false, menuType: Cart.shared.getMenuType(selectedMenuType: selectedMenuType))[selectedSize])
        } else {
            Cart.shared.itemSizes = [Sizes]()
        }
        
        Cart.shared.selectedTopping = [SelectedTopping]()
       // Cart.shared.itemSizes = [Sizes]()
        /*
        if RestaurantCartDeatils.shared.addedCartItems != nil && RestaurantCartDeatils.shared.addedCartItems.cartLists.count > 0 {
            print("---\(itemData.id)")
            RestaurantCartDeatils.shared.itemSizes = RestaurantCartDeatils.shared.getItemFromCartList(checkitem: itemData)!.restItemSizes
            RestaurantCartDeatils.shared.selectedTopping = RestaurantCartDeatils.shared.getItemFromCartList(checkitem: itemData)!.restItemTopping
        }
        */
        self.setAmountValue()
        customQtySetup()

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
        //if Int(itemData.qty!) < itemQty {
            itemQty = itemQty + 1
       // }
        self.setAmountValue()
    }
    @IBAction func minusAction() {
        if Int(restmenu.items[0].minQty) < itemQty {
            itemQty = itemQty - 1
        }
        self.setAmountValue()
    }
    @IBAction func addItemInCart() {
       // let option = SelectedOption(optionHeading: topping[indexPath.section - 1].option![indexPath.row].heading, price: "")
        if selectedSize < 0 {
            let alert = UIAlertController(title: "Alert", message: "Please select size", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        Cart.shared.itemData = restmenu.items[0]
        Cart.shared.addInCart()
        Cart.shared.tempRestmenu = restmenu
        Cart.shared.tempItemData = restmenu.items[0]
                   self.dismiss(animated: true) {
                       self.delegate?.itemAddedInTheCart()
                   }
    }
    func setAmountValue() {
        itemCountLbl.text = "\(itemQty)"
        var price: Float = 0.0
        for item in Cart.shared.itemSizes {
            price = Float(item.price)! * Float(itemQty)
        }
        var toppingsPrice: Float = 0.0
        for topping in Cart.shared.selectedTopping {
            for option in topping.option {
                let opPrice = option.price * Float(itemQty)
                toppingsPrice = toppingsPrice + opPrice
            }
        }
       price = price + toppingsPrice
        Cart.shared.itemExtra = 0.0
        Cart.shared.instructionText = ""
                price = price + Cart.shared.itemExtra
//            }
        addeditmesPriceBtn.setTitle("    Add Item | \(UtilsClass.getCurrencySymbol())\(Cart.shared.roundValue2Digit(value: price).toString())    ", for: .normal)

        Cart.shared.itemSizes = [Sizes]()
        
        if selectedSize >= 0 {
            var newSize = Cart.shared.getAllSizes(menu: restmenu, item: restmenu.items[0], isCatering: selectedMenuType == .catering ? true : false, menuType: Cart.shared.getMenuType(selectedMenuType: selectedMenuType))[selectedSize]
            newSize.itemQty = itemQty
            Cart.shared.itemSizes.append(newSize)
        }
        
    }

}
extension ItemSizesPopupVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return Cart.shared.getAllSizes(menu: restmenu, item: restmenu.items[0], isCatering: selectedMenuType == .catering ? true : false, menuType: Cart.shared.getMenuType(selectedMenuType: selectedMenuType)).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemSizeTVCell", for: indexPath) as! ItemSizeTVCell
            cell.selectionStyle = .none
        cell.backgroundColor = .clear
            let itemSizes = Cart.shared.getAllSizes(menu: restmenu, item: restmenu.items[0], isCatering: selectedMenuType == .catering ? true : false, menuType: Cart.shared.getMenuType(selectedMenuType: selectedMenuType))
            cell.sizeNameLbl.text = itemSizes[indexPath.row].name
            cell.priceLbl.attributedText = cell.priceServeAttributedText(price: "\(UtilsClass.getCurrencySymbol())\(itemSizes[indexPath.row].price) ", serve: "\(itemSizes[indexPath.row].serveTray)")
            cell.updateUIForSelectSize(indexPath: indexPath, sizes: itemSizes, selectedSize: selectedSize)
        cell.backgroundColor = .white
            return cell
        
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectedSize = indexPath.row
            Cart.shared.itemSizes = [Sizes]()
            Cart.shared.itemSizes.append(Cart.shared.getAllSizes(menu: restmenu, item: restmenu.items[0], isCatering: selectedMenuType == .catering ? true : false, menuType: Cart.shared.getMenuType(selectedMenuType: selectedMenuType))[selectedSize])
            Cart.shared.selectedTopping = [SelectedTopping]()
            //selectedOption = -1
       
        print(Cart.shared.selectedTopping.count)
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
