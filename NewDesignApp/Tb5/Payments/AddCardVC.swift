//
//  PaymentVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 20/08/25.
//

import UIKit

    class AddCardVC: UIViewController {
        @IBOutlet weak var cardNumberFld: UITextField!
        @IBOutlet weak var cardHolderFld: UITextField!
        @IBOutlet weak var submitRequestBtn: UIButton!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            submitRequestBtn.setRounded(cornerRadius: 10)
            submitRequestBtn.setFontWithString(text: "Save Details", fontSize: 16)
            self.view.backgroundColor = .white
            setupCardNumberField()
            cardNumberFld.setPlaceHolderColor(.gGray200)
            cardHolderFld.setPlaceHolderColor(.gGray200)

        }
        @IBAction func backAction() {
            self.navigationController?.popViewController(animated: true)
        }
        @IBAction func submitRequestAction() {
            if cardNumberFld.text!.isEmpty {
                self.showAlert(title: "Error", msg: "Please enter card number.")
                return
            }
            else if cardNumberFld.text!.count < 12 || cardNumberFld.text!.count > 19 {
                self.showAlert(title: "Error", msg: "Please enter a valid card number (12–19 digits).")
                return
            }
            else if cardHolderFld.text!.isEmpty {
                self.showAlert(title: "Error", msg: "Please enter card holder name.")
                return
            }
            else {
                self.view.endEditing(true)
                self.saveCardService()
               // self.navigationController?.popViewController(animated: true)
            }
        }
        func saveCardService() {
            var parameters = CommonAPIParams.base()
            parameters.merge([
                "cardnumber" : cardNumberFld.text!,
                "cardholder" : cardHolderFld.text!,
                "cardzip" : "123456"
            ]) { _, new in new }
            UtilsClass.showProgressHud(view: self.view)
            WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.addCard, forModelType: SaveCardResponse.self) { success in
                UtilsClass.hideProgressHud(view: self.view)
                if success.data.data.result == "Card details added successfully" {
                    let alertController = UIAlertController(title: "Success", message: "Card added successfully.", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(OKAction)
                    OperationQueue.main.addOperation {
                        self.present(alertController, animated: true,
                                     completion:nil)
                    }
                } else {
                    self.showAlert(title: "Error", msg: success.data.data.result)
                }
                
            } ErrorHandler: { error in
                UtilsClass.hideProgressHud(view: self.view)
                self.showAlert(title: "Error", msg: "Something went wrong.")
            }
        }
        
        private func setupCardNumberField() {
            cardNumberFld.delegate = self
            cardNumberFld.keyboardType = .numberPad
            cardNumberFld.addTarget(self, action: #selector(cardNumberFieldDidChange), for: .editingChanged)
        }
        
        @objc private func cardNumberFieldDidChange(_ textField: UITextField) {
            // Remove any non-digit characters
            let cleaned = textField.text?.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression) ?? ""
            
            // Limit to max 19 digits
            let limited = String(cleaned.prefix(19))
            
            // Update text field
            textField.text = limited
        }

    }
extension AddCardVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == cardNumberFld {
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            let cleaned = newText.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
            return cleaned.count <= 19
        }
        return true
    }
}
