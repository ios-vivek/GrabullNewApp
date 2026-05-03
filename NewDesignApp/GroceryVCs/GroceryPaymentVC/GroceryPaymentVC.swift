//
//  ConfirmOrderVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 22/10/24.
//

import UIKit
import Stripe
import StripePaymentSheet
enum GroceryCellTypes: Int {
    case Restname
    case Deliveryto
    case Deliveryat
    case Special
    case Payment
    case Redeem
    case Tips
    case Donate
    case Itemdetails
    case Totalprice
    case TotalRowsCount
}
class GroceryPaymentVC: UIViewController {
    private var paymentSheet: PaymentSheet?
    @IBOutlet weak var cartTableView: UITableView!
    private let viewModel = GroceryPaymentViewModel()
    var payBy = PayBy.Stripe
    override func viewDidLoad() {
        super.viewDidLoad()
//        GroceryCartData.shared.isDonate = false
        GroceryCartData.shared.tipAmount = 0.0
//        GroceryCartData.shared.donateAmount = 0.0
//        GroceryCartData.shared.alternateNumber = ""
//        GroceryCartData.shared.isReward =  false
//        GroceryCartData.shared.rewardAmount =  0.0
//        GroceryCartData.shared.cardNumber = ""
//        GroceryCartData.shared.cardCvv = ""
//        GroceryCartData.shared.cardExpiry = ""
//        GroceryCartData.shared.cardHolder = ""
//        GroceryCartData.shared.cardZip = ""
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
                           viewController: GroceryFinalOrderPageVC.self,
                           storyName: StoryName.Grocery.rawValue
                       ) as! GroceryFinalOrderPageVC
               self?.navigationController?.pushViewController(vc, animated: true)
           }
        // PaymentSheet presentation: view model will provide a configured PaymentSheet to present
        viewModel.presentPaymentSheet = { [weak self] paymentSheet in
            guard let self = self else { return }
            paymentSheet.present(from: self) { paymentResult in
                self.viewModel.paymentResultReceived(paymentResult)
            }
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
    /*
        if ((GroceryCartData.shared.restDetails.openStatus.status.contains("Closed") || GroceryCartData.shared.restDetails.openStatus.status.contains("closed")) && GroceryCartData.shared.orderDate == .ASAP){
            let alertController = UIAlertController(title: "Alert", message: "Restaurant is closed for now. Please change your delivery / pickup timing.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
                self.clickedOnChangeTime()

            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { alert in
                
            }
            alertController.addAction(OKAction)
            alertController.addAction(cancel)
            OperationQueue.main.addOperation {
                self.present(alertController, animated: true,
                             completion:nil)
            }
            return
        }
        */
//        let vc = self.viewController(
//            viewController: GroceryFinalOrderPageVC.self,
//            storyName: StoryName.Grocery.rawValue
//        ) as! GroceryFinalOrderPageVC
//        self.navigationController?.pushViewController(vc, animated: true)
//        return
        viewModel.checkPaymentType(
            transactionIdentifier: transactionIdentifier
        )
        
    }

}

