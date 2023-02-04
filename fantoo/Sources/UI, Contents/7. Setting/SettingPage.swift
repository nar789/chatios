//
//  SettingView.swift
//  fantoo
//
//  Created by fns on 2022/05/15.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import BottomSheet

struct SettingPage: View {
    
    @Environment(\.openURL) private var openURL
    @StateObject var languageManager = LanguageManager.shared
    
    @State var showList = false
    @State var leftItems: [CustomNavigationBarButtonType] = []
    @State var rightItems: [CustomNavigationBarButtonType] = [.UnLike]
    @State private var shouldShowSetting = false
    @State private var showAccontPage = false
    
    @State private var showTransPage = false
    @State private var showPushAlarmPage = false
    @State private var showMarketingPage = false
    
    @State private var showVersionPage = false
    @State private var showNoticePage = false
    @State private var showEmailInquiryPage = false
    
    @State private var showServiceTermsPage = false
    @State private var showPersonalTermPage = false
    @State private var showYouthProtectionPage = false
    
    @State private var showAlert: Bool = false
    @State private var showAgreeAlert: Bool = false
    
    @StateObject var vm = BSLanguageViewModel()
    
    @AppStorage("toggleIsOn") var toggleIsOn = false
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let cellHeight: CGFloat = 50.0
        static let cellLeadingPadding: CGFloat = 16.0
        static let cellBottomPadding: CGFloat = 5.0
        static let cellTrailingPadding: CGFloat = 16.0
        static let cellTopPadding: CGFloat = 20.0
        static let iconSize: CGSize = CGSize(width: 17, height: 16)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    SettingListLinkView(text:  "g_account_info".localized, subText: "", lang: "", type: .ClickAllWithArrow, showLine: true, onPress: {
                        showAccontPage = true
                    })
                        .background(
                            NavigationLink("", isActive: $showAccontPage) {
                                AccountInfoPage()
                            }.hidden()
                        )
                    
                    Text("s_setting_service".localized)
                        .font(Font.body21420Regular)
                        .foregroundColor(Color.primary500)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: sizeInfo.cellTopPadding, leading: sizeInfo.cellLeadingPadding, bottom: sizeInfo.cellBottomPadding, trailing: 0))
                    
                    VStack(spacing: 0) {
                        SettingListLinkView(text: "b_select_trans_language".localized, subText: "", lang: languageManager.languageName, type: .ClickLanguage, showLine: true, onPress: {
                            BottomSheetManager.shared.show.language = true
                            BottomSheetManager.shared.customBottomSheetClickType = .Language
//                            showTransPage = true
                        })
                        SettingListLinkView(text: "p_setting_push_alarm".localized, subText: "", lang: "", type: .ClickAllWithArrow, showLine: true, onPress: {
                            showPushAlarmPage = true
                        })
                            .background(
                                NavigationLink("", isActive: $showPushAlarmPage) {
                                    PushAlarmPage()
                                }.hidden()
                            )
                        
                        SettingListToggleLinkView(text: "m_agree_marketing_recieved".localized, subText: "", showLine: true, toggleIsOn: $toggleIsOn) {
                            
                        }
                        .onChange(of: toggleIsOn) { value in
                            print(value)
                            if value {
                                showAlert = true
                            }
                            else {
                                showAgreeAlert = true
                            }
                        }
                    }
                    
                    Text("g_customer_support".localized)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(Color.primary500)
                        .padding(EdgeInsets(top: sizeInfo.cellTopPadding, leading: sizeInfo.cellLeadingPadding, bottom: sizeInfo.cellBottomPadding, trailing: 0))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 0)  {
                        //                        SettingListLinkView(text: "\("h_current_version".localized) \(vm.config?.version?.current_version ?? "None")", subText: "", type: .ClickUpdate, showLine: true, onPress: {
                        //                            showVersionPage = true
                        //                        })
                        //                            .onAppear {
                        //                                self.vm.getConfig()
                        //                            }
                        
                        SettingListLinkView(text: "\("h_current_version".localized)", subText: "", lang: "", type: .ClickUpdate, showLine: true, onPress: {
                            // 임시
                            let url = "itms-apps://itunes.apple.com/app/" + "1553859430"
                            if let url = URL(string: url) {
                                openURL(url)
                            }
                        })
         
                        
                        SettingListLinkView(text:  "g_notice".localized, subText: "", lang: "", type: .ClickAllWithArrow, showLine: true, onPress: {
                            showNoticePage = true
                        })
                            .background(
                                NavigationLink("", isActive: $showNoticePage) {
                                    SettingNoticePage()
                                }.hidden()
                            )
                        SettingListLinkView(text:  "a_inquiry_email".localized, subText: "", lang: "", type: .ClickAllWithArrow, showLine: true, onPress: {
                            if let url = URL(string: "mailto:\(DefineKey.inquiryEmail)") {
                                openURL(url)
                            }
                        })
                    }
                    Text("s_term_service".localized)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(Color.primary500)
                        .padding(EdgeInsets(top: sizeInfo.cellTopPadding, leading: sizeInfo.cellLeadingPadding, bottom: sizeInfo.cellBottomPadding, trailing: 0))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 0)  {
                        SettingListLinkView(text:  "s_term_use_service".localized, subText: "", lang: "", type: .ClickAllWithArrow, showLine: true, onPress: {
                            showServiceTermsPage = true
                        })
                            .background(
                                NavigationLink("", isActive: $showServiceTermsPage) {
                                    Text("showServiceTermsPage")
                                }.hidden()
                            )
                        SettingListLinkView(text:  "g_term_privacy_info".localized, subText: "", lang: "", type: .ClickAllWithArrow, showLine: true, onPress: {
                            showPersonalTermPage = true
                        })
                            .background(
                                NavigationLink("", isActive: $showPersonalTermPage) {
                                    Text("showPersonalTermPage")
                                }.hidden()
                            )
                        SettingListLinkView(text:  "c_term_youth".localized, subText: "", lang: "", type: .ClickAllWithArrow, showLine: true, onPress: {
                            showYouthProtectionPage = true
                        })
                            .background(
                                NavigationLink("", isActive: $showYouthProtectionPage) {
                                    Text("showYouthProtectionPage")
                                }.hidden()
                            )
                    }
                }
            }
            .modifier(ScrollViewLazyVStackModifier())
        }
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "s_setting".localized, onPress: { buttonType in
            print("onPress buttonType : \(buttonType)")
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
        .showAlert(isPresented: $showAlert, type: .DateAlert, title: "g_advertisement_alarm".localized, message: showAlert ? "se_p_agree_market_info".localized : "se_p_disagree_marketing_info".localized, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
            
        })
        .showAlert(isPresented: $showAgreeAlert, type: .DateAlert, title: "g_advertisement_alarm".localized, message: "se_p_disagree_marketing_info".localized, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
            
        })
        .bottomSheet(isPresented: $showTransPage, height: UIScreen.main.bounds.height, topBarBackgroundColor: Color.gray100) {
            BSLanguageView(isShow: $showTransPage, selectedLangName: $languageManager.languageName, selectedLangCode: languageManager.languageCode, type: .nonType, onClick: { language in
                languageManager.languageCode = language
            })
        }
    }
}

struct SettingPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingPage()
    }
}
