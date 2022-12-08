//
//  SubPopular.swift
//  fantoo
//
//  Created by 김홍필 on 2022/04/28.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import PopupView
import SDWebImageSwiftUI

struct SubPopular {
    //popup (아이템 more)
    private var popupTitle: String = ""
    @State private var popupSelectedTitle: String? = ""
    @State private var showSheetClubVisibility = false
    @State private var clickedPopupItemPosition = -1 // 초기값은 해당되지 않는 값으로 설정
    //popup (언어 필터)
    private var popupGlobalLanTitle: String = "언어 필터"
    @State private var popupGlobalLanSelectedTitle: String? = "GLOBAL" // 초기값
    @State private var showSheetGlobalLanVisibility = false
    @State private var clickedPopupGlobalLanPosition = -1 // 초기값은 해당되지 않는 값으로 설정
    
    @State private var showClubProfilePage = false
    
    @ObservedObject var viewModel = SubPopularViewModel()
    
    /**
     * 언어팩 등록할 것
     */
    private let popularClubTitle = "a_recomment_poplular_club".localized
    private let popularClubSubTitle = "se_a_recommend_hottest_club".localized
    private let translateTitle = "GLOBAL"
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
        static let bottomSheetHeight: CGFloat = 327.0 + DefineSize.SafeArea.bottom
        static let bottomSheetPopupGlobalLanHeight: CGFloat = 220.0 + DefineSize.SafeArea.bottom
    }
}

extension SubPopular: View {
    
