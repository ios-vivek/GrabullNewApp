import Foundation

final class ConfirmOrderViewModel {

    // MARK: - State
    var selectedPaymentType: Int = 0
    var payBy: PayBy = .Card
    var isSpecialSelected = false

    var userRewardAmount: String = "0.0"
    var recipientFirstName = ""
    var recipientLastName = ""
    var recipientPhone = ""
    var orderAsGift = "No"

    // MARK: - Bindings
    var reloadTable: (() -> Void)?
    var showLoader: (() -> Void)?
    var hideLoader: (() -> Void)?
    var showError: ((String) -> Void)?
    var orderPlaced: (() -> Void)?

    // MARK: - API
    func fetchRewards() {
        showLoader?()

        let params = CommonAPIParams.base()
        WebServices.loadDataFromServiceWithBaseResponse(
            parameter: params,
            servicename: OldServiceType.getReward,
            forModelType: RewardsResponse.self
        ) { [weak self] success in
            guard let self else { return }
            self.userRewardAmount = success.data.data.rewards.toString()
            Cart.shared.rewardAmount = success.data.data.rewards
            self.hideLoader?()
            self.reloadTable?()
        } ErrorHandler: { [weak self] error in
            self?.hideLoader?()
        }
    }

    // MARK: - Validation
    func validatePayment() -> Bool {
        if hideCard() { return true }

        switch selectedPaymentType {
        case 0:
            payBy = .Card
            if Cart.shared.cardNumber.count < 12 {
                showError?("Please enter valid card number")
                return false
            }
            if Cart.shared.cardExpiry.isEmpty {
                showError?("Please enter card expiry")
                return false
            }
            if Cart.shared.cardCvv.isEmpty {
                showError?("Please enter card cvv")
                return false
            }
            if Cart.shared.cardZip.isEmpty {
                showError?("Please enter zipcode")
                return false
            }
        case 1:
            payBy = .Gift
            if Cart.shared.giftNumber.isEmpty {
                showError?("Please enter gift number")
                return false
            }
        case 2:
            payBy = .ApplePay
        default: break
        }
        return true
    }

    func hideCard() -> Bool {
        Cart.shared.isReward && Cart.shared.getTotalPrice() == 0
    }

    // MARK: - Items Payload
    func buildItemList() -> [[String: AnyObject]] {
        Cart.shared.cartData.compactMap { item in
            guard let size = item.restItemSizes.first else { return nil }

            let toppings = item.restItemTopping.flatMap { $0.option }
            let toppingText = toppings.map {
                $0.price > 0 ? "\($0.optionHeading) \($0.price)" : $0.optionHeading
            }.joined(separator: " | ")

            let toppingAmount = Cart.shared.roundValue2Digit(
                value: toppings.reduce(0) { $0 + Float($1.price) }
            )

//            let optionList = toppings.map {
//                [
//                    "id": "\($0.opID)" as AnyObject,
//                    "heading": $0.optionHeading as AnyObject,
//                    "price": "\($0.price)" as AnyObject
//                ]
//            }
            
            let optionList = toppings
                .map { String($0.opID) }
                .joined(separator: "|")

            return [
                "id": item.restItem.id as AnyObject,
                "mid": size.manuId as AnyObject,
                "heading": item.restItem.heading as AnyObject,
                "menu": size.manuName as AnyObject,
                "menutype": size.menuType as AnyObject,
                "qty": "\(size.itemQty)" as AnyObject,
                "size": size.name as AnyObject,
                "sizeh": size.sizeKey as AnyObject,
                "price": "\(size.price)" as AnyObject,
                "extra": toppingText as AnyObject,
                "extamount": "\(toppingAmount)" as AnyObject,
                "extracharge": "\(item.instructionExtraAmount)" as AnyObject,
                "addedInst": item.instructionText as AnyObject,
                "toppingList": optionList as AnyObject,
                "tax": item.restItem.tax as AnyObject,
                "free": "No" as AnyObject,
                "freenote": "" as AnyObject
            ]
        }
    }

