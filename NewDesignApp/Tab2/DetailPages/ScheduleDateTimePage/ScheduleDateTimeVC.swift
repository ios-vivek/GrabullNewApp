//
//  ScheduleDateTimeVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 01/10/24.
//

import UIKit
protocol DateChangedDelegate: AnyObject {
    func dateChanged()
}
class ScheduleDateTimeVC: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var pickDeliveryControl: UISegmentedControl!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var dateCollection: UICollectionView!
    @IBOutlet weak var etalbl: UILabel!
    @IBOutlet weak var etaDetailLbl: UILabel!
    @IBOutlet weak var dateSubmitButton: UIButton!
    @IBOutlet weak var asapView: UIView!
    @IBOutlet weak var selectTimeLbl: UILabel!
    @IBOutlet weak var selecttimeView: UIView!
    @IBOutlet weak var timeBackBtn: UIButton!
    @IBOutlet weak var warningLbl: UILabel!
    @IBOutlet weak var collectionTopHeight: NSLayoutConstraint!
    weak var delegate: DateChangedDelegate?
    @IBOutlet weak var topConstrainsWarningLbl: NSLayoutConstraint!
    @IBOutlet weak var cancelView: UIView!

    var selectedTimeIndex = -1
    var selectedDateIndex = -1
    var timing: RestTiming!
    let datesList = UtilsClass.getDates()
    var timeList = [String]()
    var type = ""
    var isPickupDeliverySettingHide = false
   private var orderDate: OrderDate = .ASAP

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.orderDate = Cart.shared.orderDate
        segmentedControl.setTextColor()
        pickDeliveryControl.setTextColor()
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(self.cancelTap(_:)))
        cancelView.addGestureRecognizer(cancelTap)
        segmentedControl.selectedSegmentTintColor = kBlueColor
        //segmentedControl.backgroundColor = .gOrange100

        pickDeliveryControl.selectedSegmentTintColor = themeBackgrounColor
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        selectedDateIndex = -1
        selectedDateIndex = -1
        type = Cart.shared.orderType == .delivery ? "Delivery" : "Pickup"
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        pickDeliveryControl.addTarget(self, action: #selector(pickupDeliveryControlValueChanged(_:)), for: .valueChanged)

        if Cart.shared.orderType == .delivery {
            pickDeliveryControl.selectedSegmentIndex = 0
           // etalbl.text = "Eta \(Int(Cart.shared.tempRestDetails.deliverytime)) - \(Int(Cart.shared.tempRestDetails.deliverytime + 10.0)) mins"
          //  etaDetailLbl.text = "\(Int(Cart.shared.tempRestDetails.deliverytime + 10.0)) mins for order over $150"
        }
        if Cart.shared.orderType == .pickup {
            pickDeliveryControl.selectedSegmentIndex = 1
          //  etalbl.text = "Eta \(Int(Cart.shared.tempRestDetails.pickuptime)) - \(Int(Cart.shared.tempRestDetails.pickuptime + 10.0)) mins"
          //  etaDetailLbl.text = "\(Int(Cart.shared.tempRestDetails.pickuptime + 10.0)) mins for order over $150"
        }
     //   self.segmentedControl.setEnabled(Cart.shared.tempRestDetails.isDelivery, forSegmentAt: 0);
      //  self.segmentedControl.setEnabled(Cart.shared.tempRestDetails.isPickup, forSegmentAt: 1);

        dateLbl.text = UtilsClass.getTodayDateInString()
        dateCollection.backgroundColor = .white
        dateSubmitButton.setRounded(cornerRadius: 8)
        getTimingFromApi(date: UtilsClass.getCurrentDateInString(date: Date()))
         //   self.segmentedControl.setEnabled(Cart.shared.tempRestDetails.isRestaurantOpen, forSegmentAt: 0);
//        if !Cart.shared.tempRestDetails.isRestaurantOpen {
//            self.segmentedControl.selectedSegmentIndex = 1
//        }
        //print("today closed..\(UtilsClass.isRestaurantClosedToday(Cart.shared.tempRestDetails.stopyoday))")
       // segmentedControl.setEnabled(!UtilsClass.isRestaurantClosedToday(Cart.shared.tempRestDetails.stopyoday), forSegmentAt: 1);
        pickDeliveryControl.isHidden = isPickupDeliverySettingHide
        topConstrainsWarningLbl.constant = isPickupDeliverySettingHide ? 12 : 65
    }
    @objc func cancelTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.backAction()
    }
    func getTimingFromApi(date: String) {
    
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "cust_lat" : "\(APPDELEGATE.selectedLocationAddress.latLong.latitude)",
            "cust_long" : "\(APPDELEGATE.selectedLocationAddress.latLong.longitude)",
            "rest_id": Cart.shared.tempRestDetails.rid,
            "order_date": date

        ]) { _, new in new }
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.restaurantTime, forModelType: RestTimingResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            self.timing = success.data.data
            self.setTimelist()
            self.dateCollection.reloadData()
            //75inch-
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
        
    }
    func setTimelist() {
        timeList = [String]()
        var tempTimeList: [String] = []
        tempTimeList = self.timing.deliveryTime
        if Cart.shared.orderType == .pickup {
            tempTimeList = self.timing.pickupTime
        }
       
        for time in tempTimeList {
            if self.orderDate == .Later {
                let d = datesList[selectedDateIndex]
                self.calculateAvailableTime(time: time, date: d.currectDateInFormate)
            } else {
                self.calculateAvailableTime(time: time, date: "\(UtilsClass.getCurrentDateInString(date: Date()))")
            }
        }
    }
    func calculateAvailableTime(time: String, date: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let time1 = formatter.date(from: UtilsClass.getCurrentTime()),
           let time2 = formatter.date(from: "\(date) \(time)") {

            if time1 < time2 {
               // print("time1\(time1) is earlier than time2\(time2)")
                timeList.append(time)
            }
        }
    }
    @IBAction func backAction() {
        self.dismiss(animated: true) {
            
        }
    }
    @IBAction func dateSubmitAction() {
        if segmentedControl.selectedSegmentIndex == 0{
            self.orderDate = .ASAP
        }
        if segmentedControl.selectedSegmentIndex == 1{
            self.orderDate = .Today
        }
        if segmentedControl.selectedSegmentIndex == 2{
            self.orderDate = .Later
        }
        if self.orderDate == .ASAP {
            //Pickup today ASAP
            //Pickup today at 6:15 pm
            //Pickup on 2, Oct at 06:30 am
            let selectedTime = SeletedTime(date: UtilsClass.getCurrentDateInString(date: Date()), time: "", heading: "\(type) today ASAP")
            //let seletedTime = SeletedTime.init(ht: "", t: "", a: "", finalTimeAndDate: UtilsClass.getCurrentDateInString(date: Date()), heading: "Pickup today ASAP")
            Cart.shared.selectedTime = selectedTime
        }
        else if self.orderDate == .Today {
            if selectedTimeIndex == -1 {
                self.showAlert(title: "Error", msg: "Please select time.")
                return
            }
            let t = timeList[selectedTimeIndex]
             let convertedTime = UtilsClass.getStringDateHHMMSS(stringTime: t)
            //let seletedTime = SeletedTime.init(ht: t.ht, t: t.t, a: t.a, finalTimeAndDate: "\(self.timing.date) \(t.ht):00", heading: "Pickup today at \(t.t) \(t.a)")
            let selectedTime = SeletedTime(date: UtilsClass.getCurrentDateInString(date: Date()), time: t, heading: "\(type) today at \(convertedTime)")
            Cart.shared.selectedTime = selectedTime
        }
        else {
            if selectedDateIndex == -1 {
                self.showAlert(title: "Error", msg: "Please select date.")
                return
            }
            if selectedTimeIndex == -1 {
                self.showAlert(title: "Error", msg: "Please select time.")
                return
            }
            let d = datesList[selectedDateIndex]
            let t = timeList[selectedTimeIndex]
            let convertedTime = UtilsClass.getStringDateHHMMSS(stringTime: t)
            let selectedTime = SeletedTime(date: d.currectDateInFormate, time: t, heading: "\(type) on \(d.day), \(d.date) at \(convertedTime)")

           // let seletedTime = SeletedTime.init(ht: t.ht, t: t.t, a: t.a, finalTimeAndDate: "\(d.currectDateInFormate) \(t.ht):00", heading: "Pickup on \(d.day) at \(t.t) \(t.a)")
        Cart.shared.selectedTime = selectedTime
        }
        Cart.shared.orderDate = self.orderDate
        self.dismiss(animated: true) {
            self.delegate?.dateChanged()
        }
    }
    @IBAction func timeBackAction() {
        timeList = [String]()
        selectedTimeIndex = -1
        selectedDateIndex = -1
        dateCollection.reloadData()
    }
    func updateUI() {
        type = Cart.shared.orderType == .delivery ? "Delivery" : "Pickup"
        warningLbl.text = "Select a \(type) time upto 18 days in advance"

        if segmentedControl.selectedSegmentIndex == 0 {
            asapView.isHidden = false
            dateCollection.isHidden = true
            dateSubmitButton.setTitle("\(type) today ASAP", for: .normal)
            dateLbl.text = UtilsClass.getTodayDateInString()
            selectTimeLbl.text = ""
            selectedTimeIndex = 0
            selectedDateIndex = 0
            selecttimeView.isHidden = true
            timeBackBtn.isHidden = true
            dateSubmitButton.backgroundColor = themeBackgrounColor
            dateSubmitButton.setTitleColor(color: .white)
        }
        else if segmentedControl.selectedSegmentIndex == 1 {
            asapView.isHidden = true
            dateCollection.isHidden = false
            var convertedTime = ""
            if selectedTimeIndex != -1 {
                convertedTime = UtilsClass.getStringDateHHMMSS(stringTime: self.timeList[selectedTimeIndex])
            }
            let str = selectedTimeIndex >= 0 ? "\(type) today at \(convertedTime)" : "\(type) today"
            dateSubmitButton.setTitle("\(str)", for: .normal)
            dateLbl.text = UtilsClass.getTodayDateInString()
            selectTimeLbl.text = "Select Time \(type)"
            selectedDateIndex = 0
            collectionTopHeight.constant = 70.0
            selecttimeView.isHidden = false
            timeBackBtn.isHidden = true
            dateSubmitButton.backgroundColor = selectedTimeIndex >= 0 ? themeBackgrounColor : .gGray100
            dateSubmitButton.setTitleColor(color: selectedTimeIndex >= 0 ? .white : themeBackgrounColor)
        }
        else {
            asapView.isHidden = true
            dateCollection.isHidden = false
            var convertedTime = ""
            if selectedTimeIndex != -1 {
                convertedTime = UtilsClass.getStringDateHHMMSS(stringTime: self.timeList[selectedTimeIndex])
            }
            let str = (selectedTimeIndex >= 0 && selectedDateIndex >= 0) ? "\(type) on \(self.datesList[selectedDateIndex].day), \(self.datesList[selectedDateIndex].date) \(convertedTime)" : "\(type)"

            dateSubmitButton.setTitle("\(str)", for: .normal)
            collectionTopHeight.constant =  selectedDateIndex >= 0 ? 70.0 : 5
            selecttimeView.isHidden = selectedDateIndex >= 0 ? false : true
            timeBackBtn.isHidden = selectedDateIndex >= 0 ? false : true
            dateLbl.text = selectedDateIndex >= 0 ? "\(self.datesList[selectedDateIndex].day), \(self.datesList[selectedDateIndex].date)" : "Select Date"
            selectTimeLbl.text = "Select Time \(type)"
            dateSubmitButton.backgroundColor = (selectedTimeIndex >= 0 && selectedDateIndex >= 0) ? themeBackgrounColor : .gGray100
            dateSubmitButton.setTitleColor(color: (selectedTimeIndex >= 0 && selectedDateIndex >= 0) ? .white : themeBackgrounColor)
        }
    }
    @objc func pickupDeliveryControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            Cart.shared.orderType = .delivery
        }
        if sender.selectedSegmentIndex == 1 {
            Cart.shared.orderType = .pickup
        }
        self.setTimelist()
        self.dateCollection.reloadData()
    }
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        timeList = [String]()
        selectedTimeIndex = -1
        selectedDateIndex = -1
        if sender.selectedSegmentIndex == 0 {
            self.orderDate = .ASAP
        }
        else if sender.selectedSegmentIndex == 1 {
            self.orderDate = .Today
            getTimingFromApi(date: UtilsClass.getCurrentDateInString(date: Date()))
        } else {
            self.orderDate = .Later
        }
        dateCollection.reloadData()
    }

}
extension ScheduleDateTimeVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = ((collectionView.frame.height) - 50) / 3
        return CGSize(width: size, height: 55)
    }
}
extension ScheduleDateTimeVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        updateUI()
        if segmentedControl.selectedSegmentIndex == 0 {
            return 0
        }
        if segmentedControl.selectedSegmentIndex == 1 {
            return timeList.count
        }
        if segmentedControl.selectedSegmentIndex == 2 {
            if selectedDateIndex >= 0 {
                return timeList.count
            }
            return self.datesList.count
        }
        return timeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if segmentedControl.selectedSegmentIndex == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCVCell", for: indexPath as IndexPath) as! TimeCVCell
            cell.backgroundColor = .white
            let timing = timeList[indexPath.row]
            let convertedTime = UtilsClass.getStringDateHHMMSS(stringTime: timing)
            cell.timeLbl.text = convertedTime//"\(timing.t) \(timing.a)"
            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 1
           // cell.layer.borderColor = UIColor.orange.cgColor
           // if selectedTimeIndex == indexPath.row {
            //    cell.backgroundColor = UIColor.gOrange100
           // }
            
            cell.timeLbl.textColor = selectedTimeIndex == indexPath.row ? .orange : .black
            cell.layer.borderColor = selectedTimeIndex == indexPath.row ? UIColor.orange.cgColor : UIColor.gGray100.cgColor
            cell.backgroundColor = UIColor.gOrange100//selectedTimeIndex == indexPath.row ? UIColor.gOrange100 : UIColor.white
            return cell;
        }
        if selectedDateIndex >= 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCVCell", for: indexPath as IndexPath) as! TimeCVCell
            cell.backgroundColor = .white
            let timing = timeList[indexPath.row]
            let convertedTime = UtilsClass.getStringDateHHMMSS(stringTime: timing)
            cell.timeLbl.text = convertedTime//"\(timing.t) \(timing.a)"
            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 1
            //cell.layer.borderColor = UIColor.orange.cgColor
