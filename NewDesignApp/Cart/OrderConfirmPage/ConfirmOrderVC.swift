//
//  ConfirmOrderVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 22/10/24.
//

import UIKit
//import PassKit
enum PayBy {
    case Cash
    case Card
    case Gift
    case ApplePay
}
enum CellTypeSelected: Int {
    case Restname
    case Deliveryto
    case Deliveryat
    case SendAsGift
    case Special
    case Payment
    case Redeem
    case Tips
    case Donate
    case Itemdetails
    case Totalprice
    case TotalRowsCount
}
class ConfirmOrderVC: UIViewController {
    @IBOutlet weak var cartTableView: UITableView!
//let sectionArr = ["restname","deliveryto", "deliveryat", "SendAsGift", "Special","payment", "Redeem", "tips", "donate", "itemdetails", "totalprice"]
    private let viewModel = ConfirmOrderViewModel()
    var payBy = PayBy.Card
    var userRewardAmount: String = "0.0"
    var recipientfName: String = ""
    var recipientlName: String = ""
    var recipientPhone: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        Cart.shared.isTips = false
        Cart.shared.isDonate = false
        Cart.shared.tipsAmount = 0.0
        Cart.shared.donateAmount = 0.0
        Cart.shared.alternateNumber = ""
        Cart.shared.isReward =  false
        Cart.shared.rewardAmount =  0.0
        Cart.shared.cardNumber = ""
        Cart.shared.cardCvv = ""
        Cart.shared.cardExpiry = ""
        Cart.shared.cardHolder = ""
        Cart.shared.cardZip = ""
        // Do any additional setup after loading the view.
        bindViewModel()
        viewModel.fetchRewards()
        self.setDefaultBack()
        self.view.backgroundColor = .white
        cartTableView.backgroundColor = .white

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func bindViewModel() {
           viewModel.reloadTable = { [weak self] in
               self?.cartTableView.reloadData()
           }

        viewModel.showLoader = { [weak self] in
            guard let view = self?.view else { return }
            UtilsClass.showProgressHud(view: view)
        }

        viewModel.hideLoader = { [weak self] in
            guard let view = self?.view else { return }
            UtilsClass.hideProgressHud(view: view)
        }

           viewModel.showError = { [weak self] message in
               self?.showAlert(title: "Error", msg: message)
           }

           viewModel.orderPlaced = { [weak self] in
               let vc = self?.viewController(
                   viewController: FinalOrderPageVC.self,
                   storyName: StoryName.CartFlow.rawValue
               ) as! FinalOrderPageVC
               self?.navigationController?.pushViewController(vc, animated: true)
           }
       }
   
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
   
    func setAmountValue(sizes: Sizes, toppings: [SelectedTopping])-> Float {
        var price: Float = 0.0
        price = Float(sizes.price)! * Float(sizes.itemQty)

        var toppingsPrice: Float = 0.0
        for topping in toppings {
            for option in topping.option {
                toppingsPrice = toppingsPrice + option.price
            }
        }
       price = price + toppingsPrice
        
        return price

    }
   
    @objc func deleteAction() {
        let alertController = UIAlertController(title: "Delete", message: "Are you sure want to delete?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Cancel", style: .default) { action in
            
        }
        let cancel = UIAlertAction(title: "Ok", style: .cancel) { alert in
            self.viewModel.orderAsGift = "No"
            self.recipientPhone = ""
            self.recipientfName = ""
            self.recipientlName = ""
            self.cartTableView.reloadData()

        }
        alertController.addAction(OKAction)
        alertController.addAction(cancel)
        OperationQueue.main.addOperation {
            self.present(alertController, animated: true,
                         completion:nil)
        }
        
    }

    func addOrder(transactionIdentifier: String) {
        viewModel.placeOrder(
            recipientFName: recipientfName,
            recipientLName: recipientlName,
            recipientPhone: recipientPhone,
            transactionIdentifier: transactionIdentifier
        )
    }

}