    // MARK: - Place Order
       func placeOrder(
           recipientFName: String,
           recipientLName: String,
           recipientPhone: String,
           transactionIdentifier: String
       ) {
           guard validatePayment() else {
               showError?("Invalid payment details")
               return
           }

           showLoader?()

           // MARK: - Hold Date / Time
           var holddate = "\(Cart.shared.selectedTime.date)"
           var holdTime = "\(String(Cart.shared.selectedTime.time.dropLast(3)))"

           if Cart.shared.orderDate == .ASAP {
               holddate = ""
               holdTime = ""
           }

           if Cart.shared.orderType == .pickup {
               Cart.shared.userAddress = UserAdd(
                   id: 0, street: "", add1: "", add2: "",
                   add3: "", addtypes: "", city: "", state: "", zip: ""
               )
           }

           let donateAmount = Cart.shared.isDonate ? Cart.shared.donateAmount : 0.0
           let price = Cart.shared.getAllPriceDeatils()

           // MARK: - Parameters (UNCHANGED)
           var params: [String: AnyObject] = [:]

           params["did"] = Cart.shared.orderNumber as AnyObject
           params["api_id"] = AppConfig.API_ID as AnyObject
           params["api_key"] = AppConfig.OldAPI_KEY as AnyObject
           params["customer_id"] = APPDELEGATE.userResponse?.customer.customerId as AnyObject
           params["name"] = APPDELEGATE.userResponse?.customer.fullName as AnyObject
           params["email"] = APPDELEGATE.userResponse?.customer.email as AnyObject
           params["phone"] = APPDELEGATE.userResponse?.customer.phone as AnyObject
           params["restaurant_id"] = Cart.shared.restDetails.rid as AnyObject
           params["order_type"] = "\(Cart.shared.orderType)".capitalized as AnyObject

           let address = Cart.shared.userAddress
           params["add1"] = address?.add1 as AnyObject
           params["add2"] = address?.add2 as AnyObject
           params["city"] = address?.city as AnyObject
           params["state"] = address?.state as AnyObject
           params["zip"] = address?.zip as AnyObject
           params["orderat"] = address?.addtypes as AnyObject

           params["pay_by"] = "\(payBy)" as AnyObject

           params["giftnumber"] = selectedPaymentType == 1 ? Cart.shared.giftNumber as AnyObject : "" as AnyObject
           params["cardno"] = selectedPaymentType == 0 ? Cart.shared.cardNumber as AnyObject : "" as AnyObject
           params["expiry"] = selectedPaymentType == 0 ? Cart.shared.cardExpiry as AnyObject : "" as AnyObject
           params["cvv"] = selectedPaymentType == 0 ? Cart.shared.cardCvv as AnyObject : "" as AnyObject
           params["billingzip"] = selectedPaymentType == 0 ? Cart.shared.cardZip as AnyObject : "" as AnyObject
           params["cardholder"] = selectedPaymentType == 0 ? Cart.shared.cardHolder as AnyObject : "" as AnyObject

           params["addcard"] = "No" as AnyObject
           params["newcard"] = "New" as AnyObject
           params["holdtime"] = Cart.shared.orderDate == .ASAP ? "No" as AnyObject : "Yes" as AnyObject
           params["holddate"] = "\(holddate) \(holdTime)" as AnyObject

           params["total"] = "\(price.total)" as AnyObject
           params["tips"] = Cart.shared.isTips ? "\(Cart.shared.tipsAmount)" as AnyObject : "0.0" as AnyObject
           params["rewards"] = Cart.shared.isReward ? "\(Cart.shared.rewardAmount)" as AnyObject : "0.0" as AnyObject
           params["specialinstruction"] = Cart.shared.specialInstructionText as AnyObject
           params["items"] = buildItemList() as AnyObject
           params["devicetype"] = AppConfig.DeviceType as AnyObject
           params["scharge"] = "\(price.serviceCharge)" as AnyObject
           params["donate"] = "\(donateAmount)" as AnyObject
           params["dcharge"] = "\(price.deliveryCharge)" as AnyObject

           params["recipientname"] = "\(recipientFName) \(recipientLName)" as AnyObject
           params["recipientphone"] = recipientPhone as AnyObject
           params["orderasGift"] = orderAsGift as AnyObject
           params["transactionIdentifier"] = transactionIdentifier as AnyObject
           params["dbname"] = Cart.shared.dbname as AnyObject
           params["offerdetails"] = price.offerdetails as AnyObject
           params["offeramount"] = price.offeramount as AnyObject
           
           print(params.json)

           // MARK: - API Call
           
           WebServices.placeOrderService(parameters: params) { response in
               self.hideLoader?()
               if let data = response["data"] as? [String: Any] {
                   if let oid = data["orderId"] as? String {
                       Cart.shared.orderNumber = oid
                       print("Order number:", oid)
                   }
                   if let support = data["support"] as? String {
                       Cart.shared.supportNumber = support
                   }
               }
               
               self.orderPlaced?()
               
           } errorHandler: { errorMessage in
               self.hideLoader?()
               self.showError?(errorMessage)
           }
       }
}
