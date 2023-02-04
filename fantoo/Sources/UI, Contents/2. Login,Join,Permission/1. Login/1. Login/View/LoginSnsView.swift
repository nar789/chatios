//
//  LoginSnsView.swift
//  fantoo
//
//  Created by Benoit Lee on 2022/07/05.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct LoginSnsView : View {
    
    @StateObject var languageManager = LanguageManager.shared
    
    var iconName: String
    var snsName: String
    
    let onPress: () -> Void
    
    private struct sizeInfo {
        static let horizontalPadding: CGFloat = 14.0
        static let padding: CGFloat = 30
        
        
        static let roundImageSize: CGSize = CGSize(width: 276.0, height: 42.0)
        static let iconSize: CGSize = CGSize(width: 24.0, height: 24.0)
    }
    
    var body: some View {
        Button {
            onPress()
        } label: {
            ZStack {
                HStack(spacing: 0) {
                    Image(iconName)
                        .resizable()
                        .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height)
                        .padding(.leading, sizeInfo.horizontalPadding)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 0) {
                    Text(snsName)
                        .font(Font.body21420Regular)
                        .foregroundColor(Color.gray870)
                    
                    Text("r_continue_at".localized)
                        .font(Font.body21420Regular)
                        .foregroundColor(Color.gray870)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(width: sizeInfo.roundImageSize.width, height: sizeInfo.roundImageSize.height)
            .background(Color.gray25.cornerRadius(sizeInfo.roundImageSize.height / 2 ))
            .shadow(color: Color.gray100, radius: 2, x: 0, y: 2)
        }
    }
}

struct LoginSnsView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSnsView(iconName: "btn_login_google", snsName: "google") {
        }
        .previewLayout(.sizeThatFits)
    }
}
