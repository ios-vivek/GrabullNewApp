//
//  TabBarVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 09/08/24.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let dashboard = UIStoryboard(name: "DashBoard", bundle: nil)
        let mainS = UIStoryboard(name: "Main", bundle: nil)
        let search = UIStoryboard(name: "FoodSearch", bundle: nil)
        let history = UIStoryboard(name: "History", bundle: nil)
        let profile = UIStoryboard(name: "Profile", bundle: nil)
        
        let dashBoardVC = dashboard.instantiateViewController(withIdentifier: "DashBoardVC") as! DashBoardVC
        let restaurantVC = mainS.instantiateViewController(withIdentifier: "RestaurantVC") as! RestaurantVC
        let foodSearchVC = search.instantiateViewController(withIdentifier: "FoodSearchVC") as! FoodSearchVC

        let historyVC = history.instantiateViewController(withIdentifier: "HistoryHomeVC") as! HistoryHomeVC
        let profileVC = profile.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC

       // let dashBoardVCNav = UINavigationController(rootViewController: dashBoardVC)
        dashBoardVC.title = "Food"
       // dashBoardVCNav.isNavigationBarHidden = true
        dashBoardVC.tabBarItem.image = UIImage(named: "Food")
        
      //  let restaurantVCNav = UINavigationController(rootViewController: restaurantVC)
        restaurantVC.title = "Home"
        restaurantVC.tabBarItem.image = UIImage(named: "home")
       // restaurantVCNav.isNavigationBarHidden = true
        
        //  let foodSearchVCNav = UINavigationController(rootViewController: foodSearchVC)
        foodSearchVC.title = "Search"
        foodSearchVC.tabBarItem.image = UIImage(named: "search")
         // foodSearchVCNav.isNavigationBarHidden = true
        
       // let historyVCNav = UINavigationController(rootViewController: historyVC)
        historyVC.title = "History"
       // historyVC.isNavigationBarHidden = true
        historyVC.tabBarItem.image = UIImage(named: "history")
        
       // let profileVCNav = UINavigationController(rootViewController: profileVC)
        profileVC.title = "Profile"
       // profileVCNav.isNavigationBarHidden = true
        profileVC.tabBarItem.image = UIImage(named: "profileIcon")
               //navigationController.tabBarItem.image = UIImage.init(named: "map-icon-1")
        
        self.tabBar.tintColor = themeBackgrounColor
        self.tabBar.backgroundColor = kGrayColor
       // self.tabBarItem.item = UIImage(named: "profileIcon24")

              viewControllers = [dashBoardVC, restaurantVC, foodSearchVC, historyVC, profileVC]
        NotificationCenter.default.addObserver(self, selector: #selector(self.notification(notification:)), name: Notification.Name("notification"), object: nil)



    }
    @objc func notification(notification: Notification) {
        if !APPDELEGATE.notificationType.isEmpty {
            navigateToPage(named: APPDELEGATE.notificationType)
            //APPDELEGATE.notificationType = ""
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !APPDELEGATE.notificationType.isEmpty {
            navigateToPage(named: APPDELEGATE.notificationType)
            //APPDELEGATE.notificationType = ""
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("tab viewWillAppear")
    }
    func navigateToPage(named pageName: String) {
//        guard let windowScene = UIApplication.shared.connectedScenes
//                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
//              let window = windowScene.windows.first(where: { $0.isKeyWindow }),
//              let rootVC = window.rootViewController else {
//            print("rootVC not found")
//            return
//        }
        switch pageName {
        case NotificationType.Offer.rawValue:
           // if let tabBarController = findTabBarController(from: rootVC), tabBarController.viewControllers?.count ?? 0 > 4 {
                self.selectedIndex = 4
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushnotificationaccount"),
                                                    object: nil,
                                                    userInfo: nil)
            //    }
            }
        case NotificationType.OnGoingOrder.rawValue, NotificationType.UpcomingOrder.rawValue, NotificationType.PastHistory.rawValue, NotificationType.DineIn.rawValue:
           // if let tabBarController = findTabBarController(from: rootVC), let vcs = tabBarController.viewControllers, vcs.count > 3 {
                self.selectedIndex = 3
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushnotification"),
                                                    object: nil,
                                                    userInfo: nil)
                }
            //}
        default:
            //if let tabBarController = findTabBarController(from: rootVC), tabBarController.viewControllers?.count ?? 0 > 2 {
                self.selectedIndex = 1
           // }
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
