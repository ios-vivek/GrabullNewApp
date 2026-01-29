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
   // @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var firstAddressLbl: UILabel!
    @IBOutlet weak var secondAddressLbl: UILabel!
   // @IBOutlet weak var animateImage: UIImageView!
    @IBOutlet weak var notEnabledLocationView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var locationView: LottieAnimationView!

    var locationAvailable = false
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(LocalizeDefaultLaunchLanguage, forKey: LocalizeUserDefaultKey)
        locationView.play()
        //locationView.loopMode = .loop
        titleLbl.text = "title5".translated()
        subTitleLbl.text = "title6".translated()
        LocationManagerClass.shared.getUserLocation()
        locationNotEnabledViewHidden(hidden: false)
        continueButton.backgroundColor = themeBackgrounColor
        continueButton.setRounded(cornerRadius: 10)
       // continueButton.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 8)
        
        continueButton.setFontWithString(text: "btnTitle1".translated(), fontSize: 16)
        // Do any additional setup after loading the view.
        firstAddressLbl.text = ""
        secondAddressLbl.text = ""
       // let location = CLLocation(latitude: 28.5847, longitude: 77.3159)
       // let region = MKCoordinateRegion( center: location.coordinate, latitudinalMeters: CLLocationDistance(exactly: 5000)!, longitudinalMeters: CLLocationDistance(exactly: 5000)!)
     //   mapView.setRegion(mapView.regionThatFits(region), animated: true)
        
//        UIView.animate(withDuration: 1, animations: {
//            self.animateImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//        }) { (finished) in
//            UIView.animate(withDuration: 1, delay: 0) {
//                
//            }
//            UIView.animate(withDuration: 1, animations: {
//                //self.animateImage.transform = CGAffineTransform.identity
//                self.animateImage.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
//                //self.animateImage.isHidden = true
//
//            })
//        }
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager().authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    self.locationAvailable = false
                    DispatchQueue.main.async {
                        self.locationNotEnabledViewHidden(hidden: false)
                    }
                case .authorizedAlways, .authorizedWhenInUse:
                    self.locationAvailable = true
                    DispatchQueue.main.async {
                        self.locationNotEnabledViewHidden(hidden: false)
                    }
                @unknown default:
                    break
                }
            } else {
                print("Location services are not enabled")
            }
        }
    }
    func locationNotEnabledViewHidden(hidden: Bool) {
        notEnabledLocationView.isHidden = false
        continueButton.isHidden = hidden
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
///        let nib = UINib(nibName: "TableHeaderFilterView", bundle: nil)
//        restaurantTable.register(nib, forHeaderFooterViewReuseIdentifier: "TableHeaderFilterView")
      
        LocationManagerClass.shared.completionAddress = {address in
            print("test address clouser is done\(address)")
            self.locationAvailable = true
            if address.count > 0{
                let breaksAdd = address.components(separatedBy:", *")
                self.firstAddressLbl.text = "\(breaksAdd[0].replacingOccurrences(of: ",", with: ""))"
                self.secondAddressLbl.text = "\(breaksAdd[1])"
                self.openTabbarPage()
            }
            
        }
        
             

    }
    func openTabbarPage() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.continueAction()
         }
    }
    @IBAction func continueAction() {
        if locationAvailable {
            let vc = self.viewController(viewController: TabBarVC.self, storyName: StoryName.Main.rawValue)
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        let alertController = UIAlertController(title: "Enable Location Services", message: "Please go to Setting and enable location services for the App.", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Setting", style: .default) { action in
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)

        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { alert in
            
        }
        alertController.addAction(OKAction)
        alertController.addAction(cancel)
        OperationQueue.main.addOperation {
            self.present(alertController, animated: true,
                         completion:nil)
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       // APPDELEGATE.tabbarWithAnimation()
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

