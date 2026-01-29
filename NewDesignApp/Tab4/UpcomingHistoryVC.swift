//
//  HistoryVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 09/08/24.
//

import UIKit
import Lottie
class UpcomingHistoryVC: UIViewController {
    
    @IBOutlet weak var emptyImageView: LottieAnimationView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var historyTblView: UITableView!
    @IBOutlet weak var noDataFoundLbl: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginView: UIView!

    var historyList = [OrderHistory]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyView.isHidden = true
        noDataFoundLbl.textColor = .lightGray
        emptyImageView.play()
        emptyImageView.loopMode = .loop
        // Do any additional setup after loading the view.
       // self.view.backgroundColor = .red
        loginBtn.setRounded(cornerRadius: 8)
        loginBtn.setFontWithString(text: "Proceed with Email/Phone number", fontSize: 12)
        loginBtn.backgroundColor = themeBackgrounColor
        self.view.backgroundColor = pageBackgroundColor
        historyTblView.backgroundColor = .clear
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if APPDELEGATE.userLoggedIn() {
            self.callService()
        } else {
            historyList = [OrderHistory]()
            historyTblView.reloadData()
        }
    }
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if APPDELEGATE.userLoggedIn() {
            self.callService()
        } else {
            historyList = [OrderHistory]()
            noDataFoundRefersh()
        }
    }
    func noDataFoundRefersh(){
        noDataFoundLbl.isHidden = !APPDELEGATE.userLoggedIn()
        loginView.isHidden = APPDELEGATE.userLoggedIn()
    }
    
    @IBAction func loginAction() {
        let vc = self.viewController(viewController: ProfileVC.self, storyName: StoryName.Profile.rawValue) as! ProfileVC
        vc.delegate = self
        vc.fromOtherPage = true
        self.present(vc, animated: true)
    }
    func getOrderHistoryDataFromApi() {
        self.emptyView.isHidden = true
        let parameters = CommonAPIParams.base()
        
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.ongoingOrder, forModelType: HisoryResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            self.historyList = success.data.data
            self.historyTblView.reloadData()
            self.noDataFoundRefersh()
            if self.historyList.count == 0 {
                self.emptyView.isHidden = false
                self.noDataFoundLbl.text = "You don't have any upcoming orders."
            }
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
            self.noDataFoundRefersh()
            self.historyTblView.reloadData()
            self.emptyView.isHidden = false
            self.noDataFoundLbl.text = "You don't have any upcoming orders."
        }
    }
    
    @objc func ratingAction(sender: UIButton) {
        let rest = historyList[sender.tag]
       // getRestDetailFromApi(restid: "\(rest.resturantID)", dbname: "\(rest.dbname)")
        }
        
    func getRestDetailFromApi(restid: String, dbname: String) {
        Cart.shared.dbname = dbname
           
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "rest_id" : restid
        ]) { _, new in new }
        
            UtilsClass.showProgressHud(view: self.view)
            WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.restaurantDetail, forModelType: RestDetailsApiResponse.self) { success in
                UtilsClass.hideProgressHud(view: self.view)
                let story = UIStoryboard.init(name: "OrderFlow", bundle: nil)
                let vc = story.instantiateViewController(withIdentifier: "RestDetailsVC") as! RestDetailsVC
              //  vc.restDetailsData = success.data.restaurant
                self.navigationController?.pushViewController(vc, animated: true)
                
            } ErrorHandler: { error in
                UtilsClass.hideProgressHud(view: self.view)
            }
        }
    
    @objc func trackOrderAction(sender: UIButton) {
        let getTag = sender.tag
        let story = UIStoryboard.init(name: "History", bundle: nil)
        let trackVC = story.instantiateViewController(withIdentifier: "TrackOrderVC") as! TrackOrderVC
        trackVC.trackURL = historyList[getTag].trackorder
        self.navigationController?.pushViewController(trackVC, animated: true)
    }
    
    func callService() {
            self.getOrderHistoryDataFromApi()
    }
    
}
extension UpcomingHistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noDataFoundRefersh()
            return historyList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTVCell", for: indexPath) as! HistoryTVCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.updateUI(order: historyList[indexPath.row])
            cell.rateBtn.tag = indexPath.row
            cell.rateBtn.addTarget(self, action: #selector(ratingAction), for: .touchUpInside)
            cell.reOrderBtn.tag = indexPath.row
            cell.reOrderBtn.addTarget(self, action: #selector(trackOrderAction), for: .touchUpInside)
            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = self.viewController(viewController: OrderDetailVC.self, storyName: StoryName.History.rawValue) as! OrderDetailVC
            vc.hOrder = historyList[indexPath.section]
            self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension UpcomingHistoryVC: LoginSuccessDelegate {
    func signupAction() {
        let vc = self.viewController(viewController: SignupVC.self, storyName: StoryName.Profile.rawValue) as! SignupVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loginCompleted() {
        self.noDataFoundRefersh()
        callService()
    }
}
extension UpcomingHistoryVC: SignupSuccessfullyDelegate {
    func signupCompleted() {
        self.noDataFoundRefersh()
        callService()

    }
}
