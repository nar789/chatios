//
//  ClubSettingPage.swift
//  fantoo
//
//  Created by mkapps on 2022/06/22.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct ClubSettingPage: View {
    @Environment(\.presentationMode) var presentationMode
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let cellHeight: CGFloat = 50.0
        static let cellPadding: CGFloat = 16.0
        static let iconSize: CGSize = CGSize(width: 17, height: 16)
    }
    
    @Binding var clubId: String
    @Binding var memberId: Int
    
    @State var leftItems: [CustomNavigationBarButtonType] = [.Back]
    @State var rightItems: [CustomNavigationBarButtonType] = [.AlarmOn]
    
    @State private var myPostCount: String = "124"
    @State private var myCommentCount: String = "125234"
    @State private var savedPostCount: String = "1251232512"
    
    @StateObject var vm = ClubSettingViewModel()
    
    //push
    @State private var showImageViewer = false
    @State private var showStorage = false
    @State private var showProfileSetting = false
    @State private var showMember = false
    @State private var showLeave = false
    @State private var showInfoSetting = false
    @State private var showManaging = false
    @State private var showAlarm = false
    @State private var showRemoveAlarm = false
    @State private var showBottomSheet = false
    @State private var popUpisPresenting = false

    
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ClubSettingProfileView(profileUrl: vm.profileImg.imageOriginalUrl, nickName: vm.nickname, membership: vm.memberLevelName) { buttonType in
                            print("buttonType : \(buttonType)")
                            if buttonType == .EditProfile {
                                
                            }
                            else {
                                showImageViewer = true
                            }
                        }
                        
                        Spacer().frame(height: sizeInfo.padding)
                        
                        ClubSettingInfoView(myPostCount: vm.postCount, myCommentCount: vm.replyCount, savedPostCount: vm.bookmarkCount) { buttonType in
                            print("buttonType : \(buttonType)")
                            showStorage = true
                        }
                        .background(
                            NavigationLink("", isActive: $showStorage) {
                                ClubStoragePage()
                            }.hidden()
                        )
                        
                        ListLinkView(text: "p_setting_profile".localized, subText: "", subTextColor: Color.gray800, type: .ClickAllWithArrow) {
                            showProfileSetting = true
                        }
                        .background(
                            NavigationLink("", isActive: $showProfileSetting) {
                                ClubMyProfileSettingPage(clubId: $clubId, profileImg: $vm.profileImg, nickname: $vm.nickname)
                            }.hidden()
                        )
                        
                        ListLinkView(text: "m_show_member".localized, subText: "", subTextColor: Color.gray800, type: .ClickAllWithArrow) {
                            vm.requestClubMemberList(clubId: clubId) { success in
                                if success {
                                    showMember = true
                                }
                                else {
                                    showBottomSheet = true
                                }
                            }
                        }
                        .background(
                            NavigationLink("", isActive: $showMember) {
                                ClubMemeberListPage(clubId: $clubId)
                            }.hidden()
                        )
                        
                        if vm.memberLevel == 20 {
                            ListLinkView(text: "k_club_info_setting".localized, subText: "", subTextColor: Color.gray800, type: .ClickAllWithArrow) {
                                showInfoSetting = true
                            }
                            .background(
                                NavigationLink("", isActive: $showInfoSetting) {
                                    ClubInfoSettingPage(clubId: $clubId, countryCode: $vm.countryCode)
                                }.hidden()
                            )
                            
                            ListLinkView(text: "k_club_management".localized, subText: "", subTextColor: Color.gray800, type: .ClickAllWithArrow) {
                                showManaging = true
                            }
                            .background(
                                NavigationLink("", isActive: $showManaging) {
                                    ClubManagementPage(clubId: $clubId)
                                }.hidden()
                            )
                        }
                        else {
                            ListLinkView(text: "k_club_leave".localized, subText: "", subTextColor: Color.gray800, type: .ClickAllWithArrow) {
                                showLeave = true
                            }
                            .background(
                                NavigationLink("", isActive: $showLeave) {
                                    ClubLeavePage()
                                }.hidden()
                            )
                        }
                    }
                    .modifier(ScrollViewLazyVStackModifier())

                }
                .onAppear(perform: {
                    vm.requestMyClubStorageCount(clubId: clubId)
                    vm.requestClubMemberDetail(clubId: clubId, memberId: "0")
                    //                vm.requestMyClubFavoritePatch()
                    //                vm.requestClubMemberWithdrwal()
                    //                vm.requestClubMemberList()
                    //                vm.requestClubMemberFollow()
                    //                vm.requestMyClubStorageReply()
                    //                vm.requestClubMemberEdit()
                    //                vm.requestClubMemberNicknameCheck()
                })
                .popup(isPresenting: $showBottomSheet, cornerRadius: 5, locationType: .bottom, autoDismiss: .after(2), popup:
                        ZStack {
                    Spacer()
                    Text( "se_m_member_hidden_club".localized)
                        .foregroundColor(Color.gray25)
                        .font(Font.body21420Regular)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.gray800)
                }
                       
                )

                
                .showAlert(isPresented: $vm.showAlert, type: .Default, title: "", message: vm.alertMessage, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
                })
                
                .showAlert(isPresented: $showAlarm, type: .Default, message: "se_k_set_club_alarm".localized, buttons: ["h_confirm".localized], onClick: { buttonIndex in
                    
                })
                .showAlert(isPresented: $showRemoveAlarm, type: .Default, message: "se_k_released_club_alarm".localized, buttons: ["h_confirm".localized], onClick: { buttonType in
                    
                })
                .background(Color.gray25)
                .navigationType(leftItems: leftItems, rightItems: rightItems, leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "s_setting".localized, onPress: { buttonType in
                    if buttonType == .AlarmOff {
                        rightItems = [.AlarmOn]
                        showAlarm = true
                    }
                    else if buttonType == .AlarmOn {
                        rightItems = [.AlarmOff]
                        showRemoveAlarm = true
                    }
                })
                .navigationBarBackground {
                    Color.gray25
                }
                .statusBarStyle(style: .darkContent)
            }
            
            LoadingViewInPage(loadingStatus: $vm.loadingStatus)
            
        }
    }
}


struct ClubSettingPage_Previews: PreviewProvider {
    static var previews: some View {
        ClubSettingPage(clubId: .constant(""), memberId: .constant(0))
    }
}
