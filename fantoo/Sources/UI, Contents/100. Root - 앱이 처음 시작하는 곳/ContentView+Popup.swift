//
//  ContentView+Popup.swift
//  fantoo
//
//  Created by mkapps on 2022/10/06.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct ContentViewPopup: ViewModifier {
    
    @StateObject var userManager = UserManager.shared
    @StateObject var moreManager = MoreManager.shared
    
    func body(content: Content) -> some View {
        content
            .bottomSheet(
                isPresented: $moreManager.show.bottomSheet,
                height: 500,
                topBarCornerRadius: DefineSize.CornerRadius.BottomSheet,
                content: {
                    HomePageBottomView(
                        title: "123",
                        type: HomePageBottomType.SubHomeItemMore,
                        onPressItemMore: { buttonType in
                            print("\n--- \(buttonType) ---\n")
                        },
                        onPressGlobalLan: {_ in },
                        selectedTitle: .constant("123"),
                        isShow: $moreManager.show.bottomSheet
                    )
                })
    }
}
