//
//  MyStoragePage.swift
//  fantoo
//
//  Created by mkapps on 2022/05/21.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct MyStoragePage: View {
    
    private struct sizeInfo {
        static let tabViewHeight: CGFloat = 40.0
        static let padding: CGFloat = 10.0
        static let padding5: CGFloat = 5.0
    }
    
    @State var currentTab: Int = 0
    @Binding var settingTab: Int
    
    var body: some View {
        ZStack(alignment: .top) {
            TabView(selection: self.$currentTab, content: {
                MyStorageSortCommunityView(currentTab: $settingTab).tag(0)
                MyStorageSortClubView(currentTab: $settingTab).tag(1)
            })
                .tabViewStyle(.page(indexDisplayMode: .never))
                .edgesIgnoringSafeArea(.all)
                .padding(.top, sizeInfo.tabViewHeight)
            CustomTabView(currentTab: $currentTab, style: .UnderLine, titles: ["k_community".localized, "k_club".localized], height: sizeInfo.tabViewHeight)
        }
        .onAppear(perform: {
        })
        .background(Color.gray25)
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "b_storage".localized, onPress: { buttonType in
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }
}


//struct MyStoragePage_Previews: PreviewProvider {
//    static var previews: some View {
//        MyStoragePage()
//    }
//}
