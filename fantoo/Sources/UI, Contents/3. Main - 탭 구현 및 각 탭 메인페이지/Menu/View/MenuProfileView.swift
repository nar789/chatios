//
//  MenuInfoView.swift
//  fantoo
//
//  Created by mkapps on 2022/05/19.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct MenuProfileView: View {
    
    @StateObject var languageManager = LanguageManager.shared
    
    enum MenuProfileViewButtonType: Int {
        case EditProfile
        case ImageViewer
    }
    
    let profileUrl: String
    let nickName: String
    let onPress: () -> Void
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let cellHeight: CGFloat = 86.0
        static let cellPadding: CGFloat = 16.0
        static let iconSize: CGFloat = 24.0
    }
    
    var body: some View {
        ZStack {
            Button {
                onPress()
            } label: {
                HStack {
                    WebImage(url: URL(string: profileUrl.imageOriginalUrl))
                        .resizable()
                        .placeholder(Image(Define.ProfileDefaultImage))
                        .frame(width: DefineSize.Size.ProfileThumbnailM.width, height: DefineSize.Size.ProfileThumbnailM.height, alignment: .leading)
                        .clipped()
                        .cornerRadius(DefineSize.CornerRadius.ProfileThumbnailM)
                        .padding([.leading], sizeInfo.cellPadding)
                        .padding([.trailing], sizeInfo.padding)
                    
                    Text(nickName)
                        .font(Font.title51622Medium)
                        .foregroundColor(Color.gray870)
                        .padding([.trailing], sizeInfo.padding)
                        .fixedSize(horizontal: true, vertical: true)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    
                    Image("icon_outline_edit")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: sizeInfo.iconSize, height: sizeInfo.iconSize, alignment: .leading)
                        .padding([.trailing], sizeInfo.cellPadding)
                        .foregroundColor(.black)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .modifier(ListRowModifier(rowHeight: sizeInfo.cellHeight))
    }
}
