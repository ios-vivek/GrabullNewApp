//
//  ItemSizeSelectionPopupVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 16/08/24.
//

import UIKit
protocol ItemAddedInCartDelegate: AnyObject {
    func itemAddedInTheCart()
}
class ItemSizeSelectionPopupVC: UIViewController {
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
    @IBOutlet weak var instructionPlaceholderLbl: UILabel!
    @IBOutlet weak var instructionTxtView: UITextView!
    @IBOutlet weak var soldOutImage: UIImageView!

    var delegate: ItemAddedInCartDelegate?
//let arr = ["Half", "Medium", "Full"]
    var restmenu: CustMenuCategory!
    var itemData: MenuItem!

    var selectedSize: Int = -1
    var itemQty: Int = 1
    var topping = [RestToppingsResponse]()
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
        instructionTxtView.backgroundColor = .white
        instructionTxtView.textColor = .black
        instructionPlaceholderLbl.isHidden = false
        instructionTxtView.layer.masksToBounds = true
        instructionTxtView.layer.cornerRadius = 10
        instructionTxtView.text = ""
        itemSelectionTbl.register(UINib(nibName: "ItemHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ItemHeaderView")
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
        
        itemNametLbl.text = itemData.heading
        itemNametLbl.textColor = kOrangeColor
        itemQty = Int(itemData.minQty)
        if Cart.shared.getAllSizes(menu: restmenu, item: itemData, isCatering: selectedMenuType == .catering ? true : false, menuType: Cart.shared.getMenuType(selectedMenuType: selectedMenuType)).count == 1 {
            selectedSize = 0
            Cart.shared.itemSizes = [Sizes]()
            Cart.shared.itemSizes.append(Cart.shared.getAllSizes(menu: restmenu, item: itemData, isCatering: selectedMenuType == .catering ? true : false, menuType: Cart.shared.getMenuType(selectedMenuType: selectedMenuType))[selectedSize])
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
        getToppingFromApi()
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
    func getToppingFromApi() {
        
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "cust_lat" : "\(APPDELEGATE.selectedLocationAddress.latLong.latitude)",
            "cust_long" : "\(APPDELEGATE.selectedLocationAddress.latLong.longitude)",
            "item_id": "\(itemData.id)",

        ]) { _, new in new }
        
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.options, forModelType: ToppingsResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            self.topping = [RestToppingsResponse]()
            for item in success.data.data {
                if item.optionList!.count > 0 {
                    self.topping.append(item)
                }
            }
            //self.topping = success.data
                self.itemSelectionTbl.reloadData()
           // }
           
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
    }
    @IBAction func plusAction() {
        //if Int(itemData.qty!) < itemQty {
            itemQty = itemQty + 1
       // }
        self.setAmountValue()
    }
    @IBAction func minusAction() {
        if Int(itemData.minQty) < itemQty {
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
        
        for toppings in topping {
          let msg =  Cart.shared.checkMinimumToppins(topping: toppings)
            if msg != "not required" {
                let alert = UIAlertController(title: "Toppings", message: msg, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
        }
        
        Cart.shared.itemData = itemData
        Cart.shared.addInCart()
        Cart.shared.tempRestmenu = restmenu
        Cart.shared.tempItemData = itemData
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
        let array = instructionTxtView.text.uppercased().components(separatedBy: " ".uppercased())
        for extraItem in array {
            if extraItem.contains("extra".uppercased()) {
                //Cart.shared.itemExtra += Cart.shared.restDetails.extracharge
            }
        }
                price = price + Cart.shared.itemExtra
//            }
        Cart.shared.instructionText = instructionTxtView.text
        addeditmesPriceBtn.setTitle("    Add Item | \(UtilsClass.getCurrencySymbol())\(Cart.shared.roundValue2Digit(value: price).toString())    ", for: .normal)

        Cart.shared.itemSizes = [Sizes]()
        
        if selectedSize >= 0 {
            var newSize = Cart.shared.getAllSizes(menu: restmenu, item: itemData, isCatering: selectedMenuType == .catering ? true : false, menuType: Cart.shared.getMenuType(selectedMenuType: selectedMenuType))[selectedSize]
            newSize.itemQty = itemQty
            Cart.shared.itemSizes.append(newSize)
        }
        
    }

}
extension ItemSizeSelectionPopupVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if selectedSize >= 0 {
            return 1 + self.topping.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return Cart.shared.getAllSizes(menu: restmenu, item: itemData, isCatering: selectedMenuType == .catering ? true : false, menuType: Cart.shared.getMenuType(selectedMenuType: selectedMenuType)).count
        }
        if selectedSize >= 0 {
            return self.topping[section - 1].optionList?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemSizeTVCell", for: indexPath) as! ItemSizeTVCell
            cell.selectionStyle = .none
        cell.backgroundColor = .clear
        if indexPath.section == 0 {
            cell.sizeNameLbl.text = Cart.shared.getAllSizes(menu: restmenu, item: itemData, isCatering: selectedMenuType == .catering ? true : false, menuType: Cart.shared.getMenuType(selectedMenuType: selectedMenuType))[indexPath.row].name
            cell.priceLbl.text = "\(UtilsClass.getCurrencySymbol())\(Cart.shared.getAllSizes(menu: restmenu, item: itemData, isCatering: selectedMenuType == .catering ? true : false, menuType: Cart.shared.getMenuType(selectedMenuType: selectedMenuType))[indexPath.row].price)"
            cell.updateUIForSelectSize(indexPath: indexPath, sizes: Cart.shared.getAllSizes(menu: restmenu, item: itemData, isCatering: selectedMenuType == .catering ? true : false, menuType: Cart.shared.getMenuType(selectedMenuType: selectedMenuType)), selectedSize: selectedSize)
        }
        else if indexPath.section > 0 {
            if selectedSize >= 0 {
                
            }
            cell.updateUIForSelectOption(indexPath: indexPath, option: self.topping[indexPath.section - 1].optionList!, isChecked: Cart.shared.isAddedOption(toppingHeading: self.topping[indexPath.section - 1].heading, optionHeading: self.topping[indexPath.section - 1].optionList![indexPath.row].heading), sizes: selectedSize >= 0 ? Cart.shared.getAllSizes(menu: restmenu, item: itemData, isCatering: selectedMenuType == .catering ? true : false, menuType: Cart.shared.getMenuType(selectedMenuType: selectedMenuType))[selectedSize] : nil)
         }
        else {
            cell.sizeNameLbl.text = self.topping[indexPath.row].heading
            cell.priceLbl.text = ""
            //cell.updateUIForSelectOption(indexPath: indexPath, option: self.topping.op, selectedSize: selectedSize)
        }
        cell.backgroundColor = .white
            return cell
        
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            selectedSize = indexPath.row
            Cart.shared.itemSizes = [Sizes]()
            Cart.shared.itemSizes.append(Cart.shared.getAllSizes(menu: restmenu, item: itemData, isCatering: selectedMenuType == .catering ? true : false, menuType: Cart.shared.getMenuType(selectedMenuType: selectedMenuType))[selectedSize])
            Cart.shared.selectedTopping = [SelectedTopping]()
            //selectedOption = -1
        } else {
           // selectedOption = indexPath.row
            
            let option = SelectedOption(opID: topping[indexPath.section - 1].optionList![indexPath.row].id, optionHeading: topping[indexPath.section - 1].optionList![indexPath.row].heading, price: Cart.shared.getOptionsPrice(option: topping[indexPath.section - 1].optionList![indexPath.row], sizes: selectedSize >= 0 ? Cart.shared.itemSizes[0] : nil))
            let toppingHeading = topping[indexPath.section - 1].heading
            let selectedOption = SelectedTopping(toppingHeading: toppingHeading, option: [option])
           let msg = Cart.shared.addAndRemoveToppins(selectedTopping: selectedOption, maxCount: Int(topping[indexPath.section - 1].restChoice))
            if msg.count > 0 {
                self.showToast(message: msg, font: .systemFont(ofSize: 14.0))
            }
            
        }
       
        print(Cart.shared.selectedTopping.count)
        tableView.reloadData()
        setAmountValue()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 40
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return 50
    }
            return 0
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > 0 {
            let sec = section - 1
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ItemHeaderView") as! ItemHeaderView
            var warningText = ""
            /*
            if let rq = self.topping[sec].r {
                if rq > 0.0 {
                    warningText = "Must Choose \(Int(rq))"
                }
            }
            */
            //headerView.headingLbl.text = "\(self.topping[sec].heading) \(warningText)"
            headerView.headingLbl.attributedText = UtilsClass.getOptionAttributedString(str1: self.topping[sec].heading, str2: " \(warningText)")
            headerView.headingLbl.textColor = .black
            headerView.headerViewBckground.backgroundColor = UIColor.gGray100
            return headerView
    }
        return nil
    
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
        
}
extension ItemSizeSelectionPopupVC: UITextViewDelegate { //If your class is not conforms to the UITextViewDelegate protocol you will not be able to set it as delegate to UITextView

    func textViewDidChange(_ textView: UITextView) {
        //Handle the text changes here
        if textView.text.count > 0 {
            instructionPlaceholderLbl.isHidden = true
            setAmountValue()
        } else {
            instructionPlaceholderLbl.isHidden = false
        }
        print(textView.text); //the textView parameter is the textView where text was changed
    }
}
