//
//  ClubMemberDetailPage.swift
//  fantoo
//
//  Created by fns on 2022/08/16.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct ClubMemberDetailPage {
    
    // 홈버튼 클릭시, NavigationLink 뒤로가기
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showBottomView = false
    @State private var showForceLeave = false
    @State private var showDelegatePage = false
    @State private var selectedTab: Int = 0
    
    // Sticky Header 불투명 값
    @State private var headerLayoutOffsetY: CGFloat = CGFloat.zero
    @State private var headerLayoutOpacity: Double = CGFloat.zero
    @State private var headerTitleOffsetY: CGFloat = CGFloat.zero
    @State private var naviTitleOpacity: Double = CGFloat.zero
    
    @StateObject var vm = ClubSettingViewModel()
    
    @State var subSeq: Int = 0
    
    /**
     *  BodyScrollView 스크롤시, HeaderScrollView를 강제로 이동시키기
     */
    // Body ScrollView 스크롤시 반환되는 offset 값 저장
    @State private var bodyScrollOffsetY: CGFloat = 0
    private let headerFixY_common: CGFloat = -100.0
    
    @StateObject var viewModel = MainCommunityMyViewModel()
    
    @Binding var clubId: String
    @Binding var nickname: String
    @Binding var memberId: String
    @Binding var profileImg: String
    @Binding var memberLevel: Int
    @Binding var createDate: String

    private let tabs: [String] = ["j_wrote_post".localized, "j_wrote_rely".localized, "j_save".localized]
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
        static let bottomSheetHeight: CGFloat = 326.0 + DefineSize.SafeArea.bottom
        
    }
}

