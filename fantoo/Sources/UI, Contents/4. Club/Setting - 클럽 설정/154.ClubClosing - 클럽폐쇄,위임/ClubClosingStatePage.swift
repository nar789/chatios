//
//  ClubClosingStatePage.swift
//  fantoo
//
//  Created by fns on 2022/07/25.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
import LineSDK

struct ClubClosingStatePage: View {
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var userManager = UserManager.shared
    @StateObject var vm = ClubSettingViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    private struct sizeInfo {
        static let spacing2: CGFloat = 2.0
        static let padding8: CGFloat = 8
        static let padding10: CGFloat = 10.0
        static let padding12: CGFloat = 12.0
        static let padding15: CGFloat = 15.5
        static let padding16: CGFloat = 16.0
        static let padding20: CGFloat = 20.0
        static let padding22: CGFloat = 22.0
        static let padding23: CGFloat = 23.5
        static let padding33: CGFloat = 33.5
        static let cornerRadius: CGFloat = 16
        static let rectangleBorder: CGFloat = 1
        static let frameHeight: CGFloat = 98
    }
    @Binding var clubId: String
    
    let delegateDate: String
    @State var showCancelAlert: Bool = false
    @State var showCancelBottomSheet: Bool = false
    
    var body: some View {
        VStack {
            //            Spacer().frame(height: sizeInfo.padding16)
            //            ExDivider(color: Color.bgLightGray50, height: 1)
            VStack(alignment: .leading, spacing: 0) {
                Spacer().frame(height: sizeInfo.padding16)
                Text("se_k_club_status_is_delegating".localized)
                    .font(Font.title32028Bold)
                    .foregroundColor(Color.gray900)
                    .multilineTextAlignment(.leading)
                Spacer().frame(height: sizeInfo.padding8)
                Text("a_delegating_schedule".localized + "\(delegateDate)")
                    .font(Font.body21420Regular)
                    .foregroundColor(Color.primary500)
                    .multilineTextAlignment(.leading)
                ExDivider(color: Color.gray400, height: 1)
                    .opacity(0.12)
                    .padding(.vertical, sizeInfo.padding23)
                Text("a_delegating_target_member".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray850)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, sizeInfo.padding10)
                
                ZStack {
                    RoundedRectangle(cornerRadius: sizeInfo.cornerRadius)
                        .foregroundColor(Color.bgLightGray50)
                        .frame(height: 98)
                    //                        .border(Color.gray100, width: sizeInfo.rectangleBorder, cornerRadius: sizeInfo.cornerRadius)
                    //                        .frame(height: 98)
                    HStack(spacing: 0) {
                        VStack {
                            WebImage(url: URL(string: vm.profileImg))
                                .resizable()
                                .placeholder(Image(Define.ProfileDefaultImage))
                                .frame(width: DefineSize.Size.ProfileThumbnailM.width, height: DefineSize.Size.ProfileThumbnailM.height, alignment: .leading)
                                .clipped()
                                .cornerRadius(DefineSize.CornerRadius.ProfileThumbnailS)
                                .padding([.trailing], sizeInfo.padding12)
                                .padding([.leading, .vertical], sizeInfo.padding22)
                            Spacer()
                        }
                        
                        Spacer().frame(width: sizeInfo.padding12)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            
                            HStack(spacing: sizeInfo.spacing2) {
                                let memberId = "\(vm.memberId)"
                                let memberIdPrefix = "(\(memberId.prefix(3))****)"
                                Text(vm.nickname)
                                    .font(Font.title51622Medium)
                                    .foregroundColor(Color.gray900)
                                Text(memberIdPrefix)
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(Color.gray900)
                            }
                            .padding(.top, sizeInfo.padding22)
                            
                            Text("\(vm.memberLevel == 20 ? "k_club_president".localized: "a_general_membership".localized)")
                                .font(Font.body21420Regular)
                                .foregroundColor(Color.gray400)
                                .padding(.bottom, sizeInfo.padding22)
                                .fixedSize(horizontal: true, vertical: false)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        }
                    }
                }
                .frame(height: sizeInfo.frameHeight)
                
                Spacer().frame(height: sizeInfo.padding20)
                
                ExplainText(explainText: "se_a_delegating_holding_period".localized)
                ExplainText(explainText: "se_b_can_to_cancel_delegating_holding".localized)
                
            }
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
            
            Spacer().frame(maxHeight: .infinity)
            
            Button {
                showCancelAlert = true
            } label: {
                CommonButton(title: "k_cancel_delegating_club".localized, bgColor: Color.stateActivePrimaryDefault)
                    .padding([.horizontal, .bottom], DefineSize.Contents.HorizontalPadding)
            }
        }
        .onAppear(perform: {
            vm.requestClubDelegateMember(clubId: clubId)
        })
        .popup(isPresenting: $showCancelBottomSheet, cornerRadius: 5, locationType: .bottom, autoDismiss: .after(2), popup:
                ZStack {
            Spacer()
            Text("클럽 위임 취소가 완료되었습니다.".localized)
                .foregroundColor(Color.gray25)
                .font(Font.body21420Regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
            //                        .multilineTextAlignment(.center)
                .background(Color.gray800)
        }
               
        )
        .showAlert(isPresented: $showCancelAlert, type: .Default, title: "", message: "se_a_canel_delegating_club".localized, detailMessage: "", buttons: ["a_no".localized, "a_cancel_delegating".localized], onClick: { buttonIndex in
            if buttonIndex == 1 {
                vm.requestClubDelegateCancel(clubId: clubId, memberId: "\(vm.memberId)") { success in
                    if success {
                        showCancelBottomSheet = true
//                        userManager.delegateCancelCompleteAlert = true
//                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        })
        .background(Color.gray25)
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "k_close_delete_club".localized, onPress: { buttonType in
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}


