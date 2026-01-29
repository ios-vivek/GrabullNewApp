//
//  FoodSearchVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 26/08/24.
//

import UIKit
import Lottie
class FoodSearchVC: UIViewController {
    @IBOutlet weak var emptyImageView: LottieAnimationView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var micSearch: UIImageView!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var animationSearchView: UIView!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    
    var strings = ["\'Food\'", "\'Restaurants\'", "\'Groceries\'", "\'Beverages\'", "\'Bread\'", "\'Pizza\'", "\'Biryani\'", "\'Burger\'", "\'Bajji\'", "\'Noodles\'", "\'Soup\'", "\'Sandwich\'", "\'Biscuits\'", "\'Chocolates\'"]
    var index = 1
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyImageView.play()
        emptyImageView.loopMode = .loop
        // Do any additional setup after loading the view.
        micSearch.isUserInteractionEnabled = true
        searchField.isUserInteractionEnabled = false
        searchField.text = ""//"searchTitle".localizeString(string:
        searchField.textColor = .gray
        
        let searchTap = UITapGestureRecognizer(target: self, action: #selector(searchTapAction))
        searchView.addGestureRecognizer(searchTap)
        
        let micTap = UITapGestureRecognizer(target: self, action: #selector(micTapAction(tapGestureRecognizer:)))
        micSearch.addGestureRecognizer(micTap)
        self.view.backgroundColor = .white
        searchField.setPlaceHolderColor(.gGray200)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchField.delegate = self
        searchView.layer.cornerRadius = 10
        searchView.layer.borderColor = UIColor.lightGray.cgColor
        searchView.layer.borderWidth = 1
     //   let profileTap = UITapGestureRecognizer(target: self, action: #selector(profileTapAction(_:)))
     //   userProfileIcon.addGestureRecognizer(profileTap)
        animateListOfLabels()

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Invalidate timer")
        timer?.invalidate()
    }
    func animateListOfLabels() {
        currentLabel.text = strings[index-1]
        nextLabel.alpha = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(updateLabels), userInfo: nil, repeats: true)
    }
    
    @objc func updateLabels() {
        print("updateLabels--time active")
        if index < strings.count {
            nextLabel.text = strings[index]
            nextLabel.alpha = 0
            nextLabel.transform = CGAffineTransform(translationX: 0, y: searchView.frame.height / 2)
            
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.currentLabel.alpha = 0
                self.currentLabel.transform = CGAffineTransform(translationX: 0, y: -self.searchView.frame.height / 2)
                self.nextLabel.alpha = 1
                self.nextLabel.transform = .identity
            }, completion: { _ in
                // Swap the labels
                self.currentLabel.text = self.nextLabel.text
                self.currentLabel.alpha = 1
                self.currentLabel.transform = .identity
                
                // Reset next label
                self.nextLabel.alpha = 0
                self.nextLabel.transform = CGAffineTransform(translationX: 0, y: self.searchView.frame.height / 2)
            })
            
            index += 1
        } else {
            // Invalidate the timer once all strings are displayed
           // timer?.invalidate()
            index  = 0
        }
    }
    func navigateToSearchController(withText: String){
        self.view.endEditing(true)
        let vc = self.viewController(viewController: RestSearchVC.self, storyName: StoryName.Main.rawValue) as! RestSearchVC
        vc.searchtext = withText
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func profileTapAction(_ sender: UITapGestureRecognizer? = nil) {
//        let vc = self.viewController(viewController: CartVC.self, storyName: StoryName.CartFlow.rawValue) as! CartVC
//        self.navigationController?.pushViewController(vc, animated: true)
        let vc = self.viewController(viewController: ConfirmOrderVC.self, storyName: StoryName.CartFlow.rawValue) as! ConfirmOrderVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func micTapAction(tapGestureRecognizer: UITapGestureRecognizer? = nil) {
        // handling code
        micAction()
    }
    @objc func searchTapAction() {
        // handling code
        navigateToSearchController(withText: "")
    }
    
    func micAction(){
        let vc = self.viewController(viewController: MicSearchVC.self, storyName: StoryName.Main.rawValue) as! MicSearchVC
       // self.modalPresentationStyle = UIModalPresentationCurrentContext;
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext

        self.present(vc, animated: true);
       
        vc.completion = { searchedText in
                    print("TestClosureClass is done")
            if searchedText.count > 0{
                self.dismiss(animated: true) {
                    self.navigateToSearchController(withText: searchedText)
                }
            }
                }
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
extension FoodSearchVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        navigateToSearchController(withText: "")
    }
}
extension FoodSearchVC: MicSearchDelegate {
    func searchDone(search: String){
        print(search)
        navigateToSearchController(withText: search)
    }
}

