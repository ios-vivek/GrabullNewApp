//
//  Untitled.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 27/05/25.
//
import UIKit
protocol RecipientDetailsDelegate: AnyObject {
    func recipientDetailsSubmitted(fname: String, lname: String, phone: String)
}
class AsGiftVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var giftFromField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var giftFromView: UIView!
    @IBOutlet weak var fNameView: UIView!
    @IBOutlet weak var lNameView: UIView!
    @IBOutlet weak var phoneView: UIView!
    
    var fName = ""
    var lName = ""
    var phone =  ""


    weak var delegate: RecipientDetailsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.backgroundColor = .clear
        giftFromField.text = "\(APPDELEGATE.userResponse?.customer.fullName ?? "")"
        saveButton.setRounded(cornerRadius: 8)
        saveButton.backgroundColor = themeBackgrounColor
        
        lNameView.layer.cornerRadius = 8
        lNameView.layer.masksToBounds = true
        
        fNameView.layer.cornerRadius = 8
        fNameView.layer.masksToBounds = true
        
        phoneView.layer.cornerRadius = 8
        phoneView.layer.masksToBounds = true
        
        giftFromView.layer.cornerRadius = 8
        giftFromView.layer.masksToBounds = true
        
        phoneField.delegate = self
        
        firstNameField.text = fName
        lastNameField.text = lName
        phoneField.text = phone
        
        giftFromField.setPlaceHolderColor(.gGray200)
        firstNameField.setPlaceHolderColor(.gGray200)
        lastNameField.setPlaceHolderColor(.gGray200)
        phoneField.setPlaceHolderColor(.gGray200)

    }
    
    @IBAction func dismissControllerPage() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submittedDetails() {
        if firstNameField.text!.isEmpty {
            showAlert(title: "Error", msg: "Please enter first name")
        }
        else if lastNameField.text!.isEmpty {
            showAlert(title: "Error", msg: "Please enter last name")
        }
        else if phoneField.text!.isEmpty {
            showAlert(title: "Error", msg: "Please enter phone number")
        }
        else if phoneField.text!.count < 10 {
            showAlert(title: "Error", msg: "Please enter valid phone number")
        } else {
            self.delegate?.recipientDetailsSubmitted(fname: firstNameField.text!, lname: lastNameField.text!, phone: phoneField.text!)
            self.dismissControllerPage()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let noSpaces = string.replacingOccurrences(of: " ", with: "")
            let updatedText = text.replacingCharacters(in: textRange, with: noSpaces)
            if updatedText.count > 10 {
                return false
            }
        }
        return true
    }
}
