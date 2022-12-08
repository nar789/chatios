//
//  TestMemberView.swift
//  fantoo
//
//  Created by fns on 2022/07/25.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//
//
import Foundation
import SwiftUI

struct ClubClosingMemberDetailPageTabs: View {
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

//// 사용안하는중인듯 22.10.19
//struct ClubClosingMemberDetailPage {
//    @StateObject var viewModel_home = HomeClubHomeTabViewModel()
//    @StateObject var viewModel_freeboard = HomeClubFreeboardTabViewModel()
//    @StateObject var viewModel_archive = HomeClubArchiveTabViewModel()
//    @StateObject var viewModel_bank = HomeClubBankTabViewModel()
//
//    // 홈버튼 클릭시, NavigationLink 뒤로가기
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    @State private var showBottomView = false
//    @State private var selectedTab: Int = 0
//
//    // Sticky Header 불투명 값
//    @State private var headerLayoutOffsetY: CGFloat = CGFloat.zero
//    @State private var headerLayoutOpacity: Double = CGFloat.zero
//    @State private var headerTitleOffsetY: CGFloat = CGFloat.zero
//    @State private var naviTitleOpacity: Double = CGFloat.zero
//
//    /**
//     *  BodyScrollView 스크롤시, HeaderScrollView를 강제로 이동시키기
//     */
//    // Body ScrollView 스크롤시 반환되는 offset 값 저장
//    @State private var bodyScrollOffsetY: CGFloat = 0
//    private let headerFixY_common: CGFloat = -100.0
//
//    @StateObject var viewModel = MainCommunityMyViewModel()
//
//    /**
//     * 언어팩 등록할 것
//     */
//    private let tabs: [String] = ["j_wrote_post".localized, "j_wrote_rely".localized, "j_save".localized]
//
//    private struct sizeInfo {
//        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
//        static let bottomSheetHeight: CGFloat = 326.0 + DefineSize.SafeArea.bottom
//
//    }
//}
//
//extension ClubClosingMemberDetailPage: View {
//    var body: some View {
//        ZStack(alignment: .center) {
//
//            ScrollView {
//                VStack(spacing: 0) {
//                    let _ = print("bodyScrollOffsetY : \(bodyScrollOffsetY)" as String)
//                    setNaviLayoutOpacity(offset: bodyScrollOffsetY)
//                    setNaviTitleOpacity(offset: bodyScrollOffsetY)
//                    Spacer().frame(height: bodyScrollOffsetY == 0 ? 90 : 0)
//                    header
//
//                    GeometryReader { geometry in
//                        TabView(selection: $selectedTab) {
//
//                            /**
//                             * ScrollView 의 offset 값을 반환받는 커스텀 ScrollView
//                             */
//                            ScrollViewOffset {
//                                LazyVStack(spacing: 0) {
//                                    ForEach(0..<viewModel.issueTop5_listTopFive.count, id: \.self) { i in
//                                        BoardRowView(
//                                            viewType: BoardType.MainClub_My,
//                                            communityBoardItem: viewModel.issueTop5_listTopFive[i]
//                                        )
//                                            .background(Color.gray25)
//                                        ExDivider(color: Color.bgLightGray50, height: 8)
//                                    }
//                                    ForEach(0..<viewModel.issueTop5_listTopFive.count, id: \.self) { i in
//                                        BoardRowView(
//                                            viewType: BoardType.MainClub_My,
//                                            communityBoardItem: viewModel.issueTop5_listTopFive[i]
//                                        )
//                                            .background(Color.gray25)
//                                        ExDivider(color: Color.bgLightGray50, height: 8)
//                                    }
//                                }
//                                .onAppear {
//                                    viewModel.getMyBoardList()
//                                }
//                                // make disable the bouncing
//                                .introspectScrollView {
//                                    $0.bounces = false
//                                }
//                            } onOffsetChange: { offset in
//                                //print("tag0 offset : \(offset)" as String)
//
//                                if offset > 0 {
//                                    bodyScrollOffsetY = 0
//                                }
//                                else {
//                                    if offset < headerFixY_common {
//                                        bodyScrollOffsetY = headerFixY_common
//                                    }
//                                    else {
//                                        bodyScrollOffsetY = offset
//                                    }
//                                }
//                            }
//                            .tag(0)
//
//
//                            ScrollViewOffset {
//                                LazyVStack(spacing: 0) {
//                                    if viewModel.issueTop5_listTopFive.count > 0 {
//                                        let forTestData: [Comment_Community] =
//                                        viewModel.issueTop5_listTopFive[0].comment
//
//                                        ForEach(forTestData, id: \.self) { item in
//                                            CommentRowView(itemData: item)
//                                                .background(Color.gray25)
//                                            ExDivider(color: Color.bgLightGray50, height: 8)
//                                        }
//                                    }
//                                }
//                                .onAppear {
//                                    viewModel.getCommentList()
//                                }
//                                // make disable the bouncing
//                                .introspectScrollView {
//                                    $0.bounces = false
//                                }
//                            } onOffsetChange: { offset in
//                                //print("tag1 offset : \(offset)" as String)
//
//                                if offset > 0 {
//                                    bodyScrollOffsetY = 0
//                                }
//                                else {
//                                    if offset < headerFixY_common {
//                                        bodyScrollOffsetY = headerFixY_common
//                                    }
//                                    else {
//                                        bodyScrollOffsetY = offset
//                                    }
//                                }
//
//                            }
//                            .tag(1)
//
//                            ScrollViewOffset {
//                                LazyVStack(spacing: 0) {
//                                    ForEach(0..<viewModel.issueTop5_listTopFive.count, id: \.self) { i in
//                                        BoardRowView(
//                                            viewType: BoardType.MainCommunity,
//                                            communityBoardItem: viewModel.issueTop5_listTopFive[i]
//                                        )
//                                            .background(Color.gray25)
//                                        ExDivider(color: Color.bgLightGray50, height: 8)
//
//                                    }
//                                    ForEach(0..<viewModel.issueTop5_listTopFive.count, id: \.self) { i in
//                                        BoardRowView(
//                                            viewType: BoardType.MainCommunity,
//                                            communityBoardItem: viewModel.issueTop5_listTopFive[i]
//                                        )
//                                            .background(Color.gray25)
//                                        ExDivider(color: Color.bgLightGray50, height: 8)
//                                    }
//                                }
//                                .onAppear {
//                                    viewModel.getMyBoardList()
//                                }
//                                // make disable the bouncing
//                                .introspectScrollView {
//                                    $0.bounces = false
//                                }
//                            } onOffsetChange: { offset in
//                                //print("tag2 offset : \(offset)" as String)
//
//                                if offset > 0 {
//                                    bodyScrollOffsetY = 0
//                                }
//                                else {
//                                    if offset < headerFixY_common {
//                                        bodyScrollOffsetY = headerFixY_common
//                                    }
//                                    else {
//                                        bodyScrollOffsetY = offset
//                                    }
//                                }
//
//                            }
//                            .tag(2)
//                        }
//                        .background(Color.bgLightGray50)
//                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//                    }
//                }
//                //.frame(height: UIScreen.screenHeight)
//                .frame(height: UIScreen.screenHeight + 200)
//
//            }
//            //.frame(height: UIScreen.screenHeight + (-bodyScrollOffsetY))
//            .frame(height: UIScreen.screenHeight + 200)
//            .offset(x: 0, y: bodyScrollOffsetY)
//
//        }
////        .onAppear {
////            self.callRemoteData()
////        }
//        .bottomSheet(isPresented: $showBottomView, height: sizeInfo.bottomSheetHeight, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
//            ClubMemberDetailBottomSheet(isShow: $showBottomView, subTitle: "") {
//
//            }
//        })
//        .navigationType(leftItems: [.Back], rightItems: [.More], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: naviTitleOpacity != 0 ? "사용자 닉네임" : "", onPress: { buttonType in
//            if buttonType == .More {
//                showBottomView = true
//            }
//        })
//        .navigationBarBackground {
//            Color.gray25
//        }
//        .statusBarStyle(style: .darkContent)
//    }
//
//    private var header: some View {
//        ZStack {
//
//            VStack(alignment: .leading, spacing: 0) {
//                ZStack {
//                    VStack(spacing: 0) {
//                        Spacer()
//                        ClubMemberDetailTopView(memberNickname: "사용자 닉네임", memberLevel: "a_general_membership".localized, openDate: "2022. 08. 15", open: "2022. 08. 15", kdg: "365 KDG") {
//                        }
//                        ExDivider(color: Color.bgLightGray50, height: 8)
//                    }
//                    .opacity(headerLayoutOpacity)
//                    let _ = print("확인\(headerLayoutOpacity)")
//                }
//
//                tabBar
//                    .frame(width: UIScreen.screenWidth, height: 50)
//            }
//        }
//        .frame(height: 300)
//        // 배경 이미지와 높이 동일하게 맞추기
//        .fixedSize(horizontal: false, vertical: true)
//    }
//
//    private var tabBar: some View {
//        GeometryReader { geometry in
//            ClubClosingMemberDetailPageTabs(tabs: tabs, geoWidth: geometry.size.width, selectedTab: $selectedTab)
//        }
//    }
//
//    func setNaviLayoutOpacity(offset: CGFloat) -> some View {
//        DispatchQueue.main.async {
//            self.headerLayoutOffsetY = offset
//            /**
//             * 클럽 제목 제외 나머지
//             *
//             * Header 영역이 보이면 headerLayoutOffsetY == 0.0
//             * Header 영역이 가려지면 headerLayoutOffsetY == -100.0
//             *
//             * '클럽 제목을 제외한 나머지'는 Header 영역이 보이면 headerLayoutOpacity == 1.0이 되어야 함
//             * '클럽 제목을 제외한 나머지'는 Header 영역이 가려지면 headerLayoutOpacity == 0.0이 되어야 함
//             * 아래는 이 값을 만들기 위한 계산
//             */
//            self.headerLayoutOffsetY += 100.0
//            self.headerLayoutOpacity = self.headerLayoutOffsetY / 100.0
//        }
//        return EmptyView()
//    }
//
//    func setNaviTitleOpacity(offset: CGFloat) -> some View {
//        DispatchQueue.main.async {
//            self.headerTitleOffsetY = offset
//            /**
//             * 클럽 제목
//             *
//             * Header 영역이 최상단에 위치하면 headerTitleOffsetY == 0.0
//             * Header 영역이 최하단에 위치하면 headerTitleOffsetY == -100.0
//             *
//             * '클럽 제목'은 Header 영역이 보이면 0.0이 되어야 함
//             * '클럽 제목'은 Header 영역이 가려지면 1.0이 되어야 함
//             * 아래는 이 값을 만들기 위한 계산
//             */
//            self.naviTitleOpacity = self.headerTitleOffsetY / -100.0
//        }
//        return EmptyView()
//    }
//}

//extension TestMemberView {
//    func callRemoteData() {
//        self.viewModel_home.getTabHome()
//        self.viewModel_freeboard.getTabFreeboard()
//        self.viewModel_archive.getTabArchive()
//        self.viewModel_bank.getTabBank()
//    }
//}

//struct TestMemberView: View {
//    @StateObject var languageManager = LanguageManager.shared
//
//
//    private struct sizeInfo {
//        static let padding20: CGFloat = 20.0
//        static let padding15: CGFloat = 15.5
//        static let stack15: CGFloat = 15.5
//        static let dividerHeight1: CGFloat = 1
//        static let dividerHeight8: CGFloat = 8
//        static let bottomSheetHeight: CGFloat = 176.0 + DefineSize.SafeArea.bottom
//    }
//
//    @State var leftItems: [CustomNavigationBarButtonType] = [.Back]
//    @State var rightItems: [CustomNavigationBarButtonType] = [.More]
//    @State var isShowMoreBar: Bool = false
//    @State var isShowBottomAlert: Bool = false
//
//    var body: some View {
//        ScrollView {
//            ZStack {
//            VStack(spacing: 0) {
//                LazyVStack(spacing: 0) {
//                    Spacer().frame(height: sizeInfo.stack15)
//                    ExDivider(color: Color.primary600, height: sizeInfo.dividerHeight1)
//                        .opacity(0.12)
//                    //                Spacer().frame(height: sizeInfo.padding15)
//                    ClubMemberDetailTopView(memberNickname: "사용자 닉네임", memberLevel: "a_general_membership".localized, openDate: "2022. 08. 15", open: "2022. 08. 15") {
//                    }
//                    ExDivider(color: Color.bgLightGray50, height: sizeInfo.dividerHeight8)
//
//                }
//            }
//            ClubMemberDetailView()
//                .frame(height: 1500)
//
//                if isShowMoreBar {
//                    AnimationBottomAlertView(title: "위임하기 처리 완료")
//                }
//            }
//        }
////        var body: some View {
////            ScrollView(.vertical, showsIndicators: false) {
////                StickyHeader {
////                    StickyHeader {
////                        VStack(spacing: 0) {
////
////                            LazyVStack(spacing: 0) {
////                                Spacer().frame(height: sizeInfo.stack15)
////                                ExDivider(color: Color.primary600, height: sizeInfo.dividerHeight1)
////                                    .opacity(0.12)
////                                //                Spacer().frame(height: sizeInfo.padding15)
////                                ClubMemberDetailTopView(memberNickname: "사용자 닉네임", memberLevel: "a_general_membership".localized, openDate: "2022. 08. 15", open: "2022. 08. 15") {
////                                }
////                                ExDivider(color: Color.bgLightGray50, height: sizeInfo.dividerHeight8)
////
////                            }
////                        }
////                    }
////                }
////                    ClubMemberDetailView()
////                    .frame(height: 1000)
////            }
//
//        .background(Color.gray25)
//        .bottomSheet(isPresented: $isShowMoreBar, height: sizeInfo.bottomSheetHeight, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
//            ClubMemberDetailBottomSheet(isShow: $isShowMoreBar) {
//                isShowBottomAlert = true
//                print("\(isShowBottomAlert)프린트")
//            }
//        })
//        .navigationType(leftItems: [.Back], rightItems: [.More], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "".localized, onPress: { buttonType in
//            if buttonType == .More {
//                isShowMoreBar = true
//            }
//        })
//        .navigationBarBackground {
//            Color.gray25
//        }
//        .statusBarStyle(style: .darkContent)
//        .frame(maxWidth: .infinity, alignment: .leading)
//    }
//
//    private var bookingContentView: some View {
//        VStack {
//            Color.red.frame(height: 100)
//        }
//        .padding(.top, 40)
//        .padding(.horizontal, 24)
//    }
//}
//
//
//struct StickyHeader<Content: View>: View {
//
//    var minHeight: CGFloat
//    var content: Content
//
//    init(minHeight: CGFloat = 230, @ViewBuilder content: () -> Content) {
//        self.minHeight = minHeight
//        self.content = content()
//    }
//
//    var body: some View {
//        GeometryReader { geo in
//            if(geo.frame(in: .global).minY <= 0) {
//                content
//                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
//            } else {
//                content
//                    .offset(y: -geo.frame(in: .global).minY)
//                    .frame(width: geo.size.width, height: geo.size.height + geo.frame(in: .global).minY)
//            }
//        }.frame(minHeight: minHeight)
//    }
//}
