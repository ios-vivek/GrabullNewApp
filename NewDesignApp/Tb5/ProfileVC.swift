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
   // case payments = "Payments"
    case orders = "Order History"
    case changePassword = "Change Password"
    case notifications = "Notifications"
    case myRewards = "My Rewards"
    case referAFriend = "Refer a Friend"
    case referARestaurant = "Refer a Restaurant"
   // case workWithUs = "Work With Us"
    case support = "Help"
    case logout = "Logout"
    case deleteAccount = "Delete Account"
    
    /// Display text (if you don’t want to rely on rawValue everywhere)
    var title: String {
        return self.rawValue
    }
    
    var icon: UIImage? {
        switch self {
        case .profileDetails:
            return nil
        case .myaddress:
            return UIImage(named: "icon_address")
        case .orders:
            return UIImage(named: "icon_orders")
        case .changePassword:
            return UIImage(named: "icon_passwordchange")
        case .notifications:
            return UIImage(named: "icon_notifications")
        case .myRewards:
            return UIImage(named: "icon_rewards")
        case .referAFriend, .referARestaurant:
            return UIImage(named: "icon_refere")
        case .support:
            return UIImage(named: "icon_support")
        case .logout:
            return UIImage(named: "icon_logout")
        case .deleteAccount:
            return UIImage(systemName: "trash")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal) ?? UIImage(systemName: "trash")
        }
    }
}
class ProfileVC: UIViewController {
    let items = ProfileItem.allCases

    @IBOutlet weak var tbl: UITableView!
    weak var delegate: LoginSuccessDelegate?
    let itemsicon = ["","icon_address","icon_orders","icon_passwordchange","icon_notifications","icon_rewards","icon_refere","icon_refere","icon_support","icon_logout","trash"]
    var loggedIn = false
    var fromOtherPage = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        tbl.backgroundColor  = .white
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

