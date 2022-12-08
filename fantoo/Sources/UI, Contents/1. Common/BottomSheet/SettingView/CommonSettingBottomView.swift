//
//  CommonBottomView.swift
//  fantoo
//
//  Created by fns on 2022/07/06.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import CombineMoya
import XCTest

struct CommonSettingBottomView: View {
    @StateObject var languageManager = LanguageManager.shared
    
    var clubOpenTitle = [
        subTitleDescription(SEQ: 0, subTitle: "g_open_public".localized, subDescription: "m_all_see_searth".localized),
        subTitleDescription(SEQ: 1, subTitle: "b_hidden".localized, subDescription: "n_only_see".localized)
    ]
    var memberNumberListTitle = [
        subTitleDescription(SEQ: 0, subTitle: "g_open_public".localized, subDescription: "k_show_all_member_count".localized),
        subTitleDescription(SEQ: 1, subTitle: "b_hidden".localized, subDescription: "k_can_check_club_president".localized)
    ]
    var memberListTitle = [
        subTitleDescription(SEQ: 0, subTitle: "g_open_public".localized, subDescription: "k_open_all_club_members".localized),
        subTitleDescription(SEQ: 1, subTitle: "b_hidden".localized, subDescription: "k_member_only_available_club_president".localized)
    ]
    var joinApprovalTitle = [
        subTitleDescription(SEQ: 0, subTitle: "j_auto".localized, subDescription: "g_join_immediately_after_apply".localized),
        subTitleDescription(SEQ: 1, subTitle: "s_approval".localized, subDescription: "k_join_after_approves".localized)
    ]

    // community
    var communityFavoriteTitle = [
        subTitleDescription(SEQ: 1, subTitle: "p_order_by_user_recommend".localized, subDescription: "p_order_by_manager_recommend".localized),
        subTitleDescription(SEQ: 2, subTitle: "a_order_by_popular".localized, subDescription: "k_order_by_category_of_community".localized)
    ]
    
    //club
    var clubOpenTitleaOfClub = [
        subTitleDescription(SEQ: 0, subTitle: "g_open_public".localized, subDescription: "g_post_open_if_open_visiblity".localized),
        subTitleDescription(SEQ: 1, subTitle: "b_hidden".localized, subDescription: "se_k_hide_post_in_club".localized)
    ]
    var joinApprovalTitleOfClub = [
        subTitleDescription(SEQ: 0, subTitle: "j_auto".localized, subDescription: "g_join_immediately_after_apply".localized),
        subTitleDescription(SEQ: 1, subTitle: "s_approval".localized, subDescription: "k_join_after_approves".localized)
    ]
    
    
    
    
    @State var SEQ: Int = 0
    @State var selectedTitle: String?
    
    let title: String
    let type: BottomType
    @Binding var isShow: Bool
    @Binding var selectedText: String
    @Binding var selectedSEQ: Int
    @Binding var selectedYn: Bool
    let onPress: (Int) -> Void
    
    private struct sizeInfo {
        static let titleBottomPadding: CGFloat = 14.0
        static let padding: CGFloat = 32.0
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(Font.title51622Medium)
                    .foregroundColor(Color.gray870)
                Spacer()
            }.padding(.bottom, sizeInfo.titleBottomPadding)
            
