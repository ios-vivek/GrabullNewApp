//
//  ChangePasswordVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 14/11/24.
//

import UIKit

class ChangePasswordVC: UIViewController {
    @IBOutlet weak var passwordFld: UITextField!
    @IBOutlet weak var cpasswordFld: UITextField!
    @IBOutlet weak var submitRequestBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        submitRequestBtn.setRounded(cornerRadius: 10)
        submitRequestBtn.setFontWithString(text: "UPDATE", fontSize: 16)
        self.view.backgroundColor = .white
        passwordFld.setPlaceHolderColor(.gGray200)

        cpasswordFld.setPlaceHolderColor(.gGray200)

    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitRequestAction() {
        if passwordFld.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter password.")
            return
        }
        else if cpasswordFld.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter confirm password.")
            return
        }
        else if passwordFld.text! != cpasswordFld.text! {
            self.showAlert(title: "Error", msg: "Password and confirm password does not match.")
            return
        } else {
            self.changePasswordService()
           // self.navigationController?.popViewController(animated: true)
        }
    }
    func changePasswordService() {
       
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "pass" : cpasswordFld.text!
        ]) { _, new in new }
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.changePassword, forModelType: ChangePasswordResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            if success.data.data.result == "Password changed successfully" {
                let alertController = UIAlertController(title: "Success", message: "Password has been updated successfully.", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(OKAction)
                OperationQueue.main.addOperation {
                    self.present(alertController, animated: true,
                                 completion:nil)
                }
            } else {
                self.showAlert(title: "Fail", msg: success.data.data.result)
            }
        
            
        } ErrorHandler: { error in
            if error == "Invalid User Details" || error == "Enter Different Password" {
                self.showAlert(title: "Error", msg: error)
            } else {
                self.showAlert(title: "Error", msg: "Something went wrong, try again later.")
            }

            UtilsClass.hideProgressHud(view: self.view)
        }
    }

}
