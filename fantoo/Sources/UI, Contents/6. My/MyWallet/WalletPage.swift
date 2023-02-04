//
//  WalletPage.swift
//  fantoo
//
//  Created by fns on 2022/06/02.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct WalletPage: View {
    @StateObject var languageManager = LanguageManager.shared
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer().frame(height: 50)
                WalletDetailView()
            }
        }
        .background(Color.bgLightGray50)
        .edgesIgnoringSafeArea(.bottom)
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "n_my_wallet".localized, onPress: { buttonType in
            print("onPress buttonType : \(buttonType)")
        })
        .navigationBarBackground {
            Color.bgLightGray50.shadow(radius: 0)
        }
        .statusBarStyle(style: .darkContent)
    }
}

struct WalletPage_Previews: PreviewProvider {
    static var previews: some View {
        WalletPage()
    }
}
