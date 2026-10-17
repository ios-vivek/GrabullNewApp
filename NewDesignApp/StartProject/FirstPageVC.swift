//
//  FirstPageVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 09/08/24.
//

import UIKit
import MapKit
import Lottie

let LocalizeUserDefaultKey = "LocalizeUserDefaultKey"
var LocalizeDefaultLaunchLanguage = "en"

class FirstPageVC: UIViewController {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var firstAddressLbl: UILabel!
    @IBOutlet weak var secondAddressLbl: UILabel!
    @IBOutlet weak var notEnabledLocationView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var locationView: LottieAnimationView!

    private let manualLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Enter Location Manually", for: .normal)
        button.setTitleColor(themeBackgrounColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .white
        button.layer.borderColor = themeBackgrounColor.cgColor
        button.layer.borderWidth = 1.5
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()

    var locationAvailable = false

    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(LocalizeDefaultLaunchLanguage, forKey: LocalizeUserDefaultKey)
        locationView.play()
        titleLbl.text = "title5".translated()
        subTitleLbl.text = "title6".translated()

        LocationManagerClass.shared.getUserLocation()
        locationNotEnabledViewHidden(hidden: false)

        continueButton.backgroundColor = themeBackgrounColor
        continueButton.setRounded(cornerRadius: 10)
        continueButton.setFontWithString(text: "btnTitle1".translated(), fontSize: 16)

        setupManualLocationButton()

        firstAddressLbl.text = ""
        secondAddressLbl.text = ""

        checkLocationStatus()
    }

    private func setupManualLocationButton() {
        guard let container = continueButton.superview else { return }
        container.addSubview(manualLocationButton)
        NSLayoutConstraint.activate([
            manualLocationButton.leadingAnchor.constraint(equalTo: continueButton.leadingAnchor),
            manualLocationButton.trailingAnchor.constraint(equalTo: continueButton.trailingAnchor),
            manualLocationButton.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -12),
            manualLocationButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        manualLocationButton.addTarget(self, action: #selector(manualLocationAction), for: .touchUpInside)
    }

    private func checkLocationStatus() {
        if !CLLocationManager.locationServicesEnabled() {
            self.firstAddressLbl.text = "Location Services are disabled"
            self.secondAddressLbl.text = "Enter your address manually or continue"
            return
        }

        switch CLLocationManager().authorizationStatus {
        case .denied, .restricted:
            self.firstAddressLbl.text = "Location permission not enabled"
            self.secondAddressLbl.text = "Enter your address manually or continue"
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationAvailable = true
        default:
            break
        }
    }

    func locationNotEnabledViewHidden(hidden: Bool) {
        notEnabledLocationView.isHidden = false
        continueButton.isHidden = hidden
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateAddressDisplay()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        LocationManagerClass.shared.completionAddress = { [weak self] address in
            guard let self = self else { return }
            print("test address clouser is done: \(address)")
            self.locationAvailable = true
            if !address.isEmpty {
                let breaksAdd = address.components(separatedBy: ", *")
                if let first = breaksAdd.first {
                    self.firstAddressLbl.text = first.replacingOccurrences(of: ",", with: "")
                }
                if breaksAdd.count > 1 {
                    self.secondAddressLbl.text = breaksAdd[1]
                }
                self.openTabbarPage()
            }
        }
    }

    private func updateAddressDisplay() {
        let address = APPDELEGATE.selectedLocationAddress
        if let subLocality = address.subLocality, !subLocality.isEmpty {
            self.firstAddressLbl.text = subLocality
            self.secondAddressLbl.text = "\(address.city ?? ""), \(address.state ?? "") \(address.zipcode ?? "")"
            self.locationAvailable = true
        } else if let city = address.city, !city.isEmpty {
            self.firstAddressLbl.text = city
            self.secondAddressLbl.text = "\(address.state ?? "") \(address.zipcode ?? "")"
            self.locationAvailable = true
        }
    }

    func openTabbarPage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.continueAction()
        }
    }

    @IBAction func continueAction() {
        let vc = self.viewController(viewController: TabBarVC.self, storyName: StoryName.Main.rawValue)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func manualLocationAction() {
        let vc = self.viewController(viewController: LocationVC.self, storyName: StoryName.Location.rawValue) as! LocationVC
        vc.fromFirstPage = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
