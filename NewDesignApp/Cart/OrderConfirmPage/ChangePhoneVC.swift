//
//  ChangePhoneVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 18/11/24.
//

import UIKit
protocol ChangePhoneNumberDelegate: AnyObject {
    func changesNumber()
}
class ChangePhoneVC: UIViewController {
    @IBOutlet weak var changePhoneField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var changeView: UIView!
    weak var delegate: ChangePhoneNumberDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        changePhoneField.placeholder = "Phone"
        saveButton.setRounded(cornerRadius: 8)
        cancelButton.setRounded(cornerRadius: 8)
        changeView.layer.cornerRadius = 20
        changePhoneField.setPlaceHolderColor(.gGray200)
        
    }
    
    @IBAction func dismissControllerPage() {
        self.dismiss(animated: true) {
        }
    }
    @IBAction func changePhoneAction() {
        if changePhoneField.text!.count != 10 {
            showAlert(title: "Validatetion Error", msg: "Please enter valid number")
            return
        }
        
        Cart.shared.alternateNumber = changePhoneField.text!
        self.delegate?.changesNumber()
        self.dismissControllerPage()
    }
   
}
extension UITextField {
    func setPlaceHolderColor(_ color: UIColor) {
        guard let placeholder = self.placeholder else { return }
        let attributedPlaceholder: NSAttributedString = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: color])
        self.attributedPlaceholder = attributedPlaceholder
        self.textColor = .black
    }
}
