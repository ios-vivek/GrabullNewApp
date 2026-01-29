//
//  PaymentVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 20/08/25.
//

import UIKit
protocol SelectedCardDeledate: AnyObject {
    func selectedCardDetails()
}
    class PaymentVC: UIViewController {
        @IBOutlet weak var tableView: UITableView?
        var cardDetails: [SavedCard] = []
        var viaConirmPage: Bool = false
        weak var delegate: SelectedCardDeledate?

        override func viewDidLoad() {
            super.viewDidLoad()
            tableView?.reloadData()
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            getCardsService()
        }
        @IBAction func backAction() {
            self.navigationController?.popViewController(animated: true)
        }
        @IBAction func addNewCardAction() {
            let story = UIStoryboard.init(name: "Profile", bundle: nil)
            let popupVC = story.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
            self.navigationController?.pushViewController(popupVC, animated: true)
        }
        func getCardsService() {
            
            let parameters = CommonAPIParams.base()
            
            UtilsClass.showProgressHud(view: self.view)
            WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.detailCard, forModelType: CardDetailsResponse.self) { success in
                UtilsClass.hideProgressHud(view: self.view)
                self.cardDetails = success.data.data
                self.tableView?.reloadData()
            } ErrorHandler: { error in
                UtilsClass.hideProgressHud(view: self.view)
               
            }
        }
        func deleteCardService(cardid: String, index: Int) {
            var parameters = CommonAPIParams.base()
            parameters.merge([
                "id" : cardid
            ]) { _, new in new }
            UtilsClass.showProgressHud(view: self.view)
            WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.removeCard, forModelType: SaveCardResponse.self) { success in
                UtilsClass.hideProgressHud(view: self.view)
                if success.data.data.result == "Card removed successfully" {
                    self.cardDetails.remove(at: index)
                    self.tableView?.beginUpdates()
                    self.tableView?.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                    self.tableView?.endUpdates()
                    self.showAlert(title: "Remove Card", msg: "Card Removed Successfully")
                }
            } ErrorHandler: { error in
                UtilsClass.hideProgressHud(view: self.view)
               
            }
        }
    }
extension PaymentVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.cardDetails.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
                let cell = tableView.dequeueReusableCell(withIdentifier: "CardTVCell", for: indexPath) as! CardTVCell
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
        let cardNumber = self.cardDetails[indexPath.row].cardn
        cell.cardNumberLbl.text = maskCardNumber(cardNumber)
        cell.deleteCardBtn.tag = indexPath.row
        cell.delegate = self
                return cell
    }
    
    private func maskCardNumber(_ cardNumber: String) -> String {
        guard cardNumber.count >= 4 else { return cardNumber }
        let lastFour = String(cardNumber.suffix(4))
        let maskedCount = cardNumber.count - 4
        let asteriskGroups = String(repeating: "**** ", count: maskedCount / 4)
        let remainingAsterisks = String(repeating: "*", count: maskedCount % 4)
        let maskedPart = asteriskGroups + remainingAsterisks
        return "\(maskedPart)\(lastFour)"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viaConirmPage {
            Cart.shared.cardNumber = self.cardDetails[indexPath.row].cardn
            self.delegate?.selectedCardDetails()
            self.navigationController?.popViewController(animated: true)
        }
    }
}
extension PaymentVC: CardCellDelegate {
    func deleteCardTapped(at index: Int) {
        guard self.cardDetails.indices.contains(index) else { return }
        let alert = UIAlertController(title: "Delete card?", message: "Are you sure you want to delete this card?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.deleteCardService(cardid: self.cardDetails[index].id, index: index)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
