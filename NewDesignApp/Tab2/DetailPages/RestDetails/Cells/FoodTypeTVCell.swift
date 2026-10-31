//
//  FoodTypeTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 10/08/24.
//

import UIKit

protocol MenuTypeSelectedDelegate {
    func selectedMenuType(menuType: MenuType)
}

class FoodTypeTVCell: UITableViewCell {
    @IBOutlet weak var menu1: UIButton!
    @IBOutlet weak var menu2: UIButton!
    @IBOutlet weak var menu3: UIButton!
    @IBOutlet weak var menu4: UIButton!
    @IBOutlet weak var menus: UISegmentedControl!
    var delegate: MenuTypeSelectedDelegate?
    var cateringHide: Bool = false
    var dineinHide: Bool = false
    var currentSelectedMenuType: MenuType = .menu

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        menus.selectedSegmentTintColor = themeBackgrounColor
        menus.setTextColor()
        menu1.setRounded(cornerRadius: 5)
        menu2.setRounded(cornerRadius: 5)
        menu3.setRounded(cornerRadius: 5)
        menu4.setRounded(cornerRadius: 5)
        menu1.isHidden = true
        menu2.isHidden = true
        menu3.isHidden = true
        menu4.isHidden = true
        menu1.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        menu2.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        menu3.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        menu4.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)

        menus.addTarget(self, action: #selector(menuControlValueChanged(_:)), for: .valueChanged)
        self.backgroundColor = .white
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        menus.removeAllSegments()
    }

    @objc func menuControlValueChanged(_ sender: UISegmentedControl) {
        guard sender.selectedSegmentIndex >= 0,
              let title = sender.titleForSegment(at: sender.selectedSegmentIndex) else {
            self.delegate?.selectedMenuType(menuType: .menu)
            return
        }
        let menuType: MenuType
        switch title {
        case "Menu":
            menuType = .menu
        case "Catering":
            menuType = .catering
        case "Deals":
            menuType = .deals
        case "DineIn":
            menuType = .dineIn
        default:
            menuType = .menu
        }
        self.currentSelectedMenuType = menuType
        self.delegate?.selectedMenuType(menuType: menuType)
    }

    @objc func buttonTapped(sender : UIButton) {
       // self.delegate?.selectedMenuType(menuType: (sender.titleLabel?.text)!)
    }

    func selectSegment(for menuType: MenuType) {
        let targetTitle: String
        switch menuType {
        case .menu: targetTitle = "Menu"
        case .catering: targetTitle = "Catering"
        case .deals: targetTitle = "Deals"
        case .dineIn: targetTitle = "DineIn"
        }
        for i in 0..<menus.numberOfSegments {
            if menus.titleForSegment(at: i) == targetTitle {
                menus.selectedSegmentIndex = i
                return
            }
        }
        if menus.numberOfSegments > 0 {
            menus.selectedSegmentIndex = 0
        }
    }

    func configMenu(isActiveCatering: Bool, isActiveDineIn: Bool, isDealsActive: Bool) {
        // Normal (unselected) state
        menus.setTitleTextAttributes(
            [.foregroundColor: UIColor.black],
            for: .normal
        )

        // Selected state
        menus.setTitleTextAttributes(
            [.foregroundColor: UIColor.white],
            for: .selected
        )

        // Disabled state (optional)
        menus.setTitleTextAttributes(
            [.foregroundColor: UIColor.lightGray],
            for: .disabled
        )

        menus.removeAllSegments()

        // 0: Menu is always present
        menus.insertSegment(withTitle: "Menu", at: menus.numberOfSegments, animated: false)

        // Catering is present only if active
        if isActiveCatering {
            menus.insertSegment(withTitle: "Catering", at: menus.numberOfSegments, animated: false)
        }

        // Deals is always present, but enabled/disabled based on isDealsActive
        let dealsIndex = menus.numberOfSegments
        menus.insertSegment(withTitle: "Deals", at: dealsIndex, animated: false)
        menus.setEnabled(isDealsActive, forSegmentAt: dealsIndex)

        // DineIn is present only if active
        if isActiveDineIn {
            menus.insertSegment(withTitle: "DineIn", at: menus.numberOfSegments, animated: false)
        }

        if !isDealsActive && currentSelectedMenuType == .deals {
            currentSelectedMenuType = .menu
        }

        selectSegment(for: currentSelectedMenuType)
    }

    func updateUI(menuType: [String] , selectedMenuType: MenuType) {
        self.currentSelectedMenuType = selectedMenuType
        selectSegment(for: selectedMenuType)

        menu1.backgroundColor = .gGray100
        menu2.backgroundColor = .gGray100
        menu3.backgroundColor = .gGray100
        menu4.backgroundColor = .gGray100
        menu1.titleLabel?.textColor = .black
        menu2.titleLabel?.textColor = .black
        menu3.titleLabel?.textColor = .black
        menu4.titleLabel?.textColor = .black
        for (index, item) in menuType.enumerated() {
            if index == 0 {
                menu1.setTitle(item, for: .normal)
                menu1.isHidden = false
                if selectedMenuType == .menu {
                    menu1.backgroundColor = themeBackgrounColor
                    menu1.setTitleColor(.white, for: .normal)
                }
            }
            if index == 1 {
                menu2.setTitle(item, for: .normal)
                menu2.isHidden = false
                if selectedMenuType == .catering {
                    menu2.backgroundColor = themeBackgrounColor
                    menu2.setTitleColor(.white, for: .normal)
                }
            }
            if index == 2 {
                menu3.setTitle(item, for: .normal)
                menu3.isHidden = false
                if selectedMenuType == .deals {
                    menu3.backgroundColor = themeBackgrounColor
                    menu3.setTitleColor(.white, for: .normal)
                }
            }
            if index == 3 {
                menu4.setTitle(item, for: .normal)
                menu4.isHidden = false
                if selectedMenuType == .dineIn {
                    menu4.backgroundColor = themeBackgrounColor
                    menu4.setTitleColor(.white, for: .normal)
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UISegmentedControl {
    func setTextColor() {
        // Normal state text color
        self.setTitleTextAttributes([.foregroundColor: UIColor.black],
                                                for: .normal)
        // Selected state text color
        self.setTitleTextAttributes([.foregroundColor: UIColor.white],
                                                for: .selected)
        // Change text color for disabled state
        let disabledAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray
        ]
        self.setTitleTextAttributes(disabledAttributes, for: .disabled)

    }
}
