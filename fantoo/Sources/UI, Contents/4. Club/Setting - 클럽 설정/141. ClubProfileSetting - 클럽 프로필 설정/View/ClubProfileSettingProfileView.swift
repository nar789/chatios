//
//  ClubProfileSettingProfileView.swift
//  fantoo
//
//  Created by Benoit Lee on 2022/06/30.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ClubProfileSettingProfileView: View {
    
    enum ClubProfileSettingProfileViewButtonType: Int {
        case Profile
        case Background
    }
    
    @State var showBackgoundImagePicker = false
    @State var showProfileImagePicker = false
    
    @StateObject var vm = ClubInfoSettingViewModel()
    
    let profileUrl: String
    let backgroundUrl: String
    @Binding var imgState: Bool
    
    let onPress: (ClubProfileSettingProfileViewButtonType) -> Void
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        
        static let backgroundRatio: CGFloat = 0.37
        static let backgroundBottomPadding: CGFloat = 16.0
        static let backgroundCameraIconSize: CGFloat = 34.0
        
        static let height: CGFloat = 50
        
        static let profileSize: CGFloat = 54.0
        static let rectangleSize: CGFloat = 18.0
        static let iconSize: CGFloat = 12.0
    }
    
    var body: some View {
        ZStack {
            Button(
                action: {
                    onPress(.Background)
                    showBackgoundImagePicker = true
                },
                label: {
                    ZStack {
                        WebImage(url: URL(string: backgroundUrl))
                            .resizable()
                            .frame(width: DefineSize.Screen.Width, height: DefineSize.Screen.Width * sizeInfo.backgroundRatio, alignment: .leading)
                        
                        if vm.bgImg.count < 0 {
                            Image("icon_outline_camera")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(Color.stateEnableGray400)
                                .frame(width: sizeInfo.backgroundCameraIconSize, height: sizeInfo.backgroundCameraIconSize, alignment: .center)
                        }
                    }
                    .background(Color.gray50)
                    .padding(.bottom, sizeInfo.backgroundBottomPadding)
                }
            )
            .buttonStyle(.borderless)
            
            ZStack() {
                WebImage(url: URL(string: profileUrl))
                    .resizable()
                    .placeholder(Image(Define.ProfileDefaultImage))
                    .frame(width: DefineSize.Size.ClubThumbnailM.width, height: DefineSize.Size.ClubThumbnailM.height, alignment: .leading)
                    .clipped()
                    .cornerRadius(DefineSize.CornerRadius.ClubThumbnailM)
                
                Button {
                    onPress(.Profile)
                   showProfileImagePicker = true
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
                    .padding(EdgeInsets(top: DefineSize.Size.ClubThumbnailM.height - sizeInfo.rectangleSize, leading: DefineSize.Size.ClubThumbnailM.width - sizeInfo.rectangleSize, bottom: 0, trailing: 0))
                }
                .buttonStyle(.borderless)
            }
            .frame(width: DefineSize.Size.ClubThumbnailM.width, height: DefineSize.Size.ClubThumbnailM.height)
            .padding(.trailing, DefineSize.Screen.Width - DefineSize.Size.ClubThumbnailM.width - DefineSize.Contents.HorizontalPadding)
            .padding(.leading, DefineSize.Contents.HorizontalPadding)
            .padding(.top, DefineSize.Screen.Width * sizeInfo.backgroundRatio - sizeInfo.profileSize + sizeInfo.backgroundBottomPadding)
        }
        .frame(height: DefineSize.Screen.Width * sizeInfo.backgroundRatio + sizeInfo.backgroundBottomPadding)
 
    }
}


//struct ClubProfileSettingProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClubProfileSettingProfileView(profileUrl: "", nickName: "name", membership: "a_general_membership".localized) { buttonType in
//        }
//        .previewLayout(.sizeThatFits)
//    }
//}
