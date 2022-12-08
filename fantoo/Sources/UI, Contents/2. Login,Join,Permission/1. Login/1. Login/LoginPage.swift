//
//  LoginView.swift
//  fantoo
//
//  Created by fns on 2022/04/26.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn
import BottomSheet

struct LoginPage : View {
    
    private struct sizeInfo {
        static let padding5: CGFloat = 5.0
        static let padding6: CGFloat = 6.0
        static let padding10: CGFloat = 10.0
        static let padding14: CGFloat = 14.0
        static let padding18: CGFloat = 18.0
        static let padding20: CGFloat = 20.0
        
        static let topPadding: CGFloat = 50.0
        static let bottomPadding: CGFloat = 56.0 + DefineSize.SafeArea.bottom
        
        static let logoSize: CGSize = CGSize(width: 174.0, height: 30.0)
        static let characterSize: CGSize = CGSize(width: 128.0, height: 133.0)
        static let warningSize: CGSize = CGSize(width: 16.0, height: 16.0)
        static let snsSize: CGSize = CGSize(width: 48.0, height: 48.0)
        
        static let logoBottomPadding: CGFloat = 54.0
        static let characterBottomPadding: CGFloat = 50.0
        
        static let dismissHeight: CGFloat = 42.0
        static let snsSpacing: CGFloat = 16.0
    }
    
    @State var showBottomSheetLanguageView = false
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var userManager = UserManager.shared
    @StateObject var vm = LoginViewModel()
    @State var lang: String = ""
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack(alignment: .top, content: {
            NavigationView {
                VStack(alignment: .center, spacing: 0) {
                    
                    Spacer().frame(height: sizeInfo.topPadding)
                    
                    Image("logo_login")
                        .resizable()
                        .frame(width: sizeInfo.logoSize.width, height: sizeInfo.logoSize.height)
                        .padding(.bottom, sizeInfo.logoBottomPadding)
                        
                    Image("character_login")
                        .resizable()
                        .frame(width: sizeInfo.characterSize.width, height: sizeInfo.characterSize.height)
                        .padding(.bottom, sizeInfo.characterBottomPadding)
                    
                    
                    //최근 로그인 계정 : 로그인한 이력이 없으면 감춘다.
                    if userManager.oldLoginType.count > 0 {
                        recentLoginAccountView
                        .padding(.bottom, sizeInfo.padding6)
                    }
                    
                    LoginSnsView(iconName: "btn_login_google", snsName: "google") {
                        vm.loginWithGoogle()
                    }.padding(.bottom, sizeInfo.padding6)
                    
                    LoginSnsView(iconName: "btn_login_apple", snsName: "Apple") {
                        vm.loginWithApple()
                    }.padding(.bottom, sizeInfo.padding18)
                    
                    HStack(alignment: .center, spacing: 0) {
                        Button {
                            vm.loginWithFacebook()
                        } label: {
                            Image("btn_logo_facebook")
                                .resizable()
                                .frame(width: sizeInfo.snsSize.width, height: sizeInfo.snsSize.height)
                                .padding(.trailing, sizeInfo.snsSpacing)
                        }
                        
                        Button {
                            vm.loginWithLine()
                        } label: {
                            Image("btn_logo_line")
                                .resizable()
                                .frame(width: sizeInfo.snsSize.width, height: sizeInfo.snsSize.height)
                                .padding(.trailing, sizeInfo.snsSpacing)
                        }
                        
                        Button {
                            vm.loginWithKakao()
                        } label: {
                            Image("btn_logo_kakaotalk")
                                .resizable()
                                .frame(width: sizeInfo.snsSize.width, height: sizeInfo.snsSize.height)
                                .padding(.trailing, sizeInfo.snsSpacing)
                        }
                        
                        Button {
                            vm.loginWithTwitter()
                        } label: {
                            Image("btn_logo_twitter")
                                .resizable()
                                .frame(width: sizeInfo.snsSize.width, height: sizeInfo.snsSize.height)
                        }

                        
                    }
                    .padding(.bottom, sizeInfo.padding14)
                    
                    //signup with email
    //                NavigationLink(destination: JoinPasswordPage(email: "hana_815@naver.com")) {
    //                    LoginEmailView()
    //                }
                    
                    NavigationLink(destination: EmailLoginPage()) {
                        LoginEmailView()
                    }
                    
    //                NavigationLink(destination: JoinAgreePage(email: "hana_815@naver.com", snsId: "", loginType: LoginType.email.rawValue, password: "a123456!")) {
    //                    LoginEmailView()
    //                }

                    
                    Spacer().frame(maxHeight: .infinity)
                    
                    Button {
                        userManager.isGuest = true
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("d_look_around".localized)
                            .font(Font.body21420Regular)
                            .foregroundColor(Color.gray870)
                            .frame(height: sizeInfo.dismissHeight, alignment: .center)
                            .padding(.horizontal, sizeInfo.padding10)
                            .padding(.bottom, sizeInfo.bottomPadding)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(Color.bgLightGray50)
                .edgesIgnoringSafeArea(.bottom)
                .navigationType(leftItems: [], rightItems: [.Trans], leftItemsForegroundColor: .black, rightItemsForegroundColor: .primary500, title: "", onPress: { buttonType in
                    showBottomSheetLanguageView = true
                })
                .navigationBarBackground {
                    Color.bgLightGray50
                }
                .statusBarStyle(style: .darkContent)
                
                .background(
                    NavigationLink("", isActive: $vm.showJoinPage) {
                        JoinAgreePage(email: "", snsId: vm.joinIdx, loginType: vm.joinType.rawValue, password: "")
                    }.hidden()
                )
                
                .bottomSheet(isPresented: $showBottomSheetLanguageView, height: DefineSize.Screen.Height, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
                    BSLanguageView(isShow: $showBottomSheetLanguageView, selectedLangName: $lang, selectedLangCode: languageManager.getTransCode(), isChangeAppLangCode: true, type: .nonType, onClick: { _ in
                    })
                })
            }
            
            .showAlert(isPresented: $vm.showAlert, type: .Default, title: vm.alertTitle, message: vm.alertMessage, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
            })
            
            LoadingViewInPage(loadingStatus: $vm.loadingStatus)
        })
    }
    
    var recentLoginAccountView: some View {
        HStack(alignment: .center, spacing: 0) {
            Image("icon_outline_danger")
                .renderingMode(.template)
                .resizable()
                .foregroundColor(Color.gray500)
                .frame(width: sizeInfo.warningSize.width, height: sizeInfo.warningSize.height)
            
            Group {
                Text(" ")
                Text("c_recent_login_account".localized)
                Text(" ")
                Text(userManager.oldLoginType)
            }
            .font(Font.caption11218Regular)
            .foregroundColor(Color.gray500)
        }
        .frame(height: sizeInfo.warningSize.height)
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
       LoginPage()
    }
}