    var body: some View {
        RefreshableScrollView(
            onRefresh: { done in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.viewModel.getMainHomeTabPopular()
                    done()
                }}
        ){
            LazyVStack(spacing: 0) {
                trendingView
                
                ForEach(Array(viewModel.boardList.enumerated()), id: \.offset) { index, element in
                    
                    if index==1 {
                        clubRecoView
                    }
                    else if index==3 {
                        bannerView
                    }
                    else {
                        Spacer()
                            .frame(height: 10)
                    }
                    
                    BoardRowView(viewType: BoardType.MainPopular,
                                 mainPopularItem: element,
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
            }
        }
        .background(Color.bgLightGray50)
        .onAppear {
            self.viewModel.getMainHomeTabPopular()
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
        .bottomSheet(
            isPresented: $showSheetGlobalLanVisibility,
            height: sizeInfo.bottomSheetPopupGlobalLanHeight,
            topBarCornerRadius: DefineSize.CornerRadius.BottomSheet,
            content: {
                HomePageBottomView(
                    title: popupGlobalLanTitle,
                    type: HomePageBottomType.SubHomeGlobalLan,
                    onPressItemMore: {_ in },
                    onPressGlobalLan: { buttonType in
                        
                        switch buttonType {
                        case HomePageGlobalLanType.Global:
                            print("GLOBAL 버튼 클릭!")
                        case HomePageGlobalLanType.MyLan:
                            print("내 언어로 세팅 버튼 클릭!")
                        case HomePageGlobalLanType.AnotherLan:
                            print("다른 언어 선택 버튼 클릭!")
                        }
                    },
                    selectedTitle: $popupGlobalLanSelectedTitle,
                    isShow: $showSheetGlobalLanVisibility
                )
        })
    }
    
    
    // 백업본 (리프세리 완료되면 지워도 됨)
//    var body: some View {
//        VStack(spacing: 0) {
//            trendingView
//
//            LazyVStack(spacing: 0) {
//                ForEach(Array(viewModel.boardList.enumerated()), id: \.offset) { index, element in
//
//                    if index==1 {
//                        clubRecoView
//                    }
//                    else if index==3 {
//                        bannerView
//                    }
//                    else {
//                        Spacer()
//                            .frame(height: 10)
//                    }
//
//                    BoardRowView(viewType: BoardType.MainPopular,
//                                 mainPopularItem: element,
//                                 onPress: { buttonType in
//
//                        print("\(index)번째 buttonType : \(buttonType)")
//
//                        switch buttonType {
//                        case BoardButtonType.More:
//                            print("more button cliked !")
//
//                            clickedPopupItemPosition = index
//                            showSheetClubVisibility = true
//                        case .Like:
//                            print("like button cliked !")
//                        case .Dislike:
//                            print("dislike button cliked !")
//                        case .Comment:
//                            print("comment button cliked !")
//                        }
//                    })
//                    .background(Color.gray25)
//                    .onAppear {
//                        fetchMoreData(element)
//                    }
//
////                    BoardRowView(viewType: BoardType.MainPopular,
////                                 mainPopularItem: viewModel.boardList[i])
////                    .background(Color.gray25)
////                    .onAppear {
////                        fetchMoreData(viewModel.boardList[i])
////                    }
//                }
//            }
//        }
//        .background(Color.bgLightGray50)
//        .onAppear {
//            self.viewModel.getMainHomeTabPopular()
//        }
//        .refreshableCompat { done in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.viewModel.getMainHomeTabPopular()
//                done()
//            }
//        } progress: { state in
//            RefreshActivityIndicator(isAnimating: state == .loading) {
//                $0.hidesWhenStopped = false
//            }
//        }
//        .bottomSheet(
//            isPresented: $showSheetClubVisibility,
//            height: sizeInfo.bottomSheetHeight,
//            topBarCornerRadius: DefineSize.CornerRadius.BottomSheet,
//            content: {
//                HomePageBottomView(
//                    title: popupTitle,
//                    type: HomePageBottomType.SubHomeItemMore,
//                    onPressItemMore: { buttonType in
//                        switch buttonType {
//                        case HomePageItemMoreType.Save:
//                            print("\(clickedPopupItemPosition)번째 아이템, 저장하기 버튼 클릭!")
//                        case HomePageItemMoreType.Share:
//                            print("\(clickedPopupItemPosition)번째 아이템, 공유하기 버튼 클릭!")
//                        case HomePageItemMoreType.Join:
//                            print("\(clickedPopupItemPosition)번째 아이템, 가입하기 버튼 클릭!")
//                        case HomePageItemMoreType.Notice:
//                            print("\(clickedPopupItemPosition)번째 아이템, 신고하기 버튼 클릭!")
//                        case HomePageItemMoreType.Hide:
//                            print("\(clickedPopupItemPosition)번째 아이템, 게시글 숨기기 버튼 클릭!")
//                        case HomePageItemMoreType.Block:
//                            print("\(clickedPopupItemPosition)번째 아이템, 이 사용자 차단하기 버튼 클릭!")
//                        }
//                    },
//                    onPressGlobalLan: {_ in },
//                    selectedTitle: $popupSelectedTitle,
//                    isShow: $showSheetClubVisibility
//                )
//        })
//        .bottomSheet(
//            isPresented: $showSheetGlobalLanVisibility,
//            height: sizeInfo.bottomSheetPopupGlobalLanHeight,
//            topBarCornerRadius: DefineSize.CornerRadius.BottomSheet,
//            content: {
//                HomePageBottomView(
//                    title: popupGlobalLanTitle,
//                    type: HomePageBottomType.SubHomeGlobalLan,
//                    onPressItemMore: {_ in },
//                    onPressGlobalLan: { buttonType in
//
//                        switch buttonType {
//                        case HomePageGlobalLanType.Global:
//                            print("GLOBAL 버튼 클릭!")
//                        case HomePageGlobalLanType.MyLan:
//                            print("내 언어로 세팅 버튼 클릭!")
//                        case HomePageGlobalLanType.AnotherLan:
//                            print("다른 언어 선택 버튼 클릭!")
//                        }
//                    },
//                    selectedTitle: $popupGlobalLanSelectedTitle,
//                    isShow: $showSheetGlobalLanVisibility
//                )
//        })
//    }
    
    var trendingView: some View {
        VStack (alignment: .leading, spacing: 8) {
            
            Text("TRENDING")
                .font(Font.title51622Medium)
                .foregroundColor(.gray900)
                .padding(EdgeInsets(top: 10, leading: sizeInfo.Hpadding, bottom: 0, trailing: 0))
            
            if viewModel.afterTrendingList.count > 0 {
                // The 'viewModel.trending' is not nil
                //let _ = print("idpil_log$ arrayTrending : \(arrayTrending)" as String)
                TabView(selection: $viewModel.trendingIndex) {
                    ForEach(0..<viewModel.afterTrendingList.count, id: \.self) { i in
                        VStack(spacing: 0) {
                            trendingRowView(arrayItem: viewModel.afterTrendingList[i])
                                //.background(Color.blue)
                                .tag(i)
                            Spacer()
                        }
                    }
                }
                .padding(.top, 10)
                .frame(height: 137)
                .onChange(of: viewModel.trendingIndex) { value in
                    //let _ = print("idpil_log$ trendingIndex : \(trendingIndex)")
                }
                
                // TabView Indicator
                ZStack(alignment: .center) {
                    HStack(spacing: 10) {
                        ForEach(0..<viewModel.afterTrendingList.count, id: \.self) { index in
                            Capsule()
                                .fill(viewModel.trendingIndex == index ? Color.primary500 : Color.gray300)
                            //.fill(Color.white.opacity(trendingIndex == index ? 1 : 0.55)) // 원래 코드 (참고용)
                                .frame(width: viewModel.trendingIndex == index ? 18 : 4, height: 4)
                                .animation(.easeInOut, value: viewModel.trendingIndex)
                        }
                    }
                    HStack(spacing: 0) {
                        Spacer()
                        Button(action: {
                            showSheetGlobalLanVisibility = true
                        }, label: {
                            HStack {
                                Image("icon_outline_filter")
                                    .frame(width: 20, height: 20)
                                Text(popupGlobalLanSelectedTitle ?? translateTitle)
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(Color.gray700)
                            }
                        })
                    }
                }
                .padding(.horizontal, sizeInfo.Hpadding)
                .padding(.bottom, 20)
            }
            else {
                // The 'viewModel.trending' is nil
                //Text("a_no")
            }
        }
        .background(Color.bgLightGray50)
    }
    
    var clubRecoView: some View {
        ZStack(alignment: .topTrailing) {
            Image("character_main3")
                .resizable()
                .frame(width: 50, height: 48)
                .padding(EdgeInsets(top: 18, leading: 0, bottom: 0, trailing: 27))
            
            VStack (alignment: .leading, spacing: 0) {
                VStack (alignment: .leading, spacing: 0) {
                    Text(popularClubTitle)
                        .font(.title51622Medium)
                        .foregroundColor(.gray900)
                    Text(popularClubSubTitle)
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
    
    var bannerView: some View {
        ZStack {
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.bannerList) { item in
                        WebImage(url: URL(string: item.image))
                            .resizable()
                            .scaledToFit()
                            .frame(height: 140)
                            .cornerRadius(16)
                            .padding(EdgeInsets(top: sizeInfo.Hpadding, leading: sizeInfo.Hpadding, bottom: sizeInfo.Hpadding, trailing: 0))
                    }
                }
            }
        }
        .background(Color.blue.opacity(0.07))
    }
}

extension SubPopular {
    fileprivate func fetchMoreData(_ boardList: ItemData){
        if self.viewModel.boardList.last == boardList {
            print("[마지막]에 도달했다")
            viewModel.fetchMoreActionSubject.send()

            viewModel.onPagingLoadView()
        }
    }
    
    func trendingRowView(arrayItem: [[String]]) -> some View {
        VStack(alignment: .leading) {
            
            ForEach(arrayItem, id: \.self) { itemArray in
                HStack(alignment: .top) {
                    ForEach(itemArray, id: \.self) { item in
                        ZStack {
                            /**
                             * RoundedRectangle().style() 은 원래 없는 기능인데,
                             * Shape+Extension 에서 추가한 기능임.
                             * 추가한 이유는,
                             * 추가하지 않으면 withstroke 와 fill 을 함께 사용하지 못 했기 때문
                             */
                            RoundedRectangle(cornerRadius: 30)
                                .style(
                                    withStroke: Color.gray200,
                                    lineWidth: 1,
                                    fill: Color.gray25
                                )
                            Text("#\(item)")
                                .font(Font.body21420Regular)
                                .fixedSize()
                                .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                        }
                        .fixedSize()
                    }
                    Spacer()
                }
                .padding(EdgeInsets(top: 1, leading: sizeInfo.Hpadding, bottom: 1, trailing: sizeInfo.Hpadding))
                .frame(width: UIScreen.screenWidth)
                //.background(Color.yellow)
            }
        }
    }
}

struct SubPopular_Previews: PreviewProvider {
    static var previews: some View {
        SubPopular()
    }
}
