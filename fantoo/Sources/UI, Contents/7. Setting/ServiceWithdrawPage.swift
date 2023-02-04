//
//  ServiceWithdrawPage.swift
//  fantoo
//
//  Created by fns on 2022/05/31.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI


struct ServiceWithdrawPage : View {
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var vm = ServiceWithdrawalViewModel()
    
    @State var checkState:Bool = false
    @State var showAlert:Bool = false
    @State var showPassword = false
    
    private struct sizeInfo {
        static let padding5: CGFloat = 5.0
        static let padding10: CGFloat = 10.0
        static let padding14: CGFloat = 14.0
        static let padding20: CGFloat = 20.0
        static let spacing4: CGFloat = 4.0
        static let spacing10: CGFloat = 10.0
        static let spacing20: CGFloat = 20.0
        static let cornerRadius5: CGFloat = 5.0
        static let cornerRadius16: CGFloat = 16.0
        static let height1: CGFloat = 1.0
        static let height10: CGFloat = 10.0
        static let height22: CGFloat = 22.0
        // kdg, honor 없어서 높이 수정함
        static let height236: CGFloat = 190.0
        static let btnLogoIconSize: CGSize = CGSize(width: 24, height: 24)
        static let checkIconSize: CGSize = CGSize(width: 20, height: 20)
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: sizeInfo.spacing20) {
                Spacer().frame(height: sizeInfo.padding10)
                HStack {
                    Image("btn_logo_\(UserManager.shared.loginType)")
                        .resizable()
                        .frame(width: sizeInfo.btnLogoIconSize.width, height: sizeInfo.btnLogoIconSize.height, alignment: .center)
                    Text(UserManager.shared.account)
                        .font(Font.body11622Regular)
                        .foregroundColor(Color.black)
                }
                ExDivider(color: .bgLightGray50, height: sizeInfo.height1)
                WithdrawDescriptionView
                WithdrawDeleteDescriptionView
                
                Spacer().frame(maxHeight: .infinity)
                
                VStack {
                    Button(action:
                            {
                        self.checkState = !self.checkState
                        print("State : \(self.checkState)")
                    })  {
                        HStack(spacing: sizeInfo.spacing10) {
                            
                            Image(self.checkState ? "Checkbox_login_checked" : "Checkbox_login_unchecked")
                                .frame(width: sizeInfo.checkIconSize.width, height: sizeInfo.checkIconSize.height, alignment: .center)
                                .cornerRadius(sizeInfo.cornerRadius5)
                            
                            Text("se_j_agree_delete_retention_info".localized)
                                .font(Font.buttons1420Medium)
                                .foregroundColor(Color.gray870)
                            Spacer()
                        }
                        
                    }.padding(.top, sizeInfo.padding5)
                    
                    Spacer().frame(height: sizeInfo.height22)
                    
                    HStack(alignment: .bottom) {
                        Button {
                            if checkState {
                                showAlert = true
                            }
                        } label: {
                            CommonButton(title: "s_leave".localized, bgColor: checkState ? Color.stateActivePrimaryDefault : Color.gray200)
                        }
                    }
                }
            }.padding(.horizontal, sizeInfo.padding20)
        }
        
        .showAlert(isPresented: $showAlert, type: .Default, title: "s_leave".localized, message: "se_t_sure_want_withdraw".localized, detailMessage: "", buttons: ["t_do_leave".localized, "t_cancel_leave".localized], onClick: { buttonIndex in
            if buttonIndex == 0 {
                vm.requestUserWithdrawal(integUid: UserManager.shared.uid)
                UserManager.shared.logout()
            }
        })
        .navigationType(leftItems: [.Close], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "s_leave".localized, onPress: { buttonType in
            print("onPress buttonType : \(buttonType)")
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }
    
    var WithdrawDescriptionView: some View {
        VStack(alignment: .leading, spacing: sizeInfo.spacing20) {
            Text("se_j_really_leave".localized)
                .font(Font.title32028Bold)
            Text("se_t_check_info_when_withdraw".localized)
                .font(Font.body21420Regular)
                .foregroundColor(Color.gray850)
            //                .kerning(0.5)
            Text("se_t_cannot_restore_withdraw_account".localized)
                .font(Font.body21420Regular)
                .foregroundColor(Color.gray850)
            //                .kerning(0.5)
        }
    }
    
    var WithdrawDeleteDescriptionView: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: sizeInfo.spacing4) {
                Text("s_delete".localized)
                    .font(Font.buttons1420Medium)
                    .multilineTextAlignment(.leading)
                
                Text("g_account_profile_info".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray700)
                    .multilineTextAlignment(.leading)
                
                Text("g_join_club_leave_process".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray700)
                    .multilineTextAlignment(.leading)
                
                Text("b_storage_etc".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray700)
                    .multilineTextAlignment(.leading)
                
                Text("b_have_fan_it".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray700)
                    .multilineTextAlignment(.leading)
                
                //                Text("b_have_kdg".localized)
                //                    .font(Font.caption11218Regular)
                //                    .foregroundColor(Color.gray700)
                //                    .multilineTextAlignment(.leading)
                //
                //                Text("b_have_honor".localized)
                //                    .font(Font.caption11218Regular)
                //                    .foregroundColor(Color.gray700)
                //                    .multilineTextAlignment(.leading)
                //                    .padding(.bottom, 10)
                
                Text("a_maintain".localized)
                    .font(Font.buttons1420Medium)
                    .multilineTextAlignment(.leading)
                
                Text("n_keep_my_post_1".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray700)
                    .multilineTextAlignment(.leading)
            }
            .padding(.top, sizeInfo.padding14)
            .padding(.horizontal, sizeInfo.padding20)
        }
        .frame(maxWidth: .infinity, maxHeight: sizeInfo.height236, alignment: .topLeading)
        .background(Color.bgLightGray50.cornerRadius(sizeInfo.cornerRadius16))
        
    }
    
    var WithdrawStayDescriptionView: some View {
        VStack(alignment: .leading, spacing: sizeInfo.spacing10){
            Text("a_maintain".localized)
                .font(Font.buttons1420Medium)
            Text("n_keep_my_post_1".localized)
                .font(Font.body21420Regular)
                .foregroundColor(Color.gray800)
            Spacer().frame(height: sizeInfo.height10)
            ExDivider(color: .bgLightGray50, height: sizeInfo.height1)
        }
    }
}

struct ServiceWithdrawPage_Previews: PreviewProvider {
    static var previews: some View {
        ServiceWithdrawPage()
    }
}
