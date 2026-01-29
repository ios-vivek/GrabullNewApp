//
//  ProfileVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 09/08/24.
//

import UIKit

protocol LoginSuccessDelegate: AnyObject {
    func loginCompleted()
    func signupAction()
}
enum ProfileItem: String, CaseIterable {
    case profileDetails = "Profile Details"
    case myaddress = "Address"
    case payments = "Payments"
    case orders = "Order History"
    case changePassword = "Change Password"
    case notifications = "Notifications"
    case myRewards = "My Rewards"
    case referAFriend = "Refer a Friend"
    case referARestaurant = "Refer a Restaurant"
    case workWithUs = "Work With Us"
    case support = "Help"
    case logout = "Logout"
    
    /// Display text (if you don’t want to rely on rawValue everywhere)
    var title: String {
        return self.rawValue
    }
}
class ProfileVC: UIViewController {
    let items = ProfileItem.allCases

    @IBOutlet weak var tbl: UITableView!
    weak var delegate: LoginSuccessDelegate?
    let itemsicon = ["","icon_address","icon_payments","icon_orders","icon_passwordchange","icon_notifications","icon_rewards","icon_refere","icon_refere","icon_workWithUs","icon_support","icon_logout"]
    var loggedIn = false
    var fromOtherPage = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        tbl.backgroundColor  = .clear
        checkedForTblScroll()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("pushnotificationaccount"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UtilsClass.getuserDetails()
        guard let user = APPDELEGATE.userResponse else {
            logoutPage()
            return
        }
        loginAction()
    }
    func loginAction() {
        loggedIn = true
        tbl.reloadData()
        checkedForTblScroll()
        self.dismiss(animated: true) {
            self.delegate?.loginCompleted()
        }
    }
    func logoutPage() {
        APPDELEGATE.clearNotifications()
            self.logout()
    }
    func logout() {
        APPDELEGATE.userResponse = nil
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "SavedPerson")
        loggedIn = false
        tbl.reloadData()
        checkedForTblScroll()
    }
    func checkedForTblScroll() {
        tbl.isScrollEnabled = loggedIn ? true : false
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        if let topVC = UIApplication.topViewController(),
           !(topVC is NotificationListVC) {
            self.navigateToNotification()
        }
        APPDELEGATE.notificationType = ""
    }

    func signInService(email: String, password: String) {
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "customer_id" : email,
            "customer_pw" : password
        ]) { _, new in new }
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.getLogin, forModelType: LoginResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            APPDELEGATE.userResponse = success.data.data
            APPDELEGATE.clearNotifications()
            UtilsClass.saveUserDetails()
            self.loginAction()
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
            self.showAlert(title: "Error", msg: error)
        }
    }

}
extension ProfileVC: EditProfileDelegate {
    func editProfileSelected() {
        let vc = self.viewController(viewController: EditProfileVC.self, storyName: StoryName.Profile.rawValue) as! EditProfileVC
            self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension ProfileVC: LoginDelegate {
    func forgotActionAction() {
        let story = UIStoryboard.init(name: "Profile", bundle: nil)
        let popupVC = story.instantiateViewController(withIdentifier: "ForgotVC") as! ForgotVC
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        self.present(popupVC, animated: true)
    }
    
    func loggedInAction(email: String, password: String) {
        self.signInService(email: email, password: password)
    }
    
    func loginErrorAction(msg: String) {
        self.showAlert(title: "Error", msg: msg)
    }
    
    func signupAction() {
        if fromOtherPage {
            self.dismiss(animated: true) {
                APPDELEGATE.clearNotifications()
                self.delegate?.signupAction()
            }
        } else {
            let vc = self.viewController(viewController: SignupVC.self, storyName: StoryName.Profile.rawValue) as! SignupVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func navigateToNotification() {
        let vc = self.viewController(viewController: NotificationListVC.self, storyName: StoryName.Profile.rawValue) as! NotificationListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loggedIn {
            return items.count
        }
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if loggedIn {
            let sectionItem = items[indexPath.row]
            switch sectionItem{
            case .profileDetails:
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailsTVCell", for: indexPath) as! UserDetailsTVCell
                cell.selectionStyle = .none
                cell.delegate = self
                cell.backgroundColor = .clear
                cell.updateUI()
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileItemTVCell", for: indexPath) as! ProfileItemTVCell
                cell.itemName.text = items[indexPath.row].title
                cell.imageIcon.image = UIImage(named: itemsicon[indexPath.row])
                cell.accessoryType = .disclosureIndicator
                if indexPath.row == ProfileItem.allCases.count - 1 {
                    cell.accessoryType = .none
                }
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoginViewTVCell", for: indexPath) as! LoginViewTVCell
            cell.backgroundColor = .clear
            cell.delegate = self
            return cell
        }
      
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if loggedIn {
            let sectionItem = items[indexPath.row]
            switch sectionItem{
            case .myaddress:
                let vc = self.viewController(viewController: AddressVC.self, storyName: StoryName.Profile.rawValue) as! AddressVC
                self.navigationController?.pushViewController(vc, animated: true)
            case .payments:
                let vc = self.viewController(viewController: PaymentVC.self, storyName: StoryName.Profile.rawValue) as! PaymentVC
                self.navigationController?.pushViewController(vc, animated: true)
            case .orders:
                let history = UIStoryboard(name: "History", bundle: nil)
                let historyVC = history.instantiateViewController(withIdentifier: "HistoryHomeVC") as! HistoryHomeVC
                historyVC.backBtnEnable = false
                self.navigationController?.pushViewController(historyVC, animated: true)
            case .myRewards:
                let vc = self.viewController(viewController: RewardVC.self, storyName: StoryName.Profile.rawValue) as! RewardVC
                self.navigationController?.pushViewController(vc, animated: true)
            case .referAFriend:
                let vc = self.viewController(viewController: ReferVC.self, storyName: StoryName.Profile.rawValue) as! ReferVC
                self.navigationController?.pushViewController(vc, animated: true)
            case .referARestaurant:
                let vc = self.viewController(viewController: ReferRestaurantVC.self, storyName: StoryName.Profile.rawValue) as! ReferRestaurantVC
                self.navigationController?.pushViewController(vc, animated: true)
            case .workWithUs:
                let vc = self.viewController(viewController: WorkWithUsVC.self, storyName: StoryName.Profile.rawValue) as! WorkWithUsVC
                self.navigationController?.pushViewController(vc, animated: true)
            case .support:
                let vc = self.viewController(viewController: SupportVC.self, storyName: StoryName.Profile.rawValue) as! SupportVC
                self.navigationController?.pushViewController(vc, animated: true)
            case .changePassword:
                let vc = self.viewController(viewController: ChangePasswordVC.self, storyName: StoryName.Profile.rawValue) as! ChangePasswordVC
                self.navigationController?.pushViewController(vc, animated: true)
            case .notifications:
                navigateToNotification()
            default:
                if indexPath.row == ProfileItem.allCases.count - 1 {
                    let alertController = UIAlertController(title: "Logout", message: "Are you sure want to logout?", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "Cancel", style: .default) { action in
                        
                    }
                    let cancel = UIAlertAction(title: "Ok", style: .cancel) { alert in
                        self.logout()
                    }
                    alertController.addAction(OKAction)
                    alertController.addAction(cancel)
                    OperationQueue.main.addOperation {
                        self.present(alertController, animated: true,
                                     completion:nil)
                    }
                }}
        }
            
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if loggedIn {
            if indexPath.row == 0 {
                return 190
            }
            return 50
        }
        return 745
    }
}
