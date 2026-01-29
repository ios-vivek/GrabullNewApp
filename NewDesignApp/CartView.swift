//
//  CartView.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 27/08/24.
//

import UIKit
protocol OpenCartViewDelegate: AnyObject {
    func openCartView()
}
class CartView: UIView {
    var itemLbl = UILabel()
    var delegate: OpenCartViewDelegate?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
      }
      
      //initWithCode to init view from xib or storyboard
      required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
      }
      
      //common func to init our view
      private func setupView() {
        backgroundColor = .kgreen
          itemLbl = UILabel(frame: CGRect(x: 20, y: 5, width: 200, height: 30))
              //label.center = CGPoint(x: 20, y: 20)
          itemLbl.textAlignment = .left
          itemLbl.text = "\(Cart.shared.cartData.count) Items added"
          itemLbl.font = UIFont.boldSystemFont(ofSize: 16)
          itemLbl.textColor = .white
          self.addSubview(itemLbl)
          
          let viewCartLbl = UILabel(frame: CGRect(x: self.frame.size.width - 240, y: 5, width: 200, height: 30))
              //label.center = CGPoint(x: 20, y: 20)
          viewCartLbl.textAlignment = .right
         // itemLbl.text = "\(UtilsClass.getCurrencySymbol())\(Cart.shared.getAllPriceDeatils().subTotal)"
          viewCartLbl.text = "View Cart"

          viewCartLbl.font = UIFont.boldSystemFont(ofSize: 16)
          viewCartLbl.textColor = .white
          self.addSubview(viewCartLbl)
          
          let img = UIImageView(frame: CGRect(x: self.frame.size.width - 30, y: 13, width: 12, height: 18))
          img.image = UIImage.init(named: "whiteArrow")
          self.addSubview(img)
          let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
          self.addGestureRecognizer(tap)

      }
    func updateUI(){
        itemLbl.text = "\(Cart.shared.cartData.count) Items added"
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.delegate?.openCartView()
    }

}
