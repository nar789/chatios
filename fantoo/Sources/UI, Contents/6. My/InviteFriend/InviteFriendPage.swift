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
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let padding30: CGFloat = 30.0
        
        static let inputHeight: CGFloat = 42.0
        static let buttonWidth: CGFloat = 86.0
        static let buttonCornerRadius: CGFloat = 7.0
    }
    
    @State var referralCode:String = ""
    @State var correctStatus:CheckCorrectStatus = .Check
    @State var isKeyboardEnter: Bool = false
    
    @StateObject var vm = InviteFriendViewModel()
    
    //alert
    @State var showAlertCopy: Bool = false
    @State var showAlertInvalidReferralCode: Bool = false
    @State var showAlertNoValueEntered: Bool = false
    @State var showAlertCannotUsedYourCode: Bool = false
    @State var showAlertSuccess: Bool = false
    
    var body: some View {
        
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                Text("n_my_referral_code".localized)
                    .font(Font.buttons1420Medium)
                    .foregroundColor(.gray900)
                    .padding(.bottom, sizeInfo.padding)
                
                HStack(spacing: 0) {
                    Text("EUJUDFESES")
                        .font(Font.body21420Regular)
                        .foregroundColor(Color.primary500)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding(.horizontal, sizeInfo.padding)
                        .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(Color.gray100, lineWidth: DefineSize.LineHeight)
                        )
                    
                    Button {
                        showAlertCopy = true
                        UIPasteboard.general.setValue("",
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
                
                Text("n_my_referral_code".localized)
                    .font(Font.buttons1420Medium)
                    .foregroundColor(.gray900)
                    .padding(.bottom, sizeInfo.padding)
                    .padding(.top, sizeInfo.padding30)
                
                HStack(spacing: 0) {
                    CustomTextField(text: $referralCode, correctStatus: $correctStatus, isKeyboardEnter: $isKeyboardEnter, placeholder: "se_c_write_referral_code".localized)
                    
                    Button {
                        vm.requestMyReferral(integUid: UserManager.shared.uid, referralCode: referralCode)
                    } label: {
                        Text("d_registration".localized)
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
//                .padding(.top, 8)
                
                Text("se_h_valid_12hours".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(.gray500)
                    .padding(.top, sizeInfo.padding)
            }
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
            .modifier(ScrollViewLazyVStackModifier())
        }
        .onAppear(perform: {
            vm.requestMyReferralCreate(integUid: UserManager.shared.uid)
        })
        
        .showAlertSimple(isPresented: $showAlertCopy, type: .Default, title: "", message: "se_c_share_friend_referral_code".localized, detailMessage: "") { index in
        }
        
        .showAlertSimple(isPresented: $showAlertInvalidReferralCode, type: .Default, title: "", message: "se_a_invalid_referral_code".localized, detailMessage: "") { index in
        }
        
        //입력된값 없음
        .showAlertSimple(isPresented: $showAlertNoValueEntered, type: .Default, title: "", message: "se_a_write_referral_code".localized, detailMessage: "") { index in
        }
        
        .showAlertSimple(isPresented: $showAlertCannotUsedYourCode, type: .Default, title: "", message: "se_b_cannot_use_your_code".localized, detailMessage: "") { index in
        }
        
        .showAlertSimple(isPresented: $vm.showAlertSuccess, type: .Default, title: "se_c_referral_code_succeess_registered".localized, message: String(format: "se_p_fanit_paid_and_check".localized, "500"), detailMessage: "") { index in
        }
        
        .showAlert(isPresented: $vm.showAlert, type: .Default, title: "", message: vm.alertMessage, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
        })
        
        .background(Color.gray25)
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "c_invite_friend".localized, onPress: { buttonType in
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }
}


struct InviteFriendPage_Previews: PreviewProvider {
    static var previews: some View {
        InviteFriendPage()
    }
}
