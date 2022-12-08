//
//  PermissionText.swift
//  fantoo
//
//  Created by fns on 2022/06/15.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct PermissionText : View {
    
    var icon : String
    var description : String
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let stackHeight: CGFloat = 60.0
        static let descriptionPadding: CGFloat = 25.0
        static let spacerWidth: CGFloat = 5.0
    }
    
    var body: some View {
        ZStack {
            HStack {
                Text(icon)
                    .font(Font.title5Roboto1622Medium)
                    .foregroundColor(Color.gray500)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: sizeInfo.descriptionPadding, trailing: 0))
                
                Spacer().frame(width: sizeInfo.spacerWidth)
                
                Text(description)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray500)
                    .lineLimit(3)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: sizeInfo.descriptionPadding, trailing: 0))
            }
        }
        .frame(height: sizeInfo.stackHeight)
    }
}


struct PermissionText_Previews: PreviewProvider {
    static var previews: some View {
        PermissionText(icon: "•", description: "해당 기능을 이용하실 때 접근 권한 요청을 드리며, \n접근 권한에 대해 허용하지 않아도 기본 서비스의 이용은 가능합니다.")
    }
}
