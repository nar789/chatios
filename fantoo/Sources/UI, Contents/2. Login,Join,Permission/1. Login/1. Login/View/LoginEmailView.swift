//
//  SignupLongItemView.swift
//  fantoo
//
//  Created by fns on 2022/04/26.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct LoginEmailView: View {
    
    private struct sizeInfo {
        static let padding: CGFloat = 10
        
        static let viewSize: CGSize = CGSize(width: 240.0, height: 42.0)
        static let iconSize: CGSize = CGSize(width: 24.0, height: 24.0)
        
        static let cornerRadius: CGFloat = 10.0
    }
    
    @StateObject var languageManager = LanguageManager.shared
    
    var body: some View {
        HStack(alignment: .center) {
            HStack(alignment: .center) {
                Image("Icon_email_login")
                    .resizable()
                    .scaledToFill()
                    .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height)
                    .foregroundColor(Color.gray800)
                    .padding(.leading, sizeInfo.padding)
                
                Text("a_continue_email".localized)
                    .font(Font.body21420Regular)
                    .foregroundColor(Color.gray800)
            }
        }
        .frame(width: sizeInfo.viewSize.width, height: sizeInfo.viewSize.height, alignment: .center)
        .background(Color.bgLightGray50)
        .overlay(
            RoundedRectangle(cornerRadius: sizeInfo.cornerRadius)
            .stroke(Color.gray100, lineWidth: 0.5)
        )
    }
}

struct LoginEmailView_Previews: PreviewProvider {
    static var previews: some View {
        LoginEmailView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
