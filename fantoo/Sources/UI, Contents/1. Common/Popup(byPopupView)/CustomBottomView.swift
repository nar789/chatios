//
//  HomePageBottomView.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/31.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct CustomBottomView: View {
    let title: String
    let type: CustomBottomSheetClickType
    let onPressItemMore: ((HomePageItemMoreType) -> Void)
    //var onPressGlobalLan: ((GlobalLanType) -> Void) = {_ in }
    var onPressGlobalLan: ((String) -> Void) = {_ in }
    var onPressCommon: ((String) -> Void) = {_ in }
    var onPressCommonSeq: ((Int) -> Void) = {_ in }
    @Binding var isShow: Bool
    //    @Published var onPressItemMore: HomePageItemMoreType = .None
    //    let onPressItemMore: ((HomePageItemMoreType) -> Void) = {
    //        (_ : HomePageItemMoreType ) in
    //    }
    
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var bottomSheetManager = BottomSheetManager.shared
    
    private struct sizeInfo {
        static let titleBottomPadding: CGFloat = 22.0
        static let hPadding: CGFloat = 30.0
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if !title.isEmpty {
                    HStack(spacing: 0) {
                        Text(title)
                            .font(.title51622Medium)
                            .foregroundColor(.stateEnableGray900)
                        Spacer()
                    }
                    .padding(.bottom, sizeInfo.titleBottomPadding)
                }
                
                // 홈탭 -> Popular탭 -> GLOBAL버튼
                if type == .GlobalLan {
                    ForEach(Array(DefineBottomSheet.globalLanItems.enumerated()), id: \.offset) { index, element in
                        
                        CustomBottomItemGlobalView(
                            item: element,
                            onPress: { buttonType in
                                onPressGlobalLan(buttonType)
                                isShow = false
                            }
                        )
                        .padding(.top, index==0 ? 0 : 10)
                    }
                }
                else if type == .SubHomeItemMore {
                    
                    ForEach(Array(DefineBottomSheet.subHomeItemMoreItems.enumerated()), id: \.offset) { index, element in
                        
                        CustomBottomItemMoreView(
                            item: element,
                            onPress: { buttonType in
                                onPressItemMore(buttonType)
                                isShow = false
                            }
                        )
                        .padding(.top, index==0 ? 0 : 10)
                    }
                }
                else if type == .CommunityDetailNaviMore {
                    Text("halo")
                }
                else if type == .ClubSettingLanguage {
                    BSLanguageView(isShow: $bottomSheetManager.show.clubSettingLanguage, selectedLangName: $bottomSheetManager.onPressClubLanguage, selectedLangCode: bottomSheetManager.onPressClubLanguageCode, isChangeAppLangCode: true, type: .ClubOpen, onClick: { language in
                        //                        bottomSheetManager.onPressClubLanguageCode = language
                        onPressCommon(language)
                    })
                    .padding(.horizontal, -30)
                }
                else if type == .SettingCountry {
                    BSCountryView(isShow: $bottomSheetManager.show.clubSettingCountry, selectedCountryCode: bottomSheetManager.onPressClubCountryCode, type: .nonType) { countryData in
                        onPressCommon(countryData.iso2)
                        bottomSheetManager.setDisplayValues(countryCode: bottomSheetManager.onPressClubCountryCode, selectedCountryData: countryData)
                    }
                    .padding(.horizontal, -30)
                }
                else if type == .JoinApprovalSettingOfClub {
                    ForEach(Array(DefineBottomSheet.joinApprovalSettingOfClub.enumerated()), id: \.offset) { index, element in
                        
                        CustomBottomCommonView(
                            type: .JoinApprovalSettingOfClub,
                            item: element,
                            onPress: { buttonType in
                                onPressCommon(buttonType)
                                isShow = false
                            }
                        )
                        .padding(.top, index==0 ? 0 : 10)
                    }
                }
                else if type == .ClubOpenSettingOfClub {
                    ForEach(Array(DefineBottomSheet.clubOpenSettingOfClub.enumerated()), id: \.offset) { index, element in
                        
                        CustomBottomCommonView(
                            type: .ClubOpenSettingOfClub,
                            item: element,
                            onPress: { buttonType in
                                onPressCommon(buttonType)
                                isShow = false
                            }
                        )
                        .padding(.top, index==0 ? 0 : 10)
                    }
                }
                else if type == .ClubOpenTitle {
                    ForEach(Array(DefineBottomSheet.clubOpenTitle.enumerated()), id: \.offset) { index, element in
                        
                        CustomBottomCommonView(
                            type: .ClubOpenTitle,
                            item: element,
                            onPress: { buttonType in
                                onPressCommon(buttonType)
                                isShow = false
                            }
                        )
                        .padding(.top, index==0 ? 0 : 10)
                    }
                }
                else if type == .JoinApprovalTitle {
                    ForEach(Array(DefineBottomSheet.joinApprovalTitle.enumerated()), id: \.offset) { index, element in
                        
                        CustomBottomCommonView(
                            type: .JoinApprovalTitle,
                            item: element,
                            onPress: { buttonType in
                                onPressGlobalLan(buttonType)
                                isShow = false
                            }
                        )
                        .padding(.top, index==0 ? 0 : 10)
                    }
                }
                else if type == .MemberListTitle {
                    ForEach(Array(DefineBottomSheet.memberListTitle.enumerated()), id: \.offset) { index, element in
                        
                        CustomBottomCommonView(
                            type: .MemberListTitle,
                            item: element,
                            onPress: { buttonType in
                                onPressCommon(buttonType)
                                isShow = false
                            }
                        )
                        .padding(.top, index==0 ? 0 : 10)
                    }
                }
                else if type == .MemberNumberListTitle {
                    ForEach(Array(DefineBottomSheet.memberNumberListTitle.enumerated()), id: \.offset) { index, element in
                        
                        CustomBottomCommonView(
                            type: .MemberNumberListTitle,
                            item: element,
                            onPress: { buttonType in
                                onPressCommon(buttonType)
                                isShow = false
                            }
                        )
                        .padding(.top, index==0 ? 0 : 10)
                    }
                }
                else if type == .ArchiveTypeTitle {
                    ForEach(Array(DefineBottomSheet.archiveTypeTitle.enumerated()), id: \.offset) { index, element in
                        
                        CustomBottomCommonView(
                            type: .ArchiveTypeTitle,
                            item: element,
                            onPress: { buttonType in
                                onPressCommon(buttonType)
                                isShow = false
                            }
                        )
                        .padding(.top, index==0 ? 0 : 10)
                    }
                }
                else if type == .ArchiveVisibilityTitle {
                    ForEach(Array(DefineBottomSheet.archiveVisibilityTitle.enumerated()), id: \.offset) { index, element in
                        
                        CustomBottomCommonView(
                            type: .ArchiveVisibilityTitle,
                            item: element,
                            onPress: { buttonType in
                                onPressCommon(buttonType)
                                isShow = false
                            }
                        )
                        .padding(.top, index==0 ? 0 : 10)
                    }
                }
                
                else if type == .RejoinSetting {
                    ForEach(Array(DefineBottomSheet.rejoinSetting.enumerated()), id: \.offset) { index, element in
                        
                        CustomBottomCommonView(
                            type: .RejoinSetting,
                            item: element,
                            onPress: { buttonType in
                                onPressCommon(buttonType)
                                isShow = false
                            },
                            onPressSeq: { buttonType in
                                onPressCommonSeq(buttonType)
                            }
                        )

                        .padding(.top, index==0 ? 0 : 10)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, sizeInfo.hPadding)
        }
    }
}

