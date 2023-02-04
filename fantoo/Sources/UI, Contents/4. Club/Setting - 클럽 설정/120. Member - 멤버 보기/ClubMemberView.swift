//
//  ClubMemberView.swift
//  fantoo
//
//  Created by mkapps on 2022/06/25.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI


struct ClubMemberView {
    
    // 홈버튼 클릭시, NavigationLink 뒤로가기
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showBottomView = false
    @State private var showBottomViewAlert = false
    @State private var showAccountBlockBottomViewAlert = false
    @State private var showBlockClearBottomViewAlert = false
    @State private var accountBlockState = false
    
    @State private var selectedTab: Int = 0
    
    // Sticky Header 불투명 값
    @State private var headerLayoutOffsetY: CGFloat = CGFloat.zero
    @State private var headerLayoutOpacity: Double = CGFloat.zero
    @State private var headerTitleOffsetY: CGFloat = CGFloat.zero
    @State private var naviTitleOpacity: Double = CGFloat.zero
    
    /**
     *  BodyScrollView 스크롤시, HeaderScrollView를 강제로 이동시키기
     */
    // Body ScrollView 스크롤시 반환되는 offset 값 저장
    @State private var bodyScrollOffsetY: CGFloat = 0
    private let headerFixY_common: CGFloat = -50.0
    @State var subSeq: Int = 0
    @State var accountBlock: String = "g_block_account".localized
    @State var blockClear: String = "c_release_account_block".localized
    
    @State var accountBlockAlert: String = "se_s_do_you_want_block_select_user".localized
    @State var blockClearAlert: String = "se_s_do_you_want_release_block_select_user".localized
    
    @StateObject var vm = ClubMemberViewModel()
    @Binding var clubId: String
    @Binding var nickname: String
    @Binding var memberId: String
    @Binding var profileImg: String
    @Binding var memberLevel: Int
    
    /**
     * 언어팩 등록할 것
     */
    private let tabs: [String] = ["j_wrote_post".localized, "j_wrote_rely".localized, ""]
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
        static let bottomSheetHeight: CGFloat = 220.0 + DefineSize.SafeArea.bottom
        static let imageSize: CGSize = CGSize(width: 100, height: 100)
        
    }
}

