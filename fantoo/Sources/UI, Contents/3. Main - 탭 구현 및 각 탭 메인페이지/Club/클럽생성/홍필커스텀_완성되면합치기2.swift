//
//  홍필커스텀_완성되면합치기2.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/11.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import CombineMoya
import XCTest

struct ClubInfoSettingBottomView_Copy: View {
    @StateObject var languageManager = LanguageManager.shared
    
    var clubOpenTitle = [
        subTitleDescription(SEQ: 1, subTitle: "g_open_public".localized, subDescription: "m_all_see_searth".localized),
        subTitleDescription(SEQ: 2, subTitle: "b_hidden".localized, subDescription: "n_only_see".localized)
    ]
    var memberNumberListTitle = [
        subTitleDescription(SEQ: 1, subTitle: "g_open_public".localized, subDescription: "k_show_all_member_count".localized),
        subTitleDescription(SEQ: 2, subTitle: "b_hidden".localized, subDescription: "k_can_check_club_president".localized)
    ]
    var memberListTitle = [
        subTitleDescription(SEQ: 1, subTitle: "g_open_public".localized, subDescription: "k_open_all_club_members".localized),
        subTitleDescription(SEQ: 2, subTitle: "b_hidden".localized, subDescription: "k_member_only_available_club_president".localized)
    ]
    var joinApprovalTitle = [
        subTitleDescription(SEQ: 1, subTitle: "j_auto".localized, subDescription: "g_join_immediately_after_apply".localized),
        subTitleDescription(SEQ: 2, subTitle: "s_approval".localized, subDescription: "k_join_after_approves".localized)
    ]
    
    let title: String
    let type: BottomType
    @Binding var selectedTitle: String?
    @Binding var isShow: Bool
    
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
                    ClubInfoSettingBottomRow_Copy(subTitle: subTitle.subTitle, subDescription: subTitle.subDescription, selectedTitle: $selectedTitle, onPress: {
                        isShow = false
                    })
                }
            }
            else if type == .MemberNumberList {
                ForEach(memberNumberListTitle, id: \.SEQ) { subTitle in
                    ClubInfoSettingBottomRow_Copy(subTitle: subTitle.subTitle, subDescription: subTitle.subDescription, selectedTitle: $selectedTitle, onPress: {
                        isShow = false
                    })
                }
            }
            else if type == .MemberList {
                ForEach(memberListTitle, id: \.SEQ) { subTitle in
                    ClubInfoSettingBottomRow_Copy(subTitle: subTitle.subTitle, subDescription: subTitle.subDescription, selectedTitle: $selectedTitle, onPress: {
                        isShow = false
                    })
                }
            }
            else if type == .JoinApproval {
                ForEach(joinApprovalTitle, id: \.SEQ) { subTitle in
                    ClubInfoSettingBottomRow_Copy(subTitle: subTitle.subTitle, subDescription: subTitle.subDescription, selectedTitle: $selectedTitle, onPress: {
                        isShow = false
                    })
                }
            }
            Spacer().frame(maxHeight: .infinity)
        }
        .padding(.horizontal, sizeInfo.padding)
    }
}

struct ClubInfoSettingBottomRow_Copy: View {
    
    let subTitle: String
    let subDescription: String
    @Binding var selectedTitle: String?
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
                    .opacity( subTitle == selectedTitle ? 1 : 0)
            }
        }
        .padding(.bottom, sizeInfo.bottomPadding)
    }
}
