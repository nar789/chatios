//
//  ClubMemeberListPage.swift
//  fantoo
//
//  Created by mkapps on 2022/06/22.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct ClubMemeberListPage: View {
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let spacing14: CGFloat = 14.0
        static let padding15: CGFloat = 15.0
        static let spacing100: CGFloat = 100.0
        static let cellHeight: CGFloat = 50.0
        static let cellPadding: CGFloat = 16.0
        static let imageSize: CGSize = CGSize(width: 100, height: 100)
    }
    
    @Binding var clubId: String
    
    @State var showMember: Bool = false
    @State var cancelSearch: Bool = false
    @State var leftItems: [CustomNavigationBarButtonType] = [.Back]
    @State var rightItems: [CustomNavigationBarButtonType] = [.Search]
    @State var isShowSearchBar: Bool = false
    @State var searchText: String = ""
    @State var nickname: String = ""
    @State var memberId: String = ""
    @State var profileImg: String = ""
    @State var memberLevel: Int = 0
    
    
    @StateObject var vm = ClubSettingViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                
                CountDisplayView(count: .constant(vm.memberListSize))
                
                let clubMemberList = vm.clubMemberListData ?? nil
                if clubMemberList != nil {
                    
                    if !cancelSearch {
                        if clubMemberList!.filter({"\($0)".contains(self.searchText) || self.searchText.isEmpty}).count > 0 {
                            ScrollView {
                                ForEach((clubMemberList!.filter({"\($0)".contains(self.searchText) || self.searchText.isEmpty})), id : \.self) { i in
                                    ClubMemberListView(image: i.profileImg.imageOriginalUrl, text: i.nickname, memberLevel: i.memberLevel == 20 ? "k_club_president".localized: "a_general_membership".localized) {
                                        showMember = true
                                        nickname = i.nickname
                                        memberId = "\(i.memberId)"
                                        profileImg = i.profileImg
                                        memberLevel = i.memberLevel
                                    }
                                }
                            }
                            .background(
                                NavigationLink("", isActive: $showMember) {
                                    ClubMemberView(nickname: $nickname, memberId: $memberId, profileImg: $profileImg, memberLevel: $memberLevel)
                                }.hidden()
                            )
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
                        ScrollView {
                            ForEach(clubMemberList!, id : \.self) { i in
                                ClubMemberListView(image: i.profileImg.imageOriginalUrl, text: i.nickname, memberLevel: i.memberLevel == 20 ? "k_club_president".localized: "a_general_membership".localized) {
                                    showMember = true
                                    nickname = i.nickname
                                    memberId = "\(i.memberId)"
                                    profileImg = i.profileImg
                                    memberLevel = i.memberLevel

                                }
                            }
                        }
                        .background(
                            NavigationLink("", isActive: $showMember) {
                                ClubMemberView(nickname: $nickname, memberId: $memberId, profileImg: $profileImg, memberLevel: $memberLevel)
                            }.hidden()
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .navigationType(leftItems: leftItems, rightItems: rightItems, isShowSearchBar: isShowSearchBar, searchText: $searchText, placeholder: "m_search_member_nickname".localized, leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "m_show_member".localized, onPress: { buttonType in
                if buttonType == .Search {
                    isShowSearchBar = true
                    cancelSearch = false
                }
                else if buttonType == .Cancel {
                    isShowSearchBar = false
                    cancelSearch = true
                    searchText = ""
                }
            })
            .navigationBarBackground {
                Color.gray25
            }
            .statusBarStyle(style: .darkContent)
            .onAppear {
                vm.requestClubMemberList(clubId: clubId) { success in
                    if success {
                        
                    }
                }
            }
            LoadingViewInPage(loadingStatus: $vm.loadingStatus)
        }
    }
}


struct ClubMemeberListPage_Previews: PreviewProvider {
    static var previews: some View {
        ClubMemeberListPage(clubId: .constant(""))
    }
}



//                            if {
//                                // 검색때 사용
//                                Spacer().frame(height: sizeInfo.spacing100)
//
//                                Image("character_club2")
//                                    .frame(width: sizeInfo.imageSize.width, height: sizeInfo.imageSize.height, alignment: .center)
//
//                                Spacer().frame(height: sizeInfo.spacing14)
//
//                                Text("\(searchText) 가 포함된 \n멤버의 검색 결과를 찾을 수 없습니다.")
//                                    .font(Font.body21420Regular)
//                                    .foregroundColor(Color.gray600)
//                                    .multilineTextAlignment(.center)
//                            }