struct CustomBottomItemMoreView: View {
    let item: CustomBottomSheetModel
    let onPress: ((HomePageItemMoreType) -> Void)
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Image(item.image)
                .resizable()
                .frame(width: 22, height: 22)
            
            Text(item.title)
                .font(.body11622Regular)
                .foregroundColor(.gray870)
                .padding(.leading, 18)
            
            Spacer()
        }
        .padding(.vertical, 6)
        .onTapGesture {
            switch item.SEQ {
            case 1:
                onPress(HomePageItemMoreType.Save)
            case 2:
                onPress(HomePageItemMoreType.Share)
            case 3:
                onPress(HomePageItemMoreType.Join)
            case 4:
                onPress(HomePageItemMoreType.Notice)
            case 5:
                onPress(HomePageItemMoreType.Hide)
            case 6:
                onPress(HomePageItemMoreType.Block)
            default:
                print("")
            }
        }
    }
}

struct CustomBottomItemGlobalView: View {
    @StateObject var bottomSheetManager = BottomSheetManager.shared
    
    let item: CustomBottomSheetModel
    //let onPress: ((GlobalLanType) -> Void)
    let onPress: ((String) -> Void)
    
    private struct sizeInfo {
        static let subTitleHeight: CGFloat = 80.0
        static let bottomPadding: CGFloat = 14.0
    }
    
    var body: some View {
        
        HStack(spacing: 0) {
            Button {
                switch item.SEQ {
                case 1:
                    onPress(GlobalLanType.Global.description)
                case 2:
                    onPress(GlobalLanType.MyLan.description)
                case 3:
                    onPress(GlobalLanType.AnotherLan.description)
                default:
                    print("switch default")
                }
            } label: {
                Text(item.title)
                    .font(.body11622Regular)
                    .foregroundColor(self.compareCheckMarkOpacity(title: self.item.title) ? Color.primaryDefault : Color.gray800)
                Spacer()
                Image(systemName: "checkmark")
                    .foregroundColor(Color.primary300)
                    .opacity(self.compareCheckMarkOpacity(title: self.item.title) ? 1 : 0)
            }
        }
        .padding(.bottom, sizeInfo.bottomPadding)
    }
    
