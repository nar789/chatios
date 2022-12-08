//
//  ClubProfileSettingProfileView.swift
//  fantoo
//
//  Created by mkapps on 2022/06/23.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ClubMyProfileSettingProfileView: View {
    
    let profileUrl: String
    let onPress: () -> Void
    
    @StateObject var vm = ClubSettingViewModel()

    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let cellHeight: CGFloat = 130.0
        
        static let profileBottomPadding: CGFloat = 30.0
        
        static let rectangleSize: CGFloat = 24.0
        static let iconSize: CGFloat = 14.0
    }
    
    var body: some View {
        HStack(alignment: .center) {
            ZStack() {
                WebImage(url: URL(string: profileUrl))
                    .resizable()
                    .placeholder(Image(Define.ProfileDefaultImage))
                    .frame(width: DefineSize.Size.ProfileThumbnailL.width, height: DefineSize.Size.ProfileThumbnailL.height, alignment: .leading)
                    .clipped()
                    .cornerRadius(DefineSize.CornerRadius.ClubThumbnailM)
                
                Button {
                    onPress()
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.gray25)
                            .frame(width: sizeInfo.rectangleSize, height: sizeInfo.rectangleSize)
                            .shadow(color: Color.gray100, radius: 2, x: 0, y: 2)
                        
                        Image("icon_fill_camera")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: sizeInfo.iconSize, height: sizeInfo.iconSize, alignment: .center)
                            .foregroundColor(.black)
                    }
                    .padding(EdgeInsets(top: DefineSize.Size.ProfileThumbnailL.height - sizeInfo.rectangleSize, leading: DefineSize.Size.ProfileThumbnailL.width - sizeInfo.rectangleSize, bottom: 0, trailing: 0))
                }
                .buttonStyle(.borderless)
            }
            .frame(height: DefineSize.Size.ProfileThumbnailL.height)
        }
        .modifier(ListRowModifier(rowHeight: sizeInfo.cellHeight))
  
    }
}

//struct ClubMyProfileSettingProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClubMyProfileSettingProfileView(profileUrl: $profileUrl) {
//        }
//        .previewLayout(.sizeThatFits)
//    }
//}

