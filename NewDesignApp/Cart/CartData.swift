//
//  CartData.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 15/10/24.
//

import Foundation
struct AddedCartItems: Codable {
    var cartRestuarant: RestDetailsRes!
    var cartLists : [CartList]
}
struct CartList: Codable {
    var restItems: [CartRestItemList]
}
struct CartRestItemList: Codable {
    var restItem: MenuItem!
    var restItemSizes = [Sizes]()
    var restItemTopping = [SelectedTopping]()
}

enum OrderType {
    case pickup
    case delivery
}
enum OrderDate {
    case ASAP
    case Today
    case Later
}
struct CartItemList: Codable {
    var restItem: MenuItem!
    var restItemSizes = [Sizes]()
    var restItemTopping = [SelectedTopping]()
    var extra: Float = 0.0
    var instructionText = ""
    var instructionExtraAmount: Float = 0.0
}
struct CheckoutPrice: Codable {
    var subTotal: Float = 0.0
    var discountedSubTotal: Float = 0.0
    var discount: Float = 0.0
    var tax: Float = 0.0
    var total: Float = 0.0
    var con: Float = 0.0
    var serviceCharge: Float = 0.0
    var deliveryCharge: Float = 0.0
    var offerdetails: String
    var offeramount: Float
}
class Cart {
    static let shared = Cart()
    var tempRestDetails: CustomRestDetails!
    var restDetails: CustomRestDetails!
    var selectedTopping = [SelectedTopping]()
    var itemSizes = [Sizes]()
    var dbname = ""
    var itemData: MenuItem!
    var allCompleteMealList = [String]()
    var addedCartItems: AddedCartItems!
    var userAddress: UserAdd!
    var alternateNumber = ""
    var giftNumber = ""
    var cardNumber = ""
    var cardCvv = ""
    var cardExpiry = ""
    var cardHolder = ""
    var cardZip = ""
    var orderNumber = ""
    var supportNumber = ""
    //var menuType = "Menu" //Catering / Menu
    var tempRestmenu: CustMenuCategory!
    var tempItemData: MenuItem!
    var tempAllRestmenu = [CustMenuCategory]()
    
    
    //var restuarant: RestaurantDetailData!
    var cartData = [CartItemList]()
    var orderType: OrderType = .pickup
    var selectedTime: SeletedTime!
    var orderDate: OrderDate = .ASAP
    var isDonate: Bool = false
    var donateAmount: Float = 0.0
    var isTips: Bool = false
    var isReward: Bool = false
    var rewardAmount: Float = 0.0
    var tipsAmount: Float = 0.0
    var itemExtra: Float = 0.0
    var instructionText = ""
    var specialInstructionText = ""


