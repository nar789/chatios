//
//  MenuInfoView.swift
//  fantoo
//
//  Created by mkapps on 2022/05/19.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct MenuInfoView: View {
    @StateObject var languageManager = LanguageManager.shared
    
    var myPostCount: String
    var myCommentCount: String
    var savedPostCount: String
    
    let onPress: (StorageButtonType) -> Void
    
    private struct sizeInfo {
        static let cellHeight: CGFloat = 78.0
        
        static let textSpacing: CGFloat = 5.0
        static let dividerWidth: CGFloat = 1.0
        static let dividerPadding: CGFloat = 15.0
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                HStack(spacing: 0) {
                    
                    ZStack {
                        Button {
                            onPress(.Post)
                        } label: {
                            VStack {
                                Text(UserManager.shared.isLogin ? myPostCount.insertComma : "-")
                                    .font(Font.body21420Regular)
                                    .foregroundColor(Color.gray900)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                Spacer().frame(height: sizeInfo.textSpacing)
                                
                                Text("j_wrote_post".localized)
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(Color.gray800)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .frame(width: geo.size.width/3)
                        }
                        .buttonStyle(.borderless)
                        
                        VerticalDivider(color: Color.gray400, width: sizeInfo.dividerWidth)
                            .opacity(0.12)
                            .padding(EdgeInsets(top: sizeInfo.dividerPadding, leading: geo.size.width/3 - sizeInfo.dividerWidth, bottom: sizeInfo.dividerPadding, trailing: 0.0))
                    }
                    
                    
                    ZStack {
                        Button {
                            onPress(.Comment)
                        } label: {
                            VStack {
                                Text(UserManager.shared.isLogin ? myCommentCount.insertComma : "-")
                                    .font(Font.body21420Regular)
                                    .foregroundColor(Color.gray900)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                Spacer().frame(height: sizeInfo.textSpacing)
                                
                                Text("j_wrote_rely".localized)
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(Color.gray800)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .frame(width: geo.size.width/3)
                        }
                        .buttonStyle(.borderless)
                        
                        VerticalDivider(color: Color.gray400, width: sizeInfo.dividerWidth)
                            .opacity(0.12)
                            .padding(EdgeInsets(top: sizeInfo.dividerPadding, leading: geo.size.width/3 - sizeInfo.dividerWidth, bottom: sizeInfo.dividerPadding, trailing: 0.0))
                    }
                    
                    ZStack {
                        Button {
                            onPress(.Save)
                        } label: {
                            VStack {
                                Text(UserManager.shared.isLogin ? savedPostCount.insertComma : "-")
                                    .font(Font.body21420Regular)
                                    .foregroundColor(Color.gray900)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                Spacer().frame(height: sizeInfo.textSpacing)
                                
                                Text("j_save".localized)
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(Color.gray800)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .frame(width: geo.size.width/3)
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .modifier(ListRowModifier(rowHeight: sizeInfo.cellHeight))
    }
}
