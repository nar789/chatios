//
//  FantooTvPage.swift
//  fantoo
//
//  Created by fns on 2022/08/17.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
//import ScalingHeaderScrollView // 라이브러리 사용 안 함

struct FantooTvPage {
    @StateObject var viewModel = FantooTvViewModel()
    
    // 홈버튼 클릭시, NavigationLink 뒤로가기
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var goToSettingPage = false
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
    private let followY = "팔로우"
    private let followN = "팔로잉"
    
    @State private var showInfoAlert = false
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
}

extension FantooTvPage: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if self.viewModel.fantooTV_Tabs.count > 0 {
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
                                    homeTabContentsView
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
                                    channelTabContentsView
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
                            }
                            .background(Color.bgLightGray50)
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        }
                    }
                    .frame(height: UIScreen.screenHeight + 100)
                    
                }
                //.background(Color.blue)
                //.frame(height: UIScreen.screenHeight + (-bodyScrollOffsetY))
                .frame(height: UIScreen.screenHeight + 100)
                .offset(x: 0, y: bodyScrollOffsetY)
            }
        }
        .onAppear {
            self.callRemoteData()
        }
        //.background(Color.red)
        .navigationType(
            leftItems: [.Back],
            rightItems: [.Search],
            leftItemsForegroundColor: Color.gray25,
            rightItemsForegroundColor: Color.gray25,
            title: "",
            onPress: { buttonType in
                if buttonType == .Home {
                    presentationMode.wrappedValue.dismiss()
                }
                else if buttonType == .Search {
                    print("clicked Search button !!!!!!!!!!")
                }
                else if buttonType == .ClubSetting {
                    goToSettingPage = true
                    print("clicked Setting button !!!!!!!!!!")
                }
            })
        .background(
            NavigationLink("", isActive: $goToSettingPage) {
                ClubSettingPage(clubId: .constant("81"), memberId: .constant(141))
            }.hidden()
        )
        .navigationBarBackground {
            Color.clear
        }
        .statusBarStyle(style: .darkContent)
        .edgesIgnoringSafeArea(.top)
        //.edgesIgnoringSafeArea(.bottom)
        .showFollowAlert(isPresented: $showInfoAlert, title: "p_fantoo_tv".localized, message: "12.345만명", number: "", detailMessage: "세계적인 아이돌 그룹인 BTS와 함께할 클럽원\n모집합니다! 클럽 많은 관심과 사랑 부탁!^^\n먹긴 우리의 BTS팬클럽 소개를 해드릴까해요!!\n클럽 많은 관심과 사랑 부탁드립니다!", buttons: ["공유하기", "d_close".localized], onClick: { buttonIndex in
            
        }, onPress: {
            
        })
    }
    
    private var header: some View {
        ZStack {
            Image("hanryutimes_bg")
                .resizable()
                .frame(height: 265)
            
            VStack(alignment: .leading, spacing: 0) {
                ZStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer()
                        
                        Group {
                            HStack(spacing: 0) {
                                Group {
                                    WebImage(url: URL(string: self.viewModel.profileImg))
                                        .placeholder(content: {
                                            Image("profile_club_character")
                                                .resizable()
                                        })
                                        .resizable()
                                }
                                .frame(width: 38, height: 38)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        Text(self.viewModel.clubName)
                                            .font(.title51622Medium)
                                            .foregroundColor(.gray25)
                                        Spacer()
                                    }
                                    
                                    HStack(spacing: 0) {
                                        let fllower: String = "팔로워 " + String(self.viewModel.memberCount) + "명"
                                        Text(fllower)
                                            .font(.caption11218Regular)
                                            .foregroundColor(.gray25)
                                        Button {
                                            showInfoAlert = true
                                        } label: {
                                            Image("icon_fill_Information")
                                                .resizable()
                                                .renderingMode(.template)
                                                .frame(width: 13.33, height: 13.33)
                                                .foregroundColor(.gray25)
                                                .padding(.top, 3.33)
                                                .padding(.leading, 3.33)
                                        }
                                        Spacer()
                                    }
                                }
                                .padding(.leading, 12)
                                Spacer()
                                ZStack {
                                    Text(self.viewModel.follow ? followY : followN)
                                        .frame(width: 50, height: 26)
                                        .font(.caption11218Regular)
                                        .foregroundColor(.gray25)
                                    
                                        .background(self.viewModel.follow ? Color.primary500 : Color.clear)
                                        .cornerRadius(6)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(Color.gray25, lineWidth: 1)
                                                .frame(width: 50, height: 26)
                                        )
                                }
                            }
                            
                            Text(self.viewModel.introduction)
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
                        
                        Text("p_fantoo_tv".localized)
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
            HomeClubPageTabs(tabs: self.viewModel.fantooTV_Tabs, geoWidth: geometry.size.width, selectedTab: $selectedTab)
        }
    }
    
    private var homeTabContentsView: some View {
        LazyVStack(spacing: 0) {
            if self.viewModel.homeTab_PostList.count > 0 {
                ForEach(Array(self.viewModel.homeTab_PostList.enumerated()), id: \.offset) { index, element in
                    
                    BoardRowView(viewType: BoardType.HomeClubType1,
                                 fantooTVHomeTabItem: element,
                                 likeCount: (self.getClubLikeInfo(index: index, type: BoardLikeInfoType.LikeCount) as! Int),
                                 likeBtnColor: (self.getClubLikeInfo(index: index, type: BoardLikeInfoType.LikeBtnColor) as! Color),
                                 dislikeBtnColor: (self.getClubLikeInfo(index: index, type: BoardLikeInfoType.DisLikeBtnColor) as! Color),
                                 likeTxtColor: (self.getClubLikeInfo(index: index, type: BoardLikeInfoType.LikeTxtColor) as! Color),
                                 onPress: { buttonType in
                        switch buttonType {
                        case BoardButtonType.More:
                            print("more button cliked !")
                        case .Like:
                            print("like button cliked !")
                            
                            self.clickLike(categoryCode: self.viewModel.homeTab_PostList[index].categoryCode, likeType: "like", url_postId: self.viewModel.homeTab_PostList[index].postId, index: index)
                            
                        case .Dislike:
                            print("dislike button cliked !")
                            
                            self.clickLike(categoryCode: self.viewModel.homeTab_PostList[index].categoryCode, likeType: "dislike", url_postId: self.viewModel.homeTab_PostList[index].postId, index: index)
                        case .Comment:
                            print("comment button cliked !")
                        }
                    })
                    .background(Color.gray25)
                    .padding(.top, index==0 ? 0 : 8)
                }
            }
        }
    }
    
    private var channelTabContentsView: some View {
        VStack(spacing: 0) {
            if self.viewModel.channelTab_CategoryList.count > 0 {
                ForEach(Array(self.viewModel.channelTab_CategoryList.enumerated()), id: \.offset) { index, element in
                    
                    HStack(spacing: 0) {
                        Text(element.categoryName)
                            .font(.body21420Regular)
                            .foregroundColor(.gray870)
                        
                        Spacer()
                        
                        if let NOpostCount = element.postCount {
                            Text(String(NOpostCount))
                                .font(.buttons1420Medium)
                                .foregroundColor(.gray870)
                                .padding(.bottom, 1.5) // font가 밑으로 약간 치우친 거 같아서 padding 줌
                                .padding(.horizontal, 6)
                                .background(Color.gray50)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                    .padding(14)
                    .background(Color.gray25)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: Color.gray100, radius: 3)
                    .padding(.top, index==0 ? 0 : 12)
                }
            }
        }
        .padding(.vertical, sizeInfo.Hpadding)
        .padding(.horizontal, sizeInfo.Hpadding)
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
    
    
    /**
     * 클럽 게시글 좋아요/싫어요 클릭 후, 결과 값 가져오기
     */
    func getClubLikeInfo(index: Int, type: BoardLikeInfoType) -> Any {
        if type == BoardLikeInfoType.LikeCount {
            let likeCount: Int = viewModel.homeTab_PostList[index].like.likeCount-viewModel.homeTab_PostList[index].like.dislikeCount
            return likeCount
        }
        else if type == BoardLikeInfoType.LikeBtnColor {
            if let NOlikeYn = viewModel.homeTab_PostList[index].like.likeYn {
                let likeBtnColor: Color = NOlikeYn ? Color.stateActivePrimaryDefault : Color.stateDisabledGray200
                
                return likeBtnColor
            }
            else {
                return Color.stateDisabledGray200
            }
        }
        else if type == BoardLikeInfoType.DisLikeBtnColor {
            if let NOlikeYn = viewModel.homeTab_PostList[index].like.likeYn {
                let dislikeBtnColor: Color = NOlikeYn ? Color.stateDisabledGray200 : Color.stateActiveGray700
                
                return dislikeBtnColor
            }
            else {
                return Color.stateDisabledGray200
            }
        }
        else if type == BoardLikeInfoType.LikeTxtColor {
            if let NOlikeYn = viewModel.homeTab_PostList[index].like.likeYn {
                let likeTxtColor: Color = NOlikeYn ? Color.stateActivePrimaryDefault : Color.stateActiveGray700
                
                return likeTxtColor
            }
            else {
                return Color.stateActiveGray700
            }
        }
        else {
            return ""
        }
    }
}

extension FantooTvPage {
    func callRemoteData() {
        self.viewModel.getDetailTop(clubId: "fantoo_tv")
        self.viewModel.getTabInfo(clubId: "fantoo_tv", integUid: UserManager.shared.uid)
        self.viewModel.getHomeTab(clubId: "fantoo_tv", categoryCode: "home", integUid: UserManager.shared.uid, nextId: nil, size: nil)
        self.viewModel.getFollowInfo(clubId: "fantoo_tv", integUid: UserManager.shared.uid, access_token: UserManager.shared.accessToken)
    }
    
    func clickLike(categoryCode: String, likeType: String, url_postId: Int, index: Int) {
        self.viewModel.patchFantooTVLike(clubId: "fantoo_tv", likeType: likeType, categoryCode: categoryCode, url_postId: url_postId, integUid: UserManager.shared.uid, access_token: UserManager.shared.accessToken, clickedIndex: index)
    }
}

