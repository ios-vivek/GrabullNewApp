//
//  DineInReservationVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 05/03/25.
//

import UIKit
import WebKit
//https://www.storemanage.grabulldirect.com/secure-account/home/
class DineInReservationVC: UIViewController, WKNavigationDelegate, UIWebViewDelegate {
  
    @IBOutlet var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.backgroundColor = .white
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // UtilsClass.showProgressHud(view: self.view)
        let url = URL(string: "https://www.menu-widget.grabulldirect.com/reservation/test-store-gb-pay-monthly-36-commerce-way-woburn-ma")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        //self.loadJson(filename: "test")
    }
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    func loadJson(filename fileName: String) -> [Person]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                print("success:\(jsonData)")
                return jsonData.person
            } catch {
                print("error:\(error)")
            }
        }
        return nil
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
struct ResponseData: Decodable {
    var person: [Person]
}
struct Person: Decodable {
    var name: String?
    var ageType: String?
    var employed: String
}
