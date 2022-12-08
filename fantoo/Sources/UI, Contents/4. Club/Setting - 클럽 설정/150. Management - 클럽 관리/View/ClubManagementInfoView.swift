//
//  ClubManagementInfoView.swift
//  fantoo
//
//  Created by fns on 2022/07/13.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct ClubManagementInfoView: View {
    @StateObject var languageManager = LanguageManager.shared
    
    @Binding var memberCount: String
    @Binding var postCount: String
    @Binding var kdgCount: String
    
    private struct sizeInfo {
        static let cellHeight: CGFloat = 100.0
        static let textSpacing: CGFloat = 6.0
        static let dividerWidth: CGFloat = 1.0
        static let dividerPadding: CGFloat = 30.0
        static let dividerHeight: CGFloat = 8.0
    }
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                HStack(spacing: 0) {
                    ZStack {
                        VStack {
                            Text("j_total_member_count".localized)
                                .font(Font.body21420Regular)
                                .foregroundColor(Color.gray600)
                                .fixedSize(horizontal: true, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            Spacer().frame(height: sizeInfo.textSpacing)
                            
                            Text(memberCount.insertComma)
                                .font(Font.buttons1420Medium)
                                .foregroundColor(Color.gray900)
                                .fixedSize(horizontal: true, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .frame(width: geo.size.width/3)
                        
                        VerticalDivider(color: Color.gray400, width: sizeInfo.dividerWidth)
                            .opacity(0.12)
                            .padding(EdgeInsets(top: sizeInfo.dividerPadding, leading: geo.size.width/3 - sizeInfo.dividerWidth, bottom: sizeInfo.dividerPadding, trailing: 0.0))
                    }
                    
                    ZStack {
                        VStack {
                            Text("j_total_post_count".localized)
                                .font(Font.body21420Regular)
                                .foregroundColor(Color.gray600)
                                .fixedSize(horizontal: true, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            Spacer().frame(height: sizeInfo.textSpacing)
                            
                            Text(postCount.insertComma)
                                .font(Font.buttons1420Medium)
                                .foregroundColor(Color.gray900)
                                .fixedSize(horizontal: true, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .frame(width: geo.size.width/3)
                        
                        VerticalDivider(color: Color.gray400, width: sizeInfo.dividerWidth)
                            .opacity(0.12)
                            .padding(EdgeInsets(top: sizeInfo.dividerPadding, leading: geo.size.width/3 - sizeInfo.dividerWidth, bottom: sizeInfo.dividerPadding, trailing: 0.0))
                    }
                    
                    VStack {
//                        Text("g_safe_kdg".localized)
//                            .font(Font.body21420Regular)
//                            .foregroundColor(Color.gray600)
//                            .fixedSize(horizontal: true, vertical: true)
//                            .frame(maxWidth: .infinity, alignment: .center)
//                        
//                        Spacer().frame(height: sizeInfo.textSpacing)
//                        
//                        Text(kdgCount.insertComma)
//                            .font(Font.buttons1420Medium)
//                            .foregroundColor(Color.gray900)
//                            .fixedSize(horizontal: true, vertical: true)
//                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(width: geo.size.width/3)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: sizeInfo.cellHeight)
            
            ExDivider(color: Color.bgLightGray50, height: sizeInfo.dividerHeight)
        }
    }
}
