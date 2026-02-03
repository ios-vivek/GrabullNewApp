//
//  HistoryVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 09/08/24.
//

import UIKit
import Lottie
class PastHistoryVC: UIViewController {
    
    @IBOutlet weak var emptyImageView: LottieAnimationView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var historyTblView: UITableView!
    @IBOutlet weak var noDataFoundLbl: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var monthButton: UILabel!
    @IBOutlet weak var yearButton: UILabel!
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var yearView: UIView!
    @IBOutlet weak var searchView: UIView!

    @IBOutlet weak var calendarStack: UIStackView!
    var historyList = [OrderHistory]()
    private enum PickerMode {
        case month
        case year
    }
    private let pickerView = UIPickerView()
    private let pickerToolbar = UIToolbar()
    private var pickerMode: PickerMode = .month
    private let months: [String] = DateFormatter().monthSymbols
    private lazy var years: [String] = {
        let currentYear = Calendar.current.component(.year, from: Date())
        return ["\(currentYear)", "\(currentYear - 1)"]
    }()
    private let hiddenPickerTextField = UITextField(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyView.isHidden = true
        noDataFoundLbl.textColor = .lightGray
        emptyImageView.play()
        emptyImageView.loopMode = .loop
        // Do any additional setup after loading the view.
       // self.view.backgroundColor = .red
        loginBtn.setRounded(cornerRadius: 8)
        loginBtn.setFontWithString(text: "Proceed with Email/Phone number", fontSize: 12)
        loginBtn.backgroundColor = themeBackgrounColor

        configurePicker()
        configureInitialExpiryTitles()
        configureMonthYearViewGestures()
        
        setView(view: monthView, btn: monthButton)
        setView(view: yearView, btn: yearButton)
        setSearchView(view: searchView)
        self.view.backgroundColor = pageBackgroundColor
        historyTblView.backgroundColor = .clear
        let monthTapGesture = UITapGestureRecognizer(target: self, action: #selector(monthAction))
        monthView.isUserInteractionEnabled = true   // important!
        monthView.addGestureRecognizer(monthTapGesture)
        
        let yearTapGesture = UITapGestureRecognizer(target: self, action: #selector(yearAction))
        yearView.isUserInteractionEnabled = true   // important!
        yearView.addGestureRecognizer(yearTapGesture)
        
    }
    func setView(view: UIView, btn: UILabel) {
        view.layer.borderWidth = 1
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.backgroundColor = .white
        btn.textColor = .black
        btn.font = UIFont.systemFont(ofSize: 12)
        btn.adjustsFontSizeToFitWidth = true
    }
    func setSearchView(view: UIView) {
        view.backgroundColor = kBlueColor

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if APPDELEGATE.userLoggedIn() {
            self.callService()
        } else {
            historyList = [OrderHistory]()
            historyTblView.reloadData()
        }
    }
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func monthAction() {
        pickerMode = .month
        pickerView.reloadAllComponents()
        selectCurrentValueIfAny()
        hiddenPickerTextField.becomeFirstResponder()
    }
    @objc func yearAction() {
        pickerMode = .year
        pickerView.reloadAllComponents()
        selectCurrentValueIfAny()
        hiddenPickerTextField.becomeFirstResponder()
    }
    func noDataFoundRefersh(){
        noDataFoundLbl.isHidden = !APPDELEGATE.userLoggedIn()
        loginView.isHidden = APPDELEGATE.userLoggedIn()
        calendarStack.isHidden = !APPDELEGATE.userLoggedIn()
    }
    
    @IBAction func loginAction() {
        let vc = self.viewController(viewController: ProfileVC.self, storyName: StoryName.Profile.rawValue) as! ProfileVC
        vc.delegate = self
        vc.fromOtherPage = true
        self.present(vc, animated: true)
      //  print(Int(Cart.shared.getAllPriceDeatils().subTotal))
      //  print(Cart.shared.restuarant.mindelivery)
    }
    func getOrderHistoryDataFromApi() {
        let selectedMonth = monthButton?.text ?? ""
        let selectedYear = yearButton?.text ?? ""
        let row = months.firstIndex(of: selectedMonth) ?? 0
let montharr = ["01","02","03","04","05","06","07","08","09","10","11","12"]

        var parameters = CommonAPIParams.base()
        parameters.merge([
            "year" : "\(selectedYear)",
            "month" : "\(montharr[row])",
            "dbname" : Cart.shared.dbname,
        ]) { _, new in new }
        
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.pastOrder, forModelType: HisoryResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            self.historyList = success.data.data
            self.historyTblView.reloadData()
            self.noDataFoundRefersh()
            self.noDataFoundLbl.text = self.historyList.count != 0 ? "" : "You don't have any order history in \(selectedMonth)."
            self.emptyView.isHidden = self.historyList.count != 0 ? true : false
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
            self.noDataFoundRefersh()
            self.historyTblView.reloadData()
            self.noDataFoundLbl.text = "You don't have any past orders."
            self.emptyView.isHidden = false
        }
    }
    
    private func configureMonthYearViewGestures() {
        let monthTap = UITapGestureRecognizer(target: self, action: #selector(monthViewTapped))
        monthView.addGestureRecognizer(monthTap)
        monthView.isUserInteractionEnabled = true
        
        let yearTap = UITapGestureRecognizer(target: self, action: #selector(yearViewTapped))
        yearView.addGestureRecognizer(yearTap)
        yearView.isUserInteractionEnabled = true
        
        let searchTap = UITapGestureRecognizer(target: self, action: #selector(searchViewTapped))
        searchView.addGestureRecognizer(searchTap)
        searchView.isUserInteractionEnabled = true
    }
    @objc private func searchViewTapped() {
        self.callService()
    }
    @objc private func monthViewTapped() {
        monthAction()
    }
    
    @objc private func yearViewTapped() {
        yearAction()
    }

    private func configurePicker() {
        hiddenPickerTextField.isHidden = true
        view.addSubview(hiddenPickerTextField)
        pickerView.dataSource = self
        pickerView.delegate = self
        hiddenPickerTextField.inputView = pickerView
        
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePicker))
        pickerToolbar.items = [cancel, flex, done]
        pickerToolbar.sizeToFit()
        hiddenPickerTextField.inputAccessoryView = pickerToolbar
    }
    
    private func configureInitialExpiryTitles() {
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        let currentMonthName = months.indices.contains(currentMonthIndex) ? months[currentMonthIndex] : DateFormatter().monthSymbols[currentMonthIndex]
        monthButton?.text = "\(currentMonthName)"
        yearButton?.text = "\(currentYear)"
    }
    
    private func selectCurrentValueIfAny() {
        switch pickerMode {
        case .month:
            let current = monthButton?.text ?? ""
            let row = months.firstIndex(of: current) ?? 0
            pickerView.selectRow(row, inComponent: 0, animated: false)
        case .year:
            let current = yearButton?.text ?? ""
            let row = years.firstIndex(of: current) ?? 0
            pickerView.selectRow(row, inComponent: 0, animated: false)
        }
    }
    
    @objc private func cancelPicker() {
        hiddenPickerTextField.resignFirstResponder()
    }
    
    @objc private func donePicker() {
        let row = pickerView.selectedRow(inComponent: 0)
        switch pickerMode {
        case .month:
            monthButton?.text = "\(months[row])"
        case .year:
            yearButton?.text = "\(years[row])"
        }
        hiddenPickerTextField.resignFirstResponder()
    }
    @objc func ratingAction(sender: UIButton) {
        let getTag = sender.tag
        let story = UIStoryboard.init(name: "History", bundle: nil)
        let popupVC = story.instantiateViewController(withIdentifier: "RatingVC") as! RatingVC
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.orderID = historyList[getTag].order
        self.present(popupVC, animated: true)
    }
    
    @objc func trackOrderAction(sender: UIButton) {
        let rest = historyList[sender.tag]
       // getRestDetailFromApi(restid: "\(rest.resturant_id)", dbname: "\(rest.dbname)")
    }
    
    func getRestDetailFromApi(restid: String, dbname: String) {
        Cart.shared.dbname = dbname
       
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "rest_id" : restid
        ]) { _, new in new }
        
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.restaurantDetail, forModelType: RestDetailsApiResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            let story = UIStoryboard.init(name: "OrderFlow", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "RestDetailsVC") as! RestDetailsVC
          //  vc.restDetailsData = success.data.restaurant
            self.navigationController?.pushViewController(vc, animated: true)
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
    }
    
