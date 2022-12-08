//
//  FindPasswordPage.swift
//  fantoo
//
//  Created by fns on 2022/05/03.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//


import SwiftUI

struct FindPasswordPage: View {
    
    private struct sizeInfo {
        static let padding8: CGFloat = 8.0
        static let padding12: CGFloat = 12.0
        
        static let textBottomPadding: CGFloat = 24.0
        static let noticeBottomPadding: CGFloat = 32.0
        
        static let inputHeight: CGFloat = 42.0
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var vm = FindPasswordViewModel()
    
    @State private var email = ""
    @State var emailCorrectStatus:CheckCorrectStatus = .Check
    @State var isKeyboardEnter: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer().frame(height: DefineSize.Contents.TopPadding)
            
            Text("se_b_lost_password".localized)
                .font(Font.title41824Medium)
                .foregroundColor(Color.gray870)
                .padding(.bottom, sizeInfo.textBottomPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            CustomTextField(text: $email, correctStatus: $emailCorrectStatus, isKeyboardEnter: $isKeyboardEnter, placeholder: "a_write_email".localized)
                .frame(maxWidth: .infinity)
                .frame(height: sizeInfo.inputHeight)
                .padding(.bottom, sizeInfo.padding12)
                .onChange(of: email) { newValue in
                    if email.count > 4 {
                        emailCorrectStatus = .Correct
                    }
                    else {
                        emailCorrectStatus = .Check
                    }
                }
            
            Text("se_b_wrtie_email_for_change_password".localized)
                .font(Font.caption11218Regular)
                .foregroundColor(Color.gray500)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("se_a_tmp_password_will_sent".localized)
                .font(Font.caption11218Regular)
                .foregroundColor(Color.gray500)
                .padding(.bottom, sizeInfo.noticeBottomPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if emailCorrectStatus == .Correct {
                Button {
                    vm.tempPassword(loginId: email)
                } label: {
                    CommonButton(title: "a_send_email".localized, bgColor: Color.stateEnablePrimaryDefault)
                }
            }
            else {
                Button {
                } label: {
                    CommonButton(title: "a_send_email".localized, bgColor: Color.stateDisabledGray200)
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
        
        .showAlert(isPresented: $vm.showAlert, type: .Default, title: vm.alertTitle, message: vm.alertMessage, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
        })
        
        .showAlert(isPresented: $vm.isNextStep, type: .Default, title: "", message: "se_a_sent_cert_number".localized, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
            self.presentationMode.wrappedValue.dismiss()
        })
    }
}



struct FindPasswordPage_Previews: PreviewProvider {
    static var previews: some View {
        FindPasswordPage()
    }
}
