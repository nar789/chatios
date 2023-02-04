//
//  WalletWithdrawPage.swift
//  fantoo
//
//  Created by fns on 2022/06/02.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct WalletWithdrawPage : View {
    @StateObject var languageManager = LanguageManager.shared
    var body: some View {
        VStack {
            WalletWithdrawNumberKeyPadView()
    }
        .navigationType(leftItems: [.Close], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "", onPress: { buttonType in
            print("onPress buttonType : \(buttonType)")
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }

}

struct WalletWithdrawPage_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            WalletWithdrawPage()
        }
    }
}

