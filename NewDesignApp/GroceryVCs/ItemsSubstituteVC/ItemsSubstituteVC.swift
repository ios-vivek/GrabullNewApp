//
//  ItemsSubstituteVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 04/07/26.
//

import UIKit

class ItemsSubstituteVC: UIViewController {
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        continueButton.setRounded(cornerRadius: 8)
        continueButton.setFontWithString(text: "Yes", fontSize: 12)
        continueButton.backgroundColor = themeBackgrounColor
        
        cancelButton.setRounded(cornerRadius: 8)
        cancelButton.setFontWithString(text: "No Thanks", fontSize: 12)
        cancelButton.backgroundColor = kColor_buttonTitle
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        GroceryCartData.shared.isSubstituteItemApplied = false
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapContinue(_ sender: Any) {
        GroceryCartData.shared.isSubstituteItemApplied = true
        self.dismiss(animated: true, completion: nil)
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