            if type == .ClubOpen {
                ForEach(clubOpenTitle, id: \.SEQ) { subTitle in
                    CommonSettingBottomRow(subTitle: subTitle.subTitle, subDescription: subTitle.subDescription, selectedTitle: $selectedText, onPress: {
                        selectedText = subTitle.subTitle
                        isShow = false
                        if subTitle.SEQ == 0 {
                            selectedYn = true
                        }
                        else {
                            selectedYn = false
                        }
                        SEQ = subTitle.SEQ
                        onPress(SEQ)
                    })
                }
            }
            else if type == .MemberNumberList {
                ForEach(memberNumberListTitle, id: \.SEQ) { subTitle in
                    CommonSettingBottomRow(subTitle: subTitle.subTitle, subDescription: subTitle.subDescription, selectedTitle: $selectedText, onPress: {
                        selectedText = subTitle.subTitle
                        isShow = false
                        if subTitle.SEQ == 0 {
                            selectedYn = true
                        }
                        else {
                            selectedYn = false
                        }
                        SEQ = subTitle.SEQ
                        onPress(SEQ)
                    })
                }
            }
            else if type == .MemberList {
                ForEach(memberListTitle, id: \.SEQ) { subTitle in
                    CommonSettingBottomRow(subTitle: subTitle.subTitle, subDescription: subTitle.subDescription, selectedTitle: $selectedText, onPress: {
                        selectedText = subTitle.subTitle
                        isShow = false
                        if subTitle.SEQ == 0 {
                            selectedYn = true
                        }
                        else {
                            selectedYn = false
                        }
                        SEQ = subTitle.SEQ
                        onPress(SEQ)
                    })
                }
            }
            else if type == .JoinApproval {
                ForEach(joinApprovalTitle, id: \.SEQ) { subTitle in
                    CommonSettingBottomRow(subTitle: subTitle.subTitle, subDescription: subTitle.subDescription, selectedTitle: $selectedText, onPress: {
                        selectedText = subTitle.subTitle
                        isShow = false
                        if subTitle.SEQ == 0 {
                            selectedYn = true
                        }
                        else {
                            selectedYn = false
                        }
                        SEQ = subTitle.SEQ
                        onPress(SEQ)
                    })
                }
            }
            else if type == .CommunityFavorite {
                if let NOcommunityFavoriteTitle = communityFavoriteTitle {
                    ForEach(NOcommunityFavoriteTitle, id: \.SEQ) { subTitle in
                        CommonCommunityBottomRow(subTitle: subTitle.subTitle, subDescription: subTitle.subDescription, selectedTitle: $selectedText, onPress: {
                            selectedText = subTitle.subTitle
                            selectedSEQ = subTitle.SEQ
                            isShow = false
                            if subTitle.SEQ == 0 {
                                selectedYn = true
                            }
                            else {
                                selectedYn = false
                            }
                            SEQ = subTitle.SEQ
                            onPress(SEQ)
                        })
                    }
                }
            }
            else if type == .ClubOpenTitleaOfClub {
                if let NOclubOpenTitleaOfClub = clubOpenTitleaOfClub {
                    ForEach(NOclubOpenTitleaOfClub, id: \.SEQ) { subTitle in
                        CommonSettingBottomRow(subTitle: subTitle.subTitle, subDescription: subTitle.subDescription, selectedTitle: $selectedText, onPress: {
                            selectedText = subTitle.subTitle
                            selectedSEQ = subTitle.SEQ
                            isShow = false
                            if subTitle.SEQ == 0 {
                                selectedYn = true
                            }
                            else {
                                selectedYn = false
                            }
                            SEQ = subTitle.SEQ
                            onPress(SEQ)
                        })
                    }
                }
            }
            else if type == .JoinApprovalTitleOfClub {
                if let NOjoinApprovalTitleOfClub = joinApprovalTitleOfClub {
                    ForEach(NOjoinApprovalTitleOfClub, id: \.SEQ) { subTitle in
                        CommonSettingBottomRow(subTitle: subTitle.subTitle, subDescription: subTitle.subDescription, selectedTitle: $selectedText, onPress: {
                            selectedText = subTitle.subTitle
                            selectedSEQ = subTitle.SEQ
                            isShow = false
                            if subTitle.SEQ == 0 {
                                selectedYn = true
                            }
                            else {
                                selectedYn = false
                            }
                            SEQ = subTitle.SEQ
                            onPress(SEQ)
                        })
                    }
                }
            }
            Spacer().frame(maxHeight: .infinity)
        }
        .padding(.horizontal, sizeInfo.padding)
    }
}

struct CommonSettingBottomRow: View {
    @StateObject var languageManager = LanguageManager.shared
    
    let subTitle: String
    let subDescription: String
    @Binding var selectedTitle: String
    let onPress: () -> Void
    
    private struct sizeInfo {
        static let subTitleHeight: CGFloat = 80.0
        static let bottomPadding: CGFloat = 14.0
        static let iconSize: CGSize = CGSize(width: 24, height: 24)
    }
    
    var body: some View {
        
        HStack {
            Button {
                self.selectedTitle = self.subTitle
                onPress()
                print("title\(subTitle)")
            } label: {
                Text(subTitle)
                    .font(Font.title51622Medium)
                    .foregroundColor(subTitle == selectedTitle ? Color.primaryDefault : Color.gray800)
                    .frame(width: sizeInfo.subTitleHeight, alignment: .leading)
                Spacer()
                Text(subDescription)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray800)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                Image(systemName: "checkmark")
                    .foregroundColor(Color.primary300)
                    .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height)
                    .opacity(subTitle == selectedTitle ? 1 : 0)
            }
        }
        .padding(.bottom, sizeInfo.bottomPadding)
    }
}

struct CommonCommunityBottomRow: View {
    
    let subTitle: String
    let subDescription: String
    @Binding var selectedTitle: String
    let onPress: () -> Void
    
    private struct sizeInfo {
        static let subTitleHeight: CGFloat = 80.0
        static let bottomPadding: CGFloat = 14.0
        static let iconSize: CGSize = CGSize(width: 24, height: 24)
    }
    
    var body: some View {
        
        HStack(spacing: 0) {
            Button {
                self.selectedTitle = self.subTitle
                onPress()
                //print("title\(subTitle)")
            } label: {
                Text(subTitle)
                    .font(Font.title51622Medium)
                    .foregroundColor(subTitle == selectedTitle ? Color.primaryDefault : Color.gray800)
                    .frame(width: sizeInfo.subTitleHeight, alignment: .leading)
                
                Text(subDescription)
                    .font(Font.body21420Regular)
                    .foregroundColor(Color.stateEnableGray400)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 17)
                
                Spacer()
                Image(systemName: "checkmark")
                    .foregroundColor(Color.primary300)
                    .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height)
                    .opacity( subTitle == selectedTitle ? 1 : 0)
            }
        }
        .padding(.bottom, sizeInfo.bottomPadding)
    }
}
