//
//  GoToJoin.swift
//  fantoo
//
//  Created by fns on 2022/05/03.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import AttributedText

struct JoinEmailPage: View {
    
    private struct sizeInfo {
        static let padding4: CGFloat = 4.0
        static let padding8: CGFloat = 8.0
        static let padding12: CGFloat = 12.0
        
        static let textBottomPadding: CGFloat = 24.0
        static let noticeBottomPadding: CGFloat = 32.0
        
        static let inputHeight: CGFloat = 42.0
    }
    
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var vm = JoinEmailViewModel()
    
    @State private var email = ""
    @State var emailCorrectStatus:CheckCorrectStatus = .Check
    @State var isKeyboardEnter: Bool = false
    
    var body: some View {
        ZStack(alignment: .top, content: {
            VStack(alignment: .center, spacing: 0) {
                Spacer().frame(height: DefineSize.Contents.TopPadding)
                
                Text("a_join_email".localized)
                    .font(Font.title41824Medium)
                    .foregroundColor(Color.gray870)
                    .padding(.bottom, sizeInfo.textBottomPadding)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                CustomTextField(text: $email, correctStatus: $emailCorrectStatus, isKeyboardEnter: $isKeyboardEnter, placeholder: "a_write_email".localized)
                    .frame(maxWidth: .infinity)
                    .frame(height: sizeInfo.inputHeight)
                    //.padding(.bottom, sizeInfo.padding12)
                    .onChange(of: email) { newValue in
                        if email.count > 0 {
                            if newValue.validateEmail() {
                                emailCorrectStatus = .Correct
                            }
                            else {
                                emailCorrectStatus = .Wrong
                            }
                        }
                        else {
                            emailCorrectStatus = .Check
                        }
                    }
                
                if emailCorrectStatus == .Wrong {
                    Text("se_a_incorrect_email_format".localized)
                        .font(Font.caption11218Regular)
                        .foregroundColor(Color.stateDanger)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, sizeInfo.padding12)
                        .padding(.top, sizeInfo.padding4)
                        .padding(.bottom, sizeInfo.padding12)
                }
                else {
                    Spacer().frame(height: sizeInfo.padding12)
                }
                
                Text("se_d_recieve_cert_number".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray500)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                AttributedText {
                    let loginStr = "r_login".localized
                    let str = "se_a_login_already_registered".localized
                    let result = NSMutableAttributedString(string: str)
                    
                    result.addAttributes(
                        [.font: UIFont.caption11218Regular, .foregroundColor: UIColor.gray500],
                        range: NSRange(location: 0, length: str.count)
                    )
                    
                    result.addAttributes(
                        [.foregroundColor: UIColor.primary500],
                        range: (str as NSString).range(of: loginStr)
                    )
                    
                    return result
                }
                .padding(.bottom, sizeInfo.noticeBottomPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if emailCorrectStatus == .Correct {
                    Button {
                        vm.joinCheck(loginId: email)
                    } label: {
                        CommonButton(title: "d_next".localized, bgColor: Color.stateEnablePrimaryDefault)
                    }
                }
                else {
                    Button {
                    } label: {
                        CommonButton(title: "d_next".localized, bgColor: Color.stateDisabledGray200)
                    }
                    .disabled(true)
                }
                
                Spacer().frame(maxHeight: .infinity)
            }
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
            
            LoadingViewInPage(loadingStatus: $vm.loadingStatus)
        })
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "".localized, onPress: { buttonType in
            print("onPress buttonType : \(buttonType)")
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
        
        .showAlert(isPresented: $vm.showAlert, type: .Default, title: vm.alertTitle, message: vm.alertMessage, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
        })
        
        .background(
            NavigationLink("", isActive: $vm.isNextStep) {
                JoinCertificationEmailPage(email: email)
            }.hidden()
        )
        
        //.showBottomAlert(isPresented: $showBottomAlert, title: "인증번호가 전송되었습니다.")
        
        /*
        .showAlert(isPresented: $showUnAccount, type: .Default, title: "", message: "가입된 계정이 없습니다.", detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
            goToNext = true
            print("buttonIndex : \(buttonIndex)")
        })
        .showAlert(isPresented: $showWithdrawAccount, type: .Default, title: "", message: "탈퇴한 계정입니다. \n탈퇴 후 30일 이후부터 탈퇴한 \n계정으로 재가입 가능합니다.", detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
            print("buttonIndex : \(buttonIndex)")
        })
        .showAlert(isPresented: $showNotFoundAccount, type: .Default, title: "", message: "입력하신 이메일 정보를 찾을 수 없습니다.", detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
            print("buttonIndex : \(buttonIndex)")
        })
         */
    }
}



struct JoinEmailPage_Previews: PreviewProvider {
    static var previews: some View {
        JoinEmailPage()
    }
}
