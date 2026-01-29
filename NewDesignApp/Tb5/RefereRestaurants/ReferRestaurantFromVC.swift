//
//  ReferVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 20/08/25.
//
//POST /web-api-ios/refer-restaurant/
// {"api_id":"123","api_key":"abc","customer_id":"Customer_id","name":"Restaurant Name","address":"Restaurant address","owner":"Owner name","phone":"1234567890","website":"www.restaurant.com","email":"contact email","details":"if any"}
import UIKit

    class ReferRestaurantFromVC: UIViewController {
        @IBOutlet weak var tbl: UITableView!
        @IBOutlet weak var restNameTextField: UITextField!
        @IBOutlet weak var addressTextField: UITextField!
        @IBOutlet weak var ownerNameTextField: UITextField!
        @IBOutlet weak var phoneTextField: UITextField!
        @IBOutlet weak var websiteTextField: UITextField!
        @IBOutlet weak var emailTextField: UITextField!
        @IBOutlet weak var messageTxtView: UITextView!

        @IBOutlet weak var submitBth: UIButton!


        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = pageBackgroundColor
            tbl.backgroundColor = .clear
            restNameTextField.layer.borderWidth = 1
            restNameTextField.layer.borderColor = kborderColor.cgColor
            
            addressTextField.layer.borderWidth = 1
            addressTextField.layer.borderColor = kborderColor.cgColor
            
            ownerNameTextField.layer.borderWidth = 1
            ownerNameTextField.layer.borderColor = kborderColor.cgColor
            
            phoneTextField.layer.borderWidth = 1
            phoneTextField.layer.borderColor = kborderColor.cgColor
            
            websiteTextField.layer.borderWidth = 1
            websiteTextField.layer.borderColor = kborderColor.cgColor
            
            emailTextField.layer.borderWidth = 1
            emailTextField.layer.borderColor = kborderColor.cgColor
            
            messageTxtView.layer.borderWidth = 1
            messageTxtView.layer.borderColor = kborderColor.cgColor
            messageTxtView.text = ""
            
           submitBth.setRounded(cornerRadius: 4)
            submitBth.setFontWithString(text: "Submit", fontSize: 16)
            submitBth.backgroundColor = kBlueColor
            restNameTextField.setPlaceHolderColor(.gGray200)
            addressTextField.setPlaceHolderColor(.gGray200)
            ownerNameTextField.setPlaceHolderColor(.gGray200)
            phoneTextField.setPlaceHolderColor(.gGray200)
            websiteTextField.setPlaceHolderColor(.gGray200)
            emailTextField.setPlaceHolderColor(.gGray200)

        }
        @IBAction func backAction() {
            self.navigationController?.popViewController(animated: true)
        }
        @IBAction func referRestaurantAction() {
            // Validate required fields
            guard let restaurantName = restNameTextField.text, !restaurantName.isEmpty else {
                self.showAlert(title: "Error", msg: "Please enter restaurant name.")
                return
            }
            
            guard let address = addressTextField.text, !address.isEmpty else {
                self.showAlert(title: "Error", msg: "Please enter restaurant address.")
                return
            }
            
            guard let ownerName = ownerNameTextField.text, !ownerName.isEmpty else {
                self.showAlert(title: "Error", msg: "Please enter owner name.")
                return
            }
            
            guard let phone = phoneTextField.text, !phone.isEmpty else {
                self.showAlert(title: "Error", msg: "Please enter phone number.")
                return
            }
            /*
            guard let email = emailTextField.text, !email.isEmpty else {
                self.showAlert(title: "Error", msg: "Please enter email address.")
                return
            }
            
            guard isValidEmail(email) else {
                self.showAlert(title: "Error", msg: "Please enter a valid email address.")
                return
            }
            */
            
            // Submit restaurant referral
            submitRestaurantReferral(
                name: restaurantName,
                address: address,
                owner: ownerName,
                phone: phone,
                website: websiteTextField.text ?? "",
                email: emailTextField.text ?? "",
                details: messageTxtView.text ?? ""
            )
        }
        
        private func isValidEmail(_ email: String) -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }
        
        private func submitRestaurantReferral(name: String, address: String, owner: String, phone: String, website: String, email: String, details: String) {
            
            var parameters = CommonAPIParams.base()
            parameters.merge([
                "name": name,
                "address": address,
                "owner": owner,
                "phone": phone,
                "website": website,
                "email": email,
                "details": details,
            ]) { _, new in new }
            
            UtilsClass.showProgressHud(view: self.view)
            WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.referRestaurant, forModelType: ReferRestaurantResponse.self) { success in
                UtilsClass.hideProgressHud(view: self.view)
                if success.data.status == "Success" {
                    let alertController = UIAlertController(title: "Success", message: "Restaurant referral submitted successfully.", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(OKAction)
                    OperationQueue.main.addOperation {
                        self.present(alertController, animated: true, completion: nil)
                    }
                } else {
                    self.showAlert(title: "Error", msg: success.data.error ?? "Something went wrong.")
                }
            } ErrorHandler: { error in
                UtilsClass.hideProgressHud(view: self.view)
                self.showAlert(title: "Error", msg: "Something went wrong, try again later.")
            }
        }



    }
