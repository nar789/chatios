//
//  CommonButton2.swift
//  fantoo
//
//  Created by sooyeol on 2023/01/20.
//  Copyright © 2023 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct CommonButton2 : View {
    
    var title : String
    
    @State var type: ButtonType
    
    var height: CGFloat
    var cornerRadius: CGFloat
    
    @Binding var disabled: Bool
    
    public enum ButtonType {
        case defaults(textColor: Color? = nil, font: Font? = nil, backgroundColor: Color? = nil, disableTextColor: Color? = nil, disableFont: Font? = nil, disableBackgroundColor: Color? = nil)
        case cancel(textColor: Color? = nil, font: Font? = nil, backgroundColor: Color? = nil)
    }
    
    private struct defaultsInfo {
        static let foregroundColor: Color = Color.gray25
        static let font: Font = Font.buttons1420Medium
        static let backgroundColor: Color = Color.stateActivePrimaryDefault
        static let disableForegroundColor: Color = Color.gray25
        static let disableFont: Font = Font.buttons1420Medium
        static let disableBackgroundColor: Color = Color.stateEnableGray200
    }
    
    private struct cancelInfo {
        static let foregroundColor: Color = Color.stateEnableGray400
        static let font: Font = Font.buttons1420Medium
        static let backgroundColor: Color = Color.gray25
    }
    
    private struct defaultSize {
        static let height: CGFloat = 42
    }
    
    init(title: String,
         type: ButtonType = .defaults(),
         height: CGFloat? = nil,
         cornerRadius: CGFloat? = nil
    ) {
        self._disabled = .constant(false)
        self.title = title
        self.type = type
        self.height = height ?? defaultSize.height
        self.cornerRadius = cornerRadius ?? defaultSize.height/2
    }
    
    init(title: String,
         type: ButtonType = .defaults(),
         height: CGFloat? = nil,
         cornerRadius: CGFloat? = nil,
         disabled: Binding<Bool>) {        self._disabled = disabled
        self.title = title
        self.type = type
        self.height = height ?? defaultSize.height
        self.cornerRadius = cornerRadius ?? defaultSize.height/2
    }
    
    var body: some View {
        
        switch type {
        case .defaults(let textColor, let font, let backgroundColor, let disableTextColor, let disableFont, let disableBackgroundColor):
            content(
                foregroundColor: disabled ? disableTextColor ?? defaultsInfo.disableForegroundColor : textColor ?? defaultsInfo.foregroundColor,
                font: disabled ? disableFont ?? defaultsInfo.disableFont : font ?? defaultsInfo.font,
                backgroundColor: disabled ? disableBackgroundColor ?? defaultsInfo.disableBackgroundColor : backgroundColor ?? defaultsInfo.backgroundColor
            )
        case .cancel(let textColor, let font, let backgroundColor):
            content(
                foregroundColor: textColor ?? cancelInfo.foregroundColor,
                font: font ?? cancelInfo.font,
                backgroundColor: backgroundColor ?? cancelInfo.backgroundColor
            )
        }
    }
    

    func content(foregroundColor: Color, font: Font, backgroundColor: Color) -> some View {
        HStack(alignment: .center, spacing: 0) {
            Text(title)
                .foregroundColor(foregroundColor)
                .font(font)
                .modifier(ButtonTextMinimunScaleModifier())
        }
        .frame(height: height)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
    }
    
}

struct CommonButton2_Previews: PreviewProvider {
    static var previews: some View {
        CommonButton2(title: "버튼타이틀", disabled: .constant(false))
    }
}
