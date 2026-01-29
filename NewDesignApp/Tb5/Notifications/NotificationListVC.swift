//
//  AddressVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 31/08/24.
//

import UIKit
struct NotiFicationModel: Codable {
    let body: String
    let title: String
    let category: String
    let restid: String
}
class NotificationListVC: UIViewController {
    @IBOutlet weak var addressTbl: UITableView!
    var notificationList = [NotiFicationModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        addressTbl.backgroundColor = .clear
        notificationList = APPDELEGATE.getNotifications()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    func getRestDetailFromApi(restid: String, dbname: String) {
        /*
        Cart.shared.dbname = dbname
        let parameters = CommonAPIParams.base()
        
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromService(parameter: parameters, servicename: OldServiceType.restaurantDetail, forModelType: RestDetailResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            let story = UIStoryboard.init(name: "OrderFlow", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "RestDetailsVC") as! RestDetailsVC
            vc.restDetailsData = success.data.restaurant
            self.navigationController?.pushViewController(vc, animated: true)
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
            self.showAlert(title: "Error", msg: error)
        }
         */
    }
   

}
extension NotificationListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        let item = notificationList[indexPath.row]

        cell.configureUI(notification: item)
        if !item.restid.isEmpty {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = notificationList[indexPath.row]
        getRestDetailFromApi(restid: "\(item.restid)", dbname: "")
    }
    
}