    func callService() {
        self.emptyView.isHidden = true
            self.getOrderHistoryDataFromApi()
    }
    
}
extension PastHistoryVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerMode {
        case .month: return months.count
        case .year: return years.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerMode {
        case .month: return months[row]
        case .year: return years[row]
        }
    }
}
extension PastHistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noDataFoundRefersh()
            return historyList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTVCell", for: indexPath) as! HistoryTVCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.updateUI(order: historyList[indexPath.row])
            cell.rateBtn.tag = indexPath.row
            cell.rateBtn.addTarget(self, action: #selector(ratingAction), for: .touchUpInside)
            cell.reOrderBtn.tag = indexPath.row
            cell.reOrderBtn.addTarget(self, action: #selector(trackOrderAction), for: .touchUpInside)
            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = self.viewController(viewController: OrderDetailVC.self, storyName: StoryName.History.rawValue) as! OrderDetailVC
            vc.hOrder = historyList[indexPath.section]
            self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension PastHistoryVC: LoginSuccessDelegate {
    func signupAction() {
        let vc = self.viewController(viewController: SignupVC.self, storyName: StoryName.Profile.rawValue) as! SignupVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loginCompleted() {
        self.noDataFoundRefersh()
        callService()
    }
}
extension PastHistoryVC: SignupSuccessfullyDelegate {
    func signupCompleted() {
        self.noDataFoundRefersh()
        callService()

    }
}
