//
//  MenuLoginLinkView.swift
//  fantooTests
//
//  Created by fns on 2022/09/08.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct MenuLoginLinkView: View {

    @StateObject var languageManager = LanguageManager.shared
    let text: String
    let onPress: () -> Void
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let cellHeight: CGFloat = 56.0
        static let cellPadding: CGFloat = 16.0
        static let iconSize: CGSize = CGSize(width: 17, height: 16)
    }
    
    var body: some View {
        ZStack {
            Button(
                action: {
                    onPress()
                },
                label: {
                    HStack {
                        Text(text)
                            .font(Font.title51622Medium)
                            .foregroundColor(Color.gray870)
                            .padding([.leading], sizeInfo.cellPadding)
                            .padding([.trailing], sizeInfo.padding)
                            .fixedSize(horizontal: true, vertical: true)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        
                        Image("icon_outline_go")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height, alignment: .trailing)
                            .foregroundColor(.gray870)
                            .padding([.leading], sizeInfo.padding)
                            .padding([.trailing], sizeInfo.cellPadding)
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            )
            .buttonStyle(.borderless)
        }
        .modifier(ListRowModifier(rowHeight: sizeInfo.cellHeight))
    }
}

struct MenuLoginLinkView_Previews: PreviewProvider {
    static var previews: some View {
        MenuLoginLinkView(text: "text", onPress: {
            
        })
            .previewLayout(.sizeThatFits)
    }
}
