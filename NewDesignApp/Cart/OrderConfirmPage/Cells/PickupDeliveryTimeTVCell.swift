//
//  PickupDeliveryTimeTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 18/11/24.
//

import UIKit
import Lottie
protocol ChangeTimeDelegate: AnyObject {
    func clickedOnChangeTime()
}
class PickupDeliveryTimeTVCell: UITableViewCell {
    @IBOutlet weak var orderTypeLbl: UILabel!
    @IBOutlet weak var readyTimeLbl: UILabel!
    @IBOutlet weak var changePickTimeBtn: UIButton!
    @IBOutlet weak var timerImageView: LottieAnimationView!
    weak var delegate: ChangeTimeDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .white
    }
    func updateUI() {
        //Pickup today ASAP
        //Pickup today at 6:15 pm
        //Pickup on 2, Oct at 06:30 am
        orderTypeLbl.text = Cart.shared.selectedTime.heading
       // let min = Cart.shared.restDetails.restPickupTime + 10
        //readyTimeLbl.text = "Ready in \(Int(Cart.shared.restDetails.restPickupTime))-\(Int(min)) Min"
    }
    @IBAction func changeTimeAction() {
        self.delegate?.clickedOnChangeTime()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