    func compareCheckMarkOpacity(title: String) -> Bool {
        if self.bottomSheetManager.onPressPopularGlobal == title {
            return true
        } else {
            return false
        }
    }
}

struct CustomBottomCommonView: View {
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var bottomSheetManager = BottomSheetManager.shared

    let type: CustomBottomSheetClickType
    let item: CustomBottomSheetCommonModel
    let onPress: ((String) -> Void)
    var onPressSeq: ((Int) -> Void) = {_ in }
    
    private struct sizeInfo {
        static let subTitleHeight: CGFloat = 80.0
        static let bottomPadding: CGFloat = 14.0
        static let iconSize: CGSize = CGSize(width: 24, height: 24)
    }
    
    var body: some View {
        
        HStack {
            Button {
                if type == .JoinApprovalSettingOfClub || type == .JoinApprovalTitle {
                    switch item.SEQ {
                    case 0:
                        onPress(AutoOrApprovalType.Auto.description)
                    case 1:
                        onPress(AutoOrApprovalType.Approval.description)
                    default:
                        print("switch default")
                    }
                }
                else if type == .ClubOpenSettingOfClub || type == .ClubOpenTitle || type == .MemberListTitle || type == .MemberNumberListTitle || type == .ArchiveVisibilityTitle {
                    switch item.SEQ {
                    case 0:
                        onPress(OpenOrHiddenType.Open.description)
                    case 1:
                        onPress(OpenOrHiddenType.Hidden.description)
                    default:
                        print("switch default")
                    }
                }
                else if type == .ArchiveTypeTitle {
                    switch item.SEQ {
                    case 0:
                        onPress(ImageOrGeneralType.Image.description)
                    case 1:
                        onPress(ImageOrGeneralType.General.description)
                    default:
                        print("switch default")
                    }
                }
                else if type == .RejoinSetting {
                    onPressSeq(item.SEQ)
                    switch item.SEQ {
                    case 0:
                        onPress(ProhibitionOrAllowType.Prohibition.description)
                    case 1:
                        onPress(ProhibitionOrAllowType.Allow.description)
                    default:
                        print("switch default")
                    }
                }
                
            } label: {
                Text(item.subTitle)
                    .font(Font.title51622Medium)
                    .foregroundColor(self.compareCheckMarkOpacity(title: self.item.subTitle)  ? Color.primaryDefault : Color.gray800)
                    .frame(width: sizeInfo.subTitleHeight, alignment: .leading)
                Spacer()
                Text(item.subDescription)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray800)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                Image(systemName: "checkmark")
                    .foregroundColor(Color.primary300)
                    .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height)
                    .opacity(self.compareCheckMarkOpacity(title: self.item.subTitle) ? 1 : 0)
            }
        }
        .padding(.bottom, sizeInfo.bottomPadding)
    }
    
    func compareCheckMarkOpacity(title: String) -> Bool {
        if type == .JoinApprovalSettingOfClub {
            if self.bottomSheetManager.onPressJoinApprovalSettingOfClub == title {
                return true
            } else {
                return false
            }
        }
        else if type == .ClubOpenSettingOfClub {
            if self.bottomSheetManager.onPressClubOpenSettingOfClub == title {
                return true
            } else {
                return false
            }
        }
        else if type == .JoinApprovalTitle {
            if self.bottomSheetManager.onPressJoinApprovalTitle == title {
                return true
            } else {
                return false
            }
        }
        else if type == .ClubOpenTitle {
            if self.bottomSheetManager.onPressClubOpenTitle == title {
                return true
            } else {
                return false
            }
        }
        else if type == .MemberListTitle {
            if self.bottomSheetManager.onPressMemberListTitle == title {
                return true
            } else {
                return false
            }
        }
        else if type == .MemberNumberListTitle {
            if self.bottomSheetManager.onPressMemberNumberListTitle == title {
                return true
            } else {
                return false
            }
        }
        else if type == .ArchiveTypeTitle {
            if self.bottomSheetManager.onPressArchiveTypeTitle == title {
                return true
            } else {
                return false
            }
        }
        else if type == .ArchiveVisibilityTitle {
            if self.bottomSheetManager.onPressArchiveVisibilityTitle == title {
                return true
            } else {
                return false
            }
        }
        else if type == .RejoinSetting {
            if self.bottomSheetManager.onPressRejoinSetting == title {
                return true
            } else {
                return false
            }
        }
        return true
    }
}
