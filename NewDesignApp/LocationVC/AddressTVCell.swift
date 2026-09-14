//
//  AddressTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 25/09/24.
//

import UIKit

class AddressTVCell: UITableViewCell {
    @IBOutlet weak var addressTitleLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var seperatorImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 4
        seperatorImg.backgroundColor = .gGray100
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(address: Prediction) {
        let lines = formattedSuggestion(for: address)
        let text = "\(lines.primary)\n\(lines.secondary)"
        let attributedText = NSMutableAttributedString(string: text)
        let primaryLength = (lines.primary as NSString).length
        let secondaryRange = NSRange(location: primaryLength + 1,
                                     length: (lines.secondary as NSString).length)
        attributedText.addAttribute(.font,
                                    value: UIFont.systemFont(ofSize: 15, weight: .semibold),
                                    range: NSRange(location: 0, length: primaryLength))
        attributedText.addAttribute(.font,
                                    value: UIFont.systemFont(ofSize: 13, weight: .regular),
                                    range: secondaryRange)
        attributedText.addAttribute(.foregroundColor, value: UIColor.darkGray, range: secondaryRange)
        addressTitleLbl.attributedText = attributedText
        addressTitleLbl.numberOfLines = 2
        img.isHidden = false
        seperatorImg.isHidden = false
    }

    private func formattedSuggestion(for address: Prediction) -> (primary: String, secondary: String) {
        let values = address.terms?.map(\.value) ?? []
        guard values.count >= 2 else { return (address.description ?? "", "") }

        let country = values.last ?? ""
        var remaining = Array(values.dropLast())
        var state = ""
        var zip = ""
        if let index = remaining.lastIndex(where: { $0.range(of: #"\b\d{5}(?:-\d{4})?\b"#, options: .regularExpression) != nil }) {
            let stateAndZip = remaining.remove(at: index)
            let parts = stateAndZip.split(separator: " ", maxSplits: 1).map(String.init)
            if parts.count == 2 {
                state = parts[0]
                zip = parts[1]
            } else {
                zip = stateAndZip
            }
        }
        if state.isEmpty, let last = remaining.last,
           last.range(of: #"^[A-Z]{2}$"#, options: .regularExpression) != nil {
            state = remaining.removeLast()
        }

        let primary = remaining.joined(separator: ", ")
        let secondary = [state, country, zip].filter { !$0.isEmpty }.joined(separator: ", ")
        return (primary.isEmpty ? (address.description ?? "") : primary, secondary)
    }
    
    func savedAddressUpdateUI(address: UserAdd) {
        let primary = [address.street, address.add1, address.city]
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
        let secondary = [address.state, "USA", address.zip]
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
        setTwoLineAddress(primary: primary, secondary: secondary)
    }

    func recentAddressUpdateUI(address: String) {
        let components = address
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        guard components.count >= 2 else {
            addressTitleLbl.text = address
            return
        }

        var remaining = components
        let country = remaining.removeLast()
        var state = ""
        var zip = ""
        if let index = remaining.lastIndex(where: { $0.range(of: #"\b\d{5}(?:-\d{4})?\b"#, options: .regularExpression) != nil }) {
            let stateAndZip = remaining.remove(at: index)
            let parts = stateAndZip.split(separator: " ", maxSplits: 1).map(String.init)
            if parts.count == 2 {
                state = parts[0]
                zip = parts[1]
            } else {
                zip = stateAndZip
            }
        }
        if state.isEmpty, let last = remaining.last,
           last.range(of: #"^[A-Z]{2}$"#, options: .regularExpression) != nil {
            state = remaining.removeLast()
        }

        let primary = remaining.joined(separator: ", ")
        let secondary = [state, country, zip].filter { !$0.isEmpty }.joined(separator: ", ")
        setTwoLineAddress(primary: primary, secondary: secondary)
    }

    private func setTwoLineAddress(primary: String, secondary: String) {
        let text = "\(primary)\n\(secondary)"
        let attributedText = NSMutableAttributedString(string: text)
        let primaryLength = (primary as NSString).length
        let secondaryRange = NSRange(location: primaryLength + 1,
                                     length: (secondary as NSString).length)
        attributedText.addAttribute(.font,
                                    value: UIFont.systemFont(ofSize: 15, weight: .semibold),
                                    range: NSRange(location: 0, length: primaryLength))
        attributedText.addAttribute(.font,
                                    value: UIFont.systemFont(ofSize: 13, weight: .regular),
                                    range: secondaryRange)
        attributedText.addAttribute(.foregroundColor, value: UIColor.darkGray, range: secondaryRange)
        addressTitleLbl.attributedText = attributedText
        addressTitleLbl.numberOfLines = 2
        img.isHidden = false
        seperatorImg.isHidden = false
    }
    
    func recentTitle(address: String){
        addressTitleLbl.text = "\(address)"
        self.backgroundColor = .gGray100
        img.isHidden = true
        seperatorImg.isHidden = true
        addressTitleLbl.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }

}
