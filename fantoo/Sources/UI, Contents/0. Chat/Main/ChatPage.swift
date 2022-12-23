//
//  ChatPage.swift
//  fantoo
//
//  Created by kimhongpil on 2022/11/15.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct ChatPage: View {
    
    @Binding var showChatComposerPage: Bool;
    
    private struct sizeInfo {
        static let topPadding: CGFloat = 150.0
        static let bottomPadding: CGFloat = 56.0 + DefineSize.SafeArea.bottom
        
        static let buttonTopPadding: CGFloat = 40.0
        static let buttonWidth:CGFloat = 120.0
        
        static let characterSize: CGSize = CGSize(width: 118.0, height: 124.0)
    }
    
    @StateObject var userManager = UserManager.shared
    @State var showBottomSheetLanguageView = false
    @StateObject var languageManager = LanguageManager.shared
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 0) {
                if !userManager.isLogin {
                    needToLoginView
                } else {
                    listView
                }
                
            }
            .frame(maxWidth:.infinity, alignment: .top)
            .background(Color.bgLightGray50)
            .edgesIgnoringSafeArea(.bottom)
            .statusBarStyle(style: .darkContent)
            .onAppear {
                print("isLogin : \(userManager.isLogin)")
            }
        }
        .navigationBarBackground {
            Color.gray25
        }
    }
    
    var listView: some View {
        
        List(0..<10) { i in
            
            ChatListRowView()
                //.listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                .onTapGesture {
                    print("open chat room")
                    showChatComposerPage = true
                }
            
        }.listStyle(.plain)
            .padding(.top,14)
        
    }
    
    var needToLoginView: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: sizeInfo.topPadding)
            
            Image("character_main2")
                .resizable()
                .frame(width: sizeInfo.characterSize.width, height: sizeInfo.characterSize.height)
            Text("로그인 하여 채팅을 시작해 보세요.\n팬투 회원이라면 모두 가능합니다.")
                .multilineTextAlignment(.center)
                .foregroundColor(Color.gray870)
                .font(Font.body21420Regular)
            
            Button {
                print("login start")
                UserManager.shared.start()
            } label: {
                CommonButton(title: "r_login".localized, bgColor: Color.stateActivePrimaryDefault)
                    .padding(.bottom, sizeInfo.bottomPadding)
                    .padding(.top, sizeInfo.buttonTopPadding)
                    .frame(maxWidth: sizeInfo.buttonWidth, alignment: .bottom)
            }
            
            Spacer()
        }
    }
}
