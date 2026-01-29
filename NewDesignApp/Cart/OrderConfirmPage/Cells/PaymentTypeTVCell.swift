//
//  PaymentTypeTVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 22/10/24.
//

import UIKit
protocol PaymentTypeDeledate: AnyObject {
	func selectedPaymentType(index: Int)
	func savedCardsTapped()
}
class PaymentTypeTVCell: UITableViewCell {
	@IBOutlet weak var paymentTypeSegment: UISegmentedControl!
	@IBOutlet weak var savedCardsLbl: UILabel!
	weak var delegate: PaymentTypeDeledate?
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		paymentTypeSegment.selectedSegmentTintColor = kBlueColor
		paymentTypeSegment.setTextColor()
		paymentTypeSegment.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
		self.backgroundColor = .white
		let tap = UITapGestureRecognizer(target: self, action: #selector(savedCardsLabelTapped))
		savedCardsLbl.isUserInteractionEnabled = true
		savedCardsLbl.addGestureRecognizer(tap)

	}
	@objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
		self.delegate?.selectedPaymentType(index: sender.selectedSegmentIndex)
	}
	@objc private func savedCardsLabelTapped() {
		self.delegate?.savedCardsTapped()
	}
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)

		// Configure the view for the selected state
	}

}
