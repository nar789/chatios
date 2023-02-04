//
//  ClubSettingProfileView.swift
//  fantoo
//
//  Created by mkapps on 2022/06/22.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ClubSettingProfileView: View {
    
    enum ClubSettingInfoViewButtonType: Int {
        case EditProfile
        case ImageViewer
    }
    
    let profileUrl: String
    let nickName: String
    let membership: String
    
    let onPress: (ClubSettingInfoViewButtonType) -> Void
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let height: CGFloat = 50
        
        static let iconSize: CGFloat = 24.0
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Button(
                action: {
                    onPress(.ImageViewer)
                },
                label: {
                    WebImage(url: URL(string: profileUrl))
                        .resizable()
                        .placeholder(Image(Define.ProfileDefaultImage))
                        .frame(width: DefineSize.Size.ProfileThumbnailM.width, height: DefineSize.Size.ProfileThumbnailM.height, alignment: .leading)
                        .clipped()
                        .cornerRadius(DefineSize.CornerRadius.ProfileThumbnailS)
                        .padding([.trailing], sizeInfo.padding)
                }
            )
            .buttonStyle(.borderless)
            
            Button(
                action: {
                    onPress(.EditProfile)
                },
                label: {
                    VStack(spacing: 0) {
                        Text(nickName)
                            .font(Font.title51622Medium)
                            .foregroundColor(Color.gray900)
                            .padding([.trailing], sizeInfo.padding)
                            .fixedSize(horizontal: true, vertical: true)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        
                        Text(membership)
                            .font(Font.body21420Regular)
                            .foregroundColor(Color.gray400)
                            .padding([.trailing], sizeInfo.padding)
                            .fixedSize(horizontal: true, vertical: true)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                }
            )
            .buttonStyle(.borderless)
        }
        .frame(height: sizeInfo.height)
        .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
    }
}


struct ClubSettingProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ClubSettingProfileView(profileUrl: "", nickName: "name", membership: "a_general_membership".localized) { buttonType in
        }
        .previewLayout(.sizeThatFits)
    }
}
