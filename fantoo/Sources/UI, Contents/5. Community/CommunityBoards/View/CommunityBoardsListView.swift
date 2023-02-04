//
//  CommunityBoardsListView.swift
//  fantoo
//
//  Created by mkapps on 2022/06/14.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct CommunityBoardsListView: View {
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let padding5: CGFloat = 5.0
        
        static let height: CGFloat = 48.0
        static let cellPadding: CGFloat = 16.0
        
        static let favoriteIconSize: CGSize = CGSize(width: 18, height: 18)
    }
    
    enum MyClubListButtonType {
        case Info
        case Favorite
    }
    
    let onPress: (MyClubListButtonType) -> Void
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Button {
                    onPress(.Info)
                } label: {
                    Text("HOT")
                        .font(Font.body21420Regular)
                        .foregroundColor(Color.gray870)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    //                    .fixedSize()
//                        .padding(.leading, 0)
//                        .background(Color.red)
                }
                .buttonStyle(.borderless)
                
                Button {
                    onPress(.Favorite)
                } label: {
                    Image("icon_fill_bookmark")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: sizeInfo.favoriteIconSize.width, height:  sizeInfo.favoriteIconSize.height, alignment: .center)
                        .foregroundColor(Color.stateActiveSecondaryDefault)
                }
                .buttonStyle(.borderless)
            }
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
            
            Divider()
                .background(Color.bgLightGray50)
                .frame(height: DefineSize.LineHeight, alignment: .bottom)
                .padding(EdgeInsets(top: sizeInfo.height - DefineSize.LineHeight, leading: 0, bottom: 0, trailing: 0))
        }
        .frame(maxWidth: .infinity)
        .frame(height: sizeInfo.height)
    }
}


struct CommunityBoardsListView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityBoardsListView(onPress: { buttonType in
            
        })
            .previewLayout(.sizeThatFits)
    }
}

