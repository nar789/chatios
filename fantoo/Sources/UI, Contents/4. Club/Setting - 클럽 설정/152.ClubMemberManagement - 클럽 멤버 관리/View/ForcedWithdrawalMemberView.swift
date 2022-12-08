//
//  ForcedWithdrawalMemberView.swift
//  fantoo
//
//  Created by fns on 2022/07/14.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct ForcedWithdrawalMemberView: View {
    @StateObject var languageManager = LanguageManager.shared

    private struct sizeInfo {
        static let dividerHeight: CGFloat = 1.0
        static let bottomPadding: CGFloat = 50.0
        static let padding5: CGFloat = 5.0
        static let spacing14: CGFloat = 14.0
        static let spacing100: CGFloat = 100.0
        static let imageSize: CGSize = CGSize(width: 100, height: 100)
        static let bottomSheetHeight: CGFloat = 189.0 + DefineSize.SafeArea.bottom
    }

    @StateObject var vm = ClubMemberManagementViewModel()
    @State private var rejoinSetting = false
    //    @State var clubJoinSubText: String? = "\("g_open_public".localized)"
    @State private var rejoinText: String = "재가입금지"
    @State var approvalMemberCount: Int = 1

    let searchText: String
    @Binding var memberState: Bool
    @Binding var clubId: String
//    @Binding var

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CountDisplayView(count: .constant(vm.memberListSize))
                ExDivider(color: .bgLightGray50, height: sizeInfo.dividerHeight)

                let clubMemberList = vm.clubWithdrawListData ?? nil
                if clubMemberList != nil {
                    if !memberState {
                        if clubMemberList!.filter({"\($0)".contains(self.searchText) || self.searchText.isEmpty}).count > 0 {
                            ScrollView {
                                ForEach((clubMemberList!.filter({"\($0)".contains(self.searchText) || self.searchText.isEmpty})), id : \.id) { i in
                                 
                                    ClubAllMemberListView(profileImg: "", memberNickname: i.nickname, memberLevel: "a_general_membership".localized, ClubJoinDate: "", rejoinChoice: i.joinYn, showLine: true, type: .ClickRightWithText, onPress: {
                                        rejoinSetting = true
                                        vm.selectedJoinYn = i.joinYn
                                        vm.withdrawId = "\(i.clubWithdrawId)"
                                    })
                                }
                            }
                        }
                        else {
                            ScrollView {
                                Spacer().frame(height: sizeInfo.spacing100)

                                Image("character_club2")
                                    .frame(width: sizeInfo.imageSize.width, height: sizeInfo.imageSize.height, alignment: .center)

                                Spacer().frame(height: sizeInfo.spacing14)

                                Text(String(format: "se_g_no_result_member_search".localized, searchText))
                                    .font(Font.body21420Regular)
                                    .foregroundColor(Color.gray600)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                    else {
                        ExDivider(color: .bgLightGray50, height: 1)

                        ScrollView {
                            ForEach(clubMemberList!, id : \.id) { i in
                                ClubAllMemberListView(profileImg: "", memberNickname: i.nickname, memberLevel: "a_general_membership".localized, ClubJoinDate: "", rejoinChoice: i.joinYn, showLine: true, type: .ClickRightWithText) {
                                    rejoinSetting = true
                                    vm.selectedJoinYn = i.joinYn
                                    vm.withdrawId = "\(i.clubWithdrawId)"
                                }
                            }
                        }
                    }
                }
                else {
                    Spacer().frame(height: sizeInfo.spacing100)
                    Text("se_g_no_member_forced_leave".localized)
                        .font(Font.body21420Regular)
                        .foregroundColor(Color.gray400)
                }
            }
        }
        .onAppear {
            vm.clubMemberForceLeaveList()
            vm.requestclubMemberForceLeaveListCount()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .bottomSheet(isPresented: $rejoinSetting, height: sizeInfo.bottomSheetHeight, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
            RejoinSettingBottomView(title: "j_setting_rejoin".localized, selectedTitle: vm.selectedJoinYn ? "g_prohibition".localized :  "h_allow".localized, isShow: $rejoinSetting) { seq in
                if seq == 0 {
                    if vm.selectedJoinYn {
                        vm.requestClubMemberForceLeaveEdit(joinYn: false, withdrawId: vm.withdrawId) { success in
                            if success {
                                vm.clubMemberForceLeaveList()

                            }
                        }
                    }
                }
                else {
                    if !vm.selectedJoinYn {
                        vm.requestClubMemberForceLeaveEdit(joinYn: true, withdrawId: vm.withdrawId) { success in
                            if success {
                                vm.clubMemberForceLeaveList()
                            }
                        }
                    }
                }
            }
        })
        LoadingViewInPage(loadingStatus: $vm.loadingStatus)

    }
}

extension ForcedWithdrawalMemberView {
    
    func getMemberDate(createDate: String) -> String {
        let dateString = createDate
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [
            .withFractionalSeconds,
            .withFullDate
        ]
        let date = inputFormatter.date(from: dateString)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let weekDay = dateFormatter.string(from: date!)
        return weekDay

    }
    
}
