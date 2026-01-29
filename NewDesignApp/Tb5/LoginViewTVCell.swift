//
//  LoginViewTVCell.swift
//  NewDesignApp
//
//  Created by Vivek Singh on 09/06/1946 Saka.
//

import UIKit
protocol LoginDelegate: AnyObject {
    func loggedInAction(email: String, password: String)
    func signupAction()
    func loginErrorAction(msg: String)
    func forgotActionAction()
}
class LoginViewTVCell: UITableViewCell {
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var forgotPassField: UIButton!


    weak var delegate: LoginDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setAttributesString()
        setForgotAttributesString()
        loginBtn.setRounded(cornerRadius: 10)
        loginBtn.setFontWithString(text: "LOGIN", fontSize: 16)
        signUpBtn.setRounded(cornerRadius: 10)
        signUpBtn.setFontWithString(text: "SIGNUP", fontSize: 16)
        emailField.text = "webteamaaa@gmail.com"//"viveksinghrox@gmail.com"//
        passwordField.text = "123456" //"123456"
        emailField.setPlaceHolderColor(.gGray200)
        passwordField.setPlaceHolderColor(.gGray200)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func loginPage() {
        if emailField.text!.isEmpty {
            self.delegate?.loginErrorAction(msg: "Please enter email address.")
            return
        }
        else if passwordField.text!.isEmpty {
            self.delegate?.loginErrorAction(msg: "Please enter password.")
            return
        } else {
            self.delegate?.loggedInAction(email: emailField.text!, password: passwordField.text!)
        }
    }
    @IBAction func signupPage() {
        self.delegate?.signupAction()
    }
    @IBAction func forgotPassword() {
        self.delegate?.forgotActionAction()
    }
    func setAttributesString(){
        let str1 = "By clicking, I accept the"
        let str2 = " Terms & Conditions "
        let str3 = "& "
        let str4 = "Privacy Policy"
        let font1 = UIFont.systemFont(ofSize: 10)
        let font2 = UIFont.boldSystemFont(ofSize: 10)
        let attributes1: [NSAttributedString.Key: Any] = [
        .font: font1,
        .foregroundColor: UIColor.lightGray,
        ]
        let attributes2: [NSAttributedString.Key: Any] = [
        .font: font2,
        .foregroundColor: UIColor.black,
        ]
        let attributedQuote = NSMutableAttributedString(string: str1, attributes: attributes1)
        attributedQuote.append(NSMutableAttributedString(string: str2, attributes: attributes2))
        attributedQuote.append(NSMutableAttributedString(string: str3, attributes: attributes1))
        attributedQuote.append(NSMutableAttributedString(string: str4, attributes: attributes2))

        termsButton.setAttributedTitle(attributedQuote, for: .normal)

       
    }
    func setForgotAttributesString(){
        let str1 = "Forgot Password?   "
        let str2 = "Click Here"
        let font1 = UIFont.systemFont(ofSize: 10)
        let font2 = UIFont.boldSystemFont(ofSize: 14)
        let attributes1: [NSAttributedString.Key: Any] = [
        .font: font1,
        .foregroundColor: UIColor.lightGray,
        ]
        let attributes2: [NSAttributedString.Key: Any] = [
        .font: font2,
        .foregroundColor: UIColor.black,.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedQuote = NSMutableAttributedString(string: str1, attributes: attributes1)
        attributedQuote.append(NSMutableAttributedString(string: str2, attributes: attributes2))
       

        forgotPassField.setAttributedTitle(attributedQuote, for: .normal)

       
    }


}
