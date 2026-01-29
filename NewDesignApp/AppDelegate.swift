//
//  AppDelegate.swift
//  NewDesignApp
// https://www.grabull.com/web-api/
//pass - admin / api_gb@2019


//  Created by Vivek SIngh on 09/08/24.
//https://www.webapi.grabulldemo.com/
//adminGD/api_gd@2020
//https://lottiefiles.com/blog/working-with-lottie-animations/how-to-add-lottie-animation-ios-app-swift/
import UIKit
import CoreLocation
import IQKeyboardManagerSwift
import UserNotifications

let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    var applicationActive: Bool = false
    var gotLocation: Bool = false
    var timr=Timer()


    var userResponse: UserResponse?

    var selectedLocationAddress = LocationAddress()
    var cusines: CuisineResponse?
    var deviceToken = ""
    var notificationType: String = ""
     //  var notificationSubType: String = ""


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       // IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.resignOnTouchOutside = true

        setupLoactionManager()
        UtilsClass.getuserDetails()
        UtilsClass.getCousines()

        // Push Notification setup
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
        
        return true
    }
    func userLoggedIn()-> Bool {
        guard APPDELEGATE.userResponse != nil else {
            return false
        }
        return true
    }
    func getCousins()-> [Cuisine] {
        guard let user = APPDELEGATE.cusines else {
            return [Cuisine]()
        }
        return user.data.cuisine
    }
    func getCoupons()-> [Coupon] {
        guard let user = APPDELEGATE.cusines else {
            return [Coupon]()
        }
        return user.data.coupon
    }
    func getSlider()-> [RestSlider] {
        guard let user = APPDELEGATE.cusines else {
            return [RestSlider]()
        }
        return user.data.slider
    }
    func getBanner()-> String {
        guard let user = APPDELEGATE.cusines else {
            return ""
        }
        return user.data.banner
    }
    func getCusineheading()-> String {
        guard let user = APPDELEGATE.cusines else {
            return ""
        }
        return user.data.cuisineHeading
    }
    func getAppVersion()-> String {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return appVersion
        }
        return ""
    }
    func getMobileInfo()-> String {
        let systemName = UIDevice.current.systemName   // iOS
        let systemVersion = UIDevice.current.systemVersion
        print("\(systemName), Version\(systemVersion), \(UIDevice.modelIdentifier)")
        return ("\(systemName), Version\(systemVersion), \(UIDevice.modelIdentifier)")
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func setupLoactionManager() {
        locationManager.requestWhenInUseAuthorization();
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        else{
            print("Location service disabled");
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if (gotLocation == false){
            gotLocation = true
            UtilsClass.getAddressFromLoaction(userLocation: locations[0] as CLLocation) { (userAddress) in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "location"), object: nil)
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Location manager failed with error = \(error.localizedDescription)")
        if !applicationActive{
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            self.applicationActive = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "errorlocation"), object: nil)

        }
        }
    }

    // MARK: Push Notification Delegates
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        // Send token to server if needed
        APPDELEGATE.deviceToken = token
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // Handle notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)

        APPDELEGATE.notificationType = ""
       // APPDELEGATE.notificationSubType = ""

        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler()
            return
        }

        // 🔹 Get category directly
        if let category = aps["category"] as? String {
            APPDELEGATE.notificationType = category
            if category == NotificationType.Offer.rawValue {
                saveNotification(userInfo: userInfo)
            }
            DispatchQueue.main.async {
                //self.navigateToPage(named: category)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notification"),
                                                object: nil,
                                                userInfo: nil)
            }
        }
