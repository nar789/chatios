//
//  MenuLinkView.swift
//  fantoo
//
//  Created by mkapps on 2022/05/19.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct MenuLinkView: View {
    
    @StateObject var languageManager = LanguageManager.shared
    
    enum MenuLinkPosition: Int {
        case Top
        case Center
        case Bottom
    }
    
    let text: String
    let position: MenuLinkPosition
    let showLine: Bool
    
    let onPress: () -> Void
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let cellHeight: CGFloat = 60.0
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
                            .font(Font.body21420Regular)
                            .foregroundColor(Color.gray870)
                            .padding([.leading], sizeInfo.cellPadding)
                            .padding([.trailing], sizeInfo.padding)
                            .fixedSize(horizontal: true, vertical: true)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        
                        Image("icon_outline_go")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height, alignment: .trailing)
                            .foregroundColor(.stateEnableGray200)
                            .padding([.leading], sizeInfo.padding)
                            .padding([.trailing], sizeInfo.cellPadding)
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            )
            .buttonStyle(.borderless)
            
            
            if showLine {
                ExDivider(color: Color.gray400, height: DefineSize.LineHeight)
                    .opacity(0.12)
                    .padding(EdgeInsets(top: sizeInfo.cellHeight - DefineSize.LineHeight, leading: sizeInfo.cellPadding, bottom: 0, trailing: sizeInfo.cellPadding))
            }
        }
        .modifier(ListRowModifier(rowHeight: sizeInfo.cellHeight))
    }
}

struct MenuLinkView_Previews: PreviewProvider {
    static var previews: some View {
        MenuLinkView(text: "text", position: .Top, showLine: true, onPress: {
            
        })
            .previewLayout(.sizeThatFits)
    }
}
