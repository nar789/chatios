//
//  EditProfileProfileView.swift
//  fantoo
//
//  Created by mkapps on 2022/06/02.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct EditProfileProfileView: View {
    
    @StateObject var vm = EditProfileViewModel()
    @Binding var profileUrl: String
    
    //show
    @State private var showImagePicker = false
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let cellHeight: CGFloat = 150.0
        
        static let profileBottomPadding: CGFloat = 30.0
        
        static let rectangleSize: CGFloat = 24.0
        static let iconSize: CGFloat = 14.0
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack() {
                    WebImage(url: URL(string: profileUrl.imageOriginalUrl))
                        .resizable()
                        .placeholder(Image(Define.ProfileDefaultImage))
                        .frame(width: DefineSize.Size.ProfileThumbnailL.width, height: DefineSize.Size.ProfileThumbnailL.height, alignment: .leading)
                        .clipped()
                        .cornerRadius(DefineSize.CornerRadius.ProfileThumbnailM)
                    
                    Button {
                        showImagePicker = true
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
                .padding(.bottom, sizeInfo.profileBottomPadding)
            }
        }
        .modifier(ListRowModifier(rowHeight: sizeInfo.cellHeight))
        
        //alert
        .showAlert(isPresented: $vm.showAlert, type: .Default, title: vm.alertTitle, message: vm.alertMessage, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
        })
        
        //image picker
        .sheet(isPresented: $showImagePicker, content: {
            ImagePicker(sourceType: .photoLibrary, imageType: .ProfileImage) { success, image, message in
                
                if !success {
                    vm.alertMessage = message
                    vm.showAlert = true
                    return
                }
                
                vm.requestUploadImage(image: image) { url in
                    vm.requestUserInfoUpdate(userInfoType: .userPhoto, userPhoto: url) { success in
                        if success {
                            self.profileUrl = url
                        }
                    }
                }
            }
        })
    }
}
