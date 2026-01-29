//
//  ButtonExt.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 09/08/24.
//

import Foundation
import UIKit

extension UIButton {
    func setRounded(cornerRadius: Int) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
    }
    func setFontWithString(text: String, fontSize: Int) {
        let attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        self.setAttributedTitle(attributedText, for: .normal)
    }
    func setTitleColor(color: UIColor) {
        self.setTitleColor(color, for: .normal)
    }
}