    init(){
         let seletedTime = SeletedTime.init(date: UtilsClass.getCurrentDateInString(date: Date()), time: "00:00:00", heading: "Pickup today ASAP")
         selectedTime = seletedTime
    }
    func refreshCartData() {
        tempRestDetails = nil
        restDetails = nil
        selectedTopping = [SelectedTopping]()
        itemSizes = [Sizes]()
        itemData = nil
        addedCartItems = nil
        userAddress = nil
        alternateNumber = ""
        giftNumber = ""
        cardNumber = ""
        cardCvv = ""
        cardExpiry = ""
        cardHolder = ""
        cardZip = ""
        orderNumber = ""
        supportNumber = ""
        
        
        cartData = [CartItemList]()
        orderType = .pickup
        selectedTime = SeletedTime.init(date: UtilsClass.getCurrentDateInString(date: Date()), time: "00:00:00", heading: "Pickup today ASAP")
        orderDate = .ASAP
        isDonate = false
        donateAmount = 0.0
        isTips = false
        isReward = false
        rewardAmount  = 0.0
        tipsAmount = 0.0
        itemExtra = 0.0
        instructionText = ""
        specialInstructionText = ""
    }
    func addInCart() {
        Cart.shared.restDetails = self.restDetails
//        if self.itemData.completeMealList.count > 0 {
//            Cart.shared.allCompleteMealList.append(contentsOf: self.itemData.completeMealList)
//        }
       // print(Cart.shared.allCompleteMealList.count)
        let data = CartItemList(restItem: itemData, restItemSizes: itemSizes, restItemTopping: selectedTopping, extra: self.itemExtra, instructionText: self.instructionText, instructionExtraAmount: self.itemExtra)
        Cart.shared.cartData.append(data)
        
        print(Cart.shared.cartData.count)
        
        let oneCartItem = CartRestItemList(restItem: itemData, restItemSizes: itemSizes, restItemTopping: selectedTopping)
        
         
        if addedCartItems != nil && addedCartItems.cartLists.count > 0 {
            let temp = addedCartItems.cartLists
            var isExistItem = false
            //var isExistSize = false
            //var sizeIndex = -1
            //var itemIndex = -1
            if addedCartItems.cartRestuarant.rid == self.restDetails.rid {
                for (index, item) in temp.enumerated() {
                    for (innerIndex, innerItem) in item.restItems.enumerated() {
                        if innerItem.restItem.id == itemData.id {
                           // sizeIndex = innerIndex
                            //itemIndex = index
                            if innerItem.restItemSizes.first?.name == self.itemSizes.first?.name {
                                isExistItem = true
                                //isExistSize = true
                                addedCartItems.cartLists[index].restItems[innerIndex].restItemSizes = self.itemSizes
                                addedCartItems.cartLists[index].restItems[innerIndex].restItemTopping = self.selectedTopping
                                print("same item updated")
                                break
                            }
                        }
                    }
                }
//                if isExistItem && !isExistSize{
//                    addedCartItems.cartLists[itemIndex].restItems[sizeIndex].
//                    var acartLists = CartList(restItems: [oneCartItem])
//                    let added = AddedCartItems(cartRestuarantID: self.restuarantID, cartLists: [acartLists])
//                    self.addedCartItems = added
//                    print("next item added")
//                }
                if !isExistItem {
                    print("item not in the list")
                    let acartLists = CartList(restItems: [oneCartItem])
                    addedCartItems.cartLists.append(acartLists)
                    print("next item added")
                }

            } else {
                print("restaurant is different")
            }
        } else {
            let acartLists = CartList(restItems: [oneCartItem])
            //let added = AddedCartItems(cartRestuarant: self.restDetails, cartLists: [acartLists])
           // self.addedCartItems = added
            print("first item added")
        }
        
    }
    func getItemFromCartList(checkitem: ItemList)-> CartRestItemList? {
        var availbleData = false
        if addedCartItems != nil && addedCartItems.cartLists.count > 0 {
            let temp = addedCartItems.cartLists
            if addedCartItems.cartRestuarant.rid == self.restDetails.rid {
                for (index, item) in temp.enumerated() {
                    for innerItem in item.restItems {
                        print("\(innerItem.restItem.id)")
                        print("new \(checkitem.id)")
                        if innerItem.restItem.id == checkitem.id {
                            availbleData = true
                           // itemSizes = item.restItems[index].restItemSizes
                            selectedTopping = item.restItems[index].restItemTopping
//                            if innerItem.restItemSizes.first?.name == self.itemSizes.first?.name {
//                                addedCartItems.cartLists[index].restItems[innerIndex].restItemSizes = self.itemSizes
//                                addedCartItems.cartLists[index].restItems[innerIndex].restItemTopping = self.selectedTopping
//                                print("same item updated")
                                break
//                            }
                        }
                    }
                }

            }
        }
        var oneCartItem = CartRestItemList(restItem: itemData, restItemSizes: Cart.shared.itemSizes, restItemTopping: selectedTopping)

        if !availbleData {
            oneCartItem = CartRestItemList(restItem: itemData, restItemSizes: [Sizes](), restItemTopping: [SelectedTopping]())
        }
        return oneCartItem
    }

