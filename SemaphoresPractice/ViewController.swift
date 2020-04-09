//
//  ViewController.swift
//  SemaphoresPractice
//
//  Created by Ryan on 2020/4/7.
//  Copyright © 2020 Hanyu. All rights reserved.
//

import UIKit
import Parchment
import WebKit

class ViewController: UIViewController {
	
	fileprivate lazy var viewModel = makeViewModel()
	fileprivate lazy var pagingViewController = makePagingViewController()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		addChild(pagingViewController)
		view.addSubview(pagingViewController.view)
		pagingViewController.didMove(toParent: self)
		NSLayoutConstraint.activate([
			pagingViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
	}
}

extension ViewController {
	
	fileprivate func makeViewModel() -> ViewModel {
		let vm = ViewModel()
		return vm
	}
	
	fileprivate func makePagingViewController() -> PagingViewController {
		let vc = PagingViewController()
		vc.view.translatesAutoresizingMaskIntoConstraints = false
		vc.dataSource = self
		vc.menuBackgroundColor = .white
		vc.textColor = .blue
		vc.selectedTextColor = .blue
		vc.indicatorColor = .blue
		vc.font = .boldSystemFont(ofSize: 15)
		vc.selectedFont = .boldSystemFont(ofSize: 15)
		vc.borderColor = .clear
		vc.indicatorOptions = .visible(height: 3, zIndex: Int.max, spacing: .zero, insets: .zero)
		vc.borderOptions = .visible(height: 1, zIndex: Int.max - 1, insets: .zero)
		return vc
	}
	
	fileprivate func makeWebViewController(url: URL, identifier: String) -> WebViewController {
		let config = WKWebViewConfiguration()
		config.userContentController.add(self, name: WebScriptListener.logEvent.rawValue)
		let vc = WebViewController(configuration: config, identifier: identifier)
		let request = URLRequest(url: url)
		vc.load(request)
		vc.delegate = self
		return vc
	}
}

// MARK: - PagingViewControllerDataSource

extension ViewController: PagingViewControllerDataSource {
	
	func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
		return viewModel.countOfTypes()
	}
	
	func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
		let url = viewModel.pageURLOfIndex(index)
		let identifier = viewModel.identifierOfIndex(index)
		return makeWebViewController(url: url, identifier: identifier)
	}
	
	func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
		let title = viewModel.pageTitleOfIndex(index)
		return PagingIndexItem(index: index, title: title)
	}
}

extension ViewController: WKScriptMessageHandler {
	
	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		viewModel.handleScriptMessage(message)
	}
}

extension ViewController: WebViewControllerDelegate {
	
	func webViewControllerViewDidAppear(_ webViewController: WebViewController) {
		viewModel.setScreenName(webViewController.identifier)
	}
	
	func webViewController(_ webViewController: WebViewController, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		decisionHandler(.allow)
	}
}
