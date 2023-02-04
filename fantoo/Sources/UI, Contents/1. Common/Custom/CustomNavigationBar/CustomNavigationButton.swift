//
//  CustomNavigationButton.swift
//  fantoo
//
//  Created by mkapps on 2022/05/21.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct CustomNavigationButton: View {
    
    let type:CustomNavigationBarButtonType
    let foregroundColor: Color
    var bookmarkForegroundColor: Color?
    let onPress: (CustomNavigationBarButtonType) -> Void
    
    private struct sizeInfo {
        static let iconEdgeInsets: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)
    }
    
    var body: some View {
        Button(
            action: {
                onPress(type)
            },
            label: {
                if type.isTextButton() {
                    Text(type.getText())
                        .font(Font.body21420Regular)
                        .foregroundColor((type.getImageForegroundColor() != nil) ? type.getImageForegroundColor()! : foregroundColor)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .padding(.vertical, 10)
                        .fixedSize()
                }
                else {
                    if type == .MarkActive {
                        Image(type.getImageString())
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: type.getImageSize().width, height: type.getImageSize().height)
                            .foregroundColor((type.getImageForegroundColor() != nil) ? type.getImageForegroundColor()! : bookmarkForegroundColor)
                    } else {
                        Image(type.getImageString())
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: type.getImageSize().width, height: type.getImageSize().height)
                            .foregroundColor((type.getImageForegroundColor() != nil) ? type.getImageForegroundColor()! : foregroundColor)
                    }
                }
            }
        )
        .buttonStyle(PlainButtonStyle()) // 버튼 깜빡임 방지
        .disabled(!type.isClickable())
        // 좌측 아이템들은 패딩값 안 줌
        .padding(.leading,
                 (type == .Back || type == .Home || type == .Logo || type == .Close || type == .AlertBack)
                 ?
                 0 : 20)
        .padding(.trailing,
                 (type == .Close)
                 ?
                 20 : 0)
    }
}
