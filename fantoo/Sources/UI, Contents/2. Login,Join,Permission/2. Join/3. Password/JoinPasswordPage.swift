//
//  SettingPasswordView.swift
//  fantoo
//
//  Created by fns on 2022/05/09.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct JoinPasswordPage : View {
    
    private struct sizeInfo {
        static let padding4: CGFloat = 4.0
        static let padding8: CGFloat = 8.0
        static let padding12: CGFloat = 12.0
        static let padding17: CGFloat = 17.0
        
        static let textBottomPadding: CGFloat = 24.0
        
        static let inputHeight: CGFloat = 42.0
    }
    
    let email: String
    
    @State private var password = ""
    @State private var passwordConfirm = ""
    
    @State var passwordCorrectStatus:CheckCorrectStatus = .Check
    @State var passwordConfirmCorrectStatus:CheckCorrectStatus = .Check
    
    @State var isNextStep: Bool = false
    
    @State var isKeyboardEnter: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer().frame(height: DefineSize.Contents.TopPadding)
            
            Text("se_b_set_password".localized)
                .font(Font.title41824Medium)
                .foregroundColor(Color.gray870)
                .padding(.bottom, sizeInfo.textBottomPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            CustomTextField(text: $password, correctStatus: $passwordCorrectStatus, isKeyboardEnter: $isKeyboardEnter, placeholder: "b_password_setting".localized, type: .Security)
                .frame(maxWidth: .infinity)
                .frame(height: sizeInfo.inputHeight)
                .onChange(of: password) { newValue in
                    if password.count == 0 {
                        passwordCorrectStatus = .Check
                    }
                    else {
                        if newValue.validatePassword() {
                            passwordCorrectStatus = .Correct
                        }
                        else {
                            passwordCorrectStatus = .Wrong
                        }
                    }
                }
            
            if passwordCorrectStatus == .Wrong {
                Text("se_num_keep_format".localized)
                    .font(Font.caption21116Regular)
                    .foregroundColor(Color.stateDanger)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, sizeInfo.padding12)
                    .padding(.top, sizeInfo.padding4)
                    .padding(.bottom, sizeInfo.padding17)
            }
            else {
                Spacer().frame(height: sizeInfo.padding8)
            }
            
            
            CustomTextField(text: $passwordConfirm, correctStatus: $passwordConfirmCorrectStatus, isKeyboardEnter: $isKeyboardEnter, placeholder: "b_confirm_password".localized, type: .Security)
                .frame(maxWidth: .infinity)
                .frame(height: sizeInfo.inputHeight)
                .onChange(of: passwordConfirm) { newValue in
                    
                    if passwordConfirm.count == 0 {
                        passwordConfirmCorrectStatus = .Check
                    }
                    else {
                        if newValue == password {
                            passwordConfirmCorrectStatus = .Correct
                        }
                        else {
                            passwordConfirmCorrectStatus = .Wrong
                        }
                    }
                }
            
            Text(passwordConfirmCorrectStatus == .Wrong ? "se_b_cannot_match_password".localized : "")
                .font(Font.caption21116Regular)
                .foregroundColor(Color.stateDanger)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, sizeInfo.padding12)
                .padding(.top, sizeInfo.padding4)
                .padding(.bottom, sizeInfo.padding17)
            
            if passwordCorrectStatus == .Correct, passwordConfirmCorrectStatus == .Correct {
                Button {
                    isNextStep = true
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
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "".localized, onPress: { buttonType in
            print("onPress buttonType : \(buttonType)")
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
        
        .background(
            NavigationLink("", isActive: $isNextStep) {
                JoinAgreePage(email: email, snsId: "", loginType: LoginType.email.rawValue, password: password)
            }.hidden()
        )
    }
}

struct JoinPasswordPage_Previews: PreviewProvider {
    static var previews: some View {
        JoinPasswordPage(email: "dd@m.com")
    }
}