    func addAndRemoveToppins(selectedTopping: SelectedTopping, maxCount: Int) -> String {
        var msg = ""
        if Cart.shared.selectedTopping.count == 0 {
            Cart.shared.selectedTopping.append(selectedTopping)
            return msg
        }
        var isExistTopping = false
        for (index, item) in Cart.shared.selectedTopping.enumerated(){
            if item.toppingHeading == selectedTopping.toppingHeading {
                isExistTopping = true
                var isExistOption = false
                var existOption = Cart.shared.selectedTopping[index].option
                for (opIndex, option) in item.option.enumerated() {
                    if option.optionHeading == selectedTopping.option[0].optionHeading {
                        isExistOption = true
                        existOption.remove(at: opIndex)
                    }
                }
                if !isExistOption {
                    if maxCount == 0 {
                        existOption.append(selectedTopping.option[0])
                    }
                    else if maxCount > existOption.count {
                        existOption.append(selectedTopping.option[0])
                    } else {
                        msg = "You can choose only \(maxCount) option(s)"
                    }
                }
                Cart.shared.selectedTopping[index].option = existOption
            }
        }
        if !isExistTopping {
            Cart.shared.selectedTopping.append(selectedTopping)
        }
      //  print(RestaurantCartDeatils.shared.selectedTopping[0].option)
       // print(RestaurantCartDeatils.shared.selectedTopping.count)
        
        return msg
    }
    
    func calculateAmounts(cartItems: [CartItemList]) -> (subTotal: Float, taxAbleSubtotal: Float) {
        var subTotal: Float = 0.0
        var taxAbleSubtotal: Float = 0.0
        for item in cartData {
            let size = item.restItemSizes.first
            var asubTotal = Float(size!.price)! * Float(size!.itemQty)
            var toppings: Float = 0.0
            for topping in item.restItemTopping {
                for option in topping.option {
                    toppings = toppings + (Float(option.price) * Float(size!.itemQty))
                }
            }
            asubTotal = asubTotal + toppings + item.extra
            subTotal = subTotal + asubTotal
            if item.restItem.tax == 1 {
                taxAbleSubtotal = taxAbleSubtotal + asubTotal
            }
        }
        return (subTotal, taxAbleSubtotal)
    }
    
    func calculateOffer(rest: CustomRestDetails, subTotal: Float = 0.0)-> (discount: Float, offerType: String) {
        var discount: Float = 0
        var offerType = ""
        let offers = rest.offer?
            .sorted { ($0.minAmount ?? 0) < ($1.minAmount ?? 0) } ?? []

        for offer in offers {
            let minAmount = Float(offer.minAmount ?? 0)
            guard minAmount <= subTotal else { continue }

            if offer.type == "$" {
                discount = minAmount
                offerType = "\(offer.discountValue ?? 0)$ Discount"
            } else if offer.type == "%" {
                discount = (subTotal * minAmount) / 100
                offerType = "\(offer.discountValue ?? 0)% Discount"
            }
            
        }

        // Coupons
        for coupon in APPDELEGATE.getCoupons() {
            let minOrder = Float(coupon.min)
            let amount = Float(coupon.amount)

            let isFirstOrder = !APPDELEGATE.userLoggedIn()
                || APPDELEGATE.userResponse?.customer.orders == 0

            guard minOrder <= subTotal, amount > discount else { continue }

            if coupon.type == "New", isFirstOrder {
                discount = amount
                offerType = "First Order Coupon Discount"
            } else if coupon.type == "All" {
                discount = amount
                offerType = "Coupon Discount"
            }
        }
        
        return (discount, offerType)
    }
    func calculateTaxConServices(rest: CustomRestDetails, discountedSubTotal: Float, taxAbleSubtotal: Float)-> (tax: Float, con: Float, serviceCharge: Float) {
        var serviceCharge: Float = 0
        if rest.serviceFee == "Yes" {
            serviceCharge = Float(rest.scharged)
            if Float(rest.schargev) <= discountedSubTotal {
                serviceCharge = Float(rest.schargeo)
            }
            serviceCharge = roundValue2Digit(value: serviceCharge)
        }

        let conRate = (rest.gbDelivery == "Yes" && Cart.shared.orderType == .delivery) ? rest.gbconv : rest.conv
        let con = roundValue2Digit(value: (discountedSubTotal * Float(conRate)) / 100)

        let tax = roundValue2Digit(
            value: (taxAbleSubtotal * Float(rest.tax)) / 100
        )
        //print("-----Tax: \(tax), \nCon: \(con), \nService: \(serviceCharge), \ntaxable\(taxAbleSubtotal), \ndiscountedSubtotal: \(discountedSubTotal)")
        return (tax, con, serviceCharge)
    }
    
