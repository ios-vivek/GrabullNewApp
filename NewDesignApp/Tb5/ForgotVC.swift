//
//  ForgotVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 12/11/24.
//

import UIKit

class ForgotVC: UIViewController {
    @IBOutlet weak var forgotField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var forgotView: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        forgotField.placeholder = "Email/Phone"
        saveButton.setRounded(cornerRadius: 8)
        cancelButton.setRounded(cornerRadius: 8)
        forgotView.layer.cornerRadius = 20
        self.view.backgroundColor = .white
        forgotField.setPlaceHolderColor(.gGray200)

    }
    
    @IBAction func dismissControllerPage() {
        self.dismiss(animated: true) {
            
        }
    }
    @IBAction func forgotActionAction() {
        forgotPassService(email: forgotField.text!)
    }
    func forgotPassService(email: String) {
        if forgotField.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter Email/Phone")
            return
        }
        
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "email" : email
        ]) { _, new in new }
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.forgotpass, forModelType: ForgotPasswordResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            if success.data.code == 200 {
                let alert = UIAlertController(title: "Forgot password", message: success.data.data.message, preferredStyle: UIAlertController.Style.alert)

                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { ok in
                    self.dismissControllerPage()
                }))

                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            else {
                self.showAlert(title: "Error", msg: success.data.data.message)
           }
        } ErrorHandler: { error in
                self.showAlert(title: "Error", msg: error)
            UtilsClass.hideProgressHud(view: self.view)
        }
    }
}
