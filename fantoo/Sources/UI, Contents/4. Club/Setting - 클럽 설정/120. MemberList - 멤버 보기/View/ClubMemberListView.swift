//
//  ClubMemberView.swift
//  fantoo
//
//  Created by mkapps on 2022/06/25.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ClubMemberListView: View {
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let padding3: CGFloat = 3.0
        static let padding5: CGFloat = 5.0
        
        static let cellHeight: CGFloat = 54.0
        static let cellPadding: CGFloat = 16.0
        
        static let lockIconSize: CGSize = CGSize(width: 20, height: 20)
        static let personIconSize: CGSize = CGSize(width: 12, height: 12)
        static let favoriteIconSize: CGSize = CGSize(width: 18, height: 18)
    }
        
    let image: String
    let text: String
    let memberLevel: String
    let onPress: () -> Void
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Button {
                    onPress()
                } label: {
                    WebImage(url: URL(string: image))
                        .resizable()
                        .placeholder(Image(Define.ProfileDefaultImage))
                    //.background(Color.stateEnablePrimaryDefault)
                        .frame(width: DefineSize.Size.ProfileThumbnailS.width, height: DefineSize.Size.ProfileThumbnailS.height)
                        .cornerRadius(DefineSize.CornerRadius.ClubThumbnailS)
                    
                    VStack(spacing: 0) {
                        Text(text)
                            .font(Font.body21420Regular)
                            .foregroundColor(Color.gray900)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        
                        Text(memberLevel)
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.gray500)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, sizeInfo.padding5)
                }
                .buttonStyle(.borderless)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
            
            ExDivider(color: Color.gray400, height: DefineSize.LineHeight)
                .opacity(0.12)
                .padding(EdgeInsets(top: sizeInfo.cellHeight - DefineSize.LineHeight, leading: 0, bottom: 0, trailing: 0))
        }
        .frame(height: sizeInfo.cellHeight)
    }
}


//struct ClubMemberListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClubMemberListView(text: "", onPress: {
//            
//        })
//        .previewLayout(.sizeThatFits)
//    }
//}
