//
//  AuthBox.swift
//  fantoo
//
//  Created by fns on 2022/05/02.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct PermissionDetailView : View {
    
    var icon : String
    var title : String
    var description : String
    var bgColor : Color
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let textPadding: CGFloat = 5.0
        static let height: CGFloat = 50.0
        static let cornerRadius: CGFloat = 20.0
        static let iconSize: CGSize = CGSize(width: 50, height: 50)
        static let iconCornerRadius: CGFloat = 25.0
        static let lineWidth: CGFloat = 0.5
    }
    
    var body: some View {
        HStack(spacing: sizeInfo.padding) {
            Image(icon)
                .renderingMode(.template)
                .resizable()
                .padding(sizeInfo.padding)
                .foregroundColor(Color.primary500)
                .clipShape(Circle())
                .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height)
                .background(Color.gray50)
                .overlay(
                    Circle().strokeBorder(Color.gray100, lineWidth: sizeInfo.lineWidth)
                )
                .cornerRadius(sizeInfo.iconCornerRadius)
//                .padding(.all, 10)
                
            
            VStack(alignment: .leading, spacing: 0){
                Divider().opacity(0)
                Rectangle().frame(height: 0)
                Text(title)
                    .fontWeight(.bold)
                    .font(Font.buttons1420Medium)
                    .foregroundColor(Color.gray870)
                
                Spacer().frame(height: sizeInfo.textPadding)
                
                Text(description)
                    .foregroundColor(Color.gray600)
                    .font(Font.caption11218Regular)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .background(bgColor)
        .cornerRadius(sizeInfo.cornerRadius)
    }
}

struct PermissionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionDetailView(icon: "icon_camera", title: "", description: "", bgColor: Color.clear)
    }
}
