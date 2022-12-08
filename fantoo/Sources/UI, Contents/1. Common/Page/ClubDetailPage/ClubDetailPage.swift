//
//  ClubDetailPage.swift
//  fantoo
//
//  Created by kimhongpil on 2022/09/02.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SwiftUIX
import SDWebImageSwiftUI
import Introspect
import AVKit

struct ClubDetailPage {
    @StateObject var viewModel = ClubDetailPageViewModel()
    
    @State private var naviTitle: String = ""
    @State private var commentText: String = ""
    // ScrollView Up Button
    @State private var ScrollViewOffset: CGFloat = 0
    @State private var startOffset: CGFloat = 0 // 정확한 오프셋을 얻기 위해 startOffset을 가져옴
    
    // 사진앱에서 이미지 선택
    // // jpg 또는 png 만 등록할 수 있음
    @State var isUnqualifiedImageFormats: Bool = false // (true : 등록 못 함)
    // 5MB 이하의 이미지만 등록할 수 있음
    @State var isUnqualifiedImageSize: Bool = false  // (true : 등록 못 함)
    
    /**
     * 언어팩 등록할 것
     */
    private let unqualifiedImageFormats = "없로드 가능한 파일 형식이 아닙니다.\nJPG, PNG 파일만 등록 가능합니다."
    private let unqualifiedImageSize = "업로드 가능한 용량을 초과하였습니다.\n5MB 이하의 파일을 선택해 주세요."
    private let popupTitleOK = "h_confirm".localized
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
}

extension ClubDetailPage: View {
    var body: some View {
        VStack(spacing: 0) {
            if let itemData = viewModel.clubDetailPageData {
                
                setNaviTitle(board_name: itemData.board_name)
                
                
                
                //Text(NOcommunityDetailPageData.board_name)
                ZStack(alignment: .bottomTrailing) {
                    /**
                     * 컨텐츠 영역
                     */
                    ScrollViewReader { proxyReader in
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: 0) {
                                
                                ClubDetailHeaderView(
                                    authorProfile: itemData.author_profile,
                                    authorNickname: itemData.author_nickname,
                                    boardName: itemData.board_name,
                                    boardDate: itemData.date,
                                    boardItemName: itemData.board_item_name
                                )
                                .padding(EdgeInsets(top: 17, leading: 20, bottom: 0, trailing: 20))
                                
                                ClubDetailBodyView(boardTitle: itemData.title, boardContent: itemData.contents)
                                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20))
                                
                                ClubDetailImagesView(boardThumbnail: itemData.post_thumbnail)
                                
                                ClubDetailVideoView(boardVideoUrl: itemData.post_video.video_url)
                                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                                
//                                ClubDetailTagsView(boardTags: itemData.tags)
//                                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
//
//                                ClubDetailFooterView(boardLikeCount: itemData.like_count, boardHonorCount: itemData.honor_count, boardCommentCount: itemData.story_count)
//                                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
                                
                                ClubDetailCommentListView(boardComment: itemData.comment)
                                
                            }
                            .id("SCROLL_TO_TOP")
                            //ScrollView offset 가져오기
                            .overlay(
                                //GeometrtReader를 사용하여 ScrollView offset 값을 가져옴
                                GeometryReader{ proxy -> Color in
                                    DispatchQueue.main.async {
                                        //startOffset을 정해줌
                                        if startOffset == 0 {
                                            self.startOffset = proxy.frame(in: .global).minY
                                        }
                                        let offset = proxy.frame(in: .global).minY
                                        self.ScrollViewOffset = offset - startOffset
                                        //print("ScrollView offset 확인 : \(self.ScrollViewOffset)" as String)
                                    }
                                    return Color.clear
                                }
                                    .frame(width: 0, height: 0), alignment: .top
                            )
                        }
                        // make disable the bouncing
                        .introspectScrollView {
                            $0.bounces = false
                        }
                        .overlay(
                            HStack(spacing: 0) {
                                Button(action: {
                                    // 애니메이션과 함께 스크롤 탑 액션 지정
                                    withAnimation(.default) {
                                        proxyReader.scrollTo("SCROLL_TO_TOP", anchor: .top)
                                    }
                                }, label: {
                                    Image("btn_top_go")
                                })
                            }
                                .frame(width: 40, height: 40)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 32, trailing: 20))
                                .opacity(-ScrollViewOffset > 450 ? 1 : 0)   // 만약 scrollViewOffset이 450보다 작으면 투명도를 적용
                                .animation(.easeIn), alignment: .bottomTrailing // 버튼을 오른쪽 하단에 고정
                        )
                    }
                }
                .frame(width: UIScreen.screenWidth)
                
                /**
                 * 댓글작성  영역
                 */
                CommunityDetailCommentInputView(
                    text: $commentText,
                    isUnqualifiedImageFormats: $isUnqualifiedImageFormats,
                    isUnqualifiedImageSize: $isUnqualifiedImageSize
                )
                
                
            }
        }
        .onAppear() {
            self.callRemoteData()
        }
        .navigationType(leftItems: [.Back], rightItems: [.MarkInActive, .More], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: naviTitle, onPress: { buttonType in
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
        .showAlert(isPresented: $isUnqualifiedImageFormats, type: .Default, title: "", message: unqualifiedImageFormats, detailMessage: "", buttons: [popupTitleOK], onClick: { buttonIndex in
//            if buttonIndex == 1 {
//                UserManager.shared.logout()
//            }
        })
        .showAlert(isPresented: $isUnqualifiedImageSize, type: .Default, title: "", message: unqualifiedImageSize, detailMessage: "", buttons: [popupTitleOK], onClick: { buttonIndex in
//            if buttonIndex == 1 {
//                UserManager.shared.logout()
//            }
        })
    }
    
    func setNaviTitle(board_name: String) -> some View {
        DispatchQueue.main.async {
            self.naviTitle = board_name
        }
        return EmptyView()
    }
}

extension ClubDetailPage {
    func callRemoteData() {
        self.viewModel.getClubDetail()
    }
}

struct ClubDetailPage_Previews: PreviewProvider {
    static var previews: some View {
        ClubDetailPage()
    }
}
