//
//  ConfirmNumberView .swift
//  fantoo
//
//  Created by fns on 2022/05/06.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import AttributedText

struct JoinCertificationEmailPage: View {
    
    private struct sizeInfo {
        static let padding4: CGFloat = 4.0
        static let padding8: CGFloat = 8.0
        static let padding12: CGFloat = 12.0
        
        static let textBottomPadding: CGFloat = 24.0
        static let noticeBottomPadding: CGFloat = 32.0
        
        static let inputHeight: CGFloat = 42.0
    }
    
    let email:String
    
    
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var vm = JoinCertificationEmailViewModel()
    
    @State private var number = ""
    @State var numberCorrectStatus:CheckCorrectStatus = .Check
    @State var isKeyboardEnter: Bool = false
    
    
    var body: some View {
        ZStack(alignment: .top, content: {
            VStack(alignment: .center, spacing: 0) {
                Spacer().frame(height: DefineSize.Contents.TopPadding)
                
                Text("se_a_write_cert_number".localized)
                    .font(Font.title41824Medium)
                    .foregroundColor(Color.gray870)
                    .padding(.bottom, sizeInfo.textBottomPadding)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                CustomTextField(text: $number, correctStatus: $numberCorrectStatus, isKeyboardEnter: $isKeyboardEnter, placeholder: "a_wirte_cer_code".localized)
                    .frame(maxWidth: .infinity)
                    .frame(height: sizeInfo.inputHeight)
                    .padding(.bottom, sizeInfo.padding4)
                    .onChange(of: number) { newValue in
                        if number.count >= 4 {
                            numberCorrectStatus = .Correct
                        }
                        else {
                            numberCorrectStatus = .Check
                        }
                    }
                
                //남은 시간
                HStack(spacing: 0) {
                    Text(String(format: "%@ %@", "n_rest_time".localized, vm.timeRemaining.timeStringMMSS()))
                        .font(Font.caption21116Regular)
                        .foregroundColor(vm.timeRemaining == 0 ? Color.gray400 : Color.primary500)
                    
                    Button {
                        vm.sendEmail(loginId: email)
                        number = ""
                    } label: {
                        Text("j_resend".localized)
                            .underline()
                            .font(Font.caption21116Regular)
                            .foregroundColor(Color.primary500)
                            .opacity(vm.timeRemaining > 0 ? 0 : 1)
                            .padding(.leading, sizeInfo.padding8)
                    }
                    
                    Spacer().frame(maxWidth: .infinity)
                }
                .padding(.bottom, sizeInfo.padding12)
                
                //notice
                Text(String(format: "se_a_cert_number_will_sent".localized, email))
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray500)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("se_j_cert_number_will_expire".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray500)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, sizeInfo.noticeBottomPadding)
                
                if numberCorrectStatus == .Correct {
                    Button {
                        vm.sendEmailNumberCheck(authCode: number, loginId: email)
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
        
        .onAppear(perform: {
            vm.startRemaining()
        })
        
        .showAlert(isPresented: $vm.showAlert, type: .Default, title: vm.alertTitle, message: vm.alertMessage, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
        })
        
        .background(
            NavigationLink("", isActive: $vm.isNextStep) {
                JoinPasswordPage(email: email)
            }.hidden()
        )
    }
}

struct JoinCertificationEmailPage_Previews: PreviewProvider {
    static var previews: some View {
        JoinCertificationEmailPage(email: "asdaf@naver.com")
    }
}