extension GroceryPaymentVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return GroceryCellTypes.TotalRowsCount.rawValue
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case GroceryCellTypes.Donate.rawValue:
            if self.viewModel.selectedPaymentType == 1 {
               // GroceryCartData.shared.isDonate = false
               // GroceryCartData.shared.donateAmount = 0.0
                return 0
            }
            return 0//GroceryCartData.shared.restDetails.donatechange == "Yes" ? 1 : 0
        case GroceryCellTypes.Payment.rawValue:
            if self.viewModel.selectedPaymentType == 2 || self.viewModel.selectedPaymentType == 0 {
               return 1
            }
            if viewModel.hideCard() {
                return 1
            }
            return 2
        case GroceryCellTypes.Deliveryto.rawValue:
            return 0//GroceryCartData.shared.cartData.count
        case GroceryCellTypes.Itemdetails.rawValue:
            return 0//GroceryCartData.shared.cartData.count
        case GroceryCellTypes.Totalprice.rawValue:
            return GroceryCartData.shared.cartItems.count > 0 ? 1 : 0
        case GroceryCellTypes.Redeem.rawValue:
            if Float(viewModel.userRewardAmount) ?? 0.0 > 0.0 {
                return self.viewModel.selectedPaymentType == 1 ? 0 : 1
            } else {return 0}

        default:
            return 1
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case GroceryCellTypes.Restname.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryStoreNameTVCell", for: indexPath) as! GroceryStoreNameTVCell
            cell.updateUI()
            cell.selectionStyle = .none
            return cell
        case GroceryCellTypes.Deliveryto.rawValue:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PickupDeliveryTimeTVCell", for: indexPath) as! PickupDeliveryTimeTVCell
                cell.delegate = self
                cell.updateUI()
                cell.selectionStyle = .none
            return cell
        case GroceryCellTypes.Deliveryat.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryAtTVCell", for: indexPath) as! DeliveryAtTVCell
            cell.selectionStyle = .none
            
            var add = ""
                cell.headingLbl.text = "Delivery At:"
                let address = GroceryCartData.shared.userAddress
                    add = "\(address!.add1 ?? "") \(address!.add2 ?? ""), \(address!.city ?? ""), \(address!.state ?? ""), \(address!.zip ?? "")"
                    cell.changeAddressBtn.isHidden = false
                    cell.changePhoneBtn.isHidden = false
                    cell.phoneLbl.text = "Phone: \(APPDELEGATE.userResponse?.customer.phone ?? "")"
                    if GroceryCartData.shared.alternateNumber.count == 10 {
                        cell.phoneLbl.text = "Phone: \(GroceryCartData.shared.alternateNumber)"
                    }
                
            cell.delegate = self
            cell.deliveryAtLbl.text = add
            
           
            return cell
        case GroceryCellTypes.Special.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialRequestTVCell", for: indexPath) as! SpecialRequestTVCell
            cell.selectionStyle = .none
            return cell
        case GroceryCellTypes.Payment.rawValue:
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
            
        case GroceryCellTypes.Redeem.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RedeemTVCell", for: indexPath) as! RedeemTVCell
            cell.update(amount: "\(viewModel.userRewardAmount)")
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case GroceryCellTypes.Tips.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TipsTVCell", for: indexPath) as! TipsTVCell
            cell.delegate = self
            cell.updateValue(itemPrice: GroceryCartData.shared.subtotal)
            cell.selectionStyle = .none
            return cell
        case GroceryCellTypes.Donate.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DonateTVCell", for: indexPath) as! DonateTVCell
            cell.updateUI()
            cell.selectionStyle = .none
            return cell
            
        case GroceryCellTypes.Itemdetails.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemTVCell", for: indexPath) as! CartItemTVCell
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            cell.deleteButton.isHidden = true
            cell.deleteButton.tag = indexPath.row
            cell.updateUI(index: indexPath.row)
            cell.selectionStyle = .none
            return cell
        
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryPriceDetailsTVCell", for: indexPath) as! GroceryPriceDetailsTVCell
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
        if indexPath.section == GroceryCellTypes.Special.rawValue {
            self.viewModel.isSpecialSelected.toggle()
            cartTableView.reloadData()
        }
        if indexPath.section == GroceryCellTypes.Donate.rawValue {
           // GroceryCartData.shared.isDonate.toggle()
            cartTableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == GroceryCellTypes.Special.rawValue {
            if self.viewModel.isSpecialSelected {
                return 150
            }
            return UIScreen.main.bounds.size.width == 430 ? 60 : 70
        }
        return UITableView.automaticDimension
    }
}
extension GroceryPaymentVC: PaymentTypeDeledate {
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
    
}

extension GroceryPaymentVC: TipsDelegate {
    func tipsAction(isTips: Bool, tipsAmount: Double) {
        GroceryCartData.shared.tipAmount = tipsAmount
        cartTableView.reloadData()
    }
}

extension GroceryPaymentVC: ChangeTimeDelegate {
    func clickedOnChangeTime() {
        let story = UIStoryboard.init(name: "OrderFlow", bundle: nil)
        let popupVC = story.instantiateViewController(withIdentifier: "ScheduleDateTimeVC") as! ScheduleDateTimeVC
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        self.present(popupVC, animated: true)
    }
}
extension GroceryPaymentVC: ChangeAddressDelegate {
    func changeAddress() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func changePhone() {
        self.navigationController?.popViewController(animated: true)
    }
}
extension GroceryPaymentVC: ReloadAddressDelegate {
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
extension GroceryPaymentVC: ReloadNewAddressDelegate {
    func addednewAddress() {
        cartTableView.reloadData()
    }
    
}
extension GroceryPaymentVC: ChangePhoneNumberDelegate {
    func changesNumber(updatedNumber: String) {
        GroceryCartData.shared.alternateNumber = updatedNumber
        cartTableView.reloadData()
    }
}
extension GroceryPaymentVC: DateChangedDelegate {
    func dateChanged() {
       // let address = GroceryCartData.shared.userAddress
//        if GroceryCartData.shared.orderType == .delivery && address == nil {
//            self.navigationController?.popViewController(animated: true)
//        } else {
//            cartTableView.reloadData()
//        }
    }
}
extension GroceryPaymentVC: GroceryCheckoutDelegate {
    func checkoutAction(){
        self.addOrder(transactionIdentifier: "")
    }
    func emptyAction(){
        
    }
}
extension GroceryPaymentVC: RedeemDelegate {
    func selectedRedeemAction() {
       // if re
        cartTableView.reloadData()
    }
}

extension GroceryPaymentVC: RecipientDetailsDelegate {
    func recipientDetailsSubmitted(fname: String, lname: String, phone: String) {
               
        cartTableView.reloadData()
    }
}

extension GroceryPaymentVC: SelectedCardDeledate {
    func selectedCardDetails() {
        cartTableView.reloadData()
    }
}
