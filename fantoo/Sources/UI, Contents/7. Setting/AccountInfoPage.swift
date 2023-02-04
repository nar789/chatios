//
//  AccountInfoPage.swift
//  fantoo
//
//  Created by fns on 2022/05/25.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import PopupView

struct AccountInfoPage: View {
    @StateObject var languageManager = LanguageManager.shared
    @State var leftItems: [CustomNavigationBarButtonType] = []
    @State var rightItems: [CustomNavigationBarButtonType] = [.UnLike]
    @State private var showAccountDetailPage = false
    @State private var showPasswordChangePage = false
    @State private var showLogoutPage = false
    @State private var showServiceWithdrawPage = false
    
    var body: some View {
        ZStack(alignment: .top) {
            if UserManager.shared.loginType == DefineKey.email {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        SettingListLinkView(text:  "g_join_account".localized, subText: "", lang: "", type: .ClickAccount, showLine: true, onPress: {
                            showAccountDetailPage = true
                        })
                        SettingListLinkView(text:  "b_change_password".localized, subText: "", lang: "", type: .ClickAllWithArrow, showLine: true, onPress: {
                            showPasswordChangePage = true
                        })
                            .background(
                                NavigationLink("", isActive: $showPasswordChangePage) {
                                    PasswordChangePage()
                                }.hidden()
                            )
                        SettingListLinkView(text:  "r_logout".localized, subText: "", lang: "", type: .ClickAllWithArrow, showLine: true, onPress: {
                            showLogoutPage = true
                        })
                        SettingListLinkView(text:  "s_leave".localized, subText: "", lang: "", type: .ClickAllWithArrow, showLine: true, onPress: {
                            showServiceWithdrawPage = true
                        })
                            .background(
                                NavigationLink("", isActive: $showServiceWithdrawPage) {
                                    ServiceWithdrawPage()
                                }.hidden()
                            )
                    }
                }
            }
            else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        SettingListLinkView(text:  "g_join_account".localized, subText: "", lang: "", type: .ClickAccount, showLine: true, onPress: {
                            showAccountDetailPage = true
                        })
                        SettingListLinkView(text:  "r_logout".localized, subText: "", lang: "", type: .ClickAllWithArrow, showLine: true, onPress: {
                            showLogoutPage = true
                        })
                        SettingListLinkView(text:  "s_leave".localized, subText: "", lang: "", type: .ClickAllWithArrow, showLine: true, onPress: {
                            showServiceWithdrawPage = true
                        })
                            .background(
                                NavigationLink("", isActive: $showServiceWithdrawPage) {
                                    ServiceWithdrawPage()
                                }.hidden()
                            )
                    }
                }
            }
        }
        .modifier(ScrollViewLazyVStackModifier())
        
        
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "g_account_info".localized, onPress: { buttonType in
            print("onPress buttonType : \(buttonType)")
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
        .showAlert(isPresented: $showLogoutPage, type: .Default, title: "", message: "se_r_question_login".localized, detailMessage: "", buttons: ["a_no".localized, "h_confirm".localized], onClick: { buttonIndex in
            if buttonIndex == 1 {
                UserManager.shared.logout()
            }
        })
    }
}

struct AccountInfoPage_Previews: PreviewProvider {
    static var previews: some View {
        AccountInfoPage()
    }
}

