//
//  FavoriteSortView.swift
//  fantoo
//
//  Created by mkapps on 2022/06/13.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct MyClubSortView: View {
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let height: CGFloat = 50.0
        static let cellPadding: CGFloat = 16.0
        static let iconSize: CGSize = CGSize(width: 17, height: 16)
    }
    
    @State var title: String = ""
    @Binding var isOn:Bool
    let lineYn: Bool
    let myClubFavoriteCount: Int    // 즐겨찾기 클럽
    let myClubJoinCount: Int        // 가입한 클럽
    let onPress: () -> Void
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Text(isOn ? "\("j_favorite_club".localized) (\(myClubFavoriteCount))" : "\("g_club_joined".localized) (\(myClubJoinCount))")
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray500)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .fixedSize()
                
                Spacer()
                    .frame(maxWidth: .infinity)
                
                Text("j_favorite".localized)
                    .font(Font.body21420Regular)
                    .foregroundColor(Color.gray500)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                    .fixedSize()
                    .padding(.trailing)
                
                
                Toggle(isOn: $isOn, label: {
                })
                .onChange(of: isOn, perform: { newValue in
                    onPress()
                })
                .toggleStyle(SwitchToggleStyle(tint: Color.primary300))
                .frame(height:100)
                .fixedSize()
                .padding(.leading, -sizeInfo.padding)
            }
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
            
            ExDivider(color: Color.gray400, height: DefineSize.LineHeight)
                .opacity(0.12)
                .padding(EdgeInsets(top: sizeInfo.height - DefineSize.LineHeight, leading: 0, bottom: 0, trailing: 0))
        }
        .frame(height: sizeInfo.height)
        .frame(maxWidth: .infinity)
    }
}


struct MyClubSortView_Previews: PreviewProvider {
    static var previews: some View {
        MyClubSortView(isOn: .constant(true), lineYn: false, myClubFavoriteCount: 0, myClubJoinCount: 0, onPress: {
            
        })
            .previewLayout(.sizeThatFits)
    }
}
