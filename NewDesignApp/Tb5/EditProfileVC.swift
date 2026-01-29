//
//  EditProfileVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 31/08/24.
//

import UIKit

class EditProfileVC: UIViewController {
    @IBOutlet weak var fNameFld: UITextField!
    @IBOutlet weak var sNameFld: UITextField!
    @IBOutlet weak var emailFld: UITextField!
    @IBOutlet weak var phoneFld: UITextField!
    @IBOutlet weak var submitRequestBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        submitRequestBtn.setRounded(cornerRadius: 10)
        submitRequestBtn.setFontWithString(text: "UPDATE", fontSize: 16)
        // Do any additional setup after loading the view.
        fNameFld.text = APPDELEGATE.userResponse?.customer.firstName
        sNameFld.text = APPDELEGATE.userResponse?.customer.lastName
        emailFld.text = APPDELEGATE.userResponse?.customer.email
        emailFld.textColor = .gray
        phoneFld.text = APPDELEGATE.userResponse?.customer.phone
        self.view.backgroundColor = .white
        fNameFld.backgroundColor = .white
        sNameFld.backgroundColor = .white
        emailFld.backgroundColor = .white
        phoneFld.backgroundColor = .white
        fNameFld.setPlaceHolderColor(.gGray200)
        sNameFld.setPlaceHolderColor(.gGray200)
        emailFld.setPlaceHolderColor(.gGray200)
        phoneFld.setPlaceHolderColor(.gGray200)

    }
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitRequestAction() {
        if fNameFld.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter first name.")
            return
        }
        else if sNameFld.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter last name.")
            return
        }
        else if emailFld.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter email address.")
            return
        }
        else if phoneFld.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter phone number.")
            return
        }
        else {
            self.signUpService()
        }
    }
    func signUpService() {
        let oldFirstName = APPDELEGATE.userResponse?.customer.firstName ?? ""
        let oldLastName  = APPDELEGATE.userResponse?.customer.lastName ?? ""
        let oldEmail     = APPDELEGATE.userResponse?.customer.email ?? ""
        let oldMobile    = APPDELEGATE.userResponse?.customer.phone ?? ""
        
        let newFirstName = fNameFld.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let newLastName  = sNameFld.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let newEmail     = emailFld.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let newMobile    = phoneFld.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        let isProfileChanged =
            oldFirstName != newFirstName ||
            oldLastName  != newLastName  ||
            oldEmail     != newEmail     ||
            oldMobile    != newMobile
        
        guard isProfileChanged else {
            showAlert(title: "Alert", msg: "No profile data changed")
            return
        }
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "first_name" : fNameFld.text!,
            "last_name" : sNameFld.text!,
            "email" : emailFld.text!,
            "mobile" : phoneFld.text!,
        ]) { _, new in new }
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.editProfile, forModelType: LoginResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)

                let alertController = UIAlertController(
                    title: "Success",
                    message: "Profile updated successfully.",
                    preferredStyle: .alert
                )

                let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                    APPDELEGATE.userResponse = success.data.data
                    self.navigationController?.popViewController(animated: true)
                }

                alertController.addAction(okAction)
                self.present(alertController, animated: true)

            } ErrorHandler: { error in
                UtilsClass.hideProgressHud(view: self.view)
                self.showAlert(title: "Error", msg: error)
            }
    }

}
