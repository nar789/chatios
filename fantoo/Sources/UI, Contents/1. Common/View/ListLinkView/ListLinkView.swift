//
//  ListLinkView.swift
//  fantoo
//
//  Created by mkapps on 2022/06/22.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct ListLinkView: View {
    @StateObject var languageManager = LanguageManager.shared

    enum ListLinkViewType: Int {
        case Default
        case ClickAll
        case ClickAllWithArrow
        case ClickRight
        case ClickRightWithArrow
    }
    
    let text: String
    var subText: String = ""
    let subTextColor: Color
    let type: ListLinkViewType
    let onPress: () -> Void
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let cellHeight: CGFloat = 60.0
        static let iconSize: CGSize = CGSize(width: 17, height: 16)
    }
    
    var body: some View {
        ZStack {
            if type == .Default || type == .ClickAll || type == .ClickAllWithArrow {
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
                                .font(Font.body21420Regular)
                                .foregroundColor(subTextColor)
                                .padding([.leading], DefineSize.Contents.HorizontalPadding)
                                .padding([.trailing], type == .ClickAllWithArrow ? sizeInfo.padding : DefineSize.Contents.HorizontalPadding)
                                .fixedSize(horizontal: true, vertical: true)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                            
                            if type == .ClickAllWithArrow {
                                Image("icon_outline_go")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height, alignment: .trailing)
                                    .padding([.trailing], DefineSize.Contents.HorizontalPadding)
                                    .foregroundColor(.stateEnableGray200)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                )
                .buttonStyle(.borderless)
                .disabled(type == .Default ? true : false)
            }
            else {
                HStack(spacing: 0) {
                    Text(text)
                        .font(Font.body21420Regular)
                        .foregroundColor(Color.gray870)
                        .padding([.leading], DefineSize.Contents.HorizontalPadding)
                        .padding([.trailing], sizeInfo.padding)
                        .fixedSize(horizontal: true, vertical: true)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    
                    Button(
                        action: {
                            onPress()
                        },
                        label: {
                            HStack(spacing: 0) {
                                Text(subText)
                                    .font(Font.body21420Regular)
                                    .foregroundColor(subTextColor)
                                    .padding([.leading], DefineSize.Contents.HorizontalPadding)
                                    .padding([.trailing], type == .ClickRightWithArrow ? sizeInfo.padding : DefineSize.Contents.HorizontalPadding)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                                
                                if type == .ClickRightWithArrow {
                                    Image("icon_outline_go")
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height, alignment: .trailing)
                                        .padding([.trailing], DefineSize.Contents.HorizontalPadding)
                                        .foregroundColor(.stateEnableGray200)
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    )
                    .buttonStyle(.borderless)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            
            ExDivider(color: Color.gray400, height: DefineSize.LineHeight)
                .opacity(0.12)
                .padding(EdgeInsets(top: sizeInfo.cellHeight - DefineSize.LineHeight, leading: 0, bottom: 0, trailing: 0))
        }
        .modifier(ListRowModifier(rowHeight: sizeInfo.cellHeight))
    }
}

struct ListLinkView_Previews: PreviewProvider {
    static var previews: some View {
        ListLinkView(text: "title", subText: "sub", subTextColor: Color.gray800, type: .ClickRight, onPress: {
        })
            .previewLayout(.sizeThatFits)
    }
}
