//
//  SignupVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 06/11/24.
//

import UIKit
protocol SignupSuccessfullyDelegate: AnyObject {
    func signupCompleted()
}
class SignupVC: UIViewController {
    @IBOutlet weak var fNameFld: UITextField!
    @IBOutlet weak var sNameFld: UITextField!
    @IBOutlet weak var emailFld: UITextField!
    @IBOutlet weak var phoneFld: UITextField!
    @IBOutlet weak var passwordFld: UITextField!
    @IBOutlet weak var confirmPassFld: UITextField!

    @IBOutlet weak var submitRequestBtn: UIButton!
    weak var delegate: SignupSuccessfullyDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        submitRequestBtn.setRounded(cornerRadius: 10)
        submitRequestBtn.setFontWithString(text: "SUBMIT", fontSize: 16)
        phoneFld.delegate = self
        // Do any additional setup after loading the view.
       // self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
        self.setDefaultBack()
        fNameFld.setPlaceHolderColor(.gGray200)
        sNameFld.setPlaceHolderColor(.gGray200)
        emailFld.setPlaceHolderColor(.gGray200)
        phoneFld.setPlaceHolderColor(.gGray200)
        passwordFld.setPlaceHolderColor(.gGray200)
        confirmPassFld.setPlaceHolderColor(.gGray200)

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
        else if passwordFld.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter password.")
            return
        }
        else if confirmPassFld.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter confirm password.")
            return
        }
        else if passwordFld.text! != confirmPassFld.text! {
            self.showAlert(title: "Error", msg: "Password and confirm password does not match.")
            return
        } else {
            self.signUpService()
           // self.navigationController?.popViewController(animated: true)
        }
    }
    func signUpService() {
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "registervia" : "Register",
            "fname" : fNameFld.text!,
            "lname" : sNameFld.text!,
            "email" : emailFld.text!,
            "phone" : phoneFld.text!,
            "pass" : passwordFld.text!,
        ]) { _, new in new }
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.getSignup, forModelType: LoginResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            let alertController = UIAlertController(title: "Success", message: "You are successfully registered.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
                APPDELEGATE.userResponse = success.data.data
                self.delegate?.signupCompleted()
                self.navigationController?.popViewController(animated: true)

            }
            alertController.addAction(OKAction)
            OperationQueue.main.addOperation {
                self.present(alertController, animated: true,
                             completion:nil)
            }
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
            self.showAlert(title: "Error", msg: error)
        }
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SignupVC: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString // this line

        return newText.length <= 10
    }
}
extension UIViewController {
    func showAlert(title: String, msg: String) {
        // create the alert
               let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)

               // add an action (button)
               alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

               // show the alert
               self.present(alert, animated: true, completion: nil)
    }
}