    func getAllPriceDeatils() -> CheckoutPrice {

        let amount = calculateAmounts(cartItems: Cart.shared.cartData)
        let subTotal = amount.subTotal
        var taxableSubTotal = amount.subTotal

        guard let rest = Cart.shared.restDetails else {
            return CheckoutPrice(
                subTotal: subTotal,
                discountedSubTotal: subTotal,
                discount: 0,
                tax: 0,
                total: subTotal,
                con: 0,
                serviceCharge: 0,
                deliveryCharge: 0,
                offerdetails: "",
                offeramount: 0.0
            )
        }

        // MARK: - Discount
        let offerDiscount = calculateOffer(rest: rest, subTotal: subTotal)
        let discountedSubTotal = subTotal - offerDiscount.discount
        taxableSubTotal = amount.taxAbleSubtotal - offerDiscount.discount

        // MARK: - Charges
        let deliveryCharge = roundValue2Digit(
            value: calculateDeliveryCharge(discountSubtotal: discountedSubTotal)
        )

        let allTaxesAmount = calculateTaxConServices(rest: rest, discountedSubTotal: discountedSubTotal, taxAbleSubtotal: taxableSubTotal)
        let taxCalculation = roundValue2Digit(value: allTaxesAmount.tax + allTaxesAmount.con + allTaxesAmount.serviceCharge)
        
        let total = (subTotal + taxCalculation) - offerDiscount.discount

        return CheckoutPrice(
            subTotal: subTotal,
            discountedSubTotal: discountedSubTotal,
            discount: offerDiscount.discount,
            tax: taxCalculation,
            total: total,
            con: allTaxesAmount.con,
            serviceCharge: allTaxesAmount.serviceCharge,
            deliveryCharge: deliveryCharge,
            offerdetails: "\(offerDiscount.offerType)",
            offeramount: offerDiscount.discount
        )
    }
    
    func calculateDeliveryCharge(discountSubtotal: Float) -> Float {
        var tempDeliveryCharge: Float = 0.0
        
        if Cart.shared.orderType == .delivery {
            if Cart.shared.restDetails.gbDelivery == "Yes" {
                    if Cart.shared.restDetails.deliveryChargeType == "$" {
                        tempDeliveryCharge = Float(Cart.shared.restDetails.gbDeliveryCharge)
                    } else {
                        tempDeliveryCharge = (discountSubtotal * Float(Cart.shared.restDetails.gbDeliveryCharge)) / 100
                    }
            } else {
                    if Cart.shared.restDetails.deliveryChargeType == "$" {
                        tempDeliveryCharge = Float(Cart.shared.restDetails.deliveryCharge)
                    } else {
                        tempDeliveryCharge = (discountSubtotal * Float(Cart.shared.restDetails.deliveryCharge)) / 100
                    }
            }
        }
        
        return tempDeliveryCharge
    }
    func getTotalPrice()-> Float{
        var paybleAmount: Float = 0.0
        if Cart.shared.restDetails != nil {
            let details = Cart.shared.getAllPriceDeatils()
            paybleAmount = details.total
            if Cart.shared.isTips {
                paybleAmount = details.total + Cart.shared.tipsAmount
                paybleAmount = Cart.shared.roundValue2Digit(value: paybleAmount)
            }
            if Cart.shared.isDonate {
                paybleAmount = details.total + Cart.shared.donateAmount + Cart.shared.tipsAmount
                paybleAmount = Cart.shared.roundValue2Digit(value: paybleAmount)
            }
            
            if Cart.shared.isReward {
                let payValue = paybleAmount - Cart.shared.rewardAmount
                if payValue.isLess(than: 0.0){
                    paybleAmount = 0
                }
            }
        }
        return Cart.shared.roundValue2Digit(value: paybleAmount)
         }
    
    func roundValue2Digit(value: Float)-> Float {
       // print(value)
        let y = Float(round(100 * value) / 100)
       // print(y)
        return y
    }
   