extension ConfirmOrderVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return CellTypeSelected.TotalRowsCount.rawValue
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case CellTypeSelected.Donate.rawValue:
            if self.viewModel.selectedPaymentType == 1 {
                Cart.shared.isDonate = false
                Cart.shared.donateAmount = 0.0
                return 0
            }
            return 0//Cart.shared.restDetails.donatechange == "Yes" ? 1 : 0
        case CellTypeSelected.Payment.rawValue:
            if self.viewModel.selectedPaymentType == 2 {
               return 1
            }
            if viewModel.hideCard() {
                return 1
            }
            return 2
        case CellTypeSelected.Itemdetails.rawValue:
            return 0//Cart.shared.cartData.count
        case CellTypeSelected.Totalprice.rawValue:
            return Cart.shared.cartData.count > 0 ? 1 : 0
        case CellTypeSelected.SendAsGift.rawValue:
            return self.viewModel.orderAsGift == "Yes" ? 2 : 1
        case CellTypeSelected.Redeem.rawValue:
            return self.viewModel.selectedPaymentType == 1 ? 0 : 1

        default:
            return 1
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case CellTypeSelected.Restname.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantNameTVCell", for: indexPath) as! RestaurantNameTVCell
            cell.updateUI()
            cell.selectionStyle = .none
            return cell
        case CellTypeSelected.Deliveryto.rawValue:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PickupDeliveryTimeTVCell", for: indexPath) as! PickupDeliveryTimeTVCell
                cell.delegate = self
                cell.updateUI()
                cell.selectionStyle = .none
            return cell
        case CellTypeSelected.Deliveryat.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryAtTVCell", for: indexPath) as! DeliveryAtTVCell
            cell.selectionStyle = .none
            var add = ""
            if Cart.shared.orderType == .pickup {
                cell.headingLbl.text = "Pickup From:"
                add = "\(Cart.shared.restDetails.name)\n\(Cart.shared.restDetails.street) \(Cart.shared.restDetails.address), \(Cart.shared.restDetails.city), \(Cart.shared.restDetails.state), \(Cart.shared.restDetails.zip)"
                cell.changeAddressBtn.isHidden = true
                cell.changePhoneBtn.isHidden = true
                cell.phoneLbl.text = "Phone: \(Cart.shared.restDetails.phone)"
            }else {
                cell.headingLbl.text = "Delivery At:"
                let address = Cart.shared.userAddress
                    add = "\(address!.add1 ?? "") \(address!.add2 ?? ""), \(address!.city ?? ""), \(address!.state ?? ""), \(address!.zip ?? "")"
                    cell.changeAddressBtn.isHidden = false
                    cell.changePhoneBtn.isHidden = false
                    cell.phoneLbl.text = "Phone: \(APPDELEGATE.userResponse?.customer.phone ?? "")"
                    if Cart.shared.alternateNumber.count == 10 {
                        cell.phoneLbl.text = "Phone: \(Cart.shared.alternateNumber)"
                    }
                
            }
            cell.delegate = self
            cell.deliveryAtLbl.text = add
            
           
            return cell
        case CellTypeSelected.SendAsGift.rawValue:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AsGiftTVCell", for: indexPath) as! AsGiftTVCell
                cell.selectionStyle = .none
                cell.seperatorView.isHidden = self.viewModel.orderAsGift == "Yes" ? true : false
                return cell

            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecipientTVCell", for: indexPath) as! RecipientTVCell
                cell.selectionStyle = .none
                cell.updateUI(fullName: "\(self.recipientfName) \(self.recipientlName)", phone: "\(self.recipientPhone)")
                cell.deleteBtn.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)

                return cell
            }
        case CellTypeSelected.Special.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialRequestTVCell", for: indexPath) as! SpecialRequestTVCell
            cell.selectionStyle = .none
            return cell
        case CellTypeSelected.Payment.rawValue:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTypeTVCell", for: indexPath) as! PaymentTypeTVCell
                cell.delegate = self
                cell.selectionStyle = .none
                return cell
            } else {
                if self.viewModel.selectedPaymentType == 2 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "GiftNumberTVCell", for: indexPath) as! GiftNumberTVCell
                    cell.selectionStyle = .none
                    cell.isHidden = true
                    return cell
                }
                else if self.viewModel.selectedPaymentType == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CardNumberTVCell", for: indexPath) as! CardNumberTVCell
                    cell.selectionStyle = .none
                    cell.updateCardUI()
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "GiftNumberTVCell", for: indexPath) as! GiftNumberTVCell
                    cell.selectionStyle = .none
                    return cell
                }
            }
            
        case CellTypeSelected.Redeem.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RedeemTVCell", for: indexPath) as! RedeemTVCell
            cell.update(amount: "\(userRewardAmount)")
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case CellTypeSelected.Tips.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TipsTVCell", for: indexPath) as! TipsTVCell
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case CellTypeSelected.Donate.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DonateTVCell", for: indexPath) as! DonateTVCell
            cell.updateUI()
            cell.selectionStyle = .none
            return cell
            
        case CellTypeSelected.Itemdetails.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemTVCell", for: indexPath) as! CartItemTVCell
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            cell.deleteButton.isHidden = true
            cell.deleteButton.tag = indexPath.row
            cell.updateUI(index: indexPath.row)
            cell.selectionStyle = .none
            return cell
        
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartPriceDetailsTVCell", for: indexPath) as! CartPriceDetailsTVCell
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            cell.emptyCartButton.isHidden = true
            cell.delegate = self
            cell.updateUI(isPlaceOrder: true)
            cell.selectionStyle = .none
            return cell
        }
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == CellTypeSelected.Special.rawValue {
            self.viewModel.isSpecialSelected.toggle()
            cartTableView.reloadData()
        }
        if indexPath.section == CellTypeSelected.SendAsGift.rawValue {
            let vc = self.viewController(viewController: AsGiftVC.self, storyName: StoryName.CartFlow.rawValue) as! AsGiftVC
            vc.delegate = self
            vc.fName = recipientfName
            vc.lName = recipientlName
            vc.phone = recipientPhone
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.section == CellTypeSelected.Donate.rawValue {
            Cart.shared.isDonate.toggle()
            cartTableView.reloadData()
        }
//        let story = UIStoryboard.init(name: "Restaurants", bundle: nil)
//        let vc = story.instantiateViewController(withIdentifier: "RestaurantDetailVC") as! RestaurantDetailVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == CellTypeSelected.Special.rawValue {
            if self.viewModel.isSpecialSelected {
                return 150
            }
            return UIScreen.main.bounds.size.width == 430 ? 60 : 70
        }
        return UITableView.automaticDimension
    }
}
extension ConfirmOrderVC: PaymentTypeDeledate {
    func savedCardsTapped() {
        let vc = self.viewController(viewController: PaymentVC.self, storyName: StoryName.Profile.rawValue) as! PaymentVC
        vc.viaConirmPage = true
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func selectedPaymentType(index: Int) {
        self.viewModel.selectedPaymentType = index
        cartTableView.reloadData()
        /*
        if index == 2 {
            openApplePay()
        }
        */
    }
    func displayDefaultAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
       let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    /*
    func openApplePay() {
#if DEBUG
print("Running in Sandbox")
#else
print("Running in Production")
#endif
        let pricedetails: CheckoutPrice = Cart.shared.getAllPriceDeatils()

        let paymentItem = PKPaymentSummaryItem.init(label: "Grabull Food Order", amount: NSDecimalNumber(value: pricedetails.total))
        let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa]
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            let request = PKPaymentRequest()
                request.currencyCode = "USD" // 1
                request.countryCode = "US" // 2
                request.merchantIdentifier = "merchant.com.grabull" // 3
            request.merchantCapabilities = PKMerchantCapability.threeDSecure// 4
                request.supportedNetworks = paymentNetworks // 5
                request.paymentSummaryItems = [paymentItem] // 6
            
            guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: request) else {
            displayDefaultAlert(title: "Error", message: "Unable to present Apple Pay authorization.")
            return
        }
            paymentVC.delegate = self
            self.present(paymentVC, animated: true, completion: nil)
            
        } else {
            displayDefaultAlert(title: "Error", message: "Unable to make Apple Pay transaction.")
        }
        
       
     }
    */
    
}
/*
extension ConfirmOrderVC: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: nil)
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        print("token--\(payment.token.transactionIdentifier)")
        dismiss(animated: true, completion: nil)
       // displayDefaultAlert(title: "Success!", message: "The Apple Pay transaction was complete.")
        self.addOrder(transactionIdentifier: "\(payment.token.transactionIdentifier)")
    }
}
*/
extension ConfirmOrderVC: TipsDelegate {
    func tipsAction() {
        cartTableView.reloadData()
    }
}

extension ConfirmOrderVC: ChangeTimeDelegate {
    func clickedOnChangeTime() {
        let story = UIStoryboard.init(name: "OrderFlow", bundle: nil)
        let popupVC = story.instantiateViewController(withIdentifier: "ScheduleDateTimeVC") as! ScheduleDateTimeVC
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        self.present(popupVC, animated: true)
    }
}
extension ConfirmOrderVC: ChangeAddressDelegate {
    func changeAddress() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func changePhone() {
        self.navigationController?.popViewController(animated: true)
    }
}
extension ConfirmOrderVC: ReloadAddressDelegate {
    func addNewAddress() {
        let vc = self.viewController(viewController: AddAddressVC.self, storyName: StoryName.Profile.rawValue) as! AddAddressVC
        vc.isUpdateAddress = false
        vc.fromCheckoutPage = true
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func changedAddress() {
        cartTableView.reloadData()
    }
    
}
extension ConfirmOrderVC: ReloadNewAddressDelegate {
    func addednewAddress() {
        cartTableView.reloadData()
    }
    
}
extension ConfirmOrderVC: ChangePhoneNumberDelegate {
    func changesNumber() {
        cartTableView.reloadData()
    }
}
extension ConfirmOrderVC: DateChangedDelegate {
    func dateChanged() {
        let address = Cart.shared.userAddress
        if Cart.shared.orderType == .delivery && address == nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            cartTableView.reloadData()
        }
    }
}
extension ConfirmOrderVC: CheckoutDelegate {
    func checkoutAction(){
        self.addOrder(transactionIdentifier: "")
    }
    func emptyAction(){
        
    }
}
extension ConfirmOrderVC: RedeemDelegate {
    func selectedRedeemAction() {
       // if re
        cartTableView.reloadData()
    }
}

extension ConfirmOrderVC: RecipientDetailsDelegate {
    func recipientDetailsSubmitted(fname: String, lname: String, phone: String) {
        recipientfName = fname
        recipientlName = lname
        recipientPhone = phone
        self.viewModel.orderAsGift = "Yes"
        
        cartTableView.reloadData()
    }
}

extension ConfirmOrderVC: SelectedCardDeledate {
    func selectedCardDetails() {
        cartTableView.reloadData()
    }
}
