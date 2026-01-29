//
//  SupportVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 20/08/25.
//

    import UIKit
class SupportVC: UIViewController {
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var referRestBth: UIButton!


    var supportList: [ChatData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = pageBackgroundColor
        tbl.backgroundColor = .clear
        referRestBth.setRounded(cornerRadius: 4)
        referRestBth.setFontWithString(text: "Report Your Concern", fontSize: 16)
        referRestBth.backgroundColor = kBlueColor
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        getSupportList()
    }
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func referRestaurantAction() {
        let vc = self.viewController(viewController: InstantSupportVC.self, storyName: StoryName.Profile.rawValue) as! InstantSupportVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func getSupportList() {
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "support_id": "",
        ]) { _, new in new }
        
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.getSupportDetail, forModelType: SupportDetailResponse.self) { success in
            self.supportList = success.data.data ?? [ChatData]()
            self.tbl.reloadData()
            UtilsClass.hideProgressHud(view: self.view)
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
            self.showAlert(title: "Error", msg: "Something went wrong.")
        }
    }

}

extension SupportVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supportList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupportListCell", for: indexPath) as! SupportListCell

        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.updateUI(item: supportList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.viewController(viewController: ComplaintDetailsVC.self, storyName: StoryName.Profile.rawValue) as! ComplaintDetailsVC
        vc.supportID = supportList[indexPath.row].id!
        self.navigationController?.pushViewController(vc, animated: true)
         }
    
//        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            return 80 // Adjust height as needed
//        }
}

