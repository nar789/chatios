//
//  MainClubPage.swift
//  fantooUITests
//
//  Created by kimhongpil on 2022/08/01.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct MainClubPage {
    @StateObject var viewModel = MainClubViewModel()
    @State var clickedClubCategoryPosition = 0
    @State private var showMyClub = false
    @State private var showChallenge = false
    @State private var showClubProfilePage = false
    
    /**
     * 언어팩 등록할 것
     */
    private let myClubTitle = "n_my_club".localized
    private let seeTotal = "전체보기"
    private let isOwner = "a_operate".localized
    private let myClubEmpty = "가입한 클럽이 없습니다.\n클럽에 가입하여 글로벌 친구들과 소통해 보세요!"
    private let challengeTitle = "챌린지"
    private let seeMore = "더보기"
    private let challengeEmpty = "진행중인 챌린지가 없습니다."
    private let popularClubTitle = "a_recomment_poplular_club".localized
    private let popularClubSubTitle = "se_a_recommend_hottest_club".localized
    private let newClubTitle = "신규 클럽 추천"
    private let newClubSubTitle = "내게 맞는 새 클럽이 있는지 살펴보세요."
    private let top10Title = "인기 게시글 TOP10"
    
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
    
    @StateObject var userManager = UserManager.shared
}

