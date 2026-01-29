//
//  RewardVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 30/10/24.
//

import UIKit

class RewardVC: UIViewController {
    @IBOutlet weak var rewardTbl: UITableView!
    @IBOutlet weak var viewheading: UIView!
    @IBOutlet weak var myRewardPointsLbl: UILabel!
    var rewardResponse: RewardsData!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myRewardPointsLbl.text = "$ 0.0"
        getRewardFromApi()
        self.view.backgroundColor = pageBackgroundColor
        rewardTbl.backgroundColor = .clear
        viewheading.backgroundColor = kGreenColor
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    func updateUI() {
        myRewardPointsLbl.text = "$ \(rewardResponse.rewards)"
        rewardTbl.reloadData()
    }
    func getRewardFromApi() {
        let parameters = CommonAPIParams.base()
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.getReward, forModelType: RewardsResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            self.rewardResponse = success.data.data
           // self.favTbl.reloadData()
            self.updateUI()
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
    }

}
extension RewardVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.rewardResponse != nil else {
            return 0
        }
         return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RewardTVCell", for: indexPath) as! RewardTVCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        switch indexPath.row {
        case 0:
            cell.rewardTypeLbl.text = "  Total Points"
            cell.rewardPointLbl.text = "Points \(self.rewardResponse.points)"
            cell.rewardBucksLbl.text = "GB Bucks $ \(self.rewardResponse.pointsGb)"
        case 1:
            cell.rewardTypeLbl.text = "  Friend Referrals"
            cell.rewardPointLbl.text = "Friends \(self.rewardResponse.friendCount)"
            cell.rewardBucksLbl.text = "GB Bucks $ \(self.rewardResponse.restaurantGb)"
        default:
            cell.rewardTypeLbl.text = "  Restaurant Referrals"
            cell.rewardPointLbl.text = "Restaurants \(self.rewardResponse.restaurantCount)"
            cell.rewardBucksLbl.text = "GB Bucks $ \(self.rewardResponse.restaurantGb)"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
    }
}
