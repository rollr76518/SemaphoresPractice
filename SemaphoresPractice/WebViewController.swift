//
//  webViewController.swift
//  PinkoiApp
//
//  Created by Hanyu on 2020/3/25.
//  Copyright © 2020 Pinkoi. All rights reserved.
//

import UIKit
import WebKit

protocol WebViewControllerDelegate: AnyObject {
	
	func webViewControllerViewDidAppear(_ webViewController: WebViewController)
	func webViewController(_ webViewController: WebViewController, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
}

class WebViewController: UIViewController {
	
	weak var delegate: WebViewControllerDelegate?
	
	private let configuration: WKWebViewConfiguration
	private lazy var webView = makeWebView()
	
	//For tracking.
	let identifier: String
	
	init(configuration: WKWebViewConfiguration = WKWebViewConfiguration(), identifier: String) {
		self.configuration = configuration
		self.identifier = identifier
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		view = webView
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		delegate?.webViewControllerViewDidAppear(self)
	}
}

// MARK: - Adapter for webview func

extension WebViewController {
	
	@discardableResult
	func load(_ request: URLRequest) -> WKNavigation? {
		return webView.load(request)
	}
	
	func loadFileURL(_ URL: URL, allowingReadAccessTo readAccessURL: URL) -> WKNavigation? {
		return webView.loadFileURL(URL, allowingReadAccessTo: readAccessURL)
	}
	
	func loadHTMLString(_ string: String, baseURL: URL?) -> WKNavigation? {
		return webView.loadHTMLString(string, baseURL: baseURL)
	}
	
	func load(_ data: Data, mimeType MIMEType: String, characterEncodingName: String, baseURL: URL) -> WKNavigation? {
		return webView.load(data, mimeType: MIMEType, characterEncodingName: characterEncodingName, baseURL: baseURL)
	}
}

// MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		guard let delegate = delegate else {
			decisionHandler(.allow)
			return
		}
		delegate.webViewController(self, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
	}
}

// MARK: - Lazy Initialization

extension WebViewController {
	
	fileprivate func makeWebView() -> WKWebView {
		let webView = WKWebView(frame: .zero, configuration: configuration)
		webView.navigationDelegate = self
		return webView
	}
}
