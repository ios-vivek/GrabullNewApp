//
//  WorkWithUsVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 20/08/25.
//

import UIKit
import WebKit

class WorkWithUsVC: UIViewController , WKNavigationDelegate {
	var webView: WKWebView!
	var trackURL = "https://www.grabull.com/web-api-ios/work-with-us/?customer_id=\(APPDELEGATE.userResponse?.customer.customerId ?? "")"
	override func viewDidLoad() {
		super.viewDidLoad()

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
		   webView.navigationDelegate = self
		   webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
		}
		
		let url = URL(string: trackURL)!
		UtilsClass.showProgressHud(view: self.view)
		webView.load(URLRequest(url: url))
		webView.allowsBackForwardNavigationGestures = true
	}
	@IBAction func backAction() {
		self.navigationController?.popViewController(animated: true)
	}
	
	deinit {
		if webView != nil {
			webView.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
		}
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress" {
			if webView.estimatedProgress >= 1.0 {
				DispatchQueue.main.async {
					UtilsClass.hideProgressHud(view: self.view)
				}
			}
		}
	}
	
	// MARK: - WKNavigationDelegate
	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		UtilsClass.showProgressHud(view: self.view)
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		DispatchQueue.main.async {
			UtilsClass.hideProgressHud(view: self.view)
		}
	}
	
	func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
		DispatchQueue.main.async {
			UtilsClass.hideProgressHud(view: self.view)
		}
	}
	
	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		DispatchQueue.main.async {
			UtilsClass.hideProgressHud(view: self.view)
		}
	}

}
