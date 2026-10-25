//
//  ForceUpdateVC.swift
//  Grabull
//
//  Created on 18/10/26.
//  Copyright © 2026 Omnie. All rights reserved.
//

import UIKit

class ForceUpdateVC: UIViewController {

    // MARK: - Properties
    var versionData: AppVersionData?
    var installedVersion: String = APPDELEGATE.getAppVersion()
    var appId: String = "1451513994"

    private var appStoreUrlString: String {
        if let customUrl = versionData?.appStoreUrl, !customUrl.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return customUrl
        }
        return "https://apps.apple.com/app/id\(appId)"
    }

    private var isForceUpdate: Bool {
        return versionData?.isForceUpdate ?? true
    }

    // MARK: - UI Elements
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceVertical = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let iconContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255/255.0, green: 101/255.0, blue: 1/255.0, alpha: 0.12)
        view.layer.cornerRadius = 45
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "arrow.triangle.2.circlepath")
        iv.tintColor = kOrangeColor
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let badgeContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255/255.0, green: 101/255.0, blue: 1/255.0, alpha: 0.14)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let badgeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "NEW UPDATE AVAILABLE"
        lbl.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        lbl.textColor = kOrangeColor
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Time to Update!"
        lbl.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let messageLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "A new version of Grabull is available with exciting features, improvements and bug fixes. Please update your app to continue."
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        lbl.textColor = UIColor.darkGray
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let versionCardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 247/255.0, green: 248/255.0, blue: 250/255.0, alpha: 1.0)
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 230/255.0, green: 233/255.0, blue: 238/255.0, alpha: 1.0).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let currentVersionTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "CURRENT"
        lbl.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        lbl.textColor = .systemGray
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let currentVersionValueLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        lbl.textColor = .darkGray
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "arrow.right")
        iv.tintColor = kOrangeColor
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let latestVersionTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "LATEST"
        lbl.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        lbl.textColor = kOrangeColor
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let latestVersionValueLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        lbl.textColor = kOrangeColor
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let featuresCardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 247/255.0, green: 248/255.0, blue: 250/255.0, alpha: 0.6)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let featuresStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let updateButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Update Now", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        btn.backgroundColor = kOrangeColor
        btn.layer.cornerRadius = 14
        btn.layer.shadowColor = kOrangeColor.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 4)
        btn.layer.shadowOpacity = 0.3
        btn.layer.shadowRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let laterButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Maybe Later", for: .normal)
        btn.setTitleColor(.gray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.isModalInPresentation = isForceUpdate

        setupUI()
        populateData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor)
        ])

        // Icon Container
        iconContainerView.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 44),
            iconImageView.heightAnchor.constraint(equalToConstant: 44)
        ])

        // Badge Container
        badgeContainerView.addSubview(badgeLabel)
        NSLayoutConstraint.activate([
            badgeLabel.topAnchor.constraint(equalTo: badgeContainerView.topAnchor, constant: 4),
            badgeLabel.bottomAnchor.constraint(equalTo: badgeContainerView.bottomAnchor, constant: -4),
            badgeLabel.leadingAnchor.constraint(equalTo: badgeContainerView.leadingAnchor, constant: 12),
            badgeLabel.trailingAnchor.constraint(equalTo: badgeContainerView.trailingAnchor, constant: -12)
        ])

        // Version Card
        let currentStack = UIStackView(arrangedSubviews: [currentVersionTitleLabel, currentVersionValueLabel])
        currentStack.axis = .vertical
        currentStack.spacing = 3
        currentStack.alignment = .center

        let latestStack = UIStackView(arrangedSubviews: [latestVersionTitleLabel, latestVersionValueLabel])
        latestStack.axis = .vertical
        latestStack.spacing = 3
        latestStack.alignment = .center

        let versionCardStack = UIStackView(arrangedSubviews: [currentStack, arrowImageView, latestStack])
        versionCardStack.axis = .horizontal
        versionCardStack.distribution = .equalCentering
        versionCardStack.alignment = .center
        versionCardStack.translatesAutoresizingMaskIntoConstraints = false

        versionCardView.addSubview(versionCardStack)
        NSLayoutConstraint.activate([
            arrowImageView.widthAnchor.constraint(equalToConstant: 18),
            arrowImageView.heightAnchor.constraint(equalToConstant: 18),

            versionCardStack.topAnchor.constraint(equalTo: versionCardView.topAnchor, constant: 12),
            versionCardStack.bottomAnchor.constraint(equalTo: versionCardView.bottomAnchor, constant: -12),
            versionCardStack.leadingAnchor.constraint(equalTo: versionCardView.leadingAnchor, constant: 28),
            versionCardStack.trailingAnchor.constraint(equalTo: versionCardView.trailingAnchor, constant: -28)
        ])

        // Features Card
        let feature1 = makeFeatureRow(icon: "bolt.fill", text: "Performance improvements & bug fixes")
        let feature2 = makeFeatureRow(icon: "sparkles", text: "New & enhanced food ordering experience")
        let feature3 = makeFeatureRow(icon: "shield.checkmark.fill", text: "Latest security updates & stability")
        featuresStackView.addArrangedSubview(feature1)
        featuresStackView.addArrangedSubview(feature2)
        featuresStackView.addArrangedSubview(feature3)

        featuresCardView.addSubview(featuresStackView)
        NSLayoutConstraint.activate([
            featuresStackView.topAnchor.constraint(equalTo: featuresCardView.topAnchor, constant: 14),
            featuresStackView.bottomAnchor.constraint(equalTo: featuresCardView.bottomAnchor, constant: -14),
            featuresStackView.leadingAnchor.constraint(equalTo: featuresCardView.leadingAnchor, constant: 14),
            featuresStackView.trailingAnchor.constraint(equalTo: featuresCardView.trailingAnchor, constant: -14)
        ])

        // Actions
        updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        laterButton.addTarget(self, action: #selector(laterButtonTapped), for: .touchUpInside)

        // Add subviews to contentView
        contentView.addSubview(iconContainerView)
        contentView.addSubview(badgeContainerView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(versionCardView)
        contentView.addSubview(featuresCardView)
        contentView.addSubview(updateButton)
        contentView.addSubview(laterButton)

        NSLayoutConstraint.activate([
            iconContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 36),
            iconContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: 90),
            iconContainerView.heightAnchor.constraint(equalToConstant: 90),

            badgeContainerView.topAnchor.constraint(equalTo: iconContainerView.bottomAnchor, constant: 20),
            badgeContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            badgeContainerView.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.topAnchor.constraint(equalTo: badgeContainerView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),

            versionCardView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
            versionCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            versionCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            featuresCardView.topAnchor.constraint(equalTo: versionCardView.bottomAnchor, constant: 16),
            featuresCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            featuresCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            updateButton.topAnchor.constraint(greaterThanOrEqualTo: featuresCardView.bottomAnchor, constant: 24),
            updateButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            updateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            updateButton.heightAnchor.constraint(equalToConstant: 52),

            laterButton.topAnchor.constraint(equalTo: updateButton.bottomAnchor, constant: 8),
            laterButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            laterButton.heightAnchor.constraint(equalToConstant: 40),
            laterButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    private func makeFeatureRow(icon: String, text: String) -> UIView {
        let rowView = UIView()

        let iv = UIImageView()
        iv.image = UIImage(systemName: icon)
        iv.tintColor = kOrangeColor
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false

        let lbl = UILabel()
        lbl.text = text
        lbl.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        lbl.textColor = UIColor.darkGray
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false

        rowView.addSubview(iv)
        rowView.addSubview(lbl)

        NSLayoutConstraint.activate([
            iv.leadingAnchor.constraint(equalTo: rowView.leadingAnchor),
            iv.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            iv.widthAnchor.constraint(equalToConstant: 18),
            iv.heightAnchor.constraint(equalToConstant: 18),

            lbl.leadingAnchor.constraint(equalTo: iv.trailingAnchor, constant: 10),
            lbl.trailingAnchor.constraint(equalTo: rowView.trailingAnchor),
            lbl.topAnchor.constraint(equalTo: rowView.topAnchor, constant: 2),
            lbl.bottomAnchor.constraint(equalTo: rowView.bottomAnchor, constant: -2)
        ])

        return rowView
    }

    // MARK: - Populate Data
    private func populateData() {
        if let customTitle = versionData?.title, !customTitle.isEmpty {
            titleLabel.text = customTitle
        } else {
            titleLabel.text = isForceUpdate ? "Update Required" : "Time to Update!"
        }

        if let customMessage = versionData?.message, !customMessage.isEmpty {
            messageLabel.text = customMessage
        }

        let curVersion = installedVersion.isEmpty ? "1.0.0" : installedVersion
        currentVersionValueLabel.text = "v\(curVersion)"

        let latest = versionData?.latestVersion ?? versionData?.minimumVersion ?? curVersion
        latestVersionValueLabel.text = "v\(latest)"

        // If force update is required, hide the later/cancel button so user cannot dismiss
        laterButton.isHidden = isForceUpdate
    }

    // MARK: - Actions
    @objc private func updateButtonTapped() {
        openAppStore()
    }

    @objc private func laterButtonTapped() {
        guard !isForceUpdate else { return }
        self.dismiss(animated: true, completion: nil)
    }

    private func openAppStore() {
        let itmsUrlString = "itms-apps://itunes.apple.com/app/id\(appId)"
        let webUrlString = appStoreUrlString

        if let itmsUrl = URL(string: itmsUrlString), UIApplication.shared.canOpenURL(itmsUrl) {
            UIApplication.shared.open(itmsUrl, options: [:], completionHandler: nil)
        } else if let webUrl = URL(string: webUrlString) {
            UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - Bundle Version Extensions
extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

// MARK: - AppVersionManager
class AppVersionManager {
    static let shared = AppVersionManager()

    private(set) var hasCheckedVersion: Bool = false
    private(set) var isUpdateRequired: Bool = false
    private(set) var activeVersionData: AppVersionData?

    private var inFlightCompletions: [(_ needsUpdate: Bool, _ data: AppVersionData?) -> Void] = []
    private var isChecking: Bool = false

    func checkVersion(completion: @escaping (_ needsUpdate: Bool, _ data: AppVersionData?) -> Void) {
        if hasCheckedVersion {
            completion(isUpdateRequired, activeVersionData)
            return
        }

        inFlightCompletions.append(completion)
        guard !isChecking else { return }
        isChecking = true

        let currentVersion = Bundle.main.releaseVersionNumber ?? APPDELEGATE.getAppVersion()
        print("AppVersionManager: Checking app version. Installed version: \(currentVersion)")

        // 1. Check from Backend API ("app-version/")
        checkBackendAppVersion(currentVersion: currentVersion) { [weak self] needsUpdate, apiData in
            guard let self = self else { return }

            if needsUpdate, let data = apiData {
                self.notifyAll(needsUpdate: true, data: data)
                return
            }

            // 2. Check from App Store Lookup URL
            self.checkAppStoreVersion(currentVersion: currentVersion) { appStoreNeedsUpdate, storeData in
                self.notifyAll(needsUpdate: appStoreNeedsUpdate, data: storeData)
            }
        }
    }

    private func notifyAll(needsUpdate: Bool, data: AppVersionData?) {
        self.isChecking = false
        self.hasCheckedVersion = true
        self.isUpdateRequired = needsUpdate
        self.activeVersionData = data

        let callbacks = self.inFlightCompletions
        self.inFlightCompletions.removeAll()

        DispatchQueue.main.async {
            callbacks.forEach { $0(needsUpdate, data) }
        }
    }

    private func checkBackendAppVersion(currentVersion: String, completion: @escaping (_ needsUpdate: Bool, _ data: AppVersionData?) -> Void) {
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "app_version": currentVersion,
            "appversion": currentVersion,
            "platform": "ios",
            "app_id": "1451513994"
        ]) { _, new in new }

        WebServices.loadDataFromServiceWithBaseResponse(
            parameter: parameters,
            servicename: OldServiceType.checkAppVersion,
            forModelType: AppVersionResponse.self
        ) { [weak self] success in
            guard let self = self else {
                completion(false, nil)
                return
            }
            guard let versionData = success.data.data else {
                completion(false, nil)
                return
            }

            let latestVersion = versionData.latestVersion ?? ""
            let minVersion = versionData.minimumVersion ?? ""
            let isForce = versionData.isForceUpdate ?? false

            let isOlderThanMin = !minVersion.isEmpty && self.isVersion(currentVersion, olderThan: minVersion)
            let isOlderThanLatest = !latestVersion.isEmpty && self.isVersion(currentVersion, olderThan: latestVersion)

            if isForce || isOlderThanMin || (isOlderThanLatest && (versionData.isForceUpdate ?? true)) {
                completion(true, versionData)
            } else {
                completion(false, nil)
            }
        } ErrorHandler: { error in
            print("AppVersionManager backend error: \(error)")
            completion(false, nil)
        }
    }

    private func checkAppStoreVersion(currentVersion: String, completion: @escaping (_ needsUpdate: Bool, _ data: AppVersionData?) -> Void) {
        let bundleID = Bundle.main.bundleIdentifier ?? "com.grabull"
        let timestamp = Int(Date().timeIntervalSince1970)
        let urlString = "https://itunes.apple.com/lookup?bundleId=\(bundleID)&timestamp=\(timestamp)"

        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            guard let data = data, error == nil else {
                print("AppVersionManager App Store fetch error:", error?.localizedDescription ?? "Unknown error")
                completion(false, nil)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let firstResult = results.first,
                   let appStoreVersion = firstResult["version"] as? String {
                    let trackViewUrl = firstResult["trackViewUrl"] as? String
                    let releaseNotes = firstResult["releaseNotes"] as? String
                    print("App Store Version: \(appStoreVersion), Current: \(currentVersion)")

                    if self.isVersion(currentVersion, olderThan: appStoreVersion) {
                        let versionData = AppVersionData(
                            latestVersion: appStoreVersion,
                            minimumVersion: appStoreVersion,
                            isForceUpdate: true,
                            title: "Time to Update!",
                            message: (releaseNotes?.isEmpty == false) ? releaseNotes : "A new version of Grabull is available on the App Store. Please update your app to continue enjoying the best experience.",
                            appStoreUrl: trackViewUrl ?? "https://apps.apple.com/app/id1451513994"
                        )
                        completion(true, versionData)
                    } else {
                        completion(false, nil)
                    }
                } else {
                    completion(false, nil)
                }
            } catch {
                print("AppVersionManager json parse error:", error)
                completion(false, nil)
            }
        }.resume()
    }

    func isVersion(_ current: String, olderThan target: String) -> Bool {
        let cleanCurrent = current.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanTarget = target.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanTarget.isEmpty && !cleanCurrent.isEmpty else { return false }

        let currentComponents = cleanCurrent.split(separator: ".").compactMap { Int($0) }
        let targetComponents = cleanTarget.split(separator: ".").compactMap { Int($0) }

        let maxCount = max(currentComponents.count, targetComponents.count)
        for i in 0..<maxCount {
            let cur = i < currentComponents.count ? currentComponents[i] : 0
            let tgt = i < targetComponents.count ? targetComponents[i] : 0
            if cur < tgt {
                return true
            } else if cur > tgt {
                return false
            }
        }
        return false
    }

    func presentForceUpdateIfNeeded(on viewController: UIViewController) {
        guard isUpdateRequired, let data = activeVersionData else { return }
        if viewController.presentedViewController is ForceUpdateVC { return }

        let updateVC = ForceUpdateVC()
        updateVC.versionData = data
        updateVC.installedVersion = Bundle.main.releaseVersionNumber ?? APPDELEGATE.getAppVersion()
        updateVC.appId = "1451513994"
        updateVC.modalPresentationStyle = .overFullScreen
        updateVC.modalTransitionStyle = .crossDissolve
        viewController.present(updateVC, animated: true, completion: nil)
    }
}