/*
        // 🔹 Get subtype if present
        if let alert = aps["alert"] as? [String: AnyObject],
           let valuesubtype = alert["subtype"] as? String {
            APPDELEGATE.notificationSubType = valuesubtype
        }
*/
        UNUserNotificationCenter.current().setBadgeCount(0)
        completionHandler()
    }
    /*
    // Navigation helper
    func navigateToPage(named pageName: String) {
        guard let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }),
              let rootVC = window.rootViewController else {
            print("rootVC not found")
            return
        }
        switch pageName {
        case NotificationType.Offer.rawValue:
            if let tabBarController = findTabBarController(from: rootVC), tabBarController.viewControllers?.count ?? 0 > 4 {
                tabBarController.selectedIndex = 4
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushnotificationaccount"),
                                                    object: nil,
                                                    userInfo: nil)
                }
            }
        case NotificationType.OnGoingOrder.rawValue, NotificationType.UpcomingOrder.rawValue, NotificationType.PastHistory.rawValue, NotificationType.DineIn.rawValue:
            if let tabBarController = findTabBarController(from: rootVC), let vcs = tabBarController.viewControllers, vcs.count > 3 {
                tabBarController.selectedIndex = 3
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushnotification"),
                                                    object: nil,
                                                    userInfo: nil)
                }
            }
        default:
            if let tabBarController = findTabBarController(from: rootVC), tabBarController.viewControllers?.count ?? 0 > 2 {
                tabBarController.selectedIndex = 1
            }
        }
        
    }
    */
    // Helper to recursively find UITabBarController
    func findTabBarController(from vc: UIViewController) -> UITabBarController? {
        if let tabBar = vc as? UITabBarController {
            return tabBar
        }
        if let nav = vc as? UINavigationController {
            for child in nav.viewControllers {
                if let tabBar = findTabBarController(from: child) {
                    return tabBar
                }
            }
        }
        if let presented = vc.presentedViewController {
            return findTabBarController(from: presented)
        }
        return nil
    }
    func saveNotification(userInfo: [AnyHashable: Any]) {
        guard let aps = userInfo["aps"] as? [String: Any],
              let alert = aps["alert"] as? [String: Any],
              let title = alert["title"] as? String,
              let body = alert["body"] as? String,
              let category = aps["category"] as? String,
              let restid = userInfo["restid"] as? String else {
            return
        }

        // Create Model
        let newNotification = NotiFicationModel(body: body,
                                                title: title,
                                                category: category,
                                                restid: restid)

        // Get existing list
        var notifications = getNotifications()
        // Append new one
        notifications.append(newNotification)

        // Save back to UserDefaults
        if let data = try? JSONEncoder().encode(notifications) {
            UserDefaults.standard.set(data, forKey: "notifications")
        }
    }
    func getNotifications() -> [NotiFicationModel] {
        if let data = UserDefaults.standard.data(forKey: "notifications"),
           let notifications = try? JSONDecoder().decode([NotiFicationModel].self, from: data) {
            return notifications
        }
        return []
    }
    
    func clearNotifications() {
        UserDefaults.standard.removeObject(forKey: "notifications")
    }
    
}

extension UIViewController: @retroactive UIGestureRecognizerDelegate {
    public func setDefaultBack() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
    }
}
extension UIApplication {
    class func topViewController(
        _ controller: UIViewController? =
            UIApplication.shared.connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                .first?.rootViewController
    ) -> UIViewController? {
        
        if let nav = controller as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = controller as? UITabBarController {
            return topViewController(tab.selectedViewController)
        }
        if let presented = controller?.presentedViewController {
            return topViewController(presented)
        }
        return controller
    }
}

import UIKit
extension UIDevice {
    static var modelIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)

        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }
    
    static var modelName: String {
        let identifier = modelIdentifier

        switch identifier {

        // iPhone
        case "iPhone14,7": return "iPhone 14"
        case "iPhone14,8": return "iPhone 14 Plus"
        case "iPhone15,2": return "iPhone 14 Pro"
        case "iPhone15,3": return "iPhone 14 Pro Max"

        case "iPhone15,4": return "iPhone 15"
        case "iPhone15,5": return "iPhone 15 Plus"
        case "iPhone16,1": return "iPhone 15 Pro"
        case "iPhone16,2": return "iPhone 15 Pro Max"

        // Simulator
        case "i386", "x86_64", "arm64":
            return "Simulator (\(ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "Unknown"))"

        default:
            return identifier
        }
    }
}

