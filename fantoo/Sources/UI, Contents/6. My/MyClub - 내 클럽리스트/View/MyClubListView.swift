//
//  FavoriteListView.swift
//  fantoo
//
//  Created by mkapps on 2022/06/13.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct MyClubListView: View {
    
    @StateObject var vm = ClubSettingViewModel()
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let padding3: CGFloat = 3.0
        static let padding5: CGFloat = 5.0
        
        static let height: CGFloat = 54.0
        static let cellPadding: CGFloat = 16.0
        
        static let lockIconSize: CGSize = CGSize(width: 20, height: 20)
        static let personIconSize: CGSize = CGSize(width: 12, height: 12)
        static let favoriteIconSize: CGSize = CGSize(width: 18, height: 18)
    }
    
    let clubName: String
    let openYn: Bool
    let profileImg: String
    let memberCount: Int
    let favoriteYn: Bool
    let onPress: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
            } label: {
                ZStack {
                    WebImage(url: URL(string: profileImg))
                        .resizable()
                        .placeholder(Image(Define.ProfileDefaultImage))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    //.background(Color.stateEnablePrimaryDefault)
                        .cornerRadius(DefineSize.CornerRadius.ProfileThumbnailS)
                    
                    Image(openYn ? "" : "icon_fill_private")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: sizeInfo.lockIconSize.width, height:  sizeInfo.lockIconSize.height, alignment: .center)
                        .foregroundColor(Color.gray25)
                }
                .frame(width: DefineSize.Size.ClubThumbnailS.width, height: DefineSize.Size.ClubThumbnailS.height)
                
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text(clubName)
                            .font(Font.buttons1420Medium)
                            .foregroundColor(Color.gray900)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .fixedSize()
                        
                        Text("a_operate".localized)
                            .font(Font.caption21116Regular)
                            .foregroundColor(Color.gray25)
                        //                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .fixedSize()
                            .padding(.horizontal, 5)
                            .padding(.vertical, 1)
                            .background(Color.primary300)
                            .clipShape(Capsule())
                            .padding(.leading, sizeInfo.padding5)
                        
                        Spacer()
                            .frame(maxWidth: .infinity)
                    }
                    
                    HStack(spacing: 0) {
                        Image("icon_fill_my_t")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: sizeInfo.personIconSize.width, height:  sizeInfo.personIconSize.height, alignment: .center)
                            .foregroundColor(Color.gray500)
                        
                        Text("\(memberCount)")
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.gray500)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        //                        .fixedSize()
                            .padding(.leading, sizeInfo.padding3)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, sizeInfo.padding5)
            }
            .buttonStyle(.borderless)
            
            Button {
                onPress()
            } label: {
                Image("icon_fill_bookmark")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: sizeInfo.favoriteIconSize.width, height:  sizeInfo.favoriteIconSize.height, alignment: .center)
                    .foregroundColor(vm.favoriteYn ? Color.stateActiveSecondaryDefault : Color.stateEnableGray200)
            }
            .buttonStyle(.borderless)
        }
        .frame(maxWidth: .infinity)
        .frame(height: sizeInfo.height)
        .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
        
    }
}