extension ClubMemberView: View {
    var body: some View {
        ZStack(alignment: .center) {
            
            ScrollView {
                VStack(spacing: 0) {
                    let _ = print("bodyScrollOffsetY : \(bodyScrollOffsetY)" as String)
                    setNaviLayoutOpacity(offset: bodyScrollOffsetY)
                    setNaviTitleOpacity(offset: bodyScrollOffsetY)
                    Spacer().frame(height: bodyScrollOffsetY == 0 ? 90 : 0)
                    header
                    
                    GeometryReader { geometry in
                        TabView(selection: $selectedTab) {
                            
                            /**
                             * ScrollView 의 offset 값을 반환받는 커스텀 ScrollView
                             */
                            ScrollViewOffset {
                                LazyVStack(spacing: 0) {
                                    if self.vm.clubStorageMemberPostListData.count > 0 {
                                        ForEach(Array(self.vm.clubStorageMemberPostListData.enumerated()), id: \.offset) { index, element in
                                            BoardRowView(
                                                viewType: BoardType.MyClub_Member_Storage_Post,
                                                clubStorageMemberPostListData: vm.clubStorageMemberPostListData[index]
                                            )
                                            .background(Color.gray25)
                                            ExDivider(color: Color.bgLightGray50, height: 8)
                                        }
                                    }
                                    else {
                                        ScrollView {
                                            LazyVStack(spacing: 0) {
                                                Spacer().frame(height: sizeInfo.imageSize.width)
                                                NoSearchView(image: "character_club2", text: "se_j_no_write_post".localized)
                                            }
                                        }
                                    }
                                }
                                //                                .frame(maxHeight: .infinity)
                                .onAppear {
                                    vm.myClubMemberPostList(clubId: clubId, memberId: memberId)
                                    //                                    viewModel.getMyBoardList()
                                }
                                // make disable the bouncing
                                .introspectScrollView {
                                    $0.bounces = true
                                }
                            } onOffsetChange: { offset in
                                //print("tag0 offset : \(offset)" as String)
                                
                                if offset > 0 {
                                    bodyScrollOffsetY = 0
                                }
                                else {
                                    if offset < headerFixY_common {
                                        bodyScrollOffsetY = headerFixY_common
                                    }
                                    else {
                                        bodyScrollOffsetY = offset
                                    }
                                }
                            }
                            .tag(0)
                            
                            ScrollViewOffset {
                                LazyVStack(spacing: 0) {
                                    if self.vm.clubStorageMemberReplyListData.count > 0 {
                                        ForEach(Array(self.vm.clubStorageMemberReplyListData.enumerated()), id: \.offset) { index, element in
                                            BoardRowView(
                                                viewType: BoardType.MyClub_Member_Storage_Reply,
                                                clubStorageMemberReplyListData: vm.clubStorageMemberReplyListData[index]
                                            )
                                            .background(Color.gray25)
                                            ExDivider(color: Color.bgLightGray50, height: 8)
                                        }
                                    }
                                    else {
                                        ScrollView {
                                            LazyVStack(spacing: 0) {
                                                Spacer().frame(height: sizeInfo.imageSize.width)
                                                NoSearchView(image: "character_club2", text: "se_j_no_write_post".localized)
                                            }
                                        }
                                    }
                                }
                                .onAppear {
                                    vm.myClubMemberReplyList(clubId: clubId, memberId: memberId)
                                    //                                    viewModel.getMyBoardList()
                                }
                                // make disable the bouncing
                                .introspectScrollView {
                                    $0.bounces = true
                                }
                            } onOffsetChange: { offset in
                                //print("tag0 offset : \(offset)" as String)
                                
                                if offset > 0 {
                                    bodyScrollOffsetY = 0
                                }
                                else {
                                    if offset < headerFixY_common {
                                        bodyScrollOffsetY = headerFixY_common
                                    }
                                    else {
                                        bodyScrollOffsetY = offset
                                    }
                                }
                            }
                            .tag(1)
                        }
                        .background(Color.bgLightGray50)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    }
                }
                //.frame(height: UIScreen.screenHeight)
                .frame(height: UIScreen.screenHeight + 100)
                
            }
            //.frame(height: UIScreen.screenHeight + (-bodyScrollOffsetY))
            .frame(height: UIScreen.screenHeight + 100)
            .offset(x: 0, y: bodyScrollOffsetY)
        }
        .onAppear(perform: {
            vm.requestClubBlockCheck(clubId: clubId, memberId: memberId)
            if vm.blockYn {
                accountBlockState = true
            }
            else {
                accountBlockState = false
            }
            //true면 차단된것 -> 보여질때는 차단해제로 보여야 한다
        })
        
        .popup(isPresenting: $showAccountBlockBottomViewAlert, cornerRadius: 5, locationType: .bottom,  autoDismiss: .after(2), popup:
                ZStack {
            Spacer()
            Text("se_s_blocked_select_user".localized)
                .foregroundColor(Color.gray25)
                .font(Font.body21420Regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
            //                        .multilineTextAlignment(.center)
                .background(Color.gray800)
        }
               
        )
        .popup(isPresenting: $showBlockClearBottomViewAlert, cornerRadius: 5, locationType: .bottom, autoDismiss: .after(2), popup:
                ZStack {
            Spacer()
            Text("se_s_block_released_select_user".localized)
                .foregroundColor(Color.gray25)
                .font(Font.body21420Regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
            //                        .multilineTextAlignment(.center)
                .background(Color.gray800)
        }
               
        )
        
        .showAlert(isPresented: $showBottomViewAlert, type: .Default, title: accountBlockState ? blockClear : accountBlock, message: accountBlockState ? blockClearAlert : accountBlockAlert, detailMessage: "", buttons: ["c_cancel".localized, "h_confirm".localized], onClick: { buttonIndex in
            if accountBlockState {
                if buttonIndex == 1 {
                    showBlockClearBottomViewAlert = true
                    vm.requestClubBlockMember(clubId: clubId, memberId: memberId)
                    accountBlockState.toggle()
                    
                }
            }
            else {
                if buttonIndex == 1 {
                    showAccountBlockBottomViewAlert = true
                    vm.requestClubBlockMember(clubId: clubId, memberId: memberId)
                    accountBlockState.toggle()
                }
            }
        })
        .bottomSheet(isPresented: $showBottomView, height: sizeInfo.bottomSheetHeight, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
            ClubMemberDetailBottomSheet(isShow: $showBottomView, subTitle: accountBlockState ? blockClear : accountBlock) {
                showBottomViewAlert = true
            }
        })
        .navigationType(leftItems: [.Back], rightItems: [.More], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: naviTitleOpacity != 0 ? nickname : "", onPress: { buttonType in
            if buttonType == .More {
                showBottomView = true
            }
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }
    
    private var header: some View {
        ZStack {
            
            VStack(alignment: .leading, spacing: 0) {
                ZStack {
                    VStack(spacing: 0) {
                        Spacer()
                        ClubMemberInfoView(memberNickname: nickname, memberImg: profileImg, memberLevel: memberLevel == 20 ? "k_club_president".localized: "a_general_membership".localized) {
                        }
                        ExDivider(color: Color.bgLightGray50, height: 8)
                    }
                    .opacity(headerLayoutOpacity)
                }
                
                tabBar
                    .frame(width: UIScreen.screenWidth, height: 50)
            }
        }
        .frame(height: 200)
        // 배경 이미지와 높이 동일하게 맞추기
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private var tabBar: some View {
        GeometryReader { geometry in
            ClubClosingMemberDetailPageTabs(tabs: tabs, geoWidth: geometry.size.width, selectedTab: $selectedTab)
        }
    }
    
    func setNaviLayoutOpacity(offset: CGFloat) -> some View {
        DispatchQueue.main.async {
            self.headerLayoutOffsetY = offset
            /**
             * 클럽 제목 제외 나머지
             *
             * Header 영역이 보이면 headerLayoutOffsetY == 0.0
             * Header 영역이 가려지면 headerLayoutOffsetY == -100.0
             *
             * '클럽 제목을 제외한 나머지'는 Header 영역이 보이면 headerLayoutOpacity == 1.0이 되어야 함
             * '클럽 제목을 제외한 나머지'는 Header 영역이 가려지면 headerLayoutOpacity == 0.0이 되어야 함
             * 아래는 이 값을 만들기 위한 계산
             */
            self.headerLayoutOffsetY += 50.0
            self.headerLayoutOpacity = self.headerLayoutOffsetY / 50.0
        }
        return EmptyView()
    }
    
    func setNaviTitleOpacity(offset: CGFloat) -> some View {
        DispatchQueue.main.async {
            self.headerTitleOffsetY = offset
            /**
             * 클럽 제목
             *
             * Header 영역이 최상단에 위치하면 headerTitleOffsetY == 0.0
             * Header 영역이 최하단에 위치하면 headerTitleOffsetY == -100.0
             *
             * '클럽 제목'은 Header 영역이 보이면 0.0이 되어야 함
             * '클럽 제목'은 Header 영역이 가려지면 1.0이 되어야 함
             * 아래는 이 값을 만들기 위한 계산
             */
            self.naviTitleOpacity = self.headerTitleOffsetY / -100.0
        }
        return EmptyView()
    }
}