extension ClubMemberDetailPage: View {
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
                                    ForEach(0..<vm.clubStorageMemberPostListData.count, id: \.self) { i in
                                        BoardRowView(
                                            viewType: BoardType.MyClub_Member_Storage_Post,
                                            clubStorageMemberPostListData: vm.clubStorageMemberPostListData[i]
                                        )
                                            .background(Color.gray25)
                                        ExDivider(color: Color.bgLightGray50, height: 8)
                                    }
                                }
                                .onAppear {
                                    vm.myClubMemberPostList(memberId: memberId)
                                    //                                    viewModel.getMyBoardList()
                                }
                                // make disable the bouncing
                                .introspectScrollView {
                                    $0.bounces = false
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
                                    ForEach(0..<vm.clubStorageMemberReplyListData.count, id: \.self) { i in
                                        BoardRowView(
                                            viewType: BoardType.MyClub_Member_Storage_Reply,
                                            clubStorageMemberReplyListData: vm.clubStorageMemberReplyListData[i]
                                        )
                                            .background(Color.gray25)
                                        ExDivider(color: Color.bgLightGray50, height: 8)
                                    }
                                }
                                .onAppear {
                                    vm.myClubMemberReplyList(memberId: memberId)
                                    //                                    viewModel.getMyBoardList()
                                }
                                // make disable the bouncing
                                .introspectScrollView {
                                    $0.bounces = false
                                }
                            } onOffsetChange: { offset in
                                //print("tag1 offset : \(offset)" as String)
                                
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
                            
                            ScrollViewOffset {
                                LazyVStack(spacing: 0) {
                                    ForEach(0..<vm.clubStorageBookmarkListData.count, id: \.self) { i in
                                        BoardRowView(
                                            viewType: BoardType.MyClub_Storage_Bookmark,
                                            clubStorageBookmarkListData: vm.clubStorageBookmarkListData[i]
                                        )
                                            .background(Color.gray25)
                                        Color.bgLightGray50.frame(height: 8)
                                    }
                                }
                                .onAppear {
                                    vm.requestMyClubStorageBookmark { success in
                                        
                                    }
                                    
                                }
                                // make disable the bouncing
                                .introspectScrollView {
                                    $0.bounces = false
                                }
                            } onOffsetChange: { offset in
                                //print("tag2 offset : \(offset)" as String)
                                
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
                            .tag(2)
                        }
                        .background(Color.bgLightGray50)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    }
                }
                //.frame(height: UIScreen.screenHeight)
                .frame(height: UIScreen.screenHeight + 200)
                
            }
            //.frame(height: UIScreen.screenHeight + (-bodyScrollOffsetY))
            .frame(height: UIScreen.screenHeight + 200)
            .offset(x: 0, y: bodyScrollOffsetY)
            LoadingViewInPage(loadingStatus: $vm.loadingStatus)
        }
        .background(
            NavigationLink("", isActive: $showDelegatePage) {

                ClubClosingStatePage(clubId: $clubId, delegateDate: "m_confirmation_after_member_agree".localized)
                
            }.hidden()
        )
        .showAlert(isPresented: $showForceLeave, type: .Default, title: "강제 탈퇴", message: "강제 탈퇴는 번복할 수 없습니다.\n해당 회원을 정말 탈퇴시키겠습니까?", detailMessage: "", buttons: ["c_cancel".localized, "g_force_leave".localized], onClick: { buttonIndex in
            if buttonIndex == 1 {
                vm.clubMemberForceLeave(clubId: clubId, memberId: memberId)
            }
        })
        .bottomSheet(isPresented: $showBottomView, height: sizeInfo.bottomSheetHeight, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
            ClubMemberBottomView(isShow: $showBottomView, subSeq: $subSeq) {
                if subSeq == 1 {
                    vm.clubDelegateRequest(clubId: clubId, memberId: memberId) { success in
                        showDelegatePage = true
                    }
                }
                else if subSeq == 2 {
                    showForceLeave = true
                }
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
                        ClubMemberDetailTopView(profileImg: profileImg.imageOriginalUrl, memberNickname: nickname, memberLevel: memberLevel == 20 ? "k_club_president".localized: "a_general_membership".localized, openDate: createDate, open: createDate, kdg: "365 KDG") {
                        }
                        ExDivider(color: Color.bgLightGray50, height: 8)
                    }
                    .opacity(headerLayoutOpacity)
                }
                
                tabBar
                    .frame(width: UIScreen.screenWidth, height: 50)
            }
        }
        .frame(height: 300)
        // 배경 이미지와 높이 동일하게 맞추기
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private var tabBar: some View {
        GeometryReader { geometry in
            ClubMemberDetailPageTabs(tabs: tabs, geoWidth: geometry.size.width, selectedTab: $selectedTab)
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
            self.headerLayoutOffsetY += 100.0
            self.headerLayoutOpacity = self.headerLayoutOffsetY / 100.0
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

struct ClubMemberDetailPageTabs: View {
    var fixed = false
    var tabs: [String]
    var geoWidth: CGFloat
    @Binding var selectedTab: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(0 ..< tabs.count, id: \.self) { row in
                            
                            Button(action: {
                                withAnimation {
                                    selectedTab = row
                                }
                            }, label: {
                                VStack(spacing: 0) {
                                    Spacer()
                                    Text(tabs[row])
                                        .font(.buttons1420Medium)
                                        .foregroundColor(selectedTab == row ? Color.primary500 : Color.stateActiveGray900)
                                        .frame(width: fixed ? (geoWidth / CGFloat(tabs.count)) : .none)
                                    Spacer()
                                    
                                    // Bar Indicator
                                    // 글자의 width 값 구하기
                                    let stringWidth: CGFloat = tabs[row].widthOfString(usingFont: .buttons1420Medium)
                                    
                                    if selectedTab == row {
                                        Color
                                            .primary500
                                            .frame(width: stringWidth * 2, height: 1.9)
                                    }
                                    
                                    // Divider
                                    Rectangle().fill(Color.primary600.opacity(0.12))
                                        .frame(height: 1.0)
                                }
                            })
                                .frame(width: (geoWidth / CGFloat(tabs.count)))
                                .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .onChange(of: selectedTab) { target in
                        withAnimation {
                            proxy.scrollTo(target)
                        }
                    }
                }
            }
        }
        .background(
            RoundedCornersShape(
                corners: [.topLeft, .topRight],
                radius: 24
            )
                .fill(Color.gray25)
        )
        .onAppear(perform: {
            //UIScrollView.appearance().backgroundColor = UIColor(Color.blue)
            UIScrollView.appearance().bounces = fixed ? false : true
        })
        .onDisappear(perform: {
            UIScrollView.appearance().bounces = true
        })
    }
}


