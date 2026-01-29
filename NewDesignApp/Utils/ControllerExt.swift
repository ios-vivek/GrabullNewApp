//
//  ControllerExt.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 10/09/24.
//

import Foundation
import UIKit
extension UIViewController {
    func viewController(viewController: UIViewController.Type, storyName: String) -> some UIViewController {
            return UIStoryboard(name: storyName, bundle: nil).instantiateViewController(withIdentifier: String(describing: viewController.self))
        }
     func pushAnyViewController<T: UIViewController>(viewController: T, storyboardName: String) {
        guard let nextViewController = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: String(describing: T.self)) as? T else { return }
        viewController.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
