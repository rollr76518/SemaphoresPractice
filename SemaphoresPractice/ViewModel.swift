//
//  ViewModel.swift
//  SemaphoresPractice
//
//  Created by Ryan on 2020/4/7.
//  Copyright © 2020 Hanyu. All rights reserved.
//

import Foundation
import WebKit

class ViewModel {
	
	func countOfTypes() -> Int {
		return PageType.allCases.count
	}
	
	func pageURLOfIndex(_ index: Int) -> URL {
		guard let pageType = PageType(rawValue: index) else {
			fatalError("Can not init a PageType")
		}
		guard let url = pageType.url else {
			fatalError("Can not init a URL with PageType")
		}
		return url
	}
	
	func pageTitleOfIndex(_ index: Int) -> String {
		guard let pageType = PageType(rawValue: index) else {
			fatalError("Can not init a PageType")
		}
		return "\(pageType)"
	}
	
	func identifierOfIndex(_ index: Int) -> String {
		guard let pageType = PageType(rawValue: index) else {
			fatalError("Can not init a PageType")
		}
		return pageType.screenName
	}
}

fileprivate enum PageType: Int, CaseIterable, CustomStringConvertible {
	
	case left = 0
	case right = 1
	
	var description: String {
		switch self {
		case .left:
			return "Left"
		case .right:
			return "Right"
		}
	}
}

fileprivate extension PageType {
	
	var url: URL? {
		switch self {
		case .left:
			var urlCompenent = URLComponents(url: Bundle.main.url(forResource: "demo", withExtension: "html")!, resolvingAgainstBaseURL: false)
			urlCompenent?.queryItems = [URLQueryItem(name: "tab", value: "1")]
			return urlCompenent?.url?.absoluteURL
		case .right:
			var urlCompenent = URLComponents(url: Bundle.main.url(forResource: "demo", withExtension: "html")!, resolvingAgainstBaseURL: true)
			urlCompenent?.queryItems = [URLQueryItem(name: "tab", value: "2")]
			return urlCompenent?.url?.absoluteURL
		}
	}
}

fileprivate extension PageType {
	
	var screenName: String {
		switch self {
		case .left:
			return "left"
		case .right:
			return "right"
		}
	}
}

//此字串與 Web 共同定義，若修改則會發生無法接到 event 的情況。 
enum WebScriptListener: String, RawRepresentable {
	case logEvent
}

// MARK: - Track

extension ViewModel {
	
	func setScreenName(_ screenName: String) {
		print("send setScreenName event: \(screenName)")
	}
	
	func handleScriptMessage(_ message: WKScriptMessage) {
		guard let listener = WebScriptListener(rawValue: message.name) else {
			return //若進來則為非定義好的 name。
		}
		switch listener {
		case .logEvent:
			guard
				let screenName = message.body as? String
				else {
					return
			}
			print("load page of screenName:\(screenName)")
		}
	}