    func getOptionsPrice(option: RestOptionList, sizes: Sizes?)-> Float {
        var price: Float = 0.0
        if sizes != nil {
            if sizes!.sizeKey == "sm" {
                if option.smp > 0 {
                    price = Float(option.smp)
                }
            }
            else if sizes!.sizeKey == "md" {
                if option.mdp > 0 {
                    price = Float(option.mdp)
                }
            }
            else if sizes!.sizeKey == "lg" {
                if option.lgp > 0 {
                    price = Float(option.lgp)
                }
            }
            else if sizes!.sizeKey == "ex" {
                if option.exp > 0 {
                    price = Float(option.exp)
                }
            }
            else if sizes!.sizeKey == "xl" {
                if option.xlp > 0 {
                    price = Float(option.xlp)
                }
            }

        }
        return price
    }
    func getMenuType (selectedMenuType: MenuType)-> String {
        var type = ""
        if selectedMenuType == .menu {
            type = "Menu"
        }
        if selectedMenuType == .catering {
            type = "Catering"
        }
        if selectedMenuType == .deals {
            type = "Deals"
        }
        if selectedMenuType == .dineIn {
            type = "Dinein"
        }
        
        return type
    }
    func getAllSizes(menu: CustMenuCategory, item: MenuItem, isCatering: Bool, menuType: String) -> [Sizes] {
        var arr = [Sizes]()
        var heading: String = menu.heading
        if isCatering {
//            if menu.submenu == "Yes" {
//                let innerMenu = menu.menulist2![0]
//                heading = innerMenu.heading
//            } else {
                heading = ""
          //  }
        }
        if item.smp > 0 {
            arr.append(Sizes.init(menuType: menuType, manuName: heading, manuId: menu.id, name: "\(item.sm)", price: "\(item.smp.to2Decimal())", itemQty: item.minQty, sizeKey: "sm", isCatering: isCatering))
        }
        if item.mdp > 0 {
            arr.append(Sizes.init(menuType: menuType, manuName: heading, manuId: menu.id, name: "\(item.md)", price: "\(item.mdp.to2Decimal())", itemQty: item.minQty, sizeKey: "md", isCatering: isCatering))
        }
        if item.lgp > 0 {
            arr.append(Sizes.init(menuType: menuType, manuName: heading, manuId: menu.id, name: "\(item.lg)", price: "\(item.lgp.to2Decimal())", itemQty: item.minQty, sizeKey: "lg", isCatering: isCatering))
        }
        if item.exp > 0 {
            arr.append(Sizes.init(menuType: menuType, manuName: heading, manuId: menu.id, name: "\(item.ex)", price: "\(item.exp.to2Decimal())", itemQty: item.minQty, sizeKey: "ex", isCatering: isCatering))
        }
        if item.xlp > 0 {
            arr.append(Sizes.init(menuType: menuType, manuName: heading, manuId: menu.id, name: "\(item.xl)", price: "\(item.xlp.to2Decimal())", itemQty: item.minQty, sizeKey: "xl", isCatering: isCatering))
        }
        
        return arr
    }
    func checkMinimumToppins(topping: RestToppingsResponse) -> String {
        var msg = "not required"
        let minimumReq = Int(topping.required) ?? 0
        if minimumReq > 0 {
            let top = selectedTopping.filter({ el in el.toppingHeading == topping.heading })
            if top.count == 0 {
                if top.count < minimumReq {
                    msg = "\(topping.heading) required \(minimumReq) toppings."
                }
            }
            else if top.count > 0 && top.first?.option.count == 0 {
                if top.first!.option.count < minimumReq {
                    msg = "\(topping.heading) required \(minimumReq) toppings."
                }
            }
            else if top.count > 0 && (top.first?.option.count)! > 0{
                let inner = top.first
                if inner!.option.count < minimumReq {
                    msg = "\(topping.heading) required \(minimumReq) toppings."
                }
//                for item in inner!.option {
//                    let opt = top.first!.option.filter({ el in el.optionHeading == topping.heading })
//
//                }
               // let opt: SelectedOption = top.first!.option

            }

            
        }
        return msg
    }
    func isAddedOption(toppingHeading: String, optionHeading: String)-> Bool{
        var isExistOption = false
        for item in Cart.shared.selectedTopping {
                for option in item.option {
                    if item.toppingHeading == toppingHeading && option.optionHeading == optionHeading {
                        isExistOption = true
                    }
                }
        }
        return isExistOption
       
    }
}
extension Float {
    func toString()-> String{
        return String(format: "%.2f", self)
    }
}
extension Int {
    func toString()-> String{
        return String("\(self)")
    }
}
