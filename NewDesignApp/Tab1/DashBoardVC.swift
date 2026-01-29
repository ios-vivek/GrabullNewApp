//
//  DashBoardVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 09/08/24.
//

import UIKit
import Alamofire
private enum Layout {
    static let heroHeight: CGFloat = 150
    static let section0Height: CGFloat = 130
    static let section1Height: CGFloat = 70
    static let section2Height: CGFloat = 400
}

enum DashboardSection: Int, CaseIterable {
    case welcome
    case timing
    case foodOptions
}

class DashBoardVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var topConstrains: NSLayoutConstraint!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var userProfileIcon: UIImageView!
    @IBOutlet weak var micSearch: UIImageView!
    @IBOutlet weak var serachImage: UIImageView!
    @IBOutlet weak var serachField: UITextField!
    @IBOutlet weak var restaurantTable: UITableView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var restaurationNotAvailableView: UIView!
    @IBOutlet weak var liveitUpView: UIView!
    @IBOutlet weak var cartLbl: UILabel!
    @IBOutlet weak var animationSearchView: UIView!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var searchForLabel: UILabel!

    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var imageToConstant: NSLayoutConstraint!
    
@IBOutlet weak var liveItUpImage: UIImageView!
    let strings = ["\'food\'".translated(), "\'restaurants\'".translated(), "\'groceries\'".translated(), "\'beverages\'".translated(), "\'bread\'".translated(), "\'pizza\'".translated(), "\'biryani\'".translated(), "\'burger\'".translated(), "\'bajji\'".translated(), "\'noodles\'".translated(), "\'soup\'".translated(), "\'sandwich\'".translated(), "\'biscuits\'".translated(), "\'chocolates\'".translated()]
    var index = 0
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
      
        tableViewSetup()
        let size = UIScreen.main.bounds.size.width
        if size >= 430 {
            liveitUpView.frame.size.height = 150
            imageToConstant.constant = 0.0
        } else {
            imageToConstant.constant = -40.0
        }
        cartLbl.textColor = kOrangeColor

        let url = "https://img1.wsimg.com/isteam/ip/ee445ab6-30e2-4154-ba10-a084ef192630/LiveItUpLogo_Pantone.png"
        self.loadImage(from: url)
        
        liveItUpImage.contentMode = .scaleToFill
        self.view.backgroundColor = .white
        
        micSearch.isUserInteractionEnabled = true
        serachField.isUserInteractionEnabled = false
        serachField.text = ""//"searchTitle".localizeString(string:
        serachField.textColor = .gray
        checkViewHidden()
        
        setupGestures()
        
        searchForLabel.text = "title4".translated()
        serachField.setPlaceHolderColor(.gGray200)


    }
    func tableViewSetup() {
        if #available(iOS 15.0, *) {
            restaurantTable.sectionHeaderTopPadding = 0.0
        }
        restaurantTable.backgroundColor = .white
        restaurantTable.register(UINib(nibName: "TableHeaderFilterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableHeaderFilterView")
        
    }
    
    func setupGestures() {

        let searchTap = UITapGestureRecognizer(target: self, action: #selector(searchTapAction))
        searchView.addGestureRecognizer(searchTap)
        
        let searchTap1 = UITapGestureRecognizer(target: self, action: #selector(searchTapAction))
        animationSearchView.addGestureRecognizer(searchTap1)
        
        let micTap = UITapGestureRecognizer(target: self, action: #selector(micTapAction(tapGestureRecognizer:)))
        micSearch.addGestureRecognizer(micTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("location"), object: nil)
        
       }
    
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.liveItUpImage.image = image
            }
        }.resume()
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        checkViewHidden()
    }

    func checkViewHidden() {
        var premise = APPDELEGATE.selectedLocationAddress.premise
        let local = APPDELEGATE.selectedLocationAddress.subLocality ?? ""
        let city = APPDELEGATE.selectedLocationAddress.city ?? ""
        var mainAdd = ""
        if premise.count > 0 {
            premise = "\(premise), "
        }
        if local.count > 0 {
            mainAdd = "\(premise)\(local), \(city)"
        }
        else if city.count > 0 {
            mainAdd = "\(city)"
        }
        
        self.locationButton.setTitle(mainAdd, for: .normal)
        self.headingLabel.text = "\(APPDELEGATE.selectedLocationAddress.state ?? ""), \(APPDELEGATE.selectedLocationAddress.zipcode ?? "")"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkViewHidden()
        cartLbl.text = "\(Cart.shared.cartData.count)"
        restaurantTable.reloadData()
        animateListOfLabels()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    func getCuisinesFromApi() {
        let parameters = CommonAPIParams.base()
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.cuisine, forModelType: CuisineResponse.self) { success in
            APPDELEGATE.cusines = success.data
            UtilsClass.saveCousines()
        } ErrorHandler: { _ in }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LocationManagerClass.shared.completionAddress = { [weak self] address in
            guard let self = self else { return }
            guard !address.isEmpty else { return }
            let breaksAdd = address.components(separatedBy: ", *")
            if let first = breaksAdd.first {
                self.locationButton.setTitle(first, for: .normal)
            }
            if breaksAdd.count > 1 {
                self.headingLabel.text = breaksAdd[1]
            }
            self.checkViewHidden()
        }
        serachField.delegate = self
        searchView.layer.cornerRadius = 10
        searchView.layer.borderColor = UIColor.lightGray.cgColor
        searchView.layer.borderWidth = 1
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(profileTapAction(_:)))
        userProfileIcon.addGestureRecognizer(profileTap)

       

    }
    @objc func profileTapAction(_ sender: UITapGestureRecognizer? = nil) {
        let vc = self.viewController(viewController: CartVC.self, storyName: StoryName.CartFlow.rawValue) as! CartVC
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return 1
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "WelcomeCell",
                for: indexPath
            ) as? WelcomeCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "DisplayFoodTimingTVCell",
                for: indexPath
            ) as? DisplayFoodTimingTVCell else {
                return UITableViewCell()
            }
            cell.backgroundColor = .white
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "FoodOptionTVCell",
                for: indexPath
            ) as? FoodOptionTVCell else {
                return UITableViewCell()
            }
            cell.delegate = self
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        return cell
        default:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "FoodOptionTVCell",
                for: indexPath
            ) as? FoodOptionTVCell else {
                return UITableViewCell()
            }
            cell.delegate = self
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        return cell
        }
    }
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch DashboardSection(rawValue: indexPath.section) {
        case .welcome: return Layout.section0Height
        case .timing: return Layout.section1Height
        case .foodOptions: return Layout.section2Height
        default: return 0
        }
    }
        
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableHeaderFilterView") as! TableHeaderFilterView
//        //headerView.sectionTitleLabel.text = "TableView Heder \(section)"
//        headerView.clickedOnFilter = { text in
//            let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterPageVC") as! FilterPageVC
//            //vc.modalPresentationStyle = .fullScreen
//            popupVC.modalPresentationStyle = .overCurrentContext
//            popupVC.modalTransitionStyle = .crossDissolve
//            self.present(popupVC, animated: true)
//        }
//        return headerView
//    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 0 }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) { }
    

    @IBOutlet weak var headingLabel: UILabel!
   

    @IBAction func changeLang(_ sender: Any) {
        let vc = self.viewController(viewController: LocationVC.self, storyName: StoryName.Location.rawValue) as! LocationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToSearchController(withText: String){
        self.view.endEditing(true)
        let vc = self.viewController(viewController: RestSearchVC.self, storyName: StoryName.Main.rawValue) as! RestSearchVC
        vc.searchtext = withText
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    @objc func textFieldDidChange() {
//        if let text = searchField.text, !text.isEmpty {
//            searchView.isHidden = true
//            stopTimer()
//        } else {
//            searchView.isHidden = false
//            resumeTimer()
//        }
//    }
    
    func stopTimer() { timer?.invalidate() }
    
    func resumeTimer() {
//        if UtilsClass.getLocalLanuage() == "ar" {
//            strings = arStrings
//        }
        if !strings.isEmpty {
            currentLabel.text = strings[max(0, index)]
        }
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in
            self?.updateLabels()
        }    }
    
    func animateListOfLabels() {
      //  if UtilsClass.getLocalLanuage() == "ar" {
          //  strings = arStrings
      //  }
        if !strings.isEmpty {
            currentLabel.text = strings[min(index, strings.count - 1)]
        }
        nextLabel.alpha = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(updateLabels), userInfo: nil, repeats: true)
    }
    
    @objc func updateLabels() {
        guard !strings.isEmpty else { return }
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
            index = 0
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("location"), object: nil)
        timer?.invalidate()
    }
}
extension DashBoardVC: MicSearchDelegate {
    func searchDone(search: String){
        print(search)
        navigateToSearchController(withText: search)
    }
}
extension DashBoardVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        navigateToSearchController(withText: "")
    }
}
extension DashBoardVC: DashBoardSectionDelegate {
    func selectedSection(index: Int) {
        if index == 0 {
            self.tabBarController?.selectedIndex = 1
        }
        if index == 1 {
            self.tabBarController?.selectedIndex = 1
        }
        if index == 2 {
            let story = UIStoryboard.init(name: "FoodSearch", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "SearchDetailVC") as! SearchDetailVC
            //vc.listResponse = success.data.restaurant
            vc.isDineFilter = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
