//
//  DineInVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 18/11/24.
//

import UIKit
import WebKit

class DineInVC: UIViewController {
    private var webView: WKWebView!
    var dineUrl: String = ""
    @IBOutlet weak var tbl: UITableView!

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var bookBtn: UIButton!
    
    @IBOutlet weak var noOfGuestview: UIView!
    @IBOutlet weak var noOfGuestCollection: UICollectionView!
    var selectedGuest = 1

    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateCollection: UICollectionView!
    var selectedDate = 0
    
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeCollection: UICollectionView!
    var selectedHour = -1
    
    @IBOutlet weak var specialRequestView: UIView!
    @IBOutlet weak var userDetailView: UIView!
    
    @IBOutlet weak var loginBtn: UIButton!








    var comeFromDashBoard = false
   // var isShowMinut = false
    var restaurantID = ""
   // var selectedMinut = ""
    var list = ["1 People", "2 Peoples", "3 Peoples", "4 Peoples", "5 Peoples", "6 Peoples", "7 Peoples", "8 Peoples", "8+ Peoples"]
  //  var minuts = ["05", "10", "15", "20", "25", "30", "35", "40", "45","50", "55","00"]

    let datesList = UtilsClass.getDates()
var timeSlots = [TimeSlots]()

//var numberOfPeople = 1
    override func viewDidLoad() {
        super.viewDidLoad()
       // dropDownView.isHidden = true
       // noOfPeopleLbl.text = "1 People"
        tbl.backgroundColor = .white
        self.view.backgroundColor = .white
        noOfGuestCollection.backgroundColor = .white
        dateCollection.backgroundColor = .white
        timeCollection.backgroundColor = .white
       // dineView.layer.cornerRadius = 20
        txtView.layer.cornerRadius = 10
        txtView.layer.borderWidth = 1
        txtView.layer.borderColor = UIColor.gGray100.cgColor
        txtView.text = ""
        bookBtn.setRounded(cornerRadius: 8)
        txtView.backgroundColor = .white
        txtView.textColor = .black

       
        
        noOfGuestview.layer.masksToBounds = true
        noOfGuestview.layer.cornerRadius = 10
        dateView.layer.masksToBounds = true
        dateView.layer.cornerRadius = 10
        timeView.layer.masksToBounds = true
        timeView.layer.cornerRadius = 10
        specialRequestView.layer.masksToBounds = true
        specialRequestView.layer.cornerRadius = 10
        userDetailView.layer.masksToBounds = true
        userDetailView.layer.cornerRadius = 10
        
        loginBtn.setRounded(cornerRadius: 8)
        loginBtn.setFontWithString(text: "Proceed with Email/Phone number", fontSize: 12)
        loginBtn.backgroundColor = themeBackgrounColor
        bookBtn.isEnabled = false
        refreshView()
        timeSlots = UtilsClass.getTimeSlotForDate(day: self.datesList[0].currectDateInFormate)
        tbl.isHidden = true
        setupWebView()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadURL()
    }
    private func setupWebView() {
            let config = WKWebViewConfiguration()
            //config.preferences.javaScriptEnabled = true

        webView = WKWebView(frame: .zero, configuration: config)
           webView.translatesAutoresizingMaskIntoConstraints = false
           webView.navigationDelegate = self

           view.addSubview(webView)

           NSLayoutConstraint.activate([
               webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
               webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
           ])

        }

        private func loadURL() {
            print("url: \(dineUrl)")
            guard let url = URL(string: dineUrl) else { return }
            let request = URLRequest(url: url)
            webView.load(request)
        }
    @IBAction func loginAction() {
        let vc = self.viewController(viewController: ProfileVC.self, storyName: StoryName.Profile.rawValue) as! ProfileVC
        vc.delegate = self
        vc.fromOtherPage = true
        self.present(vc, animated: true)
      //  print(Int(Cart.shared.getAllPriceDeatils().subTotal))
      //  print(Cart.shared.restuarant.mindelivery)
    }
    func refreshView() {
        if !APPDELEGATE.userLoggedIn() {
            loginBtn.isHidden = false
            bookBtn.isHidden = true
            userDetailView.isHidden = true
        } else {
            loginBtn.isHidden = true
            bookBtn.isHidden = false
            userDetailView.isHidden = false
        }
        nameLbl.attributedText = getAttributedString(fstring: "Name:  ", sstring: "\(APPDELEGATE.userResponse?.customer.fullName ?? "")")
        phoneLbl.attributedText = getAttributedString(fstring: "Phone:  ", sstring: "\(APPDELEGATE.userResponse?.customer.phone ?? "")")
    }

    func getAttributedString(fstring: String, sstring: String)-> NSMutableAttributedString {
        let fmyAttribute = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let font2 = UIFont.boldSystemFont(ofSize: 16)
        let attributes2: [NSAttributedString.Key: Any] = [
        .font: font2,
        .foregroundColor: UIColor.black,
        ]
        let myString = NSMutableAttributedString(string: fstring, attributes: fmyAttribute )
        let myString1 = NSMutableAttributedString(string: sstring, attributes: attributes2 )
        
        myString.append(myString1)

        return myString
    }
    @IBAction func cancelTap(_ sender: UIButton) {
        // handling code
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true) {
//        }
//       
    }