//struct ClubMemberDetailPage: View {
//
//    // 홈버튼 클릭시, NavigationLink 뒤로가기
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//
//    private struct sizeInfo {
//        static let tabViewHeight: CGFloat = 50.0
//        static let padding: CGFloat = 10.0
//        static let padding5: CGFloat = 5.0
//        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
//        static let topPadding: CGFloat = 44.0 + DefineSize.SafeArea.top
//        static let bottomSheetHeight: CGFloat = 176.0 + DefineSize.SafeArea.bottom
//
//    }
//
//    @State private var scrollToTop: Bool = false
//
//    @State private var headerLayoutOffsetY: CGFloat = CGFloat.zero
//    @State private var headerLayoutOpacity: Double = 0
//    @State private var headerTitleOffsetY: CGFloat = CGFloat.zero
//    @State private var naviTitleOpacity: Double = 0
//
//    @State var isShowMoreBar: Bool = false
//
//    private let tabTitles: [String] = ["작성 글", "작성 댓글", "저장"]
//    private let tabPageTypes: [String] = ["myBoard", "myComment", "myLocalBoard"]
//    @State var currentTab: Int = 0
//
//    @StateObject var viewModel = MainCommunityMyViewModel()
//
//    var body: some View {
//
//        VStack(spacing: 0) {
//            ScalingHeaderScrollView {
//                Spacer().frame(height: sizeInfo.topPadding)
//                GeometryReader { geometry in
//                    let offset = geometry.frame(in: .global).minY
//                    //setOffset(offset: offset)
//                    setNaviLayoutOpacity(offset: offset)
//                    setNaviTitleOpacity(offset: offset)
//
//                    header
//                }
//
//            } content: {
//                VStack {
//                content
//                    .frame(height: DefineSize.Screen.Height)
//                    .padding(.vertical, -40)
//                }
//            }
//            /**
//             * Pod 으로 받은 ScalingHeaderScrollView.swift 에서 public 으로 열어놓은 함수 사용
//             */
//            /// Changes min and max heights of Header
//            .height(min: 140, max: 312)
//
//            /// Allows content scroll reset, need to change Binding to `true`
//            .scrollToTop(resetScroll: $scrollToTop)
//        }
//        .bottomSheet(isPresented: $isShowMoreBar, height: sizeInfo.bottomSheetHeight, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
//            ClubMemberDetailBottomSheet(isShow: $isShowMoreBar) {
////                isShowBottomAlert = true
////                print("\(isShowBottomAlert)프린트")
//            }
//        })
//        .navigationType(leftItems: [.Back], rightItems: [.More], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: headerLayoutOpacity < 0 ? "사용자 닉네임" : "", onPress: { buttonType in
//            if buttonType == .More {
//                isShowMoreBar = true
//            }
//        })
//        .navigationBarBackground {
//            Color.gray25
//        }
//        .statusBarStyle(style: .darkContent)
//        //                    .edgesIgnoringSafeArea(.top)
//    }
//
//    //    // MARK: - Private
//    private var header: some View {
//        //        ZStack {
//        VStack(spacing: 0) {
//            VStack(spacing: 0) {
//                Spacer().frame(height: 70)
//                ExDivider(color: Color.primary600, height: 1)
//                    .opacity(0.12)
//                //                Spacer().frame(height: sizeInfo.padding15)
//                ClubMemberDetailTopView(memberNickname: "사용자 닉네임", memberLevel: "a_general_membership".localized, openDate: "2022. 08. 15", open: "2022. 08. 15", kdg: "365 KDG") {
//                }
//                ExDivider(color: Color.bgLightGray50, height: 8)
//            }
//            .opacity(self.headerLayoutOpacity)
//
//            CustomTabView(currentTab: $currentTab, style: .UnderLine, titles: tabTitles, height: sizeInfo.tabViewHeight)
//
//        }
//        //        }
//        .background(Color.gray25)
//        //            .fixedSize(horizontal: false, vertical: true)
//    }
//
//    private var content: some View {
//
//        ZStack(alignment: .top) {
//            TabView(selection: self.$currentTab, content: {
//                VStack {
//                    tabPage(tabType: tabPageTypes[0], viewModel: self.viewModel)
//                }.tag(0)
//                VStack {
//                    tabPage(tabType: tabPageTypes[1], viewModel: self.viewModel)
//                }.tag(1)
//                VStack {
//                    tabPage(tabType: tabPageTypes[2], viewModel: self.viewModel)
//                }.tag(2)
//            })
//                .tabViewStyle(.page(indexDisplayMode: .never))
//            //                .edgesIgnoringSafeArea(.all)
//            //                            .padding(.top, -100)
//        }
//    }
//
//
//    func setNaviLayoutOpacity(offset: CGFloat) -> some View {
//        DispatchQueue.main.async {
//            self.headerLayoutOffsetY = offset
//            /**
//             * 클럽 제목 제외 나머지
//             */
//            self.headerLayoutOffsetY += 100.0
//            self.headerLayoutOpacity = self.headerLayoutOffsetY / 100.0
//            //print("headerLayoutOpacity : \(self.headerLayoutOpacity)")
//        }
//        return EmptyView()
//    }
//
//    func setNaviTitleOpacity(offset: CGFloat) -> some View {
//        DispatchQueue.main.async {
//            self.headerTitleOffsetY = offset
//            /**
//             * 클럽 제목
//             */
//            self.naviTitleOpacity = self.headerTitleOffsetY / -100.0
//            //print("naviTitleOpacity : \(self.naviTitleOpacity)")
//        }
//        return EmptyView()
//    }
//}
//
//extension ClubMemberDetailPage {
//    func tabPage(tabType: String, viewModel: MainCommunityMyViewModel) -> some View {
//        VStack(spacing: 0) {
//            if tabType == "myBoard" {
//                LazyVStack(spacing: 0) {
//                    ForEach(0..<viewModel.issueTop5_listTopFive.count, id: \.self) { i in
//                        BoardRowView(
//                            viewType: BoardType.MainClub_My,
//                            communityBoardItem: viewModel.issueTop5_listTopFive[i]
//                        )
//                            .background(Color.gray25)
//                    }
//                }
//                .onAppear {
//                    viewModel.getMyBoardList()
//                }
//                // make disable the bouncing
//                .introspectScrollView {
//                    $0.bounces = false
//                }
//
//
//            } else if tabType == "myComment" {
//                LazyVStack(spacing: 0) {
//                    if viewModel.issueTop5_listTopFive.count > 0 {
//                        let forTestData: [Comment_Community] =
//                        viewModel.issueTop5_listTopFive[0].comment
//
//                        ForEach(forTestData, id: \.self) { item in
//                            CommentRowView(itemData: item)
//                                .background(Color.gray25)
//                        }
//                    }
//                }
//                .onAppear {
//                    viewModel.getCommentList()
//                }
//                // make disable the bouncing
//                .introspectScrollView {
//                    $0.bounces = false
//                }
//            }  else if tabType == "myLocalBoard" {
//                LazyVStack(spacing: 0) {
//                    ForEach(0..<viewModel.issueTop5_listTopFive.count, id: \.self) { i in
//                        BoardRowView(
//                            viewType: BoardType.MainCommunity,
//                            communityBoardItem: viewModel.issueTop5_listTopFive[i]
//                        )
//                            .background(Color.gray25)
//                    }
//                }
//                .onAppear {
//                    viewModel.getMyBoardList()
//                }
//                // make disable the bouncing
//                .introspectScrollView {
//                    $0.bounces = false
//                }
//            }
//        }
//        .background(Color.bgLightGray50)
//    }
//}
