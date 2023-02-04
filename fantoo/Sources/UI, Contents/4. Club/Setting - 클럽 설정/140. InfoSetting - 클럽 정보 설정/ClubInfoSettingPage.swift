//
//  ClubInfoSetting.swift
//  fantoo
//
//  Created by mkapps on 2022/06/22.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct ClubInfoSettingPage: View {
    
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var bottomSheetManager = BottomSheetManager.shared
    @StateObject var vm = ClubInfoSettingViewModel()
    
    @Binding var clubId: String
    @Binding var countryCode: String
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let topPadding: CGFloat = 15.0
        static let cellHeight: CGFloat = 50.0
        static let cellPadding: CGFloat = 16.0
        static let iconSize: CGSize = CGSize(width: 17, height: 16)
        static let bottomPadding: CGFloat = DefineSize.SafeArea.bottom
        static let bottomSheetHeight: CGFloat = 189.0 + DefineSize.SafeArea.bottom
    }
    
    @State var lang: String = "ko"
    @State var clubLang: String = ""
    
    //push
    @State private var showPageClubProfileSetting = false
    @State private var showPageClubCategorySetting = false
    @State private var showPageClubSearchKeywordSetting = false
    
    //popup
    @State private var showSheetClubVisibility = false
    @State private var showSheetJoinMethod = false
    @State private var showSheetMemberListVisibility = false
    @State private var showSheetMemberCountVisibility = false
    @State private var showSheetLanguageSetting = false
    @State private var showSheetCountrySetting = false
    
    @State private var clubOpenTitle = BottomSheetManager.shared.onPressClubOpenTitle.description
    @State private var joinApprovalTitle = BottomSheetManager.shared.onPressJoinApprovalTitle.description
    @State private var memberListTitle = BottomSheetManager.shared.onPressMemberListTitle.description
    @State private var memberNumberListTitle = BottomSheetManager.shared.onPressMemberNumberListTitle.description
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 15.5)
            ExDivider(color: Color.gray50, height: 1)
            ScrollView {
                LazyVStack(spacing: 0) {
                    //클럽 프로필 설정
                    ListLinkView(text: "k_club_profile_settings".localized, subTextColor: Color.gray800, type: .ClickAllWithArrow) {
                        showPageClubProfileSetting = true
                    }
                    
                    //클럽 공개 설정
                    ListLinkView(text: "k_club_visibility_settings".localized, subText: bottomSheetManager.onPressClubOpenTitle, subTextColor: Color.gray500, type: .ClickRight) {
                        //                        showSheetClubVisibility = true
                        bottomSheetManager.show.clubOpenTitle = true
                        bottomSheetManager.customBottomSheetClickType = .ClubOpenTitle
                    }
                    
                    //클럽 카테고리 설정
                    ListLinkView(text: "k_club_category_settings".localized, subTextColor: Color.gray500, type: .ClickAllWithArrow) {
                        showPageClubCategorySetting = true
                    }
                    
                    //가입 승인 방식
                    ListLinkView(text: "g_join_accept_method".localized, subText: bottomSheetManager.onPressJoinApprovalTitle, subTextColor: Color.gray500, type: .ClickRight) {
                        //                        showSheetJoinMethod = true
                        bottomSheetManager.show.joinApprovalTitle = true
                        bottomSheetManager.customBottomSheetClickType = .JoinApprovalTitle
                    }
                    
                    //멤버 목록 공개
                    ListLinkView(text: "m_member_list_revealed".localized, subText: bottomSheetManager.onPressMemberListTitle, subTextColor: Color.gray500, type: .ClickRight) {
                        //                        showSheetMemberListVisibility = true
                        bottomSheetManager.show.memberListTitle = true
                        bottomSheetManager.customBottomSheetClickType = .MemberListTitle
                    }
                    
                    //멤버수 공개
                    ListLinkView(text: "m_member_count_revealed".localized, subText: bottomSheetManager.onPressMemberNumberListTitle, subTextColor: Color.gray500, type: .ClickRight) {
                        //                        showSheetMemberCountVisibility = true
                        bottomSheetManager.show.memberNumberListTitle = true
                        bottomSheetManager.customBottomSheetClickType = .MemberNumberListTitle
                    }
                    
                    //클럽 검색어 설정
                    ListLinkView(text: "k_club_search_keyword_settings".localized, subTextColor: Color.gray500, type: .ClickAllWithArrow) {
                        showPageClubSearchKeywordSetting = true
                    }
                    
                    //주 언어 설정
                    ListLinkView(text: "j_main_language_settings".localized, subText: bottomSheetManager.onPressClubLanguage, subTextColor: Color.gray500, type: .ClickRight) {
                        //                        showSheetLanguageSetting = true
                        bottomSheetManager.show.clubSettingLanguage = true
                        bottomSheetManager.customBottomSheetClickType = .ClubSettingLanguage
                    }
                    
                    //주 활동국가 설정
                    ListLinkView(text: "j_main_activity_contry_settings".localized, subText: bottomSheetManager.onPressClubCountry, subTextColor: Color.gray500, type: .ClickRight) {
                        //                        showSheetCountrySetting = true
                        bottomSheetManager.show.clubSettingCountry = true
                        bottomSheetManager.customBottomSheetClickType = .SettingCountry
                    }
                }
                //                .modifier(ScrollViewLazyVStackModifier())
            }
            .background(Color.gray25)
            .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "k_club_info_setting".localized, onPress: { buttonType in
            })
            .navigationBarBackground {
                Color.gray25
            }
            //            .statusBarStyle(style: .darkContent)
            .onAppear(perform: {
                vm.requestClubFullInfoList(clubId: clubId) { success in
                    if success {
                        bottomSheetManager.onPressClubOpenTitle = vm.open
                        bottomSheetManager.onPressJoinApprovalTitle = vm.memberJoinAuto
                        bottomSheetManager.onPressMemberListTitle = vm.memberListOpen
                        bottomSheetManager.onPressMemberNumberListTitle = vm.memberCountOpen
                        bottomSheetManager.onPressClubLanguage = vm.languageName
                        bottomSheetManager.onPressClubLanguageCode = vm.languageCode
                        bottomSheetManager.onPressClubCountryCode = vm.activeCountryCode
                    }
                }
                vm.setDisplayValues(countryCode: bottomSheetManager.onPressClubCountryCode, languageCode: vm.languageCode)
                
            })
            
            .onChange(of: bottomSheetManager.onPressClubOpenTitle, perform: { (newValue) in
                switch newValue {
                case OpenOrHiddenType.Open.description:
                    vm.requestClubInfoEdit(clubId: clubId, integUid: UserManager.shared.uid, memberCountOpenYn: vm.memberCountOpenYn, memberJoinAutoYn: vm.memberJoinAutoYn, memberListOpenYn: vm.memberListOpenYn, openYn: true) { success in
                        if success {
                            vm.openYn = true
                        }
                    }
                case OpenOrHiddenType.Hidden.description:
                    vm.requestClubInfoEdit(clubId: clubId, integUid: UserManager.shared.uid, memberCountOpenYn: vm.memberCountOpenYn, memberJoinAutoYn: vm.memberJoinAutoYn, memberListOpenYn: vm.memberListOpenYn, openYn: false) { success in
                        if success {
                            vm.openYn = false
                        }
                    }
                default:
                    print("")
                }
            })
            
            .onChange(of: bottomSheetManager.onPressJoinApprovalTitle, perform: { (newValue) in
                switch newValue {
                case AutoOrApprovalType.Auto.description:
                    vm.requestClubInfoEdit(clubId: clubId, integUid: UserManager.shared.uid, memberCountOpenYn: vm.memberCountOpenYn, memberJoinAutoYn: true, memberListOpenYn: vm.memberListOpenYn, openYn: vm.openYn) { success in
                        if success {
                            vm.memberJoinAutoYn = true
                        }
                    }
                case AutoOrApprovalType.Approval.description:
                    vm.requestClubInfoEdit(clubId: clubId, integUid: UserManager.shared.uid, memberCountOpenYn: vm.memberCountOpenYn, memberJoinAutoYn: false, memberListOpenYn: vm.memberListOpenYn, openYn: vm.openYn) { success in
                        if success {
                            vm.memberJoinAutoYn = false
                        }
                    }
                default:
                    print("")
                }
            })
            
            .onChange(of: bottomSheetManager.onPressMemberListTitle, perform: { (newValue) in
                switch newValue {
                case OpenOrHiddenType.Open.description:
                    vm.requestClubInfoEdit(clubId: clubId, integUid: UserManager.shared.uid, memberCountOpenYn: vm.memberCountOpenYn, memberJoinAutoYn: vm.memberJoinAutoYn, memberListOpenYn: true, openYn: vm.openYn) { success in
                        if success {
                            vm.memberListOpenYn = true
                        }
                    }
                case OpenOrHiddenType.Hidden.description:
                    vm.requestClubInfoEdit(clubId: clubId, integUid: UserManager.shared.uid, memberCountOpenYn: vm.memberCountOpenYn, memberJoinAutoYn: vm.memberJoinAutoYn, memberListOpenYn: false, openYn: vm.openYn) { success in
                        if success {
                            vm.memberListOpenYn = false
                        }
                    }
                default:
                    print("")
                }
            })
            
            .onChange(of: bottomSheetManager.onPressMemberNumberListTitle, perform: { (newValue) in
                switch newValue {
                case OpenOrHiddenType.Open.description:
                    vm.requestClubInfoEdit(clubId: clubId, integUid: UserManager.shared.uid, memberCountOpenYn: true, memberJoinAutoYn: vm.memberJoinAutoYn, memberListOpenYn: vm.memberListOpenYn, openYn: vm.openYn) { success in
                        if success {
                            vm.memberCountOpenYn = true
                        }
                    }
                case OpenOrHiddenType.Hidden.description:
                    vm.requestClubInfoEdit(clubId: clubId, integUid: UserManager.shared.uid, memberCountOpenYn: false, memberJoinAutoYn: vm.memberJoinAutoYn, memberListOpenYn: vm.memberListOpenYn, openYn: vm.openYn) { success in
                        if success {
                            vm.memberCountOpenYn = false
                        }
                    }
                default:
                    print("")
                }
            })
            .onChange(of: bottomSheetManager.onPressClubLanguage, perform: { (newValue) in
                vm.requestClubInfoEdit(clubId: clubId, activeCountryCode: vm.countryIsoTwo, integUid: UserManager.shared.uid, languageCode: bottomSheetManager.onPressClubLanguageCode, memberCountOpenYn: vm.memberCountOpenYn, memberJoinAutoYn: vm.memberJoinAutoYn, memberListOpenYn: vm.memberListOpenYn, openYn: vm.openYn) { success in
                    if success {
                        print("\(bottomSheetManager.onPressClubLanguageCode)")
                        vm.setDisplayValues(languageCode: bottomSheetManager.onPressClubLanguageCode)
                    }
                    else {
                        bottomSheetManager.onPressClubLanguage = vm.languageName
                    }
                }
            })
            .onChange(of: bottomSheetManager.onPressClubCountryCode, perform: { (newValue) in
                //                vm.countryIsoTwo = countryData.iso2
                print("bottomSheetManager.onPressClubCountryCode : \(bottomSheetManager.onPressClubCountryCode)")
                
                vm.requestClubInfoEdit(clubId: clubId, activeCountryCode: bottomSheetManager.onPressClubCountryCode, integUid: UserManager.shared.uid, memberCountOpenYn: vm.memberCountOpenYn, memberJoinAutoYn: vm.memberJoinAutoYn, memberListOpenYn: vm.memberListOpenYn, openYn: vm.openYn) { success in
                    if success {
                        vm.setDisplayValues(countryCode: bottomSheetManager.onPressClubCountryCode)
                    }
                }
            })
            
            
            
            //MARK: - Show Page
            .background(
                NavigationLink("", isActive: $showPageClubProfileSetting) {
                    ClubProfileSettingPage(clubId: $clubId)
                }.hidden()
            )
            
            .background(
                NavigationLink("", isActive: $showPageClubCategorySetting) {
                    ClubCategorySettingPage(clubId: $clubId, interests: $vm.interestCategoryId, memberCountOpenYn: $vm.memberCountOpenYn, memberJoinAutoYn: $vm.memberJoinAutoYn, memberListOpenYn: $vm.memberListOpenYn, openYn: $vm.openYn)
                    
                }.hidden()
            )
            
            .background(
                NavigationLink("", isActive: $showPageClubSearchKeywordSetting) {
                    ClubSearchKeywordSettingPage(clubId: $clubId)
                }.hidden()
            )
        }
    }
}


