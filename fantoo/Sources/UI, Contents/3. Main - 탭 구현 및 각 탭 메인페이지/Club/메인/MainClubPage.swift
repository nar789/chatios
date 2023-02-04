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
    @StateObject var userManager = UserManager.shared
    
    @State private var showMyClub = false
    @State private var showChallenge = false
    @State private var showClubProfilePage = false
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
}

extension MainClubPage: View {
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                /**
                 * 내 클럽
                 */
                myClubView
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
        .onAppear() {
            self.callRemoteData()
        }
        .background(
            NavigationLink("", isActive: $showClubProfilePage) {
//                if let clubId = viewModel.clickedClubId {//"48" 112
//                    HomeClubPage(clubId: .constant(String(112)), state: .constant(false))
//                }
                
                if let NOclickedClubId = viewModel.clickedClubId {
                    HomeClubPage(clubId: .constant(String(NOclickedClubId)), state: .constant(false))
                }
            }.hidden()
        )
        .onChange(of: userManager.showInitialViewState) { value in
            showMyClub = false
            showChallenge = false
            showClubProfilePage = false
        }
        .statusBarStyle(style: .darkContent)
    }
    
    var myClubView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("n_my_club".localized)
                    .font(.title41824Medium)
                    .foregroundColor(.gray900)
                Spacer()
                if !viewModel.myclub_clubList.isEmpty {
                    Text("j_show_all".localized)
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
            }
            .padding(EdgeInsets(top: 22, leading: sizeInfo.Hpadding, bottom: 0, trailing: sizeInfo.Hpadding))
            
            myClubListView
        }
    }
    var myClubListView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            if !viewModel.myclub_clubList.isEmpty {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(Array(viewModel.myclub_clubList.enumerated()), id: \.offset) { index, element in
                        VStack(spacing: 0) {
                            ZStack(alignment: .bottom) {
                                WebImage(url: URL(string: element.profileImg.imageOriginalUrl))
                                    .placeholder(content: {
                                        Image("profile_club_character")
                                            .resizable()
                                    })
                                    .resizable()
                                    .frame(width: 54, height: 54)
                                    .cornerRadius(16)
                                    .padding(.bottom, 8)
                                
                                if element.manageYn {
                                    Text("a_operate".localized)
                                        .font(.caption21116Regular)
                                        .foregroundColor(.gray25)
                                        .padding(.vertical, 3)
                                        .padding(.horizontal, 7)
                                        .background(.primary300)
                                        .clipShape(Capsule())
                                }
                            }
                            
                            Text(element.clubName)
                                .frame(width: 54)
                                .font(.caption11218Regular)
                                .foregroundColor(.gray900)
                                .lineLimit(2)
                                //.lineSpacing(0) // 큰 숫자인 경우에는 줄 간격이 늘어나는데, 작은 숫자인 경우에는 더 이상 줄 간격이 줄어들지 않음. 이게 미니멈인가??
                                .multilineTextAlignment(.center)
                                .padding(.top, 4)
                        }
                        // 첫 번째 아이템의 leading값은 20, 나머지는 12
                        .padding(.leading, index==0 ? sizeInfo.Hpadding : 12)
                        // 마지막 번째 아이템의 trailing값은 12, 나머지는 0
                        .padding(.trailing, index==viewModel.myclub_clubList.count-1 ? 12 : 0)
                        .onTapGesture {
                            viewModel.clickedClubId = element.clubId
                            showClubProfilePage = true
                        }
                    }
                }
                .padding(.top, 14)
            } else {
                Text("se_g_not_exist_join_club_do_join_to_club".localized)
                    .font(.caption11218Regular)
                    .foregroundColor(.gray500)
                    .frame(width: UIScreen.screenWidth)
                    .multilineTextAlignment(.center)
                    .padding(.top, 22)
            }
        }
    }

    var popularClubRecoView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("a_recomment_poplular_club".localized)
                .font(.title41824Medium)
                .foregroundColor(.gray900)
                .padding(.top, 20)
                .padding(.leading, sizeInfo.Hpadding)
            Text("se_a_recommend_hottest_club".localized)
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
                if !viewModel.popularCategory_list.isEmpty {
                    ForEach(Array(viewModel.popularCategory_list.enumerated()), id: \.offset) { index, element in
                        ZStack(alignment: .center) {
                            RoundedRectangle(cornerRadius: 30)
                                .style(
                                    withStroke: viewModel.clickedClubCategoryPosition==index ? Color.primary300 : Color.gray100,
                                    lineWidth: 1,
                                    fill: viewModel.clickedClubCategoryPosition==index ? Color.primary300 : Color.gray25
                                )
                                .padding(.vertical, 1) // padding 값 없으면, 위-아래 테두리 선 약간 잘림
                            
                            Text(element.categoryCodeName)
                                .font(.caption11218Regular)
                                .foregroundColor(viewModel.clickedClubCategoryPosition==index ? Color.gray25 : Color.gray800)
                                .padding(.vertical, 7)
                                .padding(.horizontal, 12)
                        }
                        .fixedSize()
                        .padding(EdgeInsets(
                            top: 0,
                            leading: index==0 ? sizeInfo.Hpadding : 6,
                            bottom: 0,
                            trailing:index==viewModel.popularCategory_list_last ? 20 : 0
                        ))
                        .onTapGesture {
                            self.viewModel.getPopular_PopularList(categoryIndex: index, categoryCode: element.categoryCode, integUid: userManager.uid)
                        }
                    }
                }
            }
            .padding(.top, 16)
        }
    }
    var popularClubRecoView_ClubList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                if !viewModel.popularList.isEmpty {
                    ForEach(Array(viewModel.popularList.enumerated()), id: \.offset) { index, element in
                        
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(spacing: 0) {
                                WebImage(url: URL(string: element.profileImg.imageOriginalUrl))
                                    .placeholder(content: {
                                        Image("profile_club_character")
                                            .resizable()
                                    })
                                    .resizable()
                                    .frame(width: 22, height: 22)
                                    .cornerRadius(8)
                                    .padding(.leading, 10)
                                
                                Text(element.clubName)
                                    .font(.caption11218Regular)
                                    .foregroundColor(.gray600)
                                    .lineLimit(1)
                                    .allowsTightening(false) // 글자 압축 안 함 - '점점점'으로 처리
                                    .padding(.leading, 8)
                                    .padding(.trailing, 10)
                                
                                Spacer()
                            }
                            .padding(.top, 10)
                            
                            if !element.hashtagList.isEmpty {
                                /**
                                 * join an array of strings into a single string
                                 */
                                let joined = "#" + element.hashtagList.joined(separator: " #")
                                Text(joined)
                                    .font(.caption11218Regular)
                                    .foregroundColor(.gray900)
                                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                                    .lineLimit(2)
                                    .allowsTightening(false) // 글자 압축 안 함 - '점점점'으로 처리
                            }
                            
                            ZStack(alignment: .bottom) {
                                WebImage(url: URL(string: element.bgImg.imageOriginalUrl))
                                    .placeholder(content: {
                                        Image("profile_main club_bg 1")
                                            .resizable()
                                    })
                                    .resizable()
                                
                                HStack(spacing: 0) {
                                    Button(action: {
                                        print("join button clicked !")
                                    }) {
                                        Text(self.defineJoinBtnTxt(joinStatus: element.joinStatus))
                                            .font(.caption21116Regular)
                                            .foregroundColor(.gray25)
                                            .padding(.vertical, 3)
                                            .padding(.horizontal, 7)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(self.defineJoinBtnBorderColor(joinStatus: element.joinStatus), lineWidth: 0.5))
                                            .background(RoundedRectangle(cornerRadius: 8).fill(self.defineJoinBtnBackColor(joinStatus: element.joinStatus)))
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
                        .shadow(color: Color.gray400.opacity(0.5), radius:5)
                        .padding(EdgeInsets(top: 0, leading: index==0 ? 20 : 10, bottom: 26, trailing: index==viewModel.popularList.count-1 ? 20 : 0))
                        .onTapGesture(perform: {
                            viewModel.clickedClubId = element.clubId
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
            Text("s_recommend_new_club".localized)
                .font(.title41824Medium)
                .foregroundColor(.gray900)
                .padding(.leading, sizeInfo.Hpadding)
            Text("se_n_find_new_club_for_me".localized)
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
                if !viewModel.newList.isEmpty {
                    ForEach(Array(viewModel.newList.enumerated()), id: \.offset) { index, element in
                        
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(spacing: 0) {
                                WebImage(url: URL(string: element.profileImg.imageOriginalUrl))
                                    .placeholder(content: {
                                        Image("profile_club_character")
                                            .resizable()
                                    })
                                    .resizable()
                                    .frame(width: 22, height: 22)
                                    .cornerRadius(8)
                                    .padding(.leading, 10)

                                Text(element.clubName)
                                    .font(.caption11218Regular)
                                    .foregroundColor(.gray600)
                                    .lineLimit(1)
                                    .allowsTightening(false) // 글자 압축 안 함 - '점점점'으로 처리
                                    .padding(.leading, 8)
                                    .padding(.trailing, 10)
                                
                                Spacer()
                            }
                            .padding(.top, 10)

                            if !element.hashtagList.isEmpty {
                                /**
                                 * join an array of strings into a single string
                                 */
                                let joined = "#" + element.hashtagList.joined(separator: " #")
                                Text(joined)
                                    .font(.caption11218Regular)
                                    .foregroundColor(.gray900)
                                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                                    .lineLimit(2)
                                    .allowsTightening(false) // 글자 압축 안 함 - '점점점'으로 처리
                            }

                            ZStack(alignment: .bottom) {
                                WebImage(url: URL(string: element.bgImg.imageOriginalUrl))
                                    .placeholder(content: {
                                        Image("profile_main club_bg 1")
                                            .resizable()
                                    })
                                    .resizable()
                                
                                HStack(spacing: 0) {
                                    
                                    Button(action: {
                                        print("join button clicked !")
                                    }) {
                                        Text(self.defineJoinBtnTxt(joinStatus: element.joinStatus))
                                            .font(.caption21116Regular)
                                            .foregroundColor(.gray25)
                                            .padding(.vertical, 3)
                                            .padding(.horizontal, 7)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(self.defineJoinBtnBorderColor(joinStatus: element.joinStatus), lineWidth: 0.5))
                                            .background(RoundedRectangle(cornerRadius: 8).fill(self.defineJoinBtnBackColor(joinStatus: element.joinStatus)))
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
                        .shadow(color: Color.gray400.opacity(0.5), radius:5)
                        .padding(EdgeInsets(top: 0, leading: index==0 ? 20 : 10, bottom: 26, trailing: index==viewModel.popularList.count-1 ? 20 : 0))
                        .onTapGesture(perform: {
                            viewModel.clickedClubId = element.clubId
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
                Text("a_popular_post_top_10".localized)
                    .font(.title41824Medium)
                    .foregroundColor(.gray900)
                Spacer()
                Text("".changeDateFormat_Custom2(strDate: viewModel.popularListTop10_date))
                    .font(.caption11218Regular)
                    .foregroundColor(.gray700)
            }
            .padding(.horizontal, sizeInfo.Hpadding)
            
            if !viewModel.popularListTop10.isEmpty {
                ForEach(Array(viewModel.popularListTop10.enumerated()), id: \.offset) { index, element in
                    BoardRowView(
                        viewType: BoardType.MainClub_MainPage_Top10,
                        mainClub_MainPage_Top10: element
                    )
                    Divider()
                }
            }
        }
    }
}

extension MainClubPage {
    func callRemoteData() {
        CommonFunction.onPageLoading()
        self.viewModel.getMyClub(integUid: userManager.uid, nextId: "0", size: "10")
        self.viewModel.getPopular_Category(integUid: userManager.uid)
        self.viewModel.getPopular_NewList(integUid: userManager.uid)
        self.viewModel.getPopular_PopularTop10(integUid: userManager.uid)
    }
    
    // 클럽 가입상태 joinStatus
    // 0: 가입하기, 1:가입 중, 2:가입 대기 중
    func defineJoinBtnTxt(joinStatus: Int) -> String {
        var finalTxt = ""
        if joinStatus == 0 {
            finalTxt = "g_to_join".localized
        } else if joinStatus == 1 {
            finalTxt = "g_to_joined".localized
        } else if joinStatus == 2 {
            finalTxt = "g_to_wait_join".localized
        }
        return finalTxt
    }
    
    // 클럽 가입상태 joinStatus
    // 0: 가입하기, 1:가입 중, 2:가입 대기 중
    func defineJoinBtnBackColor(joinStatus: Int) -> Color {
        var finalColor = Color.gray25
        if joinStatus == 0 {
            finalColor = Color.stateDisabledGray50.opacity(0.3)
        } else if joinStatus == 1 {
            finalColor = Color.primary500
        } else if joinStatus == 2 {
            finalColor = Color.stateEnableGray900.opacity(0.6)
        }
        return finalColor
    }
    // 클럽 가입상태 joinStatus
    // 0: 가입하기, 1:가입 중, 2:가입 대기 중
    func defineJoinBtnBorderColor(joinStatus: Int) -> Color {
        var finalColor = Color.gray25
        if joinStatus == 0 {
            finalColor = Color.dimGray900.opacity(0.4)
        } else if joinStatus == 1 {
            finalColor = Color.primary600
        } else if joinStatus == 2 {
            finalColor = Color.dimGray900.opacity(0.4)
        }
        return finalColor
    }
}

struct MainClubPage_Previews: PreviewProvider {
    static var previews: some View {
        MainClubPage()
    }
}
