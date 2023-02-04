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
    @StateObject var bottomSheetManager = BottomSheetManager.shared
    @StateObject var languageManager = LanguageManager.shared
    
    func body(content: Content) -> some View {
        content
        // Popular - Item More (없애야 됨)
        //            .bottomSheet(
        //                isPresented: $bottomSheetManager.show.popularItemMore,
        //                height: 500,
        //                topBarCornerRadius: DefineSize.CornerRadius.BottomSheet,
        //                content: {
        //                    CustomBottomView(
        //                        title: "123",
        //                        type: HomePageBottomType.SubHomeItemMore,
        //                        onPressItemMore: { buttonType in
        //                            print("\n--- \(buttonType) ---\n")
        //                            //userManager.onPressItemMore(buttonType)
        //
        //                            /**
        //                             * userManager.bottomSheetWithChange 값도 저장하는 이유 :
        //                             *
        //                             * BottomSheet 사용시, BottomSheetManager 만 사용하고 수정되어야 하는데,
        //                             * BottomSheetManager 단독으로 사용하면 적용이 안 되고, UserManager 값을 같이 사용하면 적용이 됨. 이상함.
        //                             * 그래서 아래 사용하지 않는 변수(bottomSheetWithChange) 생성한 것. 원인분석 아직 못 했음.
        //                             */
        //                            userManager.bottomSheetWithChange = Date().toString()
        //                            bottomSheetManager.changetest = Date().toString()
        //                            //bottomSheetManager.onPressPopularGlobal = .Global
        //                        },
        //                        selectedTitle: .constant("123"),
        //                        isShow: $bottomSheetManager.show.popularItemMore
        //                    )
        //                })
        // 홈탭 -> Popular탭 -> GLOBAL버튼
            .bottomSheet(
                isPresented: $bottomSheetManager.show.popularGlobal,
                height: getPopupHeight(),
                topBarCornerRadius: DefineSize.CornerRadius.BottomSheet,
                content: {
                    CustomBottomView(
                        title: "a_language_filter".localized,
                        //title: "", // 제목없는 팝업뷰 테스트
                        type: CustomBottomSheetClickType.GlobalLan,
                        onPressItemMore: {_ in },
                        onPressGlobalLan: { buttonType in
                            //print("\n--- \(buttonType) ---\n")
                            
                            bottomSheetManager.onPressPopularGlobal = buttonType
                        },
                        isShow: $bottomSheetManager.show.popularGlobal
                    )
                })
        
            .bottomSheet(
                isPresented: $bottomSheetManager.show.language,
                height: getPopupHeight(),
                topBarCornerRadius: DefineSize.CornerRadius.BottomSheet,
                content: {
                    BSLanguageView(isShow: $bottomSheetManager.show.language, selectedLangName: $languageManager.languageName, selectedLangCode: languageManager.languageCode, type: .nonType, onClick: { language in
                        languageManager.languageCode = language
                    })
                })
        
            .bottomSheet(
                isPresented: $bottomSheetManager.show.clubSettingLanguage,
                height: getPopupHeight(),
                topBarCornerRadius: DefineSize.CornerRadius.BottomSheet,
                content: {
                    CustomBottomView(
                        title: "",
                        //title: "", // 제목없는 팝업뷰 테스트
                        type: CustomBottomSheetClickType.ClubSettingLanguage,
                        onPressItemMore: {_ in },
                        onPressCommon: { buttonType in
                            print("\n--- \(buttonType) ---\n")
                            
                            bottomSheetManager.onPressClubLanguageCode = buttonType
                        },
                        isShow: $bottomSheetManager.show.clubSettingLanguage
                    )
                })
        
            .bottomSheet(
                isPresented: $bottomSheetManager.show.clubSettingCountry,
                height: getPopupHeight(),
                topBarCornerRadius: DefineSize.CornerRadius.BottomSheet,
                content: {
                    CustomBottomView(
                        title: "",
                        //title: "", // 제목없는 팝업뷰 테스트
                        type: CustomBottomSheetClickType.SettingCountry,
                        onPressItemMore: {_ in },
                        onPressCommon: { buttonType in
                            print("\n--- \(buttonType) ---\n")

                            bottomSheetManager.onPressClubCountryCode = buttonType
                        },
                        isShow: $bottomSheetManager.show.clubSettingCountry
                    )
                })
        
            .bottomSheet(
                isPresented: $bottomSheetManager.show.joinApprovalSettingOfClub,
                height: getPopupHeight(),
                topBarCornerRadius: DefineSize.CornerRadius.BottomSheet,
                content: {
                    CustomBottomView(
                        title: "g_join_accept_method".localized,
                        //title: "", // 제목없는 팝업뷰 테스트
                        type: CustomBottomSheetClickType.JoinApprovalSettingOfClub,
                        onPressItemMore: {_ in },
                        onPressCommon: { buttonType in
                            //print("\n--- \(buttonType) ---\n")
                            
                            bottomSheetManager.onPressJoinApprovalSettingOfClub = buttonType
                        },
                        isShow: $bottomSheetManager.show.joinApprovalSettingOfClub
                    )
                })
        
            .bottomSheet(
                isPresented: $bottomSheetManager.show.clubOpenSettingOfClub,
                height: getPopupHeight(),
                topBarCornerRadius: DefineSize.CornerRadius.BottomSheet,
                content: {
                    CustomBottomView(
                        title: "k_club_visibility_settings".localized,
                        //title: "", // 제목없는 팝업뷰 테스트
                        type: CustomBottomSheetClickType.ClubOpenSettingOfClub,
                        onPressItemMore: {_ in },
                        onPressCommon: { buttonType in
                            //print("\n--- \(buttonType) ---\n")
                            
                            bottomSheetManager.onPressClubOpenSettingOfClub = buttonType
                        },
                        isShow: $bottomSheetManager.show.clubOpenSettingOfClub
                    )
                })
        
            .bottomSheet(
                isPresented: $bottomSheetManager.show.clubOpenTitle,
                height: getPopupHeight(),
                topBarCornerRadius: DefineSize.CornerRadius.BottomSheet,
                content: {
                    CustomBottomView(
                        title: "k_club_visibility_settings".localized,
                        type: CustomBottomSheetClickType.ClubOpenTitle,
                        onPressItemMore: {_ in },
                        onPressCommon: { buttonType in
                            
                            bottomSheetManager.onPressClubOpenTitle = buttonType
                        },
                        isShow: $bottomSheetManager.show.clubOpenTitle
                    )
                })
            .bottomSheet(
                isPresented: $bottomSheetManager.show.joinApprovalTitle,
                height: getPopupHeight(),
                topBarCornerRadius: DefineSize.CornerRadius.BottomSheet,
                content: {
                    CustomBottomView(
                        title: "g_join_accept_method".localized,
                        type: CustomBottomSheetClickType.JoinApprovalTitle,
                        onPressItemMore: {_ in },
                        onPressCommon: { buttonType in
                            
                            bottomSheetManager.onPressJoinApprovalTitle = buttonType
                        },
                        isShow: $bottomSheetManager.show.joinApprovalTitle
                    )
                })
            .bottomSheet(
                isPresented: $bottomSheetManager.show.memberListTitle,
                height: getPopupHeight(),
                topBarCornerRadius: DefineSize.CornerRadius.BottomSheet,
                content: {
                    CustomBottomView(
                        title: "m_member_list_revealed".localized,
                        type: CustomBottomSheetClickType.MemberListTitle,
                        onPressItemMore: {_ in },
                        onPressCommon: { buttonType in
                            
                            bottomSheetManager.onPressMemberListTitle = buttonType
                        },
                        isShow: $bottomSheetManager.show.memberListTitle
                    )
                })
            .bottomSheet(
                isPresented: $bottomSheetManager.show.memberNumberListTitle,
                height: getPopupHeight(),
                topBarCornerRadius: DefineSize.CornerRadius.BottomSheet,
                content: {
                    CustomBottomView(
                        title: "m_member_count_revealed".localized,
                        type: CustomBottomSheetClickType.MemberNumberListTitle,
                        onPressItemMore: {_ in },
                        onPressCommon: { buttonType in
                            
                            bottomSheetManager.onPressMemberNumberListTitle = buttonType
                        },
                        isShow: $bottomSheetManager.show.memberNumberListTitle
                    )
                })
            .bottomSheet(
                isPresented: $bottomSheetManager.show.archiveTypeTitle,
                height: getPopupHeight(),
                topBarCornerRadius: DefineSize.CornerRadius.BottomSheet,
                content: {
                    CustomBottomView(
                        title: "a_select_archive_type".localized,
                        type: CustomBottomSheetClickType.ArchiveTypeTitle,
                        onPressItemMore: {_ in },
                        onPressCommon: { buttonType in
                            
                            bottomSheetManager.onPressArchiveTypeTitle = buttonType
                        },
                        isShow: $bottomSheetManager.show.archiveTypeTitle
                    )
                })
            .bottomSheet(
                isPresented: $bottomSheetManager.show.archiveVisibilityTitle,
                height: getPopupHeight(),
                topBarCornerRadius: DefineSize.CornerRadius.BottomSheet,
                content: {
                    CustomBottomView(
                        title: "g_board_public_settings".localized,
                        type: CustomBottomSheetClickType.ArchiveVisibilityTitle,
                        onPressItemMore: {_ in },
                        onPressCommon: { buttonType in
                            
                            bottomSheetManager.onPressArchiveVisibilityTitle = buttonType
                        },
                        isShow: $bottomSheetManager.show.archiveVisibilityTitle
                    )
                })
            .bottomSheet(
                isPresented: $bottomSheetManager.show.rejoinSetting,
                height: getPopupHeight(),
                topBarCornerRadius: DefineSize.CornerRadius.BottomSheet,
                content: {
                    CustomBottomView(
                        title: "g_board_public_settings".localized,
                        type: CustomBottomSheetClickType.RejoinSetting,
                        onPressItemMore: {_ in },
                        onPressCommon: { buttonType in
                            
                            bottomSheetManager.onPressRejoinSetting = buttonType
                            print("@@@@buttonType\(buttonType)")
                        },
                        onPressCommonSeq: { buttonSeq in
                            if buttonSeq == 0 {
                                bottomSheetManager.onPressRejoinSettingType = false
                            }
                            else {
                                bottomSheetManager.onPressRejoinSettingType = true
                            }
                        },
                        isShow: $bottomSheetManager.show.rejoinSetting
                    )
                })
    }
    
    func getPopupHeight() -> CGFloat {
        var finalHeight: CGFloat = 0.0
        
        switch bottomSheetManager.customBottomSheetClickType {
        case .None:
            print("")
            finalHeight = 0.0
        case .SubHomeItemMore:
            print("")
            finalHeight = 0.0
        case .GlobalLan:
            print("")
            finalHeight = self.defineSize(isTitleEmpty: false, size: DefineBottomSheet.globalLanItems.count)
        case .CommunityDetailNaviMore:
            print("")
            finalHeight = 0.0
        case .Language:
            finalHeight = self.defineSize(isTitleEmpty: true, size: 17)
        case .ClubSettingLanguage:
            finalHeight = self.defineSize(isTitleEmpty: true, size: 17)
        case .SettingCountry:
            finalHeight = self.defineSize(isTitleEmpty: true, size: 17)
        case .ClubOpenTitle:
            finalHeight = self.defineSize(isTitleEmpty: false, size: DefineBottomSheet.clubOpenTitle.count)
        case .MemberNumberListTitle:
            finalHeight = self.defineSize(isTitleEmpty: false, size: DefineBottomSheet.memberNumberListTitle.count)
        case .MemberListTitle:
            finalHeight = self.defineSize(isTitleEmpty: false, size: DefineBottomSheet.memberListTitle.count)
        case .JoinApprovalTitle:
            finalHeight = self.defineSize(isTitleEmpty: false, size: DefineBottomSheet.joinApprovalTitle.count)
        case .ClubOpenSettingOfClub:
            finalHeight = self.defineSize(isTitleEmpty: false, size: DefineBottomSheet.clubOpenSettingOfClub.count)
        case .JoinApprovalSettingOfClub:
            finalHeight = self.defineSize(isTitleEmpty: false, size: DefineBottomSheet.joinApprovalSettingOfClub.count)
        case .ArchiveVisibilityTitle:
            finalHeight = self.defineSize(isTitleEmpty: false, size: DefineBottomSheet.archiveVisibilityTitle.count)
        case .ArchiveTypeTitle:
            finalHeight = self.defineSize(isTitleEmpty: false, size: DefineBottomSheet.archiveTypeTitle.count)
        case .RejoinSetting:
            finalHeight = self.defineSize(isTitleEmpty: false, size: DefineBottomSheet.rejoinSetting.count)

        }
        return finalHeight
    }
    
    func defineSize(isTitleEmpty: Bool, size: Int) -> CGFloat {
        var finalHeight: CGFloat = 0.0
        if size > 0 {
            switch size {
            case 1...3:
                finalHeight = CGFloat(size) * 80.0
            case 4...6:
                finalHeight = CGFloat(size) * 60.0
            case 7...9:
                finalHeight = CGFloat(size) * 55.0
            case 10...12:
                finalHeight = CGFloat(size) * 53.0
            case 13..<15:
                finalHeight = CGFloat(size) * 51.0
            case 16..<20:
                finalHeight = CGFloat(size) * 45.0
            default:
                finalHeight = .infinity
            }
        }
        
        // 팝업 상단 타이틀이 있는 경우 -> 타이틀 높이를 더해줌
        if !isTitleEmpty {
            if size == 1 {
                finalHeight += 80.0
            }
            else {
                finalHeight += 50.0
            }
        }
        return finalHeight
    }
}
