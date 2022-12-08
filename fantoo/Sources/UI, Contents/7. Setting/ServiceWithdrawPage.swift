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
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 20) {
                Spacer().frame(height: 10)
                HStack {
                    Image("btn_logo_\(UserManager.shared.loginType)")
                        .resizable()
                        .frame(width: 24, height: 24, alignment: .center)
                    Text(UserManager.shared.account)
                        .font(Font.body11622Regular)
                        .foregroundColor(Color.black)
                }
                ExDivider(color: .bgLightGray50, height: 1)
                WithdrawDescriptionView()
                WithdrawDeleteDescriptionView()
                
                Spacer().frame(maxHeight: .infinity)
                
                VStack {
                    Button(action:
                            {
                        self.checkState = !self.checkState
                        print("State : \(self.checkState)")
                    })  {
                        HStack(spacing: 10) {
                            
                            Image(self.checkState ? "Checkbox_login_checked" : "Checkbox_login_unchecked")
                                .frame(width:20, height:20, alignment: .center)
                                .cornerRadius(5)
                            
                            Text("se_j_agree_delete_retention_info".localized)
                                .font(Font.buttons1420Medium)
                                .foregroundColor(Color.gray870)
                            Spacer()
                        }
                        
                    }.padding(.top, 5)
                    
                    Spacer().frame(height: 22)
                    
                    HStack(alignment: .bottom) {
                        Button {
                            if checkState {
                                showAlert = true
                            }
                        } label: {
                            CommonButton(title: "s_leave".localized, bgColor: Color.stateActivePrimaryDefault)
                            //                            CommonButton(title: "s_leave".localized, bgColor: checkState ? Color.stateActivePrimaryDefault : Color.gray200)
                        }
                    }
                }
            }.padding(.horizontal, 20)
        }
        
        .showAlert(isPresented: $showAlert, type: .Default, title: "s_leave".localized, message: "se_t_sure_want_withdraw".localized, detailMessage: "", buttons: ["t_do_leave".localized, "t_cancel_leave".localized], onClick: { buttonIndex in
            if buttonIndex == 0 {
//                vm.requestUserWithdrawal(integUid: UserManager.shared.uid)
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
    
    var WithdrawCheckView: some View {
        
        VStack {
            Button(action:
                    {
                self.checkState = !self.checkState
                print("State : \(self.checkState)")
            })  {
                HStack(spacing: 10) {
                    
                    Image(self.checkState ? "Checkbox_login_checked" : "Checkbox_login_unchecked")
                        .frame(width:20, height:20, alignment: .center)
                        .cornerRadius(5)
                    
                    Text("se_j_agree_delete_retention_info".localized)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(Color.gray870)
                    Spacer()
                }
                
            }.padding(.top, 5)
            
            Spacer().frame(height: 22)
            
            HStack(alignment: .bottom) {
                Button {
                    showAlert = true
                } label: {
                    WithdrawButtonView(bgColor: checkState ? Color.stateActivePrimaryDefault : Color.gray200, buttonTitle: "s_leave".localized)
                }
            }
        }
    }
}

struct ServiceWithdrawPage_Previews: PreviewProvider {
    static var previews: some View {
        ServiceWithdrawPage()
    }
}


struct WithdrawDescriptionView : View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("se_j_really_leave".localized)
                .font(Font.title41824Medium)
            Text("se_t_check_info_when_withdraw".localized)
                .font(Font.body21420Regular)
                .foregroundColor(Color.gray600)
            //                .kerning(0.5)
            Text("se_t_cannot_restore_withdraw_account".localized)
                .font(Font.body21420Regular)
                .foregroundColor(Color.gray600)
            //                .kerning(0.5)
        }
    }
}

struct WithdrawDeleteDescriptionView : View {
    var body: some View {
        
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
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
                
                Text("j_posts_comments_usage_history".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray700)
                    .multilineTextAlignment(.leading)
                
                Text("b_have_fan_it".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray700)
                    .multilineTextAlignment(.leading)
                
                Text("b_have_kdg".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray700)
                    .multilineTextAlignment(.leading)
                
                Text("b_have_honor".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray700)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 10)
                
                Text("a_maintain".localized)
                    .font(Font.buttons1420Medium)
                    .multilineTextAlignment(.leading)
                
                Text("n_keep_my_post_2".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray700)
                    .multilineTextAlignment(.leading)
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity, maxHeight: 258, alignment: .topLeading)
        .background(Color.bgLightGray50.cornerRadius(16))
    }
}

struct WithdrawStayDescriptionView : View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("a_maintain".localized)
                .font(Font.buttons1420Medium)
            Text("n_keep_my_post_1".localized)
                .font(Font.body21420Regular)
                .foregroundColor(Color.gray800)
            Spacer().frame(height: 10)
            ExDivider(color: .bgLightGray50, height: 1)
        }
    }
}


struct WithdrawButtonView : View {
    var bgColor : Color
    var buttonTitle: String
    //    var buttonWidth : CGFloat?
    var body: some View {
        HStack() {
            Button {
                print("버튼")
            } label: {
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    Text(buttonTitle)
                        .foregroundColor(Color.gray25)
                        .font(.system(size: 18))
                        .font(Font.buttons1420Medium)
                        .foregroundColor(Color.gray25)
                    Spacer()
                }
                .frame(height: 45)
                .background(bgColor)
                .cornerRadius(20.0)
                .overlay(RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.clear, lineWidth: 0.5))
            }
        }
    }
}


