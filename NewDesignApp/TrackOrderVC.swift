//
//  TrackOrderVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 03/06/25.
//

import UIKit
import WebKit


class TrackOrderVC: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var trackURL = ""
    override func viewDidLoad() {
        super.viewDidLoad()

//        webView = WKWebView()
//           webView.navigationDelegate = self
//        webView.frame
        
        
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        if let webView = webView {
           view.addSubview(webView)
           webView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
              webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
              webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
              webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
           ])
        }
        if !trackURL.isEmpty {
            let url = URL(string: trackURL)!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
       
    }
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
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
