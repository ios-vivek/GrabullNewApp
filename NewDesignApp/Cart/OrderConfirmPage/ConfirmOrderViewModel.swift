import Foundation
import Stripe
import StripePaymentSheet

final class ConfirmOrderViewModel {
    
    // MARK: - State
    var selectedPaymentType: Int = 0
    var selectedGateway: PaymentGateway = .stripe
    var payBy: PayBy = .card
    var isSpecialSelected = false
    
    var userRewardAmount: String = "0.0"
    var recipientFirstName = ""
    var recipientLastName = ""
    var recipientPhone = ""
    var orderAsGift = "No"
    var tempParam = [String: AnyObject]()
    var tempRequest: StripeConfirmRequest?
    
    // MARK: - Bindings
    var reloadTable: (() -> Void)?
    var showLoader: (() -> Void)?
    var hideLoader: (() -> Void)?
    var showError: ((String) -> Void)?
    var orderPlaced: (() -> Void)?
    var goToHomeAfterPayment: (() -> Void)?
    // Payment presentation binding: view model will provide a configured PaymentSheet to present
    var presentPaymentSheet: ((PaymentSheet) -> Void)?
    var presentAuthorizeURL: ((URL) -> Void)?
    var presentFeedbackWidget: ((String) -> Void)?
    
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
    
    func hideCard() -> Bool {
        Cart.shared.isReward && Cart.shared.getTotalPrice() == 0
    }
    
    // MARK: - Items Payload
    func buildItemList() -> [CartItem] {
        Cart.shared.cartData.compactMap { item in
            guard let size = item.restItemSizes.first else { return nil }

            let toppings = item.restItemTopping.flatMap { $0.option }

            let toppingText = toppings.map {
                $0.price > 0 ? "\($0.optionHeading) $\($0.price)" : $0.optionHeading
            }.joined(separator: " | ")

            let toppingAmount = Cart.shared.roundValue2Digit(
                value: toppings.reduce(0) { $0 + Float($1.price) }
            )

            let optionList = toppings
                .map { String($0.opID) }
                .joined(separator: "|")

            return CartItem(
                toppingList: optionList,
                free: "No",
                freenote: "",
                extamount: "\(toppingAmount)",
                extracharge: "\(item.instructionExtraAmount)",
                menu: size.manuName,
                mid: size.manuId,
                extra: toppingText,
                tax: item.restItem.tax,
                menutype: size.menuType,
                addedInst: item.instructionText,
                sizeh: size.name,
                id: item.restItem.id,
                size: size.sizeKey,
                price: "\(size.price)",
                heading: item.restItem.heading,
                qty: "\(size.itemQty)"
            )
        }
    }
    
    func checkPaymentType(recipientFName: String,
                          recipientLName: String,
                          recipientPhone: String,
                          transactionIdentifier: String) {
        switch selectedPaymentType {
        case 1:
            payBy = .gift
            if Cart.shared.giftNumber.isEmpty {
                showError?("Please enter gift number")
                return
            }
            placeOrder(recipientFName: recipientFName, recipientLName: recipientLName, recipientPhone: recipientPhone, transactionIdentifier: transactionIdentifier)
        default:
            payBy = .card
            placeOrder(recipientFName: recipientFName, recipientLName: recipientLName, recipientPhone: recipientPhone, transactionIdentifier: transactionIdentifier)
        }
    }

