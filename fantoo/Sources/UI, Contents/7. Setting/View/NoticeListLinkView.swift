//
//  NoticeListLink.swift
//  fantoo
//
//  Created by fns on 2022/10/28.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct NoticeListLinkView: View {
    
    @StateObject var languageManager = LanguageManager.shared

    let text: String
    let subText: String
    let showLine: Bool
    let onPress: () -> Void
    
    private struct sizeInfo {
        static let padding: CGFloat = 13.0
        static let cellHeight: CGFloat = 68.0
        static let cellPadding: CGFloat = 20.0
        static let iconSize: CGSize = CGSize(width: 17, height: 16)
        static let textSize: CGSize = CGSize(width: 20, height: 16)
        static let toggleSize: CGSize = CGSize(width: 40, height: 16)
        static let updateSize: CGSize = CGSize(width: 70, height: 24)
        static let idIconSize: CGSize = CGSize(width: 24, height: 24)
        static let idSize: CGSize = CGSize(width: 200, height: 20)
    }

    var body: some View {
        ZStack {
                Button(
                    action: {
                        onPress()
                    },
                    label: {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(text)
                                .font(Font.body21420Regular)
                                .foregroundColor(Color.gray870)
                                .padding(.leading, sizeInfo.cellPadding)
                                .padding(.top, sizeInfo.padding)
                                .fixedSize(horizontal: true, vertical: true)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            
                            Text(subText)
                                .font(Font.caption11218Regular)
                                .foregroundColor(Color.gray400)
                                .padding(.leading, sizeInfo.cellPadding)
                                .padding(.bottom, sizeInfo.padding)
                                .fixedSize(horizontal: true, vertical: true)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)

                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                )
                    .buttonStyle(.borderless)
            
            if showLine {
                ExDivider(color: .bgLightGray50, height: 1)
                    .frame(height: DefineSize.LineHeight)
                    .padding(EdgeInsets(top: sizeInfo.cellHeight - DefineSize.LineHeight, leading:0, bottom: 0, trailing: 0))
            }
        }
        .modifier(ListRowModifier(rowHeight: sizeInfo.cellHeight))
    }
}

