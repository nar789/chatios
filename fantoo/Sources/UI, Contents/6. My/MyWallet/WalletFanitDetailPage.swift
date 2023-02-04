//
//  WalletFanitDetailPage.swift
//  fantoo
//
//  Created by fns on 2022/06/07.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct WalletFanitDetailPage: View {
    @StateObject var languageManager = LanguageManager.shared
    var body: some View {
        GeometryReader { geometry in
            VStack {
            Spacer().frame(height: 30)
            WalletDetailView()
            }
        }
        .background(Color.bgLightGray50)
        
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "g_coffer".localized, onPress: { buttonType in
            print("onPress buttonType : \(buttonType)")
        })
        .navigationBarBackground {
            Color.bgLightGray50.shadow(radius: 0)
        }
        .statusBarStyle(style: .darkContent)
    }
}

struct WalletFanitDetailPage_Previews: PreviewProvider {
    static var previews: some View {
        WalletFanitDetailPage()
    }
}

