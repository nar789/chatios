//
//  ClubManagementPage.swift
//  fantoo
//
//  Created by mkapps on 2022/06/22.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct ClubManagementPage: View {
    @StateObject var languageManager = LanguageManager.shared
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
    }
    @Binding var clubId: String
    
    @State var leftItems: [CustomNavigationBarButtonType] = [.Back]
    @State var rightItems: [CustomNavigationBarButtonType] = [.AlarmOn]
    
    @State private var memberCount: String = "123456"
    @State private var postCount: String = "1234"
    @State private var kdgCount: String = "제외예정"
    @State private var standByMemberCount: String = "5"
    @State private var openDate: String = "2022.08.28"
    @State private var open: String = "g_open_public".localized
    @State private var hidden: String = "b_hidden".localized
    
    //push
    @State private var showImageViewer = false
    @State private var showStorage = false
    @State private var showStandByJoinClubMember = false
    @State private var showMember = false
    @State private var showLeave = false
    @State private var showInfoSetting = false
    @State private var showSecondInfoSetting = false
    @State private var showThirdInfoSetting = false
    @State private var showManaging = false
    
    @StateObject var vm = ClubManagementViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    LazyVStack(spacing: 0) {

                        ClubManagementProfileView(clubName: vm.myClubName, profileImg: vm.clubImg.imageOriginalUrl, openDate: vm.clubOpenDate, open: "g_open_public".localized, clubImageType: vm.openYn ? .Public : .Private) {
                                buttonType in
                                print("buttonType : \(buttonType)")
                                if buttonType == .EditProfile {
                                }
                                else {
                                }
                            }
                     
                        Spacer().frame(height: sizeInfo.padding)
                        
                        ClubManagementInfoView(memberCount: $vm.allMemberCount, postCount: $vm.allPostCount, kdgCount: $kdgCount)
                        
                        ClubManagementLiskLinkView(text: "g_waiting_for_join_approval".localized, subText: "\(vm.approvalMemberCount)명") {
                            showStandByJoinClubMember = true
                        }
                        .background(
                            NavigationLink("", isActive: $showStandByJoinClubMember) {
                                StandByJoinClubMemberPage_S(clubId: $clubId)
                            }.hidden()
                        )
                        
                        ListLinkView(text: "m_member_management".localized, subText: "", subTextColor: Color.gray800, type: .ClickAllWithArrow) {
                            showMember = true
                        }
                        .background(
                            NavigationLink("", isActive: $showMember) {
                                ClubMemberManegementPage(clubId: $clubId)
                            }.hidden()
                        )
                        
                        ListLinkView(text: "g_board_management".localized, subText: "", subTextColor: Color.gray800, type: .ClickAllWithArrow) {
                            showLeave = true
                        }
                        .background(
                            NavigationLink("", isActive: $showLeave) {
                                ClubPostPage(clubId: $clubId)
                            }.hidden()
                        )
                        
                        ListLinkView(text: "k_club_closing_delegating".localized, subText: "", subTextColor: Color.gray800, type: .ClickAllWithArrow) {
                            showInfoSetting = true
                        }
                        .background(
                            NavigationLink("", isActive: $showInfoSetting) {
                                if vm.clubMemberCount == 1 {
                                    if vm.closesStatus == 0 {
                                        ClubClosingPage(clubId: $clubId, clubClosingType: .BeforeClubClosing)
                                    }
                                    else if vm.closesStatus == 1 {
                                        // 폐쇄 신청한 상태
                                        ClubClosingPage(clubId: $clubId, clubClosingType: .ConfirmClubClosing)
                                    }
                                }
                                else {
                                    if vm.delegateStatus == 0 {
                                        ClubClosingMemberPage(clubId: $clubId)
                                    } else {
                                        ClubClosingStatePage(clubId: $clubId, delegateDate: "m_confirmation_after_member_agree".localized)
                                    }
                                }
                            }.hidden()
                        )
                        
//                        ListLinkView(text: "클럽 폐쇄/위임하기2", subText: "", subTextColor: Color.gray800, type: .ClickAllWithArrow) {
//                            showSecondInfoSetting = true
//                        }
//                        .background(
//                            NavigationLink("", isActive: $showSecondInfoSetting) {
//                                ClubClosingMemberPage()
//                            }.hidden()
//                        )
//                        ListLinkView(text: "클럽 폐쇄/위임하기3", subText: "", subTextColor: Color.gray800, type: .ClickAllWithArrow) {
//                            showThirdInfoSetting = true
//                        }
//                        .background(
//                            NavigationLink("", isActive: $showThirdInfoSetting) {
//                                ClubClosingStatePage(delegateDate: "멤버 수락 후 확정", memberNickname: "사용자 닉네임", memberId: "abcdefg", memberLevel: "a_general_membership".localized)
//
//                            }.hidden()
//                        )
//
                    }
                    .modifier(ScrollViewLazyVStackModifier())
                }
            }
            .onAppear(perform: {
                vm.requestClubManage(clubId: clubId)
                vm.requestClubJoinMemberList(clubId: clubId)
                vm.requestClubClosingState(clubId: clubId)
                vm.requestClubMemberCount(clubId: clubId)
                vm.requestClubDelegateMember(clubId: clubId)
            })
            .background(Color.gray25)
            .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "k_club_management".localized, onPress: { buttonType in
            })
            .navigationBarBackground {
                Color.gray25
            }
            .statusBarStyle(style: .darkContent)
            LoadingViewInPage(loadingStatus: $vm.loadingStatus)
        }
    }
}


struct ClubManagementPage_Previews: PreviewProvider {
    static var previews: some View {
        ClubManagementPage(clubId: .constant(""))
    }
}

