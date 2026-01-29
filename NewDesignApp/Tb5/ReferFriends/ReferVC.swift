//
//  ReferVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 20/08/25.
//

import UIKit
//POST /web-api-ios/refer-friend/
//{"api_id":"123","api_key":"abc","customer_id":"Customer_id","email":"friend email"}

//POST /web-api-ios/refer-friend-list/
// {"api_id":"123","api_key":"abc","customer_id":"Customer_id"}
    class ReferVC: UIViewController {
        @IBOutlet weak var tbl: UITableView!
        @IBOutlet weak var emailTextField: UITextField!
        @IBOutlet weak var sendMailBth: UIButton!

        var referList = [ReferList]()
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = pageBackgroundColor
            tbl.backgroundColor = .clear
            emailTextField.layer.borderWidth = 1
            emailTextField.layer.borderColor = kborderColor.cgColor
            sendMailBth.setRounded(cornerRadius: 4)
            sendMailBth.setFontWithString(text: "Sent Email", fontSize: 16)
            sendMailBth.backgroundColor = kBlueColor
            getFriendList()
            emailTextField.setPlaceHolderColor(.gGray200)

        }
        @IBAction func backAction() {
            self.navigationController?.popViewController(animated: true)
        }
        @IBAction func sentMailAction() {
            guard let email = emailTextField.text, !email.isEmpty else {
                self.showAlert(title: "Error", msg: "Please enter email address.")
                return
            }
            
            guard isValidEmail(email) else {
                self.showAlert(title: "Error", msg: "Please enter a valid email address.")
                return
            }
            
            // Proceed with sending email
            sendReferralEmail(email: email)
        }
        
        private func isValidEmail(_ email: String) -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }
        
        private func sendReferralEmail(email: String) {
            var parameters = CommonAPIParams.base()
            parameters.merge([
                "email": email
            ]) { _, new in new }
            
            UtilsClass.showProgressHud(view: self.view)
            WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.referFriend, forModelType: ReferFriendResponse.self) { success in
                UtilsClass.hideProgressHud(view: self.view)
                if success.data.status == "Success" {
                    let alertController = UIAlertController(title: "Success", message: "Referral email sent successfully.", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
                        self.emailTextField.text = ""
                        self.getFriendList()
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
                self.showAlert(title: "Error", msg: error)
            }
        }
        
        private func getFriendList() {
            let parameters = CommonAPIParams.base()
            
            UtilsClass.showProgressHud(view: self.view)
            WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.referFriendList, forModelType: ReferFriendListResponse.self) { success in
                UtilsClass.hideProgressHud(view: self.view)
                // Handle success response and reload table
                self.referList = success.data.data.refertList
                self.tbl.reloadData()
            } ErrorHandler: { error in
                UtilsClass.hideProgressHud(view: self.view)
                self.showAlert(title: "Error", msg: "Failed to load friend list.")
            }
        }

    }
    
    extension ReferVC: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // Return the count of friend list items
            return referList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as! FriendListCell

            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.updateUI(list: referList[indexPath.row])
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Handle cell selection if needed
        }
    }