    @IBAction func bookTable(_ sender: UIButton) {
        // handling code
        self.view.endEditing(true)
        print("working fine")
        if comeFromDashBoard{
            bookDineFromApi(restaurantID: self.restaurantID)
        } else {
            bookDineFromApi(restaurantID: Cart.shared.tempRestDetails.rid)
        }

    }
    func bookDineFromApi(restaurantID: String) {
        
      //  let dateFormatter = DateFormatter()
      //  dateFormatter.dateFormat = "YYYY-MM-dd"
      //  dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        //let selectedDate = dateFormatter.string(from: datePickerView.date.addingTimeInterval(5.5 * 60 * 60))// "2015-11-10 09:44 PM"
        //let selectedDate = dateFormatter.string(from: datePickerView.date)// "2015-11-10 09:44 PM"
        //let convertedTime = UtilsClass.getStringDateHHMMSS(stringTime: "\(timeSlots[selectedHour].time)")
        var str = ""

        if selectedGuest == 0 {
            str = "\(selectedGuest + 1) People"
        }
        else if selectedGuest == 8 {
            str = "8+ Peoples"
        } else {
            str = "\(selectedGuest + 1) Peoples"
        }
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "restaurant_id": restaurantID,
            "bdate": "\(datesList[selectedDate].currectDateInFormate) \(timeSlots[selectedHour].time)",
            "phone" : "\(APPDELEGATE.userResponse?.customer.phone ?? "")",
            "email": "\(APPDELEGATE.userResponse?.customer.email ?? "")",
            "peoples" : "\(str)",
            "name" : "\(APPDELEGATE.userResponse?.customer.fullName ?? "")" as AnyObject,
            "details": "\(txtView.text!)"

        ]) { _, new in new }
        print(parameters.json)
        
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.bookdine, forModelType: DineBookedResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)

            if success.data.status == "success" {
//                let alertController = UIAlertController(title: "Booked", message: "\(success.data.result)", preferredStyle: .alert)
//                let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
//                    self.delegate?.backToDetailPage()
//                    self.navigationController?.popViewController(animated: true)
//                }
//                alertController.addAction(OKAction)
//                OperationQueue.main.addOperation {
//                    self.present(alertController, animated: true,
//                                 completion:nil)
//                }
                
                let story = UIStoryboard.init(name: "CartFlow", bundle: nil)
                let completeVC = story.instantiateViewController(withIdentifier: "DineInCompleteVC") as! DineInCompleteVC
                completeVC.orderNumber = "\(success.data.id)"
                completeVC.supportNumber = "\(success.data.support)"
                completeVC.msg = "\(success.data.result)"
                self.navigationController?.pushViewController(completeVC, animated: true)
                        
            } else {
                self.showAlert(title: "Error", msg: success.data.result)
            }
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
        
    }
    
    

}

extension DineInVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let size = (UIScreen.main.bounds.size.width-40)/2-5
        if collectionView == dateCollection
        {
            return CGSize(width: 60, height: 80)
        }
        else if collectionView == timeCollection {
            return CGSize(width: 100, height: 40)
        }
        else {
            return CGSize(width: 40, height: 40)
        }
    }
}
extension DineInVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dateCollection
        {
            return datesList.count
        }
        if collectionView == timeCollection
        {
            return timeSlots.count
        }
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberOfGroupCVCell", for: indexPath as IndexPath) as! NumberOfGroupCVCell
        cell.backgroundColor = .clear
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1.0
        if collectionView == dateCollection
        {
            cell.titlelbl.text = "\(datesList[indexPath.row].day)\n\(datesList[indexPath.row].date)"
            cell.titlelbl.textColor = selectedDate == indexPath.row ? .orange : .black
            cell.layer.borderColor = selectedDate == indexPath.row ? UIColor.orange.cgColor : UIColor.gGray100.cgColor
            cell.backgroundColor = selectedDate == indexPath.row ? UIColor.gOrange100 : UIColor.white


        }
        else if collectionView == timeCollection
        {
            cell.titlelbl.text = timeSlots[indexPath.row].time
            cell.titlelbl.textColor = selectedHour == indexPath.row ? .orange : .black
            cell.layer.borderColor = selectedHour == indexPath.row ? UIColor.orange.cgColor : UIColor.gGray100.cgColor
            cell.backgroundColor = selectedHour == indexPath.row ? UIColor.gOrange100 : UIColor.white

        }
        else {
            if indexPath.row == 8 {
                cell.titlelbl.text = "8+"
            } else {
                cell.titlelbl.text = "\(indexPath.row + 1)"
            }
            cell.layer.borderColor = selectedGuest == indexPath.row ? UIColor.orange.cgColor : UIColor.gGray100.cgColor

            cell.titlelbl.textColor = selectedGuest == indexPath.row ? .orange : .black
            cell.backgroundColor = selectedGuest == indexPath.row ? UIColor.gOrange100 : UIColor.white

        }
        return cell;

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dateCollection
        {
            selectedDate = indexPath.row
            timeSlots = UtilsClass.getTimeSlotForDate(day: self.datesList[indexPath.row].currectDateInFormate)
            selectedHour = -1
            dateCollection.reloadData()
            timeCollection.reloadData()
        }
        else if collectionView == timeCollection {
            selectedHour = indexPath.row
            timeCollection.reloadData()
        } else {
            selectedGuest = indexPath.row
            noOfGuestCollection.reloadData()

        }
        bookBtn.isEnabled = (selectedGuest >= 0 && selectedHour >= 0 && selectedDate >= 0)
       
    }
    
    
    
}
extension DineInVC: LoginSuccessDelegate {
    func signupAction() {
        let vc = self.viewController(viewController: SignupVC.self, storyName: StoryName.Profile.rawValue) as! SignupVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loginCompleted() {
        refreshView()
    }
}
extension DineInVC: SignupSuccessfullyDelegate {
    func signupCompleted() {
        self.refreshView()

    }
}
    
extension DineInVC: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started loading:", webView.url?.absoluteString ?? "")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading:", webView.url?.absoluteString ?? "")
    }

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if let url = navigationAction.request.url {
            print("Navigating to:", url.absoluteString)
        }

        decisionHandler(.allow)
    }
}
