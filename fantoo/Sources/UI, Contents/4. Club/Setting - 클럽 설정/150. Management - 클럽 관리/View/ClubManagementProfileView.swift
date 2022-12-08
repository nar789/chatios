//
//  ClubManagementProfileView.swift
//  fantoo
//
//  Created by fns on 2022/07/13.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct ClubManagementProfileView: View {
    @StateObject var languageManager = LanguageManager.shared
    
    enum ClubManegementProfileViewButtonType: Int {
        case EditProfile
        case ImageViewer
    }
    
    enum ClubImageType: Int {
        case Public
        case Private
    }
    
    let clubName: String
    let openDate: String
    let open: String
    let clubImageType: ClubImageType
    let onPress: (ClubManegementProfileViewButtonType) -> Void
    
    private struct sizeInfo {
        static let cellHeight: CGFloat = 15.0
        static let textSpacing: CGFloat = 6.0
        static let dividerWidth: CGFloat = 1.0
        static let padding: CGFloat = 10.0
        static let padding12: CGFloat = 12.0
        static let height: CGFloat = 50.0
        static let cellWidth: CGFloat = 106.0
        static let buttonHeight: CGFloat = 16
        static let blur: CGFloat = 20.0
        static let iconSize: CGSize = CGSize(width: 30.0, height: 30.0)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Button(
                action: {
                    onPress(.ImageViewer)
                },
                label: {
                    if clubImageType == .Public {
                    WebImage(url: URL(string: ""))
                        .resizable()
                        .placeholder(Image(Define.ProfileDefaultImage))
                        .frame(width: DefineSize.Size.ProfileThumbnailM.width, height: DefineSize.Size.ProfileThumbnailM.height, alignment: .leading)
                        .clipped()
                        .cornerRadius(DefineSize.CornerRadius.ProfileThumbnailS)
                        .padding([.trailing], sizeInfo.padding)
                    }
                    else if clubImageType == .Private {
                        ZStack {
                        WebImage(url: URL(string: ""))
                            .resizable()
                            .placeholder(Image(Define.ProfileDefaultImage))
                            .frame(width: DefineSize.Size.ProfileThumbnailM.width, height: DefineSize.Size.ProfileThumbnailM.height, alignment: .leading)
                            .blur(radius: sizeInfo.blur)
                            .clipped()
                            .cornerRadius(DefineSize.CornerRadius.ProfileThumbnailS)
//
                            
                            Image("icon_fill_private")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundColor(Color.gray25)
                                .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height)
                        } .padding([.trailing], sizeInfo.padding)
                    }
                }
            ) .buttonStyle(.borderless)
            
            
            Button(
                action: {
                    
                },
                label: {
                    VStack {
                        Text(clubName)
                            .font(Font.title51622Medium)
                            .foregroundColor(Color.gray900)
                            .padding([.trailing], sizeInfo.padding)
                            .fixedSize(horizontal: true, vertical: true)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        HStack(spacing: 0) {
                            HStack {
                                Text("g_create_date".localized)
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(Color.gray400)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                Spacer().frame(height: sizeInfo.textSpacing)
                                
                                Text(openDate)
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(Color.gray900)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }
                            .frame(width: sizeInfo.cellWidth)
                            
                            VerticalDivider(color: Color.gray200, width: sizeInfo.dividerWidth)
                                .frame(height: sizeInfo.buttonHeight)
                                .padding(EdgeInsets(top: 0, leading: sizeInfo.padding12, bottom: 0, trailing: sizeInfo.padding12))
                            
                            HStack {
                                Text("k_club_allow_public".localized)
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(Color.gray400)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
//                                Spacer().frame(height: sizeInfo.textSpacing)
                                
                                Text(open)
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(Color.gray900)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Spacer()
                            }
                            .frame(width: sizeInfo.cellWidth)
                            Spacer()
                        }
                    }
//                    .frame(maxWidth: .infinity)
                    .frame(height: sizeInfo.cellHeight)
                }).buttonStyle(.borderless)
        }
        .frame(height: sizeInfo.height)
        .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
    }
}
