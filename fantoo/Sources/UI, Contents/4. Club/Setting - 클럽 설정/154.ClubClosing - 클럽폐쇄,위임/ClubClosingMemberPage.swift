//
//  ClubClosingMemberPage.swift
//  fantoo
//
//  Created by fns on 2022/08/30.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct ClubClosingMemberPage: View {
    @StateObject var languageManager = LanguageManager.shared
    
    private struct sizeInfo {
        static let tabViewHeight: CGFloat = 40.0
        static let padding: CGFloat = 10.0
        static let padding5: CGFloat = 5.0
    }
    
    @Binding var clubId: String
    
    @State var currentTab: Int = 0
    @State var isShowSearchBar: Bool = false
    @State var isShowClosingInfo: Bool = false
    @State var cancelSearch: Bool = false
    @State var leftItems: [CustomNavigationBarButtonType] = [.Back]
    @State var rightItems: [CustomNavigationBarButtonType] = [.Search]
    @State var searchText: String = ""
    
    var body: some View {
        ZStack(alignment: .top) {
            TabView(selection: self.$currentTab, content: {
                ClubClosingAllMemberPage(searchText: searchText, memberState: $cancelSearch, clubId: $clubId).tag(0)
                ForcedWithdrawalMemberView(searchText: searchText, memberState: $cancelSearch, clubId: $clubId).tag(1)
            })
                .tabViewStyle(.page(indexDisplayMode: .never))
                .edgesIgnoringSafeArea(.all)
                .padding(.top, sizeInfo.tabViewHeight)
            CustomTabView(currentTab: $currentTab, style: .UnderLine, titles: ["j_all_members".localized, "g_member_forced_to_leave".localized], height: sizeInfo.tabViewHeight)
        }
        .onAppear(perform: {
            isShowClosingInfo = true
        })
        .showAlert(isPresented: $isShowClosingInfo, type: .Default, title: "k_club_closure_and_delegating_guide".localized, message: "se_h_club_member_two_more_can_delegating".localized, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
            
        })
        .background(Color.gray25)
        .navigationType(leftItems: leftItems, rightItems: rightItems, isShowSearchBar: isShowSearchBar, searchText: $searchText, placeholder: "m_search_member_nickname".localized, leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "m_show_member".localized, onPress: { buttonType in
            if buttonType == .Search {
                isShowSearchBar = true
                cancelSearch = false
            }
            else if buttonType == .Cancel {
                isShowSearchBar = false
                cancelSearch = true
                searchText = ""
            }
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }
}
