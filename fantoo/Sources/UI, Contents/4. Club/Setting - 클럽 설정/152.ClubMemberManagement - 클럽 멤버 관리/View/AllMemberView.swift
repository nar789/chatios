//
//  AllMemberView.swift
//  fantoo
//
//  Created by fns on 2022/07/14.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct AllMemberView: View {
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var vm = ClubSettingViewModel()

    private struct sizeInfo {
        static let spacing14: CGFloat = 14.0
        static let spacing100: CGFloat = 100.0
        static let stackSpacing: CGFloat = -10.0
        static let dividerHeight: CGFloat = 1.0
        static let imageSize: CGSize = CGSize(width: 100, height: 100)
    }

    @State var memberCount: Int = 1
    @State var showMemberDetailView: Bool = false

    @State var nickname: String = ""
    @State var memberId: String = ""
    @State var profileImg: String = ""
    @State var createDate: String = ""
    @State var memberLevel: Int = 0

    let searchText: String
    @Binding var memberState: Bool
    @Binding var clubId: String

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CountDisplayView(count: .constant(vm.memberListSize))
                ExDivider(color: .bgLightGray50, height: sizeInfo.dividerHeight)

                let clubMemberList = vm.clubMemberListData ?? nil
                if clubMemberList != nil {
                    if !memberState {
                        if clubMemberList!.filter({"\($0)".contains(self.searchText) || self.searchText.isEmpty}).count > 0 {
                            ScrollView {
                                ForEach((clubMemberList!.filter({"\($0)".contains(self.searchText) || self.searchText.isEmpty})), id : \.self) { i in
                                    ClubAllMemberListView(profileImg: i.profileImg.imageOriginalUrl, memberNickname: i.nickname, memberLevel: i.memberLevel == 20 ? "k_club_president".localized: "a_general_membership".localized, ClubJoinDate: getMemberDate(createDate: i.createDate), rejoinChoice: true, showLine: true, type: .ClickRightWithArrow, onPress: {
                                        showMemberDetailView = true
                                        nickname  = i.nickname
                                        memberId = "\(i.memberId)"
                                        profileImg = i.profileImg
                                        memberLevel = i.memberLevel
                                        createDate = getMemberDate(createDate: i.createDate)
                                    })
                                }
                                .background(
                                    NavigationLink("", isActive: $showMemberDetailView) {
                                        ClubMemberDetailPage(nickname: $nickname, memberId: $memberId, profileImg: $profileImg, memberLevel: $memberLevel, createDate: $createDate)
                                    }.hidden()
                                )
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
                        ScrollView {
                            ForEach(clubMemberList!, id : \.self) { i in
                                ClubAllMemberListView(profileImg: i.profileImg.imageOriginalUrl, memberNickname: i.nickname, memberLevel: i.memberLevel == 20 ? "k_club_president".localized: "a_general_membership".localized, ClubJoinDate: getMemberDate(createDate: i.createDate), rejoinChoice: true, showLine: true, type: .ClickRightWithArrow, onPress: {
                                    showMemberDetailView = true
                                    nickname  = i.nickname
                                    memberId = "\(i.memberId)"
                                    profileImg = i.profileImg
                                    memberLevel = i.memberLevel
                                    createDate = getMemberDate(createDate: i.createDate)
                                })
                            }
                            .background(
                                NavigationLink("", isActive: $showMemberDetailView) {
                                    ClubMemberDetailPage(nickname: $nickname, memberId: $memberId, profileImg: $profileImg, memberLevel: $memberLevel, createDate: $createDate)
                                }.hidden()
                            )
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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

extension AllMemberView {
    
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