//            if selectedTimeIndex == indexPath.row {
//                cell.backgroundColor = UIColor.gOrange100
//            }
            cell.timeLbl.textColor = selectedTimeIndex == indexPath.row ? .orange : .black
            cell.layer.borderColor = selectedTimeIndex == indexPath.row ? UIColor.orange.cgColor : UIColor.gGray100.cgColor
            cell.backgroundColor = UIColor.gOrange100//selectedTimeIndex == indexPath.row ? UIColor.gOrange100 : UIColor.white
            return cell;
        }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCVCell", for: indexPath as IndexPath) as! DateCVCell
            cell.backgroundColor = .white
        let d = self.datesList[indexPath.row]
        cell.dayLbl.text = d.day
        cell.dateLbl.text = d.date
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        cell.dayLbl.textColor = selectedDateIndex == indexPath.row ? .orange : .black
        cell.dateLbl.textColor = selectedDateIndex == indexPath.row ? .orange : .black

        cell.layer.borderColor = selectedDateIndex == indexPath.row ? UIColor.orange.cgColor : UIColor.gGray100.cgColor
        cell.backgroundColor = UIColor.gOrange100//selectedDateIndex == indexPath.row ? UIColor.gOrange100 : UIColor.white
            return cell;
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 1 {
            selectedTimeIndex = indexPath.row
        }
        else if segmentedControl.selectedSegmentIndex == 2 {
            if selectedDateIndex >= 0 {
                selectedTimeIndex = indexPath.row
            }else {
                selectedDateIndex = indexPath.row
                let d = self.datesList[indexPath.row]
                self.getTimingFromApi(date: d.currectDateInFormate)
            }
        }

        collectionView.reloadData()
    }
    
    
    
    
}
