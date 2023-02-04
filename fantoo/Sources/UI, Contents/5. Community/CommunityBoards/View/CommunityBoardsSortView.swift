//
//  CommunityBoardsSortView.swift
//  fantoo
//
//  Created by mkapps on 2022/06/14.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct CommunityBoardsSortView: View {
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let height: CGFloat = 50.0
        static let cellPadding: CGFloat = 16.0
        static let iconSize: CGSize = CGSize(width: 17, height: 16)
    }
    
    @Binding var isOn:Bool
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Text("se_c_sort_latest_visit".localized)
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
                    print("newValue : \(newValue)")
                })
                .toggleStyle(SwitchToggleStyle(tint: Color.primary300))
                .frame(height:100)
                .fixedSize()
                .padding(.leading, -sizeInfo.padding)
            }
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
            
            
            Divider()
                .background(Color.bgLightGray50)
                .frame(height: DefineSize.LineHeight)
                .padding(EdgeInsets(top: sizeInfo.height - DefineSize.LineHeight, leading: 0, bottom: 0, trailing: 0))
        }
        .frame(height: sizeInfo.height)
        .frame(maxWidth: .infinity)
    }
}


struct CommunityBoardsSortView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityBoardsSortView(isOn: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}