    // MARK: - Place Order
    func placeOrder(
        recipientFName: String,
        recipientLName: String,
        recipientPhone: String,
        transactionIdentifier: String
    ) {
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
                    id: "0", street: "", add1: "", add2: "",
                    add3: "", type: "", city: "", state: "", zip: ""
                )
            }
            
            // MARK: - Parameters (UNCHANGED)
        let address = Cart.shared.userAddress
        let price = Cart.shared.getAllPriceDeatils()
        let donateAmount = Cart.shared.isDonate ? Cart.shared.donateAmount : 0.0

        let cartRequest = CartRequest(
            name: APPDELEGATE.userResponse?.customer.fullName ?? "",
            recipientphone: recipientPhone,
            email: APPDELEGATE.userResponse?.customer.email ?? "",
            orderType: "\(Cart.shared.orderType)".capitalized,
            customerId: APPDELEGATE.userResponse?.customer.customerId ?? "",
            add2: address?.add2 ?? "",
            devicetype: AppConfig.DeviceType,
            holddate: Cart.shared.orderDate == .ASAP ? "" : "\(holddate) \(holdTime)",
            dcharge: "\(price.deliveryCharge)",
            holdtime: Cart.shared.orderDate == .ASAP ? "No" : "Yes",
            items: buildItemList(),
            apiKey: AppConfig.OldAPI_KEY,
            apiId: AppConfig.API_ID,
            offeramount: price.offeramount,
            state: address?.state ?? "",
            recipientname: "\(recipientFName) \(recipientLName)",
            total: "\(price.total)",
            tips: Cart.shared.isTips ? "\(Cart.shared.tipsAmount)" : "0.0",
            transactionIdentifier: transactionIdentifier,
            dbname: Cart.shared.dbname,
            city: address?.city ?? "",
            payBy: payBy.rawValue,
            orderasGift: orderAsGift,
            scharge: "\(price.serviceCharge)",
            restaurantId: Cart.shared.restDetails.rid,
            donate: "\(donateAmount)",
            orderat: address?.type ?? "",
            did: Cart.shared.orderNumber,
            rewards: Cart.shared.isReward ? "\(Cart.shared.rewardAmount)" : "0.0",
            specialinstruction: Cart.shared.specialInstructionText,
            phone: APPDELEGATE.userResponse?.customer.phone ?? "",
            add1: address?.add1 ?? "",
            offerdetails: price.offerdetails,
            zip: address?.zip ?? "",
            giftnumber: selectedPaymentType == 1 ? Cart.shared.giftNumber : ""
        )
        setTempdata(temp: cartRequest)
            
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try? encoder.encode(cartRequest)
        let jsonObject = try? JSONSerialization.jsonObject(with: data ?? Data())
        let params = jsonObject as? [String: AnyObject] ?? [:]

        print(params.json)
            
            // MARK: - API Call
        WebServices.placeOrderService(parameters: params, serviceType: "add-order/") { response in
            self.hideLoader?()
            
            // Check for error response first
            if response.status != "Success" {
                let errorMsg = response.error ?? "Something went wrong. Please try again later."
                self.showError?(errorMsg)
                return
            }
            
            guard let orderData = response.data else {
                self.showError?("Invalid server response")
                return
            }
            
            Cart.shared.orderNumber = orderData.oid ?? ""
            Cart.shared.orderTime = orderData.orderTime ?? ""
            self.tempRequest?.oid = orderData.oid ?? ""
            self.tempRequest?.orderId = orderData.orderId ?? ""

            // New API contract: always open the returned orderUrl in browser if present.
            let orderURL = (orderData.orderUrl ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            if !orderURL.isEmpty {
                self.startAuthorizePaymentFlow(urlString: orderURL)
                return
            }

            // Legacy gateway logic kept only as fallback if orderUrl is not returned.
            if let stripe = orderData.gatewayStripe ?? orderData.gateway {
                if stripe.chargeAmount > 0.0 {
                    //self.tempRequest?.transaction = stripe.paymentIntent
                    self.startPaymentFlow(custId: stripe.customer, epk: stripe.ephemeralKey, piId: stripe.paymentIntent, parameters: params)
                } else {
                    Cart.shared.supportNumber = orderData.support ?? ""
                    self.orderPlaced?()
                }
            } else {
                Cart.shared.supportNumber = orderData.support ?? ""
                self.orderPlaced?()
            }
        } errorHandler: { errorMessage in
            self.hideLoader?()
            self.showError?(errorMessage)
        }

    }
    
    func setTempdata(temp: CartRequest) {
        self.tempRequest = StripeConfirmRequest(restaurantId: temp.restaurantId, orderId: "", oid: "")
    }

    func startAuthorizePaymentFlow(urlString: String) {
        guard let url = URL(string: urlString) else {
            showError?("Invalid payment link")
            return
        }
        presentAuthorizeURL?(url)
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
            self.orderConfirmedApi(request: self.tempRequest)
        case .canceled:
            print("Payment canceled")
           // showError?("Payment was canceled")
//            self.tempRequest?.transaction = "123"
//            self.stripeConfirmedApi(request: self.tempRequest)
        case .failed(let error):
            print("Payment failed: \n\(error.localizedDescription)")
            showError?(error.localizedDescription)
        }
    }
    
    func buildFeedbackWidgetHTML(orderId: String) -> String {
        let fname = APPDELEGATE.userResponse?.customer.firstName ?? ""
        let lname = APPDELEGATE.userResponse?.customer.lastName ?? ""
        let email = APPDELEGATE.userResponse?.customer.email ?? ""
        let phone = APPDELEGATE.userResponse?.customer.phone ?? ""
        let today = Date().formatted(date: .abbreviated, time: .omitted)
        
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="Content-Security-Policy" content="default-src *; script-src * 'unsafe-inline' 'unsafe-eval'; style-src * 'unsafe-inline'">
            <title>Feedback</title>
            <style>
                body { margin: 0; padding: 20px; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; }
                #loading { text-align: center; padding: 40px; color: #666; }
            </style>
        </head>
        <body>
            <div id="loading">Loading feedback form...</div>
            <div id="InstantFeedbackWidget"></div>
            <script src="https://static.sitejabber.com/js/widget.min.js"></script>
            <script>
                window.addEventListener('load', function() {
                    if (typeof STJR !== 'undefined' && STJR.InstantFeedbackWidget) {
                        new STJR.InstantFeedbackWidget({
                            id: 'InstantFeedbackWidget',
                            url: 'grabull.com',
                            language: 'en',
                            user: {
                                first_name: '\(fname)',
                                last_name: '\(lname)',
                                email: '\(email)',
                                phone: '\(phone)'
                            },
                            order_date: '\(today)',
                            order_id: '\(orderId)'
                        }).render();
                        document.getElementById('loading').style.display = 'none';
                    }
                });
            </script>
        </body>
        </html>
        """
    }
    
    func orderConfirmedApi(request: StripeConfirmRequest?) {
        guard let finalRequest = request else { return }
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "restaurant_id" : finalRequest.restaurantId,
            "order_id" : finalRequest.orderId,
            "oid" : finalRequest.oid,
           // "transaction" : finalRequest.transaction
           // "items" : self.tempParam["items"] ?? []
        ]) { _, new in new }
        self.showLoader?()
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.stripeConfirmedOrder, forModelType: StripeConfirmResponse.self) { success in
            self.hideLoader?()

            if success.data.status == "Success" && success.data.code == 200 {
//                let feedbackHTML = self.buildFeedbackWidgetHTML(orderId: finalRequest.oid)
//                self.presentFeedbackWidget?(feedbackHTML)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    Cart.shared.refreshCartData()
                    self.goToHomeAfterPayment?()
                }
                return
            }

            Cart.shared.orderNumber = success.data.data.orderId ?? ""
            Cart.shared.supportNumber = success.data.data.support ?? ""
            Cart.shared.orderTime = success.data.data.orderTime ?? ""
            self.orderPlaced?()
            
        } ErrorHandler: { error in
            self.hideLoader?()
            self.showError?(error)
        }
    }
}
