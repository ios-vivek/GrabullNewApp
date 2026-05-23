import Foundation
import Stripe
import StripePaymentSheet

final class GroceryPaymentViewModel {
    
    // MARK: - State
    var selectedPaymentType: Int = 0
    var payBy: PayBy = .Stripe
    var isSpecialSelected = false
    
    var userRewardAmount: String = "0.0"
    var recipientFirstName = ""
    var recipientLastName = ""
    var recipientPhone = ""
    var tempParam = [String: AnyObject]()
    var tempRequest: StripeConfirmRequest?
    
    // MARK: - Bindings
    var reloadTable: (() -> Void)?
    var showLoader: (() -> Void)?
    var hideLoader: (() -> Void)?
    var showError: ((String) -> Void)?
    var orderPlaced: (() -> Void)?
    // Payment presentation binding: view controller will present PaymentSheet when provided
    var presentPaymentSheet: ((PaymentSheet) -> Void)?
    
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
           // GroceryCartData.shared.rewardAmount = success.data.data.rewards
            self.hideLoader?()
            self.reloadTable?()
        } ErrorHandler: { [weak self] error in
            self?.hideLoader?()
        }
    }
    
    func hideCard() -> Bool {
        return false
        //GroceryCartData.shared.isReward && GroceryCartData.shared.getTotalPrice() == 0
    }
    
    // MARK: - Items Payload
    func buildItemList() -> [CartItems] {
        return GroceryCartData.shared.cartItems.map { cartItem in
            CartItems(
                id: cartItem.item.id ?? "",
                mid: cartItem.parentId ?? "",
                heading: cartItem.item.heading ?? "",
                menu: cartItem.parentHeading ?? "",
                size: cartItem.selectedSize?.size ?? "",
                sizeh: cartItem.selectedSize?.name ?? "",
                tax: 1,
                qty: "\(cartItem.quantity)",
                price: "\(cartItem.selectedSize?.price ?? 0.0)"
            )
        }
    }
    
    func checkPaymentType(transactionIdentifier: String) {
        switch selectedPaymentType {
        case 1:
            payBy = .Gift
            if GroceryCartData.shared.giftNumber.isEmpty {
                showError?("Please enter gift number")
                return
            }
            placeOrder(transactionIdentifier: transactionIdentifier)
        default:
            payBy = .Stripe
            placeOrder(transactionIdentifier: transactionIdentifier)
        }
    }

    // MARK: - Place Order
    func placeOrder(
        transactionIdentifier: String
    ) {
        
            showLoader?()
            
            // MARK: - Parameters (UNCHANGED)
        let address = GroceryCartData.shared.userAddress
let total = GroceryCartData.shared.total + GroceryCartData.shared.tipAmount + GroceryCartData.shared.donateAmount
        let cartRequest = GroceryCartRequest(
            apiId: AppConfig.API_ID,
            apiKey: AppConfig.OldAPI_KEY,
            restaurantId: GroceryCartData.shared.storeDetails?.rid ?? "",
            dbname: GroceryCartData.shared.dbname,
            customerId: APPDELEGATE.userResponse?.customer.customerId ?? "",
            fname: APPDELEGATE.userResponse?.customer.firstName ?? "",
            lname: APPDELEGATE.userResponse?.customer.lastName ?? "",
            phone: APPDELEGATE.userResponse?.customer.phone ?? "",
            email: APPDELEGATE.userResponse?.customer.email ?? "",
            add1: address?.add1 ?? "",
            add2: address?.add2 ?? "",
            city: address?.city ?? "",
            state: address?.state ?? "",
            zip: address?.zip ?? "",
            orderat: address?.type ?? "",
            payBy: "\(payBy)",
            stripeId: "",
            giftnumber: selectedPaymentType == 1 ? GroceryCartData.shared.giftNumber : "",
            newcard: "New",
            addcard: "No",
            cardno: "",
            cvv: "",
            expiry: "",
            cardholder: "",
            billingzip: "",
            orderasGift: "No",
            recipientname: "",
            recipientphone: "",
            transactionIdentifier: transactionIdentifier,
            specialinstruction: GroceryCartData.shared.specialInstructionText,
            holdtime: "No",
            holddate: "",
            orderType: "Delivery",
            offerdetails: "",
            offeramount: 0.0,
            dcharge: "\(GroceryCartData.shared.deliveryAmount.toString())",
            scharge: "\(GroceryCartData.shared.serviceAmount.toString())",
            tips: "\(GroceryCartData.shared.tipAmount.toString())", donate: "",
            rewards: "\(GroceryCartData.shared.rewardAmount)",
            total: "\(total.toString())",
            items: buildItemList()
        )
        setTempdata(temp: cartRequest)
            
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try? encoder.encode(cartRequest)
        let jsonObject = try? JSONSerialization.jsonObject(with: data ?? Data())
        let params = jsonObject as? [String: AnyObject] ?? [:]

        print(params.json)
            
            // MARK: - API Call
        WebServices.placeOrderService(parameters: params, serviceType: "add-order-grocery/") { response in
            self.hideLoader?()
            let orderData = response.data
            GroceryCartData.shared.orderNumber = orderData.oid ?? ""
            self.tempRequest?.oid = orderData.oid ?? ""
            self.tempRequest?.orderId = orderData.orderId
            if self.payBy == .Stripe, let stripe = orderData.gateway {
                if response.status != "Success"{
                    self.showError?("Something went wrong. Please try again later.")
                }
                else if stripe.chargeAmount > 0.0 && response.status == "Success"{
                    self.tempRequest?.transaction = stripe.paymentIntent
                    self.startPaymentFlow(custId: stripe.customer, epk: stripe.ephemeralKey, piId: stripe.paymentIntent, parameters: params)
                } else {
                    if response.status == "Success" {
                        GroceryCartData.shared.supportNumber = orderData.support
                        self.orderPlaced?()
                    } else {
                        self.showError?("Something went wrong. Please try again later.")
                    }
                }
            } else {
                if response.status == "Success" {
                    GroceryCartData.shared.supportNumber = orderData.support
                    self.orderPlaced?()
                } else {
                    self.showError?("Something went wrong. Please try again later.")
                }
            }
        } errorHandler: { errorMessage in
            self.hideLoader?()
            self.showError?(errorMessage)
        }

    }
    
    func setTempdata(temp: GroceryCartRequest) {
        self.tempRequest = StripeConfirmRequest(restaurantId: temp.restaurantId, orderId: "", oid: "", transaction: "")
    }

    // MARK: - Stripe Payment Helpers
    func startPaymentFlow(custId: String, epk: String, piId: String, parameters: [String: AnyObject]) {
        self.tempParam = parameters
        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "Grabull"
        configuration.customer = .init(id: custId, ephemeralKeySecret: epk)

        let paymentSheet = PaymentSheet(paymentIntentClientSecret: piId, configuration: configuration)

        presentPaymentSheet?(paymentSheet)
    }

    func paymentResultReceived(_ paymentResult: PaymentSheetResult) {
        switch paymentResult {
        case .completed:
            print("Your order is confirmed")
            self.stripeConfirmedApi(request: self.tempRequest)
        case .canceled:
            print("Payment canceled")
           // showError?("Payment was canceled")
//            self.tempRequest?.transaction = "123"
 //           self.stripeConfirmedApi(request: self.tempRequest)
        case .failed(let error):
            print("Payment failed: \n\(error.localizedDescription)")
            showError?(error.localizedDescription)
        }
    }
    
    func stripeConfirmedApi(request: StripeConfirmRequest?) {
        guard let finalRequest = request else { return }
        var parameters = CommonAPIParams.groceryBase()
        parameters.merge([
            "restaurant_id" : finalRequest.restaurantId,
            "order_id" : finalRequest.orderId,
            "oid" : finalRequest.oid,
            "transaction" : finalRequest.transaction,
            "items" : self.tempParam["items"] ?? []
        ]) { _, new in new }
        self.showLoader?()
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.stripeConfirmedOrder, forModelType: StripeConfirmResponse.self) { success in
            self.hideLoader?()
            GroceryCartData.shared.orderNumber = success.data.data.orderId
            GroceryCartData.shared.supportNumber = success.data.data.support
            self.orderPlaced?()
            
        } ErrorHandler: { error in
            self.hideLoader?()
        }
    }
}
