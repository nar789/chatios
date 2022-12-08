//
//  CustomWebPage.swift
//  fantoo
//
//  Created by Benoit Lee on 2022/07/15.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct WebPage: View {
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        
        static let tabViewHeight: CGFloat = 40.0
    }
    
    var url: String
    var title: String
    
    var body: some View {
        VStack(spacing: 0) {
            WebView(url: URL(string: url)!)
        }
        
        .edgesIgnoringSafeArea(.bottom)
        
        .background(Color.gray25)
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: title, onPress: { buttonType in
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }
}
