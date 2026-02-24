//
//  RestaurantCartDeatils.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 12/10/24.
//

import Foundation
import UIKit

extension UIViewController {

    func showToast(message: String, font: UIFont) {

        guard let window = UIApplication.shared
                .connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?
                .windows
                .first(where: { $0.isKeyWindow }) else { return }

        let toastLabel = UILabel()
        toastLabel.frame = CGRect(
            x: 50,
            y: window.frame.size.height - 120,
            width: window.frame.size.width - 100,
            height: 40
        )

        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true

        window.addSubview(toastLabel)

        UIView.animate(
            withDuration: 3.0,
            delay: 0.1,
            options: .curveEaseOut,
            animations: {
                toastLabel.alpha = 0.0
            },
            completion: { _ in
                toastLabel.removeFromSuperview()
            }
        )
    }
}

extension Dictionary {

    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }

    func printJson() {
        print(json)
    }

}
