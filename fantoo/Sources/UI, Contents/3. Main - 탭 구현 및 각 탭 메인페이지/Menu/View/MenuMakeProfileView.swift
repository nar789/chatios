//
//  MenuMakeProfileView.swift
//  fantoo
//
//  Created by mkapps on 2022/05/19.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct MenuMakeProfileView: View {
    
    @StateObject var languageManager = LanguageManager.shared
    var stepValue: Int
    
    let onPress: () -> Void
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let cellHeight: CGFloat = 120.0
        static let cellPadding: CGFloat = 16.0
        static let iconSize: CGFloat = 16.0
        static let topBottomPadding: CGFloat = 20.0
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("p_complete_profile".localized)
                        .font(Font.body21420Regular)
                        .foregroundColor(Color.gray870)
                        .padding([.leading], sizeInfo.cellPadding)
                        .fixedSize(horizontal: true, vertical: true)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    
                    Button {
                        onPress()
                    } label: {
                        HStack {
                            Group {
                                Text(String(format: "%ld", stepValue)).foregroundColor(.primary500)
                                + Text("/6 ")
                                + Text("a_complete".localized)
                            }
                            .font(Font.body21420Regular)
                            .foregroundColor(Color.gray870)
                            .padding([.leading], sizeInfo.padding)
                            
                            Image("icon_outline_go")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: sizeInfo.iconSize, height: sizeInfo.iconSize, alignment: .leading)
                                .foregroundColor(.stateEnableGray200)
                                .padding([.leading], 0)
                                .padding([.trailing], sizeInfo.cellPadding)
                        }
                    }
                    .buttonStyle(.borderless)
                }
                .padding([.top], sizeInfo.topBottomPadding)
                
                HStack {
                    Text("se_p_when_complete_profile".localized)
                    + Text(" ")
                    + Text(String(format: "en_fanit_a_few".localized, 500)).foregroundColor(.primary500)
                    + Text("se_a_will_give_you".localized)
                }
                .font(Font.caption11218Regular)
                .foregroundColor(Color.gray600)
                .padding([.top], -10)
                .padding([.leading], sizeInfo.cellPadding)
                .padding([.trailing], sizeInfo.cellPadding)
                .fixedSize(horizontal: true, vertical: true)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                
                ProgressView(value:  Double(stepValue), total: 6)
//                    .tint(.primary300)
                    .background(Color.bgLightGray50)
                    .padding([.leading, .trailing], sizeInfo.cellPadding)
                    .padding([.bottom], sizeInfo.topBottomPadding)
                    .frame(maxWidth: .infinity)
            }
        }
        .onAppear(perform: {
        })
        .modifier(ListRowModifier(rowHeight: sizeInfo.cellHeight))
        
    }
}


struct MenuMakeProfileView_Previews: PreviewProvider {

    static var previews: some View {
        MenuMakeProfileView(stepValue: 6, onPress: {
        })
        .previewLayout(.sizeThatFits)
    }
}