//MARK: - Shpw Sheet

//클럽 공개 설정
//

//    .bottomSheet(isPresented: $showSheetClubVisibility, height: sizeInfo.bottomSheetHeight, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
//                CommonSettingBottomView(
//                    title: "k_club_visibility_settings".localized,
//                    type: .ClubOpen,
//                    isShow: $showSheetClubVisibility,
//                    selectedText: $vm.open,
//                    selectedSEQ: .constant(-1),
//                    selectedYn: .constant(false)) { seq in
//                        if seq == 0 {
//                            vm.requestClubInfoEdit(clubId: clubId, integUid: UserManager.shared.uid, memberCountOpenYn: vm.memberCountOpenYn, memberJoinAutoYn: vm.memberJoinAutoYn, memberListOpenYn: vm.memberListOpenYn, openYn: true) { success in
//                                if success {
//                                    vm.openYn = true
//                                }
//                            }
//                        }
//                        else {
//                            vm.requestClubInfoEdit(clubId: clubId, integUid: UserManager.shared.uid, memberCountOpenYn: vm.memberCountOpenYn, memberJoinAutoYn: vm.memberJoinAutoYn, memberListOpenYn: vm.memberListOpenYn, openYn: false) { success in
//                                if success {
//                                    vm.openYn = false
//                                }
//                            }
//                        }
//                    }
//            })
//
//            //가입 승인 방식
//            .bottomSheet(isPresented: $showSheetJoinMethod, height: sizeInfo.bottomSheetHeight, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
//                CommonSettingBottomView(
//                    title: "g_join_accept_method".localized,
//                    type: .JoinApproval,
//                    isShow: $showSheetJoinMethod,
//                    selectedText: $vm.memberJoinAuto,
//                    selectedSEQ: .constant(-1),
//                    selectedYn: .constant(false)) { seq in
//                        if seq == 0 {
//                            vm.requestClubInfoEdit(clubId: clubId, integUid: UserManager.shared.uid, memberCountOpenYn: vm.memberCountOpenYn, memberJoinAutoYn: true, memberListOpenYn: vm.memberListOpenYn, openYn: vm.openYn) { success in
//                                if success {
//                                    vm.memberJoinAutoYn = true
//                                }
//                            }
//                        }
//                        else {
//                            vm.requestClubInfoEdit(clubId: clubId, integUid: UserManager.shared.uid, memberCountOpenYn: vm.memberCountOpenYn, memberJoinAutoYn: false, memberListOpenYn: vm.memberListOpenYn, openYn: vm.openYn) { success in
//                                if success {
//                                    vm.memberJoinAutoYn = false
//                                }
//                            }
//                        }
//                    }
//            })
//
//            //멤버 목록 공개
//            .bottomSheet(isPresented: $showSheetMemberListVisibility, height: sizeInfo.bottomSheetHeight, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
//                CommonSettingBottomView(
//                    title: "m_member_list_revealed".localized,
//                    type: .MemberList,
//                    isShow: $showSheetMemberListVisibility,
//                    selectedText: $vm.memberListOpen,
//                    selectedSEQ: .constant(-1),
//                    selectedYn: .constant(false)) { seq in
//                        if seq == 0 {
//                            vm.requestClubInfoEdit(clubId: clubId, integUid: UserManager.shared.uid, memberCountOpenYn: vm.memberCountOpenYn, memberJoinAutoYn: vm.memberJoinAutoYn, memberListOpenYn: true, openYn: vm.openYn) { success in
//                                if success {
//                                    vm.memberListOpenYn = true
//                                }
//                            }
//                        }
//                        else {
//                            vm.requestClubInfoEdit(clubId: clubId, integUid: UserManager.shared.uid, memberCountOpenYn: vm.memberCountOpenYn, memberJoinAutoYn: vm.memberJoinAutoYn, memberListOpenYn: false, openYn: vm.openYn) { success in
//                                if success {
//                                    vm.memberListOpenYn = false
//                                }
//                            }
//                        }
//                    }
//            })
//
//            //멤버수 공개
//            .bottomSheet(isPresented: $showSheetMemberCountVisibility, height: sizeInfo.bottomSheetHeight, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
//                CommonSettingBottomView(
//                    title: "m_member_count_revealed".localized,
//                    type: .MemberNumberList,
//                    isShow: $showSheetMemberCountVisibility,
//                    selectedText: $vm.memberCountOpen,
//                    selectedSEQ: .constant(-1),
//                    selectedYn: .constant(false)) { seq in
//                        if seq == 0 {
//                            vm.requestClubInfoEdit(clubId: clubId, integUid: UserManager.shared.uid, memberCountOpenYn: true, memberJoinAutoYn: vm.memberJoinAutoYn, memberListOpenYn: vm.memberListOpenYn, openYn: vm.openYn) { success in
//                                if success {
//                                    vm.memberCountOpenYn = true
//                                }
//                            }
//                        }
//                        else {
//                            vm.requestClubInfoEdit(clubId: clubId, integUid: UserManager.shared.uid, memberCountOpenYn: false, memberJoinAutoYn: vm.memberJoinAutoYn, memberListOpenYn: vm.memberListOpenYn, openYn: vm.openYn) { success in
//                                if success {
//                                    vm.memberCountOpenYn = false
//                                }
//                            }
//                        }
//                    }
//            })
//    .bottomSheet(isPresented: $showSheetLanguageSetting, height: DefineSize.Screen.Height, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
//        BSLanguageView(isShow: $showSheetLanguageSetting, selectedLangName: $vm.languageName, selectedLangCode: vm.languageCode, isChangeAppLangCode: true, type: .ClubOpen, onClick: { language in
//            vm.languageCode = language
//            vm.requestClubInfoEdit(clubId: clubId, activeCountryCode: vm.countryIsoTwo, integUid: UserManager.shared.uid, languageCode: vm.languageCode, memberCountOpenYn: vm.memberCountOpenYn, memberJoinAutoYn: vm.memberJoinAutoYn, memberListOpenYn: vm.memberListOpenYn, openYn: vm.openYn) { success in
//                if success {
//                    vm.setDisplayValues(languageCode: vm.languageCode)
//                }
//            }
//        })
//    })
//    .bottomSheet(isPresented: $showSheetCountrySetting, height: DefineSize.Screen.Height, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
//
//        BSCountryView(isShow: $showSheetCountrySetting, selectedCountryCode: vm.countryIsoTwo, type: .nonType) { countryData in
//            vm.countryIsoTwo = countryData.iso2
//            vm.setDisplayValues(countryCode: vm.activeCountryCode, selectedCountryData: countryData)
//            vm.requestClubInfoEdit(clubId: clubId, activeCountryCode: vm.countryIsoTwo, integUid: UserManager.shared.uid, memberCountOpenYn: vm.memberCountOpenYn, memberJoinAutoYn: vm.memberJoinAutoYn, memberListOpenYn: vm.memberListOpenYn, openYn: vm.openYn) { success in
//                if success {
//                    vm.setDisplayValues(countryCode: vm.countryIsoTwo)
//                }
//            }
//        }
//    })
