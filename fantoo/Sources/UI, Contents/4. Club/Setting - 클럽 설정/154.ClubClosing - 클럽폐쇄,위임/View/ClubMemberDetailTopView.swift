//
//  ClubMemberDetailTopView.swift
//  fantoo
//
//  Created by fns on 2022/07/25.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct ClubMemberDetailTopView: View {
    @StateObject var languageManager = LanguageManager.shared
    
    private struct sizeInfo {
        static let padding10: CGFloat = 10.0
        static let Spacer12: CGFloat = 12.0
        static let Spacer16: CGFloat = 16.0
        static let textWidthSpacing: CGFloat = 20.0
        static let textHeightSpacing: CGFloat = 6.0
        static let cellWidth: CGFloat = 58.0
    }
    
    let profileImg: String
    let memberNickname: String
    let memberLevel: String
    var openDate: String
    var open: String
    var kdg: String
    let onPress: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            Button(
                action: {
                    onPress()
                },
                label: {
                    VStack {
                        WebImage(url: URL(string: profileImg))
                            .resizable()
                            .placeholder(Image(Define.ProfileDefaultImage))
                            .frame(width: DefineSize.Size.ProfileThumbnailM.width, height: DefineSize.Size.ProfileThumbnailM.height, alignment: .leading)
                            .clipped()
                            .cornerRadius(DefineSize.CornerRadius.ProfileThumbnailS)
                            .padding([.trailing], sizeInfo.padding10)
                        Spacer()
                    }
                }
            ) .buttonStyle(.borderless)
            Spacer().frame(width: sizeInfo.Spacer12)
            VStack {
                Button(
                    action: {
                        
                    },
                    label: {
                        VStack(spacing: 0) {
                            Text(memberNickname)
                                .font(Font.title51622Medium)
                                .foregroundColor(Color.gray900)
                                .padding([.trailing], sizeInfo.padding10)
                                .fixedSize(horizontal: true, vertical: false)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            Spacer()
                            Text(memberLevel)
                                .font(Font.body21420Regular)
                                .foregroundColor(Color.gray400)
                                .padding([.trailing], sizeInfo.padding10)
                                .fixedSize(horizontal: true, vertical: false)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            Spacer().frame(height: sizeInfo.Spacer16)
                        }
                    }).buttonStyle(.borderless)
                
                HStack {
                    Text("g_create_date".localized)
                        .font(Font.caption11218Regular)
                        .foregroundColor(Color.gray400)
                        .fixedSize(horizontal: true, vertical: false)
                        .frame(maxWidth: sizeInfo.cellWidth, alignment: .leading)
                    
                    Spacer().frame(width: sizeInfo.textWidthSpacing)
                    
                    Text(openDate)
                        .font(Font.caption11218Regular)
                        .foregroundColor(Color.gray800)
                        .fixedSize(horizontal: true, vertical: false)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer().frame(width: sizeInfo.textHeightSpacing)
                
                HStack {
                    Text("최종 방문일")
                        .font(Font.caption11218Regular)
                        .foregroundColor(Color.gray400)
                        .fixedSize(horizontal: true, vertical: false)
                        .frame(maxWidth: sizeInfo.cellWidth, alignment: .leading)
                    
                    Spacer().frame(width: sizeInfo.textWidthSpacing)
                    
                    Text(open)
                        .font(Font.caption11218Regular)
                        .foregroundColor(Color.gray800)
                        .fixedSize(horizontal: true, vertical: false)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                }
                
                Spacer().frame(width: sizeInfo.textHeightSpacing)
                
// 기획 제거
//                HStack {
//                    Text("기부 합계")
//                        .font(Font.caption11218Regular)
//                        .foregroundColor(Color.gray400)
//                        .fixedSize(horizontal: true, vertical: false)
//                        .frame(maxWidth: sizeInfo.cellWidth, alignment: .leading)
//
//                    Spacer().frame(width: sizeInfo.textWidthSpacing)
//
//                    Text(kdg)
//                        .font(Font.caption11218Regular)
//                        .foregroundColor(Color.gray800)
//                        .fixedSize(horizontal: true, vertical: false)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//
//                    Spacer()
//                }
            }
            //                    .frame(maxWidth: .infinity)
            //                    .frame(height: sizeInfo.cellHeight)
        }
                .frame(height: 140)
        .padding(.all, DefineSize.Contents.HorizontalPadding)
        
    }
}

