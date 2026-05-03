//
//  HistoryHomeVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 20/08/25.
//

import UIKit

class HistoryHomeVC: UIViewController {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var ongoingView: UIView!
    @IBOutlet weak var pastView: UIView!
    @IBOutlet weak var upcominghView: UIView!
    @IBOutlet weak var dineInView: UIView!
    
    var backBtnEnable = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.isHidden = backBtnEnable
        // Apply card style
            ongoingView.applyCardStyle()
            pastView.applyCardStyle()
            upcominghView.applyCardStyle()
            dineInView.applyCardStyle()
            
        // Enable taps on each view
        addTapGesture(to: ongoingView, action: #selector(ongoingTapped))
        addTapGesture(to: pastView, action: #selector(pastTapped))
        addTapGesture(to: upcominghView, action: #selector(upcomingTapped))
        addTapGesture(to: dineInView, action: #selector(dineInTapped))
        self.view.backgroundColor = pageBackgroundColor
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("pushnotification"), object: nil)

    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        switch NotificationType(rawValue: APPDELEGATE.notificationType) {
        case .OnGoingOrder:
                if let topVC = UIApplication.topViewController(),
                   !(topVC is OngoingHistoryVC) {
                    self.navigateToHistory()
                }
        case .UpcomingOrder:
                if let topVC = UIApplication.topViewController(),
                   !(topVC is UpcomingHistoryVC) {
                    self.navigateToUpcomingHistory()
            }
        case .PastHistory:
                if let topVC = UIApplication.topViewController(),
                   !(topVC is UpcomingHistoryVC) {
                    self.navigateToUpcomingHistory()
                }
        case .DineIn:
                if let topVC = UIApplication.topViewController(),
                   !(topVC is UpcomingHistoryVC) {
                    self.navigateToUpcomingHistory()
                }
        default:
            break
        }
        
        APPDELEGATE.notificationType = ""
    }

    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Gesture Helpers
    private func addTapGesture(to view: UIView, action: Selector) {
        let tap = UITapGestureRecognizer(target: self, action: action)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - Actions
        @objc func ongoingTapped() {
            navigateToHistory()
        }
        
        @objc func pastTapped() {
            navigateToPastHistory()
        }
        
        @objc func upcomingTapped() {
            navigateToUpcomingHistory()
        }
        
        @objc func dineInTapped() {
            navigateToDineHistory()
        }
        
        // MARK: - Navigation
        private func navigateToHistory() {
            let history = UIStoryboard(name: "History", bundle: nil)
            let historyVC = history.instantiateViewController(withIdentifier: "OngoingHistoryVC") as! OngoingHistoryVC
            self.navigationController?.pushViewController(historyVC, animated: true)
        }
    private func navigateToPastHistory() {
        let history = UIStoryboard(name: "History", bundle: nil)
        let historyVC = history.instantiateViewController(withIdentifier: "PastHistoryVC") as! PastHistoryVC
        self.navigationController?.pushViewController(historyVC, animated: true)
    }
    private func navigateToUpcomingHistory() {
            let history = UIStoryboard(name: "History", bundle: nil)
            let historyVC = history.instantiateViewController(withIdentifier: "UpcomingHistoryVC") as! UpcomingHistoryVC
            self.navigationController?.pushViewController(historyVC, animated: true)
    }
    private func navigateToDineHistory() {
        let history = UIStoryboard(name: "History", bundle: nil)
        let historyVC = history.instantiateViewController(withIdentifier: "DineinHistoryVC") as! DineinHistoryVC
        self.navigationController?.pushViewController(historyVC, animated: true)
    }
}
extension UIView {
    func applyCardStyle(cornerRadius: CGFloat = 12,
                        shadowColor: UIColor = .black,
                        shadowOpacity: Float = 0.1,
                        shadowRadius: CGFloat = 6,
                        shadowOffset: CGSize = .zero,
                        bgColor: UIColor = .white) {
        self.backgroundColor = bgColor
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = shadowOffset
    }
}
