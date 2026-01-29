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
        if dineinHide {
                   menus.removeSegment(at: 3, animated: true)
               }
        if cateringHide {
                   menus.removeSegment(at: 1, animated: true)
               }

    }
    @objc func menuControlValueChanged(_ sender: UISegmentedControl) {
        self.delegate?.selectedMenuType(menuType: MenuType(rawValue: sender.selectedSegmentIndex) ?? .menu)
    }
    @objc func buttonTapped(sender : UIButton) {
       // self.delegate?.selectedMenuType(menuType: (sender.titleLabel?.text)!)
                }
    func configMenu(isActiveCatering: Bool, isActiveDineIn: Bool) {
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
       // menus.setEnabled(isActiveCatering, forSegmentAt: 1)
       // menus.setEnabled(isActiveDineIn, forSegmentAt: 3)
        if !isActiveDineIn && !dineinHide {
            dineinHide = true
            menus.removeSegment(at: 3, animated: true)
        }
        if !isActiveCatering && !cateringHide {
            cateringHide = true
            menus.removeSegment(at: 1, animated: true)
        }
  //      menus.setTitle("", forSegmentAt: 1)
  //          menus.setEnabled(false, forSegmentAt: 1)
    }
    func updateUI(menuType: [String] , selectedMenuType: MenuType) {
//        if !Cart.shared.tempRestDetails.ordertypes.contains("Catering"){
//            self.menus.setEnabled(false, forSegmentAt: 1)
//    }

        self.menus.selectedSegmentIndex = selectedMenuType.rawValue
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
