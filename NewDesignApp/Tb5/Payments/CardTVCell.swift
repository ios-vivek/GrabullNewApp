//
//  CardTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 21/08/25.
//

import UIKit

protocol CardCellDelegate: AnyObject {
    func deleteCardTapped(at index: Int)
}

class CardTVCell: UITableViewCell {
    @IBOutlet weak var cardNumberLbl: UILabel!
    @IBOutlet weak var deleteCardBtn: UIButton!
    weak var delegate: CardCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        deleteCardBtn.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc private func deleteAction() {
        delegate?.deleteCardTapped(at: deleteCardBtn.tag)
    }

}
