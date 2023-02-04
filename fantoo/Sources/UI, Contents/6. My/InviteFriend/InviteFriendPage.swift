//
//  InviteFriendPage.swift
//  fantoo
//
//  Created by mkapps on 2022/05/21.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import AttributedText
import UniformTypeIdentifiers

struct InviteFriendPage: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let padding30: CGFloat = 30.0
        
        static let inputHeight: CGFloat = 42.0
        static let buttonWidth: CGFloat = 86.0
        static let buttonCornerRadius: CGFloat = 7.0
    }
    
    @Binding var referralCode: String
    @Binding var useReferralCode: String
    var checkPassed12Hours: Bool        //가입한지 12시간이 지났는지 체크.
    
    @State var registReferralCode: String = ""
    @State var correctStatus:CheckCorrectStatus = .Check
    @State var isKeyboardEnter: Bool = false
    
    @StateObject var vm = InviteFriendViewModel()
    
    //alert
    @State var showAlertSuccess: Bool = false
    
    var body: some View {
        
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                Text("n_my_referral_code".localized)
                    .font(Font.buttons1420Medium)
                    .foregroundColor(.gray900)
                    .padding(.bottom, sizeInfo.padding)
                
                HStack(spacing: 0) {
                    Text(referralCode)
                        .font(Font.body21420Regular)
                        .foregroundColor(Color.primary500)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding(.horizontal, sizeInfo.padding)
                        .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(Color.gray100, lineWidth: DefineSize.LineHeight)
                        )
                    
                    Button {
                        vm.showAlert = true
                        vm.alertMessage = "se_c_share_friend_referral_code".localized
                        
                        UIPasteboard.general.setValue("\(referralCode)",
                                   forPasteboardType: UTType.plainText.identifier)
                    } label: {
                        Text("b_copy".localized)
                            .font(Font.buttons1420Medium)
                            .foregroundColor(Color.gray25)
                            .modifier(ButtonTextMinimunScaleModifier())
                    }
                    .buttonStyle(.borderless)
                    .frame(maxHeight: .infinity)
                    .frame(width: sizeInfo.buttonWidth)
                    .background(Color.stateActivePrimaryDefault.cornerRadius(sizeInfo.buttonCornerRadius))
                    .padding(.leading, sizeInfo.padding)
                }
                .frame(maxWidth: .infinity)
                .frame(height: sizeInfo.inputHeight)
                
                Text("se_c_recommend_at_friend".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(.gray800)
                    .padding(.top, sizeInfo.padding)
                
                AttributedText {
                    let fanit150 = "150" + "p_fanit".localized
                    let fanit500 = "500" + "p_fanit".localized
                    let str = String(format: "se_s_rewards_fanit_referral_code".localized, fanit150, fanit500)
                    let result = NSMutableAttributedString(string: str)
                    
                    result.addAttributes(
                        [.font: UIFont.caption11218Regular, .foregroundColor: UIColor.gray500],
                        range: NSRange(location: 0, length: str.count)
                    )
                    
                    result.addAttributes(
                        [.foregroundColor: UIColor.primary500],
                        range: (str as NSString).range(of: fanit150)
                    )
                    
                    result.addAttributes(
                        [.foregroundColor: UIColor.primary500],
                        range: (str as NSString).range(of: fanit500)
                    )
                    
                    return result
                }
                
                //가입한지 12시간이 지나지 않았고, 추천인 코드 등록을 하지 않았다면 노출
                if !checkPassed12Hours, useReferralCode.count == 0 {
                    Text("n_my_referral_code".localized)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(.gray900)
                        .padding(.bottom, sizeInfo.padding)
                        .padding(.top, sizeInfo.padding30)
                    
                    HStack(spacing: 0) {
                        CustomTextField(text: $registReferralCode, correctStatus: $correctStatus, isKeyboardEnter: $isKeyboardEnter, placeholder: "se_c_write_referral_code".localized)
                            .onChange(of: registReferralCode) { newValue in
                                if registReferralCode.count > 4 {
                                    correctStatus = .Correct
                                }
                                else {
                                    correctStatus = .Check
                                }
                            }
                        
                        Button {
                            if correctStatus == .Correct {
                                vm.requestMyReferral(integUid: UserManager.shared.uid, referralCode: registReferralCode)
                            }
                        } label: {
                            Text("d_registration".localized)
                                .font(Font.buttons1420Medium)
                                .foregroundColor(Color.gray25)
                                .modifier(ButtonTextMinimunScaleModifier())
                        }
                        .buttonStyle(.borderless)
                        .frame(maxHeight: .infinity)
                        .frame(width: sizeInfo.buttonWidth)
                        .background(correctStatus == .Correct ? Color.stateActivePrimaryDefault.cornerRadius(sizeInfo.buttonCornerRadius) : Color.stateDisabledGray200.cornerRadius(sizeInfo.buttonCornerRadius))
                        .padding(.leading, sizeInfo.padding)
                        .disabled(correctStatus == .Correct ? false : true)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: sizeInfo.inputHeight)
                    
                    Text("se_h_valid_12hours".localized)
                        .font(Font.caption11218Regular)
                        .foregroundColor(.gray500)
                        .padding(.top, sizeInfo.padding)
                }
            }
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
            .modifier(ScrollViewLazyVStackModifier())
        }
        .onAppear(perform: {
            //내 추천인 코드가 발급되지 않았다면 발급하자.
            
            print("checkPassed12Hours : \(checkPassed12Hours)")
            print("useReferralCode : \(useReferralCode)")
            
            if referralCode.count == 0 {
                vm.requestMyReferralCreate(integUid: UserManager.shared.uid)
            }
        })
        //추천인 코드가 발급되었다면 갱신시켜주자.
        .onChange(of: vm.referralCode, perform: { newValue in
            if vm.referralCode.count > 0 {
                referralCode = vm.referralCode
            }
        })
        
        //alert
        .showAlert(isPresented: $vm.showAlert, type: .Default, title: "", message: vm.alertMessage, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
        })
        .showAlertSimple(isPresented: $vm.showSuccessAlert, type: .Default, title: "se_c_referral_code_succeess_registered".localized, message: String(format: "se_p_fanit_paid_and_check".localized, "500"), detailMessage: "") { index in
            useReferralCode = registReferralCode
            
            presentationMode.wrappedValue.dismiss()
        }
        
        .background(Color.gray25)
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "c_invite_friend".localized, onPress: { buttonType in
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }
}


//struct InviteFriendPage_Previews: PreviewProvider {
//    static var previews: some View {
//        InviteFriendPage()
//    }
//}