extension MainClubPage: View {
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                if let _ = viewModel.mainClub_MainPage {
                    /**
                     * 광고 배너
                     */
                    adView
                    
                    if viewModel.mainClub_MainPage_MyClub.count > 0 {
                        /**
                         * 내 클럽
                         */
                        myClubView
                    }
                    
                    if viewModel.mainClub_MainPage_Challenge.count > 0 {
                        /**
                         * 챌린지
                         */
                        challengeView
                    }
                    
                    /**
                     * 인기 클럽 추천
                     */
                    popularClubRecoView
                    
                    /**
                     * 신규 클럽 추천
                     */
                    newClubRecoView
                    
                    /**
                     * 인기 게시글 TOP10
                     */
                    top10View
                }
            }
        }
        .onAppear() {
            self.callRemoteData()
            
            if viewModel.isPageLoading {
                // 페이지 내에서 로딩
                StatusManager.shared.loadingStatus = .ShowWithTouchable
            }
        }
        .background(
            NavigationLink("", isActive: $showClubProfilePage) {
                HomeClubPage(clubId: .constant("115"), state: .constant(false))
            }.hidden()
        )
        .onChange(of: userManager.showInitialViewState) { value in
            showMyClub = false
            showChallenge = false
            showClubProfilePage = false
        }
        .statusBarStyle(style: .darkContent)
    }
    
    var adView: some View {
        Group {
            if let NOmainClub_MainPage_Ad = viewModel.mainClub_MainPage_Ad {
                WebImage(url: URL(string: NOmainClub_MainPage_Ad.image))
                    .resizable()
                    .frame(height: 68)
            }
        }
    }
    
    var myClubView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(myClubTitle)
                    .font(.title41824Medium)
                    .foregroundColor(.gray900)
                Spacer()
                Text(seeTotal)
                    .font(.caption11218Regular)
                    .foregroundColor(.gray700)
                    .onTapGesture {
                        showMyClub = true
                    }
                    .background(
                        NavigationLink("", isActive: $showMyClub) {
                            MyClubPage(size: .constant("20"), state: true)
                        }.hidden()
                    )
            }
            .padding(EdgeInsets(top: 22, leading: sizeInfo.Hpadding, bottom: 0, trailing: sizeInfo.Hpadding))
            
            myClubListView
        }
    }
    var myClubListView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            if viewModel.mainClub_MainPage_MyClub.count > 0 {
                HStack(spacing: 0) {
                    ForEach(0..<viewModel.mainClub_MainPage_MyClub.count, id: \.self) { i in
                        
                        VStack(spacing: 0) {
                            ZStack(alignment: .bottom) {
                                WebImage(url: URL(string: viewModel.mainClub_MainPage_MyClub[i].club_image))
                                    .resizable()
                                    .frame(width: 54, height: 54)
                                    .cornerRadius(16)
                                    .padding(.bottom, 8)
                                
                                if viewModel.mainClub_MainPage_MyClub[i].owner {
                                    Text(isOwner)
                                        .font(.caption21116Regular)
                                        .foregroundColor(.gray25)
                                        .padding(.vertical, 3)
                                        .padding(.horizontal, 7)
                                        .background(.primary300)
                                        .clipShape(Capsule())
                                }
                            }
                            
                            Text(viewModel.mainClub_MainPage_MyClub[i].club_name)
                                .frame(width: 54)
                                .font(.caption11218Regular)
                                .foregroundColor(.gray900)
                                .lineLimit(2)
                                //.lineSpacing(0) // 큰 숫자인 경우에는 줄 간격이 늘어나는데, 작은 숫자인 경우에는 더 이상 줄 간격이 줄어들지 않음. 이게 미니멈인가??
                                .multilineTextAlignment(.center)
                                .padding(.top, 4)
                        }
                        // 첫 번째 아이템의 leading값은 20, 나머지는 12
                        .padding(.leading, i==0 ? sizeInfo.Hpadding : 12)
                        // 마지막 번째 아이템의 trailing값은 12, 나머지는 0
                        .padding(.trailing, i==viewModel.mainClub_MainPage_MyClub.count-1 ? 12 : 0)
                    }
                }
                .padding(.top, 14)
            } else {
                Text(myClubEmpty)
                    .font(.caption11218Regular)
                    .foregroundColor(.gray500)
                    .frame(width: UIScreen.screenWidth)
                    .multilineTextAlignment(.center)
                    .padding(.top, 22)
            }
        }
    }
    
    var challengeView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(challengeTitle)
                    .font(.title41824Medium)
                    .foregroundColor(.gray900)
                Spacer()
                if viewModel.mainClub_MainPage_Challenge.count > 0 {
                    Text(seeMore)
                        .font(.caption11218Regular)
                        .foregroundColor(.gray700)
                        .onTapGesture {
                            showChallenge = true
                        }
                        .background(
                            NavigationLink("", isActive: $showChallenge) {
                                MainClubChallengePage()
                            }.hidden()
                        )
                }
            }
            
            if viewModel.mainClub_MainPage_Challenge.count > 0 {
                ForEach(0..<viewModel.mainClub_MainPage_Challenge.count, id: \.self) { i in
                    HStack(spacing: 0) {
                        /**
                         * 디자인팀에서 이미지를 잘 못 준 듯.
                         * 원래는 resizable()을 할 필요가 없는데,
                         * 사이즈를 줄이지 않으면 밀려서 가운데 선이 안 보임
                         */
                        Image("challenge")
                            .resizable()
                            .frame(width: 17, height: 17)
                            .padding(.trailing, 8)
                        
                        Text(viewModel.mainClub_MainPage_Challenge[i])
                            .font(.body21420Regular)
                            .foregroundColor(.gray900)
                            .lineLimit(1)
                            .allowsTightening(false) // 글자 압축 안 함 - '점점점'으로 처리
                    }
                    .padding(.top, i==0 ? 8 : 0)
                    
                    if i == 0 {
                        Divider()
                            .padding(.vertical, 7.5)
                    }
                }
            }
            else {
                Text(challengeEmpty)
                    .font(.caption11218Regular)
                    .foregroundColor(.gray500)
                    .padding(.top, 22)
            }
        }
        .padding(EdgeInsets(top: 24, leading: sizeInfo.Hpadding, bottom: 0, trailing: sizeInfo.Hpadding))
    }
    
    var popularClubRecoView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(popularClubTitle)
                .font(.title41824Medium)
                .foregroundColor(.gray900)
                .padding(.top, 28)
                .padding(.leading, sizeInfo.Hpadding)
            Text(popularClubSubTitle)
                .font(.body21420Regular)
                .foregroundColor(.gray500)
                .padding(.top, 2)
                .padding(.leading, sizeInfo.Hpadding)
            
            popularClubRecoView_Category
            
            popularClubRecoView_ClubList
        }
        
    }
    var popularClubRecoView_Category: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                if let NOmainClub_MainPage_PopularClub = viewModel.mainClub_MainPage_PopularClub {
                    ForEach(0..<NOmainClub_MainPage_PopularClub.catagory.count, id: \.self) { i in
                        
                        ZStack(alignment: .center) {
                            RoundedRectangle(cornerRadius: 30)
                                .style(
                                    withStroke: clickedClubCategoryPosition==i ? Color.primary300 : Color.gray100,
                                    lineWidth: 1,
                                    fill: clickedClubCategoryPosition==i ? Color.primary300 : Color.gray25
                                )
                                .padding(.vertical, 1) // padding 값 없으면, 위-아래 테두리 선 약간 잘림
                            
                            Text(NOmainClub_MainPage_PopularClub.catagory[i])
                                .font(.caption11218Regular)
                                .foregroundColor(clickedClubCategoryPosition==i ? Color.gray25 : Color.gray800)
                                .padding(.vertical, 7)
                                .padding(.horizontal, 12)
                                .onTapGesture {
                                    clickedClubCategoryPosition = i
                                }
                        }
                        .fixedSize()
                        .padding(.leading, i==0 ? sizeInfo.Hpadding : 6)
                        .padding(.trailing, i==NOmainClub_MainPage_PopularClub.catagory.count-1 ? 20 : 0)
                    }
                }
            }
            .padding(.top, 16)
        }
    }
    var popularClubRecoView_ClubList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                if let NOmainClub_MainPage_PopularClub = viewModel.mainClub_MainPage_PopularClub {
                    ForEach(0..<NOmainClub_MainPage_PopularClub.club_list.count, id: \.self) { i in
                        
                        VStack(spacing: 0) {

                            HStack(spacing: 0) {
                                WebImage(url: URL(string: NOmainClub_MainPage_PopularClub.club_list[i].profile_image))
                                    .resizable()
                                    .frame(width: 22, height: 22)
                                    .cornerRadius(8)
                                    .padding(.leading, 10)

                                Text(NOmainClub_MainPage_PopularClub.club_list[i].club_name)
                                    .font(.caption11218Regular)
                                    .foregroundColor(.gray600)
                                    .lineLimit(1)
                                    .allowsTightening(false) // 글자 압축 안 함 - '점점점'으로 처리
                                    .padding(.leading, 8)
                                    .padding(.trailing, 10)
                                
                                Spacer()
                            }
                            .padding(.top, 10)

                            /**
                             * join an array of strings into a single string
                             */
                            let joined = "#" + NOmainClub_MainPage_PopularClub.club_list[i].club_tags.joined(separator: " #")
                            Text(joined)
                                .font(.caption11218Regular)
                                .foregroundColor(.gray900)
                                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                                .lineLimit(2)
                                .allowsTightening(false) // 글자 압축 안 함 - '점점점'으로 처리

                            ZStack(alignment: .bottom) {
                                WebImage(url: URL(string: NOmainClub_MainPage_PopularClub.club_list[i].club_image))
                                    .resizable()
                                HStack(spacing: 0) {
                                    let isJoined: Bool = NOmainClub_MainPage_PopularClub.club_list[i].isJoined
                                    
                                    Button(action: {
                                        print("join button clicked !")
                                    }) {
                                        Text(isJoined ? "Joined" : "h_join".localized)
                                            .font(.caption21116Regular)
                                            .foregroundColor(.gray25)
                                            .padding(.vertical, 3)
                                            .padding(.horizontal, 7)
                                            .background(isJoined ? Color.primary500 : Color.gray300.opacity(0.6))
                                            .cornerRadius(8)
                                            .shadow(radius: 3)
                                    }
                                    Spacer()
                                }
                                .padding(.leading, 10)
                                .padding(.bottom, 10)
                            }
                            .padding(.top, 10)
                        }
                        .background(Color.gray25)
                        .frame(width: 150, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 14.0))
                        //   .shadow(radius: 3)
                        .shadow(color: Color.gray400.opacity(0.5), radius:5)
                        .padding(.leading, i==0 ? 20 : 10)
                        .padding(.trailing, i==NOmainClub_MainPage_PopularClub.club_list.count-1 ? 20 : 0)
                        .padding(.bottom, 26)
                        .onTapGesture(perform: {
                            showClubProfilePage = true
                        })
                    }
                }
            }
            .padding(.top, 20)
        }
    }
    
    var newClubRecoView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(newClubTitle)
                .font(.title41824Medium)
                .foregroundColor(.gray900)
                .padding(.leading, sizeInfo.Hpadding)
            Text(newClubSubTitle)
                .font(.body21420Regular)
                .foregroundColor(.gray500)
                .padding(.top, 2)
                .padding(.leading, sizeInfo.Hpadding)
            
            newClubRecoView_ClubList
        }
    }
    var newClubRecoView_ClubList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                if let NOmainClub_MainPage_NewClub = viewModel.mainClub_MainPage_NewClub {
                    ForEach(0..<NOmainClub_MainPage_NewClub.count, id: \.self) { i in
                        
                        VStack(spacing: 0) {

                            HStack(spacing: 0) {
                                WebImage(url: URL(string: NOmainClub_MainPage_NewClub[i].profile_image))
                                    .resizable()
                                    .frame(width: 22, height: 22)
                                    .cornerRadius(8)
                                    .padding(.leading, 10)

                                Text(NOmainClub_MainPage_NewClub[i].club_name)
                                    .font(.caption11218Regular)
                                    .foregroundColor(.gray600)
                                    .lineLimit(1)
                                    .allowsTightening(false) // 글자 압축 안 함 - '점점점'으로 처리
                                    .padding(.leading, 8)
                                    .padding(.trailing, 10)
                                
                                Spacer()
                            }
                            .padding(.top, 10)

                            /**
                             * join an array of strings into a single string
                             */
                            let joined = "#" + NOmainClub_MainPage_NewClub[i].club_tags.joined(separator: " #")
                            Text(joined)
                                .font(.caption11218Regular)
                                .foregroundColor(.gray900)
                                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                                .lineLimit(2)
                                .allowsTightening(false) // 글자 압축 안 함 - '점점점'으로 처리

                            ZStack(alignment: .bottom) {
                                WebImage(url: URL(string: NOmainClub_MainPage_NewClub[i].club_image))
                                    .resizable()
                                HStack(spacing: 0) {
                                    let isJoined: Bool = NOmainClub_MainPage_NewClub[i].isJoined
                                    
                                    Button(action: {
                                        print("join button clicked !")
                                    }) {
                                        Text(isJoined ? "Joined" : "h_join".localized)
                                            .font(.caption21116Regular)
                                            .foregroundColor(.gray25)
                                            .padding(.vertical, 3)
                                            .padding(.horizontal, 7)
                                            .background(isJoined ? Color.primary500 : Color.gray300.opacity(0.6))
                                            .cornerRadius(8)
                                            .shadow(radius: 3)
                                    }
                                    Spacer()
                                }
                                .padding(.leading, 10)
                                .padding(.bottom, 10)
                            }
                            .padding(.top, 10)
                        }
                        .background(Color.gray25)
                        .frame(width: 150, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 14.0))
                        //   .shadow(radius: 3)
                        .shadow(color: Color.gray400.opacity(0.5), radius:5)
                        .padding(.leading, i==0 ? 20 : 10)
                        .padding(.trailing, i==NOmainClub_MainPage_NewClub.count-1 ? 20 : 0)
                        .padding(.bottom, 26)
                        .onTapGesture(perform: {
                            showClubProfilePage = true
                        })
                    }
                }
            }
            .padding(.top, 16)
        }
    }
    
    var top10View: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(top10Title)
                    .font(.title41824Medium)
                    .foregroundColor(.gray900)
                Spacer()
                Text("08.27")
                    .font(.caption11218Regular)
                    .foregroundColor(.gray700)
            }
            .padding(.horizontal, sizeInfo.Hpadding)
            
            if viewModel.mainClub_MainPage_Top10.count > 0 {
                ForEach(0..<viewModel.mainClub_MainPage_Top10.count, id: \.self) { i in
                    BoardRowView(
                        viewType: BoardType.MainClub_MainPage_Top10,
                        mainClub_MainPage_Top10: viewModel.mainClub_MainPage_Top10[i]
                    )
                    
                    Divider()
                }
            }
        }
    }
}

extension MainClubPage {
    func callRemoteData() {
        self.viewModel.getMainClub_MainPage()
    }
}

struct MainClubPage_Previews: PreviewProvider {
    static var previews: some View {
        MainClubPage()
    }
}
