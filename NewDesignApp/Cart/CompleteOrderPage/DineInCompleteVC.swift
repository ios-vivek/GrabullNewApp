//
//  DineInCompleteVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 25/01/25.
//

import UIKit
import Lottie

class DineInCompleteVC: UIViewController {
    @IBOutlet weak var orderCompleteImageView: LottieAnimationView!
    @IBOutlet weak var orderNumberLbl: UILabel!
    @IBOutlet weak var supportNumberLbl: UILabel!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var tbl: UITableView!

var orderNumber = ""
    var supportNumber = ""
    var msg = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        orderCompleteImageView.play()
        orderCompleteImageView.loopMode = .loop
        orderNumberLbl.text = "Order Number: \(orderNumber)"
        supportNumberLbl.text = "Support Number: \(supportNumber)"
        msgLbl.text = "\(msg)"
        tbl.backgroundColor = .clear
        self.view.backgroundColor = .white
    }
    
    @IBAction func proceedAction() {
        for controller in self.navigationController!.viewControllers as Array
        {
          // here YourViewController is your firstVC
         if controller.isKind(of: TabBarVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
         }
        }

    }
}
