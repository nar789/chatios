//
//  WebView.swift
//  fantoo
//
//  Created by Benoit Lee on 2022/07/21.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import UIKit
import SwiftUI
import Combine
import WebKit

struct WebView: UIViewRepresentable {
    
    let url: URL
    
    func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
        let webview = WKWebView()
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webview.load(request)
        return webview
    }
    
    func updateUIView(_ webview: WKWebView, context: UIViewRepresentableContext<WebView>) {
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webview.load(request)
    }
}