    func deleteAccountService(reason: String) {
        guard let customerId = APPDELEGATE.userResponse?.customer.customerId, !customerId.isEmpty else {
            self.showAlert(title: "Error", msg: "Please login to delete your account.")
            return
        }

        var parameters = CommonAPIParams.base()
        parameters.merge([
            "customer_id": customerId,
            "reason": reason,
            "reasonType": reason,
            "deletion_reason": reason,
            "delete_reason": reason
        ]) { _, new in new }

        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(
            parameter: parameters,
            servicename: OldServiceType.deleteAccount,
            forModelType: DeleteAccountResponse.self
        ) { [weak self] success in
            guard let self = self else { return }
            UtilsClass.hideProgressHud(view: self.view)
            let message = success.data.message ?? success.data.result ?? success.data.data?.result ?? success.data.data?.message ?? "Your account has been deleted successfully."
            let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                self.logoutPage()
            }
            alertController.addAction(okAction)
            OperationQueue.main.addOperation {
                self.present(alertController, animated: true, completion: nil)
            }
        } ErrorHandler: { [weak self] error in
            guard let self = self else { return }
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
            switch sectionItem {
            case .profileDetails:
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailsTVCell", for: indexPath) as! UserDetailsTVCell
                cell.selectionStyle = .none
                cell.delegate = self
                cell.backgroundColor = .clear
                cell.updateUI()
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileItemTVCell", for: indexPath) as! ProfileItemTVCell
                cell.itemName.text = sectionItem.title
                cell.imageIcon.image = sectionItem.icon ?? (indexPath.row < itemsicon.count ? UIImage(named: itemsicon[indexPath.row]) : nil)
                if sectionItem == .deleteAccount {
                    cell.itemName.textColor = .systemRed
                    cell.accessoryType = .none
                } else if sectionItem == .logout {
                   // cell.itemName.textColor = .systemRed
                    cell.accessoryType = .none
                } else {
                    cell.itemName.textColor = .black
                    cell.accessoryType = .disclosureIndicator
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
            switch sectionItem {
            case .myaddress:
                let vc = self.viewController(viewController: LocationVC.self, storyName: StoryName.Location.rawValue) as! LocationVC
                vc.fromProfile = true
               // let vc = self.viewController(viewController: AddressVC.self, storyName: StoryName.Profile.rawValue) as! AddressVC
                self.navigationController?.pushViewController(vc, animated: true)
//            case .payments:
//                let vc = self.viewController(viewController: PaymentVC.self, storyName: StoryName.Profile.rawValue) as! PaymentVC
//                self.navigationController?.pushViewController(vc, animated: true)
            case .orders:
                let history = UIStoryboard(name: "History", bundle: nil)
                let historyVC = history.instantiateViewController(withIdentifier: "HistoryTypeVC") as! HistoryTypeVC
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
//            case .workWithUs:
//                let vc = self.viewController(viewController: WorkWithUsVC.self, storyName: StoryName.Profile.rawValue) as! WorkWithUsVC
//                self.navigationController?.pushViewController(vc, animated: true)
            case .support:
                let vc = self.viewController(viewController: SupportVC.self, storyName: StoryName.Profile.rawValue) as! SupportVC
                self.navigationController?.pushViewController(vc, animated: true)
            case .changePassword:
                let vc = self.viewController(viewController: ChangePasswordVC.self, storyName: StoryName.Profile.rawValue) as! ChangePasswordVC
                self.navigationController?.pushViewController(vc, animated: true)
            case .notifications:
                navigateToNotification()
            case .logout:
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
            case .deleteAccount:
                let popupVC = DeleteAccountReasonPopupVC()
                popupVC.onConfirmDelete = { [weak self] selectedReason in
                    self?.deleteAccountService(reason: selectedReason)
                }
                popupVC.modalPresentationStyle = .overCurrentContext
                popupVC.modalTransitionStyle = .crossDissolve
                self.present(popupVC, animated: true)
            default:
                break
            }
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

// MARK: - Delete Account Reason Popup

protocol DeleteAccountReasonDelegate: AnyObject {
    func didConfirmDeleteAccount(reason: String)
}

class DeleteAccountReasonPopupVC: UIViewController {

    weak var delegate: DeleteAccountReasonDelegate?
    var onConfirmDelete: ((String) -> Void)?

    let deletionReasons: [String] = [
        "No Longer Needed",
        "Privacy Concerns",
        "Security Concerns",
        "Duplicate Account",
        "Poor Service Experience",
        "App or Website Issues",
        "Too Many Notifications",
        "Created by Mistake",
        "Other"
    ]

    private var selectedIndex: Int? = nil

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Delete Account"
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.textColor = .systemRed
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let closeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("✕", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        btn.setTitleColor(.darkGray, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Please select a reason for deleting your account:"
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textColor = .secondaryLabel
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let dropdownContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 242/255.0, green: 243/255.0, blue: 247/255.0, alpha: 1.0)
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 209/255.0, green: 213/255.0, blue: 219/255.0, alpha: 1.0).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let dropdownTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Select Deletion Reason"
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        lbl.textColor = .darkGray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private let otherTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Please specify (optional)"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.isHidden = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let cancelButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Cancel", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        btn.setTitleColor(.darkGray, for: .normal)
        btn.backgroundColor = UIColor(red: 242/255.0, green: 243/255.0, blue: 247/255.0, alpha: 1.0)
        btn.layer.cornerRadius = 8
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(red: 209/255.0, green: 213/255.0, blue: 219/255.0, alpha: 1.0).cgColor
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let deleteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Delete Account", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemRed
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        setupViews()
    }

    private func setupViews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(backdropTapped(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)

        self.view.addSubview(containerView)

        let headerStack = UIStackView(arrangedSubviews: [titleLabel, closeButton])
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.distribution = .equalSpacing
        headerStack.translatesAutoresizingMaskIntoConstraints = false

        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)

        dropdownContainerView.addSubview(dropdownTitleLabel)

        NSLayoutConstraint.activate([
            dropdownTitleLabel.leadingAnchor.constraint(equalTo: dropdownContainerView.leadingAnchor, constant: 12),
            dropdownTitleLabel.trailingAnchor.constraint(equalTo: dropdownContainerView.trailingAnchor, constant: -12),
            dropdownTitleLabel.centerYAnchor.constraint(equalTo: dropdownContainerView.centerYAnchor),
            dropdownContainerView.heightAnchor.constraint(equalToConstant: 40)
        ])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DeleteReasonTVCell.self, forCellReuseIdentifier: DeleteReasonTVCell.identifier)

        otherTextField.delegate = self

        let buttonsStack = UIStackView(arrangedSubviews: [cancelButton, deleteButton])
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 12
        buttonsStack.distribution = .fillEqually
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.heightAnchor.constraint(equalToConstant: 44).isActive = true

        let mainStack = UIStackView(arrangedSubviews: [
            headerStack,
            subtitleLabel,
            dropdownContainerView,
            tableView,
            otherTextField,
            buttonsStack
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 10
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            containerView.topAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.bottomAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            mainStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),

            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32),

            tableView.heightAnchor.constraint(equalToConstant: 240),
            otherTextField.heightAnchor.constraint(equalToConstant: 38)
        ])
    }

    @objc private func backdropTapped(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: self.view)
        if !containerView.frame.contains(point) {
            self.dismiss(animated: true)
        }
    }

    @objc private func closeAction() {
        self.dismiss(animated: true)
    }

    @objc private func deleteButtonTapped() {
        guard let index = selectedIndex else {
            let alert = UIAlertController(title: "Reason Required", message: "Please select a deletion reason.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
            return
        }

        var finalReason = deletionReasons[index]
        if finalReason == "Other" {
            let text = (otherTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            if !text.isEmpty {
                finalReason = "Other: \(text)"
            }
        }

        let alertController = UIAlertController(
            title: "Delete Account",
            message: "Are you sure you want to delete your account? This action cannot be undone.",
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let okAction = UIAlertAction(title: "Ok", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                self.delegate?.didConfirmDeleteAccount(reason: finalReason)
                self.onConfirmDelete?(finalReason)
            }
        }
        alertController.addAction(cancel)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
}

extension DeleteAccountReasonPopupVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deletionReasons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DeleteReasonTVCell.identifier, for: indexPath) as! DeleteReasonTVCell
        let title = deletionReasons[indexPath.row]
        let isSelected = (indexPath.row == selectedIndex)
        cell.configure(title: title, isSelectedReason: isSelected)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        selectedIndex = indexPath.row
        let reason = deletionReasons[indexPath.row]
        dropdownTitleLabel.text = reason
        dropdownTitleLabel.textColor = .darkText

        let isOther = (reason == "Other")
        otherTextField.isHidden = !isOther
        if isOther {
            otherTextField.becomeFirstResponder()
        }

        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
}

extension DeleteAccountReasonPopupVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

class DeleteReasonTVCell: UITableViewCell {
    static let identifier = "DeleteReasonTVCell"

    private let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = .darkText
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let radioImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(titleLbl)
        contentView.addSubview(radioImageView)

        NSLayoutConstraint.activate([
            radioImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            radioImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            radioImageView.widthAnchor.constraint(equalToConstant: 20),
            radioImageView.heightAnchor.constraint(equalToConstant: 20),

            titleLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLbl.trailingAnchor.constraint(equalTo: radioImageView.leadingAnchor, constant: -8),
            titleLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, isSelectedReason: Bool) {
        titleLbl.text = title
        if isSelectedReason {
            radioImageView.image = UIImage(systemName: "checkmark.circle.fill")
            radioImageView.tintColor = .systemRed
            contentView.backgroundColor = UIColor.systemRed.withAlphaComponent(0.08)
            contentView.layer.cornerRadius = 6
        } else {
            radioImageView.image = UIImage(systemName: "circle")
            radioImageView.tintColor = .systemGray3
            contentView.backgroundColor = .clear
        }
    }
}
