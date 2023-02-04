//
//  ClubManagementLiskLinkView.swift
//  fantoo
//
//  Created by fns on 2022/07/13.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct ClubManagementLiskLinkView: View {
    @StateObject var languageManager = LanguageManager.shared
    
    let text: String
    var subText: String
    let onPress: () -> Void
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let cellHeight: CGFloat = 60.0
        static let iconSize: CGSize = CGSize(width: 17, height: 16)
    }
    
    var body: some View {
        ZStack {
            Button(
                action: {
                    onPress()
                },
                label: {
                    HStack(spacing: 0) {
                        Text(text)
                            .font(Font.body21420Regular)
                            .foregroundColor(Color.gray870)
                            .padding([.leading], DefineSize.Contents.HorizontalPadding)
                            .padding([.trailing], sizeInfo.padding)
                            .fixedSize(horizontal: true, vertical: true)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        
                        Text(subText)
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.primary500)
                            .padding([.leading], DefineSize.Contents.HorizontalPadding)
                            .padding([.trailing], sizeInfo.padding)
                            .fixedSize(horizontal: true, vertical: true)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                        
                        
                        Image("icon_outline_go")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height, alignment: .trailing)
                            .padding([.trailing], DefineSize.Contents.HorizontalPadding)
                            .foregroundColor(.stateEnableGray200)
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            )
                .buttonStyle(.borderless)
            
            ExDivider(color: Color.gray400, height: DefineSize.LineHeight)
                .opacity(0.12)
                .padding(EdgeInsets(top: sizeInfo.cellHeight - DefineSize.LineHeight, leading: 0, bottom: 0, trailing: 0))
        }
        .modifier(ListRowModifier(rowHeight: sizeInfo.cellHeight))
    }
}
