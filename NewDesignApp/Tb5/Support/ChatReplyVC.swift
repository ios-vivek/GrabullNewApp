//
//  SupportVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 20/08/25.
//

import UIKit
class ChatReplyVC: UIViewController {
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var submitBth: UIButton!
    @IBOutlet weak var ordernumberTextFld: UITextField!
    @IBOutlet weak var msgTextView: UITextView!
    var complainID = ""
    var subject = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = pageBackgroundColor
        submitBth.setRounded(cornerRadius: 4)
        submitBth.setFontWithString(text: "Submit Query", fontSize: 16)
        submitBth.backgroundColor = kBlueColor
        ordernumberTextFld.placeholder = "Subject or Order Number"
        
        ordernumberTextFld.layer.borderWidth = 1
        ordernumberTextFld.layer.borderColor = kborderColor.cgColor
        
        msgTextView.layer.borderWidth = 1
        msgTextView.layer.borderColor = kborderColor.cgColor
        ordernumberTextFld.text = subject
        msgTextView.text = ""
        ordernumberTextFld.setPlaceHolderColor(.gGray200)

    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
    }
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func referRestaurantAction() {
        // Validate required fields
        guard let orderNumber = ordernumberTextFld.text, !orderNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.showAlert(title: "Error", msg: "Please enter subject or order number.")
            return
        }
        
        guard let message = msgTextView.text, !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.showAlert(title: "Error", msg: "Please enter your message.")
            return
        }
        
        reportQuerySubmit()
    }
    
    private func reportQuerySubmit() {
        let orderNumber = ordernumberTextFld.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let message = msgTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "subject": orderNumber,
            "details": message,
            "complaintid": complainID,
        ]) { _, new in new }
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.customerSupport, forModelType: SupportConcernResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            if success.data.status == "Success" {
                let alertController = UIAlertController(title: "Success", message: "Your query has been submitted successfully.", preferredStyle: .alert)
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
            self.showAlert(title: "Error", msg: "Something went wrong.")
        }
    }

}

