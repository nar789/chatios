//
//  ClubMemberListView.swift
//  fantoo
//
//  Created by fns on 2022/07/14.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct ClubAllMemberListView: View {
    @StateObject var languageManager = LanguageManager.shared
    
    enum ClubMemberListViewType: Int {
        case ClickRightWithArrow
        case ClickRightWithText
    }
    
    private struct sizeInfo {
        static let cellHeight: CGFloat = 54.0
        static let cellImageSize: CGSize = CGSize(width: 36.0, height: 36.0)
        static let padding9: CGFloat = 9.0
        static let padding10: CGFloat = 10.0
        static let textSpacing: CGFloat = 2.0
        static let cellTextHeight: CGFloat = 16.0
        static let dividerWidth: CGFloat = 1.0
        static let subTextHeight: CGFloat = 16.0
        static let stackHeight36: CGFloat = 36.0
        static let iconSize: CGSize = CGSize(width: 16, height: 16)
    }
    
    var profileImg: String
    var memberNickname: String
    var memberLevel: String
    var ClubJoinDate: String
    let rejoinChoice: Bool
    let showLine: Bool
    let type: ClubMemberListViewType
    let onPress: () -> Void
    
    var body: some View {
        
        
        Button(action: {
            onPress()
        }, label:
                ZStack {
            HStack(spacing: 0) {
                
                WebImage(url: URL(string: profileImg))
                    .resizable()
                    .placeholder(Image(Define.ProfileDefaultImage))
                    .frame(width: sizeInfo.cellImageSize.width, height: sizeInfo.cellImageSize.height, alignment: .leading)
                    .clipped()
                    .cornerRadius(DefineSize.CornerRadius.ProfileThumbnailS)
                    .padding(.trailing, sizeInfo.padding10)
                
                if type == .ClickRightWithArrow {
                    VStack {
                        Text(memberNickname)
                            .font(Font.body21420Regular)
                            .foregroundColor(Color.gray900)
                            .frame(maxWidth: .infinity, maxHeight: sizeInfo.cellTextHeight, alignment: .leading)
                        Spacer().frame(width: sizeInfo.textSpacing)
                        
                        HStack {
                            Text(memberLevel)
                                .font(Font.caption11218Regular)
                                .foregroundColor(Color.gray500)
                                .frame(maxHeight: sizeInfo.subTextHeight, alignment: .leading)
                            
                            VerticalDivider(color: Color.gray100, width: sizeInfo.dividerWidth)
                                .frame(height: sizeInfo.subTextHeight - 4)
                                .padding(EdgeInsets(top: 0, leading: sizeInfo.padding9, bottom: 0, trailing: sizeInfo.padding9))
                            
                            Text("g_join_date".localized)
                                .font(Font.caption11218Regular)
                                .foregroundColor(Color.gray500)
                                .frame(maxHeight: sizeInfo.subTextHeight, alignment: .leading)
                            
                            Text(ClubJoinDate)
                                .font(Font.caption11218Regular)
                                .foregroundColor(Color.gray500)
                                .frame(maxHeight: sizeInfo.subTextHeight, alignment: .leading)
                            Spacer()
                        }
                    }
                    .frame(height: sizeInfo.stackHeight36, alignment: .center)
                    Image("icon_outline_go")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height, alignment: .trailing)
                        .foregroundColor(.stateEnableGray200)
                    
                } else if type == .ClickRightWithText {
                    VStack {
                        Text(memberNickname)
                            .font(Font.body21420Regular)
                            .foregroundColor(Color.gray900)
                            .frame(maxWidth: .infinity, maxHeight: sizeInfo.cellTextHeight, alignment: .leading)
                        Spacer().frame(width: sizeInfo.textSpacing)
                        
                        HStack {
                            Text("g_forced_leave_date".localized)
                                .font(Font.caption11218Regular)
                                .foregroundColor(Color.gray400)
                                .frame(maxHeight: sizeInfo.subTextHeight, alignment: .leading)
                            
                            Text(ClubJoinDate)
                                .font(Font.caption11218Regular)
                                .foregroundColor(Color.gray400)
                                .frame(maxHeight: sizeInfo.subTextHeight, alignment: .leading)
                            Spacer()
                        }
                    }
                    .frame(height: sizeInfo.stackHeight36, alignment: .center)
                    
                    Text(rejoinChoice ? "j_allow_rejoin".localized : "j_no_rejoin".localized)
                        .foregroundColor(rejoinChoice ? Color.primaryDefault : Color.stateDanger)
                        .font(Font.caption11218Regular)
                }
            }
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
            
            if showLine {
                ExDivider(color: .bgLightGray50, height: sizeInfo.dividerWidth)
                    .frame(height: DefineSize.LineHeight, alignment: .bottom)
                    .padding(EdgeInsets(top: sizeInfo.cellHeight - DefineSize.LineHeight, leading:0, bottom: 0, trailing: 0)
                    )}
        })
            .frame(height: sizeInfo.cellHeight, alignment: .center)
    }
}
