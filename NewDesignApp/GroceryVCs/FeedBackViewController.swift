//
//  FeedBackViewController.swift
//  NewDesignApp
//

import UIKit
import WebKit

final class FeedBackViewController: UIViewController {
    private let htmlString: String
    private let webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        return WKWebView(frame: .zero, configuration: configuration)
    }()

    init(htmlString: String) {
        self.htmlString = htmlString
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Feedback"
        view.backgroundColor = .white

        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .white
        webView.isOpaque = true
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(closeFeedback)
        )

        webView.loadHTMLString(htmlString, baseURL: URL(string: "https://grabull.com"))
    }

    @objc private func closeFeedback() {
        navigationController?.dismiss(animated: true)
    }
}
