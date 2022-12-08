//
//  SubHome.swift
//  fantoo
//
//  Created by 김홍필 on 2022/04/28.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import FSPagerView
import SDWebImageSwiftUI
import CryptoKit

struct SubHome {
    //popup
    private var popupTitle: String = ""
    @State private var popupSelectedTitle: String? = ""
    @State private var showSheetClubVisibility = false
    @State private var clickedPopupItemPosition = -1 // 초기값은 해당되지 않는 값으로 설정
    
    @State private var showClubProfilePage = false
    
    @StateObject var viewModel = SubHomeViewModel()
    @StateObject var statusManager = StatusManager.shared
    @StateObject var userManager = UserManager.shared
    
    /**
     * 언어팩 등록할 것
     */
    private let clubJoined = "Joined"
    private let clubJoin = "h_join".localized
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
        static let bottomSheetHeight: CGFloat = 327.0 + DefineSize.SafeArea.bottom
    }
}

extension SubHome: View {
    
    var body: some View {
        RefreshableScrollView(
            onRefresh: { done in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.viewModel.getMainHomeTabHome()
                    done()
                }}
        ){
            VStack(spacing: 0) {
                if viewModel.bannerList.count > 0 {
                    bannerView
                }
                
                if userManager.isGuest {
                    //Text("둘러보기로 들어온 경우 !")
                } else {
                    LazyVStack(spacing: 0) {
                        if viewModel.boardList.count > 0 {
                            ForEach(Array(viewModel.boardList.enumerated()), id: \.offset) { index, element in
                                
                                if index==2 {
                                    if (viewModel.clubRecoList.count > 0) {
                                        clubRecoView
                                    }
                                }
                                else {
                                    Spacer()
                                        .frame(height: 10)
                                }
                                
                                BoardRowView(viewType: BoardType.MainHome,
                                             mainHomeItem: element,
                                             onPress: { buttonType in
                                    
                                    print("\(index)번째 buttonType : \(buttonType)")
                                    
                                    switch buttonType {
                                    case BoardButtonType.More:
                                        print("more button cliked !")
                                        
                                        clickedPopupItemPosition = index
                                        showSheetClubVisibility = true
                                    case .Like:
                                        print("like button cliked !")
                                    case .Dislike:
                                        print("dislike button cliked !")
                                    case .Comment:
                                        print("comment button cliked !")
                                    }
                                })
                                .background(Color.gray25)
                                /**
                                 * 아래 onChange() 용도 :
                                 * - 리프레시 후, 리스트 항목 개수가 적어서 화면을 넘지 못 하는 경우, 페이징을 적용하기 위함
                                 * - 리프레시 하면, onAppear 가 호출되지 않기 때문에, fetchMoreData() 함수를 따로 적용한 것
                                 */
                                .onChange(of: viewModel.boardList) { newValue in
                                    //let _ = print("idpilLog::: newValue : \(newValue)")
                                    fetchMoreData(element)
                                }
                                .onAppear {
                                    fetchMoreData(element)
                                }
                            }
                            
                            if viewModel.isPageLoading {
                                /**
                                 * 데이터 로딩 중이라면 ScrollView 맨 아래에서 표시
                                 * ScrollView - LazyVStack 안에 있기 때문에 ScrollView 맨 아래에서 보여지는 것
                                 */
                                //MainBottomProgressView()
                            }
                        }
                    }
                }
            }
        }
        .background(Color.bgLightGray50)
        .onAppear {
            self.viewModel.getMainHomeTabHome()
            
//            if viewModel.isPageLoading {
//                // 페이지 내에서 로딩
//                StatusManager.shared.loadingStatus = .ShowWithTouchable
//            }
        }
        .onDisappear {
            // 로딩 종료
            //StatusManager.shared.loadingStatus = .Close
        }
        .bottomSheet(
            isPresented: $showSheetClubVisibility,
            height: sizeInfo.bottomSheetHeight,
            topBarCornerRadius: DefineSize.CornerRadius.BottomSheet,
            content: {
                HomePageBottomView(
                    title: popupTitle,
                    type: HomePageBottomType.SubHomeItemMore,
                    onPressItemMore: { buttonType in
                        switch buttonType {
                        case HomePageItemMoreType.Save:
                            print("\(clickedPopupItemPosition)번째 아이템, 저장하기 버튼 클릭!")
                        case HomePageItemMoreType.Share:
                            print("\(clickedPopupItemPosition)번째 아이템, 공유하기 버튼 클릭!")
                        case HomePageItemMoreType.Join:
                            print("\(clickedPopupItemPosition)번째 아이템, 가입하기 버튼 클릭!")
                        case HomePageItemMoreType.Notice:
                            print("\(clickedPopupItemPosition)번째 아이템, 신고하기 버튼 클릭!")
                        case HomePageItemMoreType.Hide:
                            print("\(clickedPopupItemPosition)번째 아이템, 게시글 숨기기 버튼 클릭!")
                        case HomePageItemMoreType.Block:
                            print("\(clickedPopupItemPosition)번째 아이템, 이 사용자 차단하기 버튼 클릭!")
                        }
                    },
                    onPressGlobalLan: {_ in },
                    selectedTitle: $popupSelectedTitle,
                    isShow: $showSheetClubVisibility
                )
        })
    }
    
    var bannerView: some View {
        ZStack {
            FSPagerViewSUI($viewModel.currentBannerPage, viewModel.bannerList) { item in
                WebImage(url: URL(string: item.image)!)
                    .resizable()
                    .cornerRadius(12)
                    .padding(.horizontal, sizeInfo.Hpadding)
                    .background(Color.bgLightGray50)
            }
            .didSelect { number in
                //print("banner selected : \(number)")
            }
            .frame(minHeight: 146)
            .padding(.top, 8)
            .padding(.bottom, 20)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        HStack {
                            Text("\(String(viewModel.currentBannerPage+1)) / \(String(viewModel.bannerList.count))")
                                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                                .background(Color.gray900.opacity(0.45))
                                .foregroundColor(Color.gray25)
                                .font(.system(size: 11))
                                .cornerRadius(4)
                            Spacer()
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: sizeInfo.Hpadding, bottom: 30, trailing: 0))
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .bottomTrailing
            )
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(width: UIScreen.screenWidth)
        .background(Color.bgLightGray50)
    }
    
    var clubRecoView: some View {
        ZStack(alignment: .topTrailing) {
            Image("character_main1")
                .resizable()
                .frame(width: 112, height: 104)
                .padding(.top, 18)
            
            VStack (alignment: .leading, spacing: 0) {
                VStack (alignment: .leading, spacing: 0) {
                    Text("m_recomment_custom_club".localized)
                        .font(.title51622Medium)
                        .foregroundColor(.gray900)
                    Text("se_n_recommend_clubs_on_interest".localized)
                        .font(.body21420Regular)
                        .foregroundColor(.gray500)
                        .padding(.top, 2)
                }
                .padding(EdgeInsets(top: 20, leading: sizeInfo.Hpadding, bottom: 0, trailing: 0))
                
                ScrollView (.horizontal, showsIndicators: false) {
                    clubRecoListView
                }
                .padding(.top, 14)
                .padding(.bottom, 20)
            }
        }
        .background(Color.bgLightGray50)
    }
    
    var clubRecoListView: some View {
        HStack(spacing: 0) {
            ForEach(Array(viewModel.clubRecoList.enumerated()), id: \.offset) { index, element in
                Group {
                    VStack(spacing: 0) {

                        HStack(spacing: 0) {
                            WebImage(url: URL(string: element.profile_image))
                                .resizable()
                                .frame(width: 22, height: 22)
                                .cornerRadius(8)
                                .padding(.leading, 10)

                            Text(element.club_name)
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
                        let joined = "#" + element.club_tags.joined(separator: " #")
                        Text(joined)
                            .font(.caption11218Regular)
                            .foregroundColor(.gray900)
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                            .lineLimit(2)
                            .allowsTightening(false) // 글자 압축 안 함 - '점점점'으로 처리

                        ZStack(alignment: .bottom) {
                            WebImage(url: URL(string: element.club_image))
                                .resizable()
                            HStack(spacing: 0) {
                                let isJoined: Bool = element.isJoined
                                
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
                    .padding(5).shadow(color: Color.gray400.opacity(0.3), radius:4)
                    .padding(.leading, index==0 ? 15 : 0)
                    .padding(.trailing, index==viewModel.clubRecoList.count-1 ? 15 : 0)
                    .onTapGesture(perform: {
                        showClubProfilePage = true
                    })
                }
            }
        }
    }
}

extension SubHome {
    fileprivate func fetchMoreData(_ boardList: ItemData){
        if self.viewModel.boardList.last == boardList {
            //print("[마지막]에 도달했다")
            viewModel.fetchMoreActionSubject.send()
            
            //viewModel.onPagingLoadView()
        }
    }
}

struct SubHome_Previews: PreviewProvider {
    static var previews: some View {
        SubHome()
    }
}

// 현재 사용 안 함
struct MainBottomProgressView: View {
    var body: some View {
        HStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.init(#colorLiteral(red: 1, green: 0.5433388929, blue: 0, alpha: 1))))
                .scaleEffect(1.7, anchor: .center)
            Spacer()
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
    }
}
