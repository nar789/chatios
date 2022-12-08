//
//  HomeClubPage.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/12.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

/**
 * 부장님 코드 적용 후
 */
import SwiftUI
//import ScalingHeaderScrollView // 라이브러리 사용 안 함

struct HomeClubPage {
    
    @Binding var clubId: String
    @Binding var state: Bool
    
    @StateObject var viewModel_home = HomeClubHomeTabViewModel()
    @StateObject var viewModel_freeboard = HomeClubFreeboardTabViewModel()
    @StateObject var viewModel_archive = HomeClubArchiveTabViewModel()
    @StateObject var viewModel_bank = HomeClubBankTabViewModel()
    
    // 홈버튼 클릭시, NavigationLink 뒤로가기
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var goToSettingPage = false
    @State private var goToHomeClubSearchPage = false
    @State private var goToClubEditorPage = false
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
    private let headerFixY_common: CGFloat = -100.0
    
    
    /**
     * 언어팩 등록할 것
     */
    //private let tabs: [String] = ["홈", "자유게시판", "아카이브", "금고"]
    private let tabs: [String] = ["h_home".localized, "j_free_board".localized, "a_archive".localized]
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
}

extension HomeClubPage: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            ScrollView {
                VStack(spacing: 0) {
                    //let _ = print("bodyScrollOffsetY : \(bodyScrollOffsetY)" as String)
                    setNaviLayoutOpacity(offset: bodyScrollOffsetY)
                    setNaviTitleOpacity(offset: bodyScrollOffsetY)
                    
                    header
                    
                    GeometryReader { geometry in
                        TabView(selection: $selectedTab) {
                            
                            /**
                             * ScrollView 의 offset 값을 반환받는 커스텀 ScrollView
                             */
                            ScrollViewOffset {
                                if !viewModel_home.isPageLoading {
                                    HomeClubHomeTabView(viewModel: viewModel_home)
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
                                if !viewModel_freeboard.isPageLoading {
                                    HomeClubFreeboardTabView(viewModel: viewModel_freeboard)
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
                                if !viewModel_archive.isPageLoading {
                                    HomeClubArchiveTabView(viewModel: viewModel_archive)
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

                            /**
                             * 광고 관리자 개발되면 '금고 기능' open
                             */
//                            ScrollViewOffset {
//                                if !viewModel_bank.isPageLoading {
//                                    HomeClubBankTabView(viewModel: viewModel_bank)
//                                }
//                            } onOffsetChange: { offset in
//                                //print("tag3 offset : \(offset)" as String)
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
//                            .tag(3)
                            
                        }
                        .background(Color.bgLightGray50)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    }
                }
                //.frame(height: UIScreen.screenHeight)
                .frame(height: UIScreen.screenHeight + 100)
                
            }
            //.background(Color.blue)
            //.frame(height: UIScreen.screenHeight + (-bodyScrollOffsetY))
            .frame(height: UIScreen.screenHeight + 100)
            .offset(x: 0, y: bodyScrollOffsetY)
            
            
            Button(action: {
                print("clicked Register button !!!!!!!!!!")
                goToClubEditorPage = true
            }, label: {
                Image("bg_btn_hover")
            })
            .frame(width: 56, height: 56)
            .padding(.trailing, sizeInfo.Hpadding)
            .padding(.bottom, 52+100)   // ScrollView 길이를 100 추가했으니, padding bottom 값도 100 추가
            
        }
        .onAppear {
            self.callRemoteData()
            print("clubId :: \(clubId)")
        }
        //.background(Color.red)
        .navigationType(
            leftItems: [.Home],
            rightItems: [.Search, .ClubSetting],
            leftItemsForegroundColor: Color.gray25,
            rightItemsForegroundColor: Color.gray25,
            title: "",
            onPress: { buttonType in
                if buttonType == .Home {
                    state = false
                    presentationMode.wrappedValue.dismiss()
                }
                else if buttonType == .Search {
                    goToHomeClubSearchPage = true
                }
                else if buttonType == .ClubSetting {
                    goToSettingPage = true
                }
            })
        .navigationBarBackground {
            Color.clear
        }
        .statusBarStyle(style: .darkContent)
        .edgesIgnoringSafeArea(.top)
        //.edgesIgnoringSafeArea(.bottom)
        .background(
            NavigationLink("", isActive: $goToHomeClubSearchPage) {
                HomeClubSearchPage()
            }.hidden()
        )
        .background(
            NavigationLink("", isActive: $goToSettingPage) {
                ClubSettingPage(clubId: $clubId, memberId: .constant(0))
            }.hidden()
        )
        .background(
            NavigationLink("", isActive: $goToClubEditorPage) {
                ClubEditorPage()
            }.hidden()
        )
    }
    
    private var header: some View {
        ZStack {
            
            Image("profile_club_bg")
                .resizable()
                .frame(height: 265)
            
            VStack(alignment: .leading, spacing: 0) {
                ZStack {
                    VStack(spacing: 0) {
                        Spacer()
                        
                        Group {
                            HStack(spacing: 0) {
                                Image("profile_club_character")
                                    .resizable()
                                    .frame(width: 38, height: 38)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        Text("백예린 팬클립")
                                            .font(.title51622Medium)
                                            .foregroundColor(.gray25)
                                        Spacer()
                                    }
                                    
                                    HStack(spacing: 0) {
                                        Text("멤버 4.6만")
                                            .font(.caption11218Regular)
                                            .foregroundColor(.gray25)
                                        Image("icon_fill_Information")
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: 13.33, height: 13.33)
                                            .foregroundColor(.gray25)
                                            .padding(.top, 3.77)
                                            .padding(.leading, 5.75)
                                        Spacer()
                                    }
                                }
                                .padding(.leading, 12)
                            }
                            
                            Text("클럽 많은 관심과 사랑 부탁드립니다! 클럽 많은 관심과 사랑 부탁드립니다! 클럽 많은 관심과 사랑 부탁드립니다!")
                                .font(.caption11218Regular)
                                .foregroundColor(.gray25)
                                .padding(.top, 11)
                                .padding(.bottom, 14)
                        }
                        .padding(.horizontal, sizeInfo.Hpadding)
                        //.opacity(self.headerLayoutOffsetY == -100.0 ? 0.0 : 1.0)
                        .opacity(self.headerLayoutOpacity)
                    }
                    
                    VStack(spacing: 0) {
                        Spacer()
                        
                        Text("백예린 클럽")
                            .font(.title41824Medium)
                            .foregroundColor(.stateEnableGray25)
                            .padding(.bottom, 10)
                            .opacity(self.naviTitleOpacity)
                    }
                    
                }
                
                tabBar
                    .frame(width: UIScreen.screenWidth, height: 50)
            }
        }
        // 배경 이미지와 높이 동일하게 맞추기
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private var tabBar: some View {
        GeometryReader { geometry in
            HomeClubPageTabs(tabs: tabs, geoWidth: geometry.size.width, selectedTab: $selectedTab)
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

extension HomeClubPage {
    func callRemoteData() {
        self.viewModel_home.getTabHome()
        self.viewModel_freeboard.getTabFreeboard()
        self.viewModel_archive.getTabArchive()
        //self.viewModel_bank.getTabBank()
    }
}

struct HomeClubPageTabs: View {
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
                                        .foregroundColor(selectedTab == row ? Color.gray900 : Color.gray400)
                                        .frame(width: fixed ? (geoWidth / CGFloat(tabs.count)) : .none)
                                    Spacer()
                                    
                                    // Bar Indicator
                                    // 글자의 width 값 구하기
                                    let stringWidth: CGFloat = tabs[row].widthOfString(usingFont: .buttons1420Medium)
                                    
                                    if selectedTab == row {
                                        Color
                                            .gray900
                                            .frame(width: stringWidth, height: 1.9)
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

//struct HomeClubPage_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeClubPage()
//    }
//}






/**
 * 부장님 코드 적용 전
 */
//import SwiftUI
//import ScalingHeaderScrollView
//
//struct HomeClubPage {
//    // 홈버튼 클릭시, NavigationLink 뒤로가기
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//
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
//    @State private var bodyScrollOffsetY: CGFloat = CGFloat.zero
//    // HeaderScrollView를 위로 강제 이동시, 목표 View에 설정할 아이디
//    @Namespace private var StickyHeader_TopID
//    // HeaderScrollView를 아래로 강제 이동시, 목표 View에 설정할 아이디
//    @Namespace private var StickyHeader_BottomID
//
//
//    /**
//     * 언어팩 등록할 것
//     */
//    private let tabs: [String] = ["홈", "자유게시판", "아카이브", "금고"]
//
//    private struct sizeInfo {
//        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
//    }
//}
//
//extension HomeClubPage: View {
//    var body: some View {
//        GeometryReader { geometry in
//            VStack(spacing: 0) {
//
//                ZStack(alignment: .bottomTrailing) {
//
//                    /**
//                     * 컨텐츠 영역
//                     */
//                    ScrollViewReader { proxyReader in
//
//                        ScalingHeaderScrollView {
//                            GeometryReader { geometry in
//                                // Sticky Header
//                                let offset = geometry.frame(in: .global).minY
//                                setNaviLayoutOpacity(offset: offset)
//                                setNaviTitleOpacity(offset: offset)
//
//                                header
//                            }
//                            .id(StickyHeader_TopID)
//                        } content: {
//
//                            /**
//                             * Sticky Header 기능 구현 못 한 경우
//                             */
//    //                        if selectedTab == 0 {
//    //                            HomeClubHomeTabView()
//    //                        }
//    //                        else if selectedTab == 1 {
//    //                            HomeClubFreeboardTabView()
//    //                        }
//    //                        else if selectedTab == 2 {
//    //                            VStack(spacing: 0) {
//    //                                Text("Tab 3")
//    //                                HomeClubHomeTabView()
//    //                            }
//    //                        }
//    //                        else if selectedTab == 3 {
//    //                            VStack(spacing: 0) {
//    //                                Text("Tab 4")
//    //                                HomeClubHomeTabView()
//    //                            }
//    //                        }
//
//                            /**
//                             * Sticky Header 기능 구현 한 경우
//                             */
//                            GeometryReader { geometry in
//                                TabView(selection: $selectedTab) {
//
//                                    /**
//                                     * ScrollView 의 offset 값을 반환받는 커스텀 ScrollView
//                                     */
//                                    ScrollViewOffset {
//                                        HomeClubHomeTabView()
//                                    } onOffsetChange: {
//                                        bodyScrollOffsetY = $0
//
//                                        if bodyScrollOffsetY == 0.0 {
//                                            // 애니메이션과 함께 스크롤 탑 액션 지정
//                                            withAnimation(.default) {
//                                                proxyReader.scrollTo(StickyHeader_TopID)
//                                                //proxyReader.scrollTo(StickyHeader_BottomID)
//
//                                            }
//                                        }
//                                        else if bodyScrollOffsetY < 0.0 {
//                                            // 애니메이션과 함께 스크롤 탑 액션 지정
//                                            withAnimation(.default) {
//                                                //proxyReader.scrollTo(StickyHeader_TopID)
//                                                proxyReader.scrollTo(StickyHeader_BottomID)
//                                            }
//                                        }
//                                    }
//                                    .tag(0)
//
//                                    ScrollView {
//                                        HomeClubFreeboardTabView()
//                                    }
//                                    .tag(1)
//
//                                    ScrollView {
//                                        HomeClubArchiveTabView()
//                                    }
//                                    .tag(2)
//
//                                    ScrollView {
//                                        HomeClubBankTabView()
//                                    }
//                                    .tag(3)
//                                }
//                                .id(StickyHeader_BottomID)
//                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//                            }
//                            .frame(height: UIScreen.screenHeight)
//
//
//                        }
//                        // Pod 으로 받은 ScalingHeaderScrollView.swift 에서 public 으로 열어놓은 함수 사용
//                        // Changes min and max heights of Header
//                        .height(min: 140, max: 240)
//                    }
//
//                    /**
//                     * 클럽생성 버튼 영역
//                     */
//                    Button(action: {
//                        print("clicked Register button !!!!!!!!!!")
//                    }, label: {
//                        Image("bg_btn_hover")
//                    })
//                    .frame(width: 56, height: 56)
//                    .padding(.trailing, sizeInfo.Hpadding)
//                    .padding(.bottom, 52)
//
//                }
//            }
//            .background(Color.bgLightGray50)
//        }
//        .navigationType(
//            leftItems: [.Home],
//            rightItems: [.Search, .ClubSetting],
//            leftItemsForegroundColor: Color.gray25,
//            rightItemsForegroundColor: Color.gray25,
//            title: "",
//            onPress: { buttonType in
//                if buttonType == .Home {
//                    presentationMode.wrappedValue.dismiss()
//                }
//                else if buttonType == .Search {
//                    print("clicked Search button !!!!!!!!!!")
//                }
//                else if buttonType == .Setting {
//                    print("clicked Setting button !!!!!!!!!!")
//                }
//            })
//        .navigationBarBackground {
//            Color.clear
//        }
//        .statusBarStyle(style: .darkContent)
//        .edgesIgnoringSafeArea(.top)
//        .edgesIgnoringSafeArea(.bottom)
//    }
//
//    private var header: some View {
//        ZStack {
//
//            Image("profile_club_bg")
//                .resizable()
//                .frame(height: 240)
//
//            VStack(alignment: .leading, spacing: 0) {
//                ZStack {
//                    VStack(spacing: 0) {
//                        Spacer()
//
//                        Group {
//                            HStack(spacing: 0) {
//                                Image("profile_club_character")
//                                    .resizable()
//                                    .frame(width: 38, height: 38)
//                                    .clipShape(RoundedRectangle(cornerRadius: 12))
//
//                                VStack(spacing: 0) {
//                                    HStack(spacing: 0) {
//                                        Text("백예린 팬클립")
//                                            .font(.title51622Medium)
//                                            .foregroundColor(.gray25)
//                                        Spacer()
//                                    }
//
//                                    HStack(spacing: 0) {
//                                        Text("멤버 4.6만")
//                                            .font(.caption11218Regular)
//                                            .foregroundColor(.gray25)
//                                        Image("icon_fill_Information")
//                                            .resizable()
//                                            .renderingMode(.template)
//                                            .frame(width: 13.33, height: 13.33)
//                                            .foregroundColor(.gray25)
//                                            .padding(.top, 3.77)
//                                            .padding(.leading, 5.75)
//                                        Spacer()
//                                    }
//                                }
//                                .padding(.leading, 12)
//                            }
//
//                            Text("클럽 많은 관심과 사랑 부탁드립니다! 클럽 많은 관심과 사랑 부탁드립니다! 클럽 많은 관심과 사랑 부탁드립니다!")
//                                .font(.caption11218Regular)
//                                .foregroundColor(.gray25)
//                                .padding(.top, 11)
//                                .padding(.bottom, 14)
//                        }
//                        .padding(.horizontal, sizeInfo.Hpadding)
//                        //.opacity(self.headerLayoutOffsetY == -100.0 ? 0.0 : 1.0)
//                        .opacity(self.headerLayoutOpacity)
//                    }
//
//                    VStack(spacing: 0) {
//                        Spacer()
//
//                        Text("백예린 클럽")
//                            .font(.title41824Medium)
//                            .foregroundColor(.stateEnableGray25)
//                            .padding(.bottom, 8)
//                            .opacity(self.naviTitleOpacity)
//                    }
//
//                }
//
//                tabBar
//                    .frame(width: UIScreen.screenWidth, height: 50)
//            }
//        }
//        // 배경 이미지와 높이 동일하게 맞추기
//        .fixedSize(horizontal: false, vertical: true)
//    }
//
//    private var tabBar: some View {
//        GeometryReader { geometry in
//            HomeClubPageTabs(tabs: tabs, geoWidth: geometry.size.width, selectedTab: $selectedTab)
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
//
//struct HomeClubPageTabs: View {
//    var fixed = false
//    var tabs: [String]
//    var geoWidth: CGFloat
//    @Binding var selectedTab: Int
//
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            ScrollViewReader { proxy in
//                VStack(spacing: 0) {
//                    HStack(spacing: 0) {
//                        ForEach(0 ..< tabs.count, id: \.self) { row in
//
//                            Button(action: {
//                                withAnimation {
//                                    selectedTab = row
//                                }
//                            }, label: {
//                                VStack(spacing: 0) {
//                                    Spacer()
//                                    Text(tabs[row])
//                                        .font(.buttons1420Medium)
//                                        .foregroundColor(selectedTab == row ? Color.gray900 : Color.gray400)
//                                        .frame(width: fixed ? (geoWidth / CGFloat(tabs.count)) : .none)
//                                    Spacer()
//
//                                    // Bar Indicator
//                                    // 글자의 width 값 구하기
//                                    let stringWidth: CGFloat = tabs[row].widthOfString(usingFont: .buttons1420Medium)
//
//                                    if selectedTab == row {
//                                        Color
//                                            .gray900
//                                            .frame(width: stringWidth, height: 1.9)
//                                    }
//
//                                    // Divider
//                                    Rectangle().fill(Color.primary600.opacity(0.12))
//                                        .frame(height: 1.0)
//                                }
//                            })
//                            .frame(width: (geoWidth / CGFloat(tabs.count)))
//                            .buttonStyle(PlainButtonStyle())
//                        }
//                    }
//                    .onChange(of: selectedTab) { target in
//                        withAnimation {
//                            proxy.scrollTo(target)
//                        }
//                    }
//                }
//            }
//        }
//        .background(
//            RoundedCornersShape(
//                corners: [.topLeft, .topRight],
//                radius: 24
//            )
//            .fill(Color.gray25)
//        )
//        .onAppear(perform: {
//            //UIScrollView.appearance().backgroundColor = UIColor(Color.blue)
//            UIScrollView.appearance().bounces = fixed ? false : true
//        })
//        .onDisappear(perform: {
//            UIScrollView.appearance().bounces = true
//        })
//    }
//}
//
//struct HomeClubPage_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeClubPage()
//    }
//}
