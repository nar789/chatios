//
//  PasswordChangePage.swift
//  fantoo
//
//  Created by fns on 2022/05/26.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct PasswordChangePage : View {
    
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var vm = PasswordChangeViewModel()
    
    private struct sizeInfo {
        static let padding4: CGFloat = 4.0
        static let padding5: CGFloat = 5.0
        static let padding30: CGFloat = 30.0
        static let cellHeight: CGFloat = 80.0
        static let inputHeight: CGFloat = 42.0
        static let buttonWidth: CGFloat = 86.0
        static let buttonCornerRadius: CGFloat = 7.0
    }
    
    @State private var showPassword = false
    
    @State var password:String = ""
    @State var passwordCorrectStatus:CheckCorrectStatus = .Check
    @State var isKeyboardEnter: Bool = false
    
    @State var newPassword:String = ""
    @State var newPasswordCorrectStatus:CheckCorrectStatus = .Check
    
    @State var checkPassword:String = ""
    @State var checkPasswordCorrectStatus:CheckCorrectStatus = .Check
    
    @State var change: Bool = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            Spacer().frame(height: 16)
            VStack(spacing: 0) {
                currentPassword
                CustomTextField(text: $password, correctStatus: $passwordCorrectStatus, isKeyboardEnter: $isKeyboardEnter, placeholder: "h_current_pasword".localized, type: .Security)
                    .frame(maxWidth: .infinity)
                    .frame(height: sizeInfo.inputHeight)
                    .padding(.top, sizeInfo.padding4)
                    .onChange(of: password) { newValue in
                        vm.requestCheckPassword(integUid: UserManager.shared.uid, loginPw: password)
                        if password.count == 0 {
                            passwordCorrectStatus = .Check
                        }
                        else {
                            if newValue.validatePassword() && vm.isMatchePw {
                                passwordCorrectStatus = .Correct
                            }
                            else {
                                passwordCorrectStatus = .Wrong
                            }
                        }
                    }
                if password.count > 0 {
                    Text("se_num_keep_format".localized)
                        .font(Font.caption21116Regular)
                        .foregroundColor(passwordCorrectStatus == .Wrong ? .stateDanger : .gray600)
                        .opacity(passwordCorrectStatus == .Correct ? 0 : 1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, sizeInfo.padding5)
                }
            }
            
            
            Spacer().frame(height: 20)
            
            VStack(spacing: 0) {
                newPasswordStack
                    .frame(height: 28)
                    .padding(.bottom, sizeInfo.padding4)
                ZStack {
                    CustomTextField(text: $newPassword, correctStatus: $newPasswordCorrectStatus, isKeyboardEnter: $isKeyboardEnter, placeholder: "b_password_setting".localized, type: .Security)
                        .frame(maxWidth: .infinity)
                        .frame(height: sizeInfo.inputHeight)
                    //                    .padding(.top, sizeInfo.padding4)
                    //                    .padding(.horizontal, 20)
                        .padding(EdgeInsets(top: 0, leading:0, bottom: newPasswordCorrectStatus == .Correct ? 0 : sizeInfo.cellHeight - 36, trailing: 0))
                        .onChange(of: newPassword) { newValue in
                            
                            if newPassword.count == 0 {
                                newPasswordCorrectStatus = .Check
                            }
                            else {
                                if newValue.validatePassword() {
                                    newPasswordCorrectStatus = .Correct
                                }
                                else {
                                    newPasswordCorrectStatus = .Wrong
                                }
                            }
                        }
                    
                    Text("se_num_keep_format".localized)
                        .font(Font.caption21116Regular)
                        .foregroundColor(newPasswordCorrectStatus == .Wrong ? .stateDanger : .gray600)
                        .opacity(newPasswordCorrectStatus == .Correct ? 0 : 1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, sizeInfo.padding5)
                        .padding(EdgeInsets(top: newPasswordCorrectStatus == .Correct ? 0 : sizeInfo.cellHeight - 36, leading:0, bottom: 0, trailing: 0))
                }
                
                .frame(height: newPasswordCorrectStatus == .Correct ? 32 : 80, alignment: .bottom)
                .padding(EdgeInsets(top: 10, leading:0, bottom: 0, trailing: 0))
                //                .background(Color.red)
                
            }
            
            //            Spacer().frame(height: change ? 0 : 16)
            Spacer().frame(height: 16)
            
            
            CustomTextField(text: $checkPassword, correctStatus: $checkPasswordCorrectStatus, isKeyboardEnter: $isKeyboardEnter, placeholder: "b_password_setting".localized, type: .Security)
                .frame(maxWidth: .infinity)
                .frame(height: sizeInfo.inputHeight)
                .padding(.top, change ? 0 : sizeInfo.padding4)
                .onChange(of: checkPassword) { newValue in
                    
                    if checkPassword.count == 0 {
                        checkPasswordCorrectStatus = .Check
                    }
                    else {
                        if checkPassword == newPassword {
                            checkPasswordCorrectStatus = .Correct
                            self.change.toggle()
                            
                        }
                        else {
                            checkPasswordCorrectStatus = .Wrong
                        }
                    }
                }
            if newPasswordCorrectStatus == .Correct && checkPassword.count == 0 {
                Text("se_b_re_write_password".localized)
                    .font(Font.caption21116Regular)
                    .foregroundColor(checkPasswordCorrectStatus == .Wrong ? .stateDanger : .gray600)
                //                    .opacity(checkPassword.count == 0  ? 1 : 0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, sizeInfo.padding5)
            } else if newPasswordCorrectStatus == .Correct && checkPassword.count > 0 {
                Text("se_b_cannot_match_password".localized)
                    .font(Font.caption21116Regular)
                    .foregroundColor(checkPasswordCorrectStatus == .Wrong ? .stateDanger : .gray600)
                    .opacity(checkPasswordCorrectStatus == .Wrong ? 1 : 0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, sizeInfo.padding5)
            }
            
            Spacer()
            
            VStack {
                Button {
                    if checkPasswordCorrectStatus == .Correct && newPasswordCorrectStatus == .Correct && passwordCorrectStatus == .Correct  {
                        showPassword = true
                        vm.requestChangePassword(integUid: UserManager.shared.uid, loginPw: checkPassword)
                    }
                } label: {
                    
                    CommonButton(title: "b_change_password".localized, bgColor: checkPasswordCorrectStatus == .Correct && newPasswordCorrectStatus == .Correct && passwordCorrectStatus == .Correct ? Color.primary500 : Color.stateEnableGray200)
                }
            }
        }
        .onChange(of: isKeyboardEnter) { isKeyboardEntered in
            vm.requestCheckPassword(integUid: UserManager.shared.uid, loginPw: password)
            if password.count == 0 {
                passwordCorrectStatus = .Check
            }
            else {
                if vm.isMatchePw {
                    passwordCorrectStatus = .Correct
                }
                else {
                    passwordCorrectStatus = .Wrong
                }
            }
        }
        .padding(.horizontal, 20)
        .showAlert(isPresented: $showPassword, type: .Default, title: "b_change_password".localized, message: "se_b_alert_change_password".localized, detailMessage: "", buttons: ["a_no".localized, "h_confirm".localized], onClick: { buttonIndex in
            if buttonIndex == 1 {
                UserManager.shared.logout()
            }
        })
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "b_change_password".localized, onPress: { buttonType in
            print("onPress buttonType : \(buttonType)")
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }
    
    private var currentPassword: some View {
        HStack {
            Text("h_current_pasword".localized)
                .font(Font.caption11218Regular)
                .foregroundColor(Color.gray800)
            Spacer()
        }
    }
    
    private var newPasswordStack: some View {
        HStack {
            Text("s_new_password".localized)
                .font(Font.caption11218Regular)
                .foregroundColor(Color.gray800)
            Spacer()
        }
    }
}

struct PasswordChangePage_Previews: PreviewProvider {
    static var previews: some View {
        PasswordChangePage()
    }
}







