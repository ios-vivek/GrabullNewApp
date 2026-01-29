//
//  RestaurantPoupVC.swift
//  Grabul
//
//  Created by Vivek SIngh on 07/08/24.
//  Copyright © 2024 Omnie. All rights reserved.
//

import UIKit
protocol SelectOptionDelegate: AnyObject {
    func selectedOption(restIndex: Int, index: Int)
}
class RestaurantPoupVC: UIViewController {
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var showSimilarView: UIView!
    @IBOutlet weak var addToFavView: UIView!
    @IBOutlet weak var hideThisRestView: UIView!
    @IBOutlet weak var firstOptionLbl: UILabel!
    @IBOutlet weak var secondOptionLbl: UILabel!
    @IBOutlet weak var thirdOptionLbl: UILabel!
    @IBOutlet weak var firstOptionImg: UIImageView!
    @IBOutlet weak var secondOptionImg: UIImageView!
    @IBOutlet weak var thirdOptionImg: UIImageView!
    var firstImg: UIImage!
    var secondImg: UIImage!
    var thirdImg: UIImage!
    @IBOutlet weak var closeView: UIView!
    @IBOutlet weak var seperatorOne: UIImageView!
    @IBOutlet weak var seperatorTwo: UIImageView!
    var pointY: Float = 0.0
    var restIndex: Int = 0
    var numberOfItem: Int = 3
    var textOne: String = ""
    var textTwo: String = ""
    var textThree: String = ""
    weak var delegate: SelectOptionDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(pointY)
        let point = CGPoint(x: UIScreen.main.bounds.size.width - 100, y: CGFloat(pointY+70))
           //let x = point.x
          // let y = point.y
        self.view.backgroundColor = .clear
        popupView.center = point
        setViewHeightAndData()
       
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap1(_:)))
        showSimilarView.addGestureRecognizer(tap1)
        showSimilarView.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap2(_:)))
        addToFavView.addGestureRecognizer(tap2)
        addToFavView.isUserInteractionEnabled = true
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap3(_:)))
        hideThisRestView.addGestureRecognizer(tap3)
        hideThisRestView.isUserInteractionEnabled = true
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(self.hideView(_:)))
        closeView.addGestureRecognizer(tap4)
        closeView.isUserInteractionEnabled = true
    }
    func setViewHeightAndData() {
        seperatorOne.isHidden = false
        seperatorTwo.isHidden = false
        if numberOfItem == 3 {
            popupView.frame.size.height = 115
        }
        if numberOfItem == 2 {
            popupView.frame.size.height = 72
            seperatorTwo.isHidden = true
        }
        if numberOfItem == 1 {
            popupView.frame.size.height = 40
            seperatorOne.isHidden = true
            seperatorTwo.isHidden = true
        }
        popupView.layer.cornerRadius = 15
        firstOptionLbl.text = textOne
        secondOptionLbl.text = textTwo
        thirdOptionLbl.text = textThree
        firstOptionImg.image = firstImg
        secondOptionImg.image = secondImg
        thirdOptionImg.image = thirdImg
        firstOptionImg.backgroundColor = .clear
    }
    @objc func hideView(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: false)
    }
    @objc func handleTap1(_ sender: UITapGestureRecognizer? = nil) {
        sendDelegateCases(text: textOne)
        self.dismiss(animated: false)
    }
    @objc func handleTap2(_ sender: UITapGestureRecognizer? = nil) {
        sendDelegateCases(text: textTwo)
        self.dismiss(animated: false)
    }
    @objc func handleTap3(_ sender: UITapGestureRecognizer? = nil) {
        sendDelegateCases(text: textThree)
        self.dismiss(animated: false)
    }
    func sendDelegateCases(text: String) {
        if text == TextType.UnhideThisRestaurant.rawValue {
            self.delegate?.selectedOption(restIndex: restIndex, index: 3)
        }
        if text == TextType.ShowSimilarRestaurants.rawValue {
            self.delegate?.selectedOption(restIndex: restIndex, index: 1)
        }
        if text == TextType.AddToFavourites.rawValue {
            self.delegate?.selectedOption(restIndex: restIndex, index: 2)
        }
        if text == TextType.RemoveFromFavourites.rawValue {
            self.delegate?.selectedOption(restIndex: restIndex, index: 2)
        }
        if text == TextType.HideThisRestaurant.rawValue {
            self.delegate?.selectedOption(restIndex: restIndex, index: 3)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       // self.dismiss(animated: false)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
