//
//  SettingListToggleLinkView.swift
//  fantoo
//
//  Created by fns on 2022/08/10.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct SettingListToggleLinkView: View {
    @StateObject var languageManager = LanguageManager.shared
    let text: String
    let subText: String
    let showLine: Bool
    @Binding var toggleIsOn: Bool
    let onPress: () -> Void
    
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let cellHeight: CGFloat = 50.0
        static let cellPadding: CGFloat = 16.0
        static let iconSize: CGSize = CGSize(width: 17, height: 16)
        static let textSize: CGSize = CGSize(width: 20, height: 16)
        static let toggleSize: CGSize = CGSize(width: 40, height: 16)
        static let updateSize: CGSize = CGSize(width: 70, height: 24)
        static let idIconSize: CGSize = CGSize(width: 20, height: 20)
        static let idSize: CGSize = CGSize(width: 200, height: 20)
    }
    
    
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Text(text)
                    .font(Font.body21420Regular)
                    .foregroundColor(Color.gray870)
                    .padding([.leading], sizeInfo.cellPadding)
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
                                .font(Font.caption11218Regular)
                                .foregroundColor(Color.gray500)
                                .padding([.leading], sizeInfo.cellPadding)
                                .padding([.trailing], sizeInfo.cellPadding)
                                .fixedSize(horizontal: true, vertical: true)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                            
                            Toggle(isOn: $toggleIsOn, label: {
                            })
                                .toggleStyle(SwitchToggleStyle(tint: Color.primary300))
                            //                                        .frame(width: sizeInfo.toggleSize.width, height: sizeInfo.toggleSize.height, alignment: .center)
                                .padding([.trailing], sizeInfo.cellPadding)
                                .onChange(of: toggleIsOn) { value in
                                    // action...
                                    print(value)
                                    if value {
                                        
                                    }
                                }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                )
                    .buttonStyle(.borderless)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if showLine {
                ExDivider(color: .bgLightGray50, height: 1)
                //                    .frame(height: DefineSize.LineHeight, alignment: .bottom)
                    .frame(height: DefineSize.LineHeight)
                    .padding(EdgeInsets(top: sizeInfo.cellHeight - DefineSize.LineHeight, leading:0, bottom: 0, trailing: 0))
            }
        }
        .modifier(ListRowModifier(rowHeight: sizeInfo.cellHeight))
        
    }
}
