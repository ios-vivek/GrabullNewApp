//
//  SupportVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 20/08/25.
//

    import UIKit
class ComplaintDetailsVC: UIViewController {
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var replyBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!


    var supportID = ""
    var chatDataList: [ChatData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = pageBackgroundColor
        tbl.backgroundColor = .clear
        
        replyBtn.setRounded(cornerRadius: 4)
        replyBtn.setFontWithString(text: "Reply", fontSize: 16)
        replyBtn.backgroundColor = kBlueColor
        
        cancelBtn.setRounded(cornerRadius: 4)
        cancelBtn.setFontWithString(text: "Close", fontSize: 16)
        cancelBtn.backgroundColor = kBlueColor
       
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        getSupportDetail(supportid: supportID)
    }
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func replyAction() {
        let vc = self.viewController(viewController: ChatReplyVC.self, storyName: StoryName.Profile.rawValue) as! ChatReplyVC
      //  print("\(chatDataList[0].subject)")
        vc.subject = chatDataList[0].subject ?? ""
        vc.complainID = chatDataList[0].id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func cancelAction() {
        let alertController = UIAlertController(title: "Close", message: "Are you sure want to close?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Cancel", style: .default) { action in
            
        }
        let cancel = UIAlertAction(title: "Ok", style: .cancel) { alert in
            self.closeQuery(supportid: "")
        }
        alertController.addAction(OKAction)
        alertController.addAction(cancel)
        OperationQueue.main.addOperation {
            self.present(alertController, animated: true,
                         completion:nil)
        }
    }
    func closeQuery(supportid: String) {
        /*
        let parameters: [String: AnyObject] = [
            "api_id": AppConfig.API_ID as AnyObject,
            "api_key": AppConfig.OldAPI_KEY as AnyObject,
            "customer_id": APPDELEGATE.userResponse?.customer.customer_id as AnyObject,
            "support_id": supportid as AnyObject
        ]
        
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromService(parameter: parameters, servicename: OldServiceType.getSupportDetail, forModelType: SupportDetailResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            self.navigationController?.popViewController(animated: true)
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
            self.showAlert(title: "Error", msg: "Something went wrong.")
        }
        */

    }
    private func getSupportDetail(supportid: String) {
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "support_id": supportid,
        ]) { _, new in new }
        
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.getSupportDetail, forModelType: SupportDetailResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            self.chatDataList = success.data.data ?? [ChatData]()
            self.tbl.reloadData()
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
            self.showAlert(title: "Error", msg: "Failed to load support list.")
        }
    }

}

extension ComplaintDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.chatDataList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatDataList[section].chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let item = self.chatDataList[indexPath.section].chatList[indexPath.row]
        if item.type == "Customer" {
            //red
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerChatCell", for: indexPath) as! CustomerChatCell

            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.updateUI(item: self.chatDataList[indexPath.section].chatList[indexPath.row], id: supportID)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GrubullChatCell", for: indexPath) as! GrubullChatCell

            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.updateUI(item: self.chatDataList[indexPath.section].chatList[indexPath.row], id: supportID)
            
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  let restaurant = restaurantList[indexPath.row]
        // Handle restaurant selection if needed
    }
    
//        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            return 80 // Adjust height as needed
//        }
}

