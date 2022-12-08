//
//  ClubPostDetailPage.swift
//  fantoo
//
//  Created by fns on 2022/07/19.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct ClubPostDetailPage: View {
    
    @StateObject var languageManager = LanguageManager.shared
    
    private struct sizeInfo {
        static let spacerHeight15: CGFloat = 15.5
        static let cellHeight: CGFloat = 50.0
        static let cellLeadingPadding: CGFloat = 20.0
        static let cellBottomPadding: CGFloat = 14.0
        static let cellTrailingPadding: CGFloat = 16.0
        static let cellTopPadding: CGFloat = 19.5
        static let iconSize: CGSize = CGSize(width: 17, height: 16)
        static let bottomPadding: CGFloat = DefineSize.SafeArea.bottom
        static let bottomSheetHeight: CGFloat = 189.0 + DefineSize.SafeArea.bottom
    }
    
    @State var showHeadTitlePage: Bool = false
    @State var showSheetClubVisibility: Bool = false
    
    @State var clubVisibilityText: String = "j_delete_my_profile_info".localized
    @State var postTitle: String = ""
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 15.5)
            ExDivider(color: Color.bgLightGray50, height: 1)
            HStack(spacing: 0) {
                Text("g_board_name".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray800)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Text("5")
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.primaryDefault)
                + Text("/20")
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray300)
            }
            .padding(EdgeInsets(top: sizeInfo.cellTopPadding, leading: sizeInfo.cellLeadingPadding, bottom: sizeInfo.cellBottomPadding, trailing: sizeInfo.cellLeadingPadding))
            
            ZStack {
                HStack {
                    Text("j_free_board".localized)
                        .foregroundColor(Color.gray870)
                        .font(Font.body21420Regular)
                        .frame(maxWidth: .infinity, maxHeight: 42, alignment: .leading)
                    //                        .padding(.vertical, 14)
                        .padding(.leading, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray100, lineWidth: 1)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray50)
                                )
                        )
                    Spacer()
                }
            }
            //            .frame(maxWidth: .infinity, maxHeight: 42, alignment: .leading)
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
            
            ExDivider(color: Color.bgLightGray50, height: 8)
                .padding(.top, 24)
            
            SettingListLinkView(text: "m_summary_setting".localized, subText: "", lang: "", type: .ClickAllWithArrow, showLine: true) {
                showHeadTitlePage = true
            }
            .background(
                NavigationLink("", isActive: $showHeadTitlePage) {
                    ClubPostHeadTitlePage()
                }.hidden()
            )
            
            SettingListLinkView(text: "g_board_public_settings".localized, subText: clubVisibilityText ?? "", lang: "", type: .ClickRight, showLine: true) {
                //자유게시판은 공개 설정 변경 불가함
//                showSheetClubVisibility = true
            }
            
            Spacer().frame(maxHeight: .infinity)
            
        }
        
        .bottomSheet(isPresented: $showSheetClubVisibility, height: sizeInfo.bottomSheetHeight, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
            CommonSettingBottomView(
                title: "club_visibility_settins".localized,
                type: .ClubOpen,
                isShow: $showSheetClubVisibility,
                selectedText: $clubVisibilityText,
                selectedSEQ: .constant(-1),
                selectedYn: .constant(false)) { seq in
                    
                }
        })
        
        .background(Color.gray25)
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "j_free_board".localized, onPress: { buttonType in
        })
        .navigationBarBackground {
            Color.gray25
        }
//        .statusBarStyle(style: .darkContent)
    }
}
