//
//  ReplyDetailPage.swift
//  fantoo
//
//  Created by kimhongpil on 2022/10/14.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SwiftUIX
import SDWebImageSwiftUI
import Introspect
import AVKit

struct ReplyDetailPage {
    @StateObject var viewModel = ReplyDetailViewModel()
    @StateObject var userManager = UserManager.shared
    
    @State private var replyText: String = ""
    // ScrollView Up Button
    @State private var ScrollViewOffset: CGFloat = 0
    @State private var startOffset: CGFloat = 0 // 정확한 오프셋을 얻기 위해 startOffset을 가져옴
    
    // 사진앱에서 이미지 선택
    // // jpg 또는 png 만 등록할 수 있음
    @State var isUnqualifiedImageFormats: Bool = false // (true : 등록 못 함)
    // 5MB 이하의 이미지만 등록할 수 있음
    @State var isUnqualifiedImageSize: Bool = false  // (true : 등록 못 함)
    
    // 버튼 클릭 유무 확인
    @State var isClickLikeBtn: Bool = false
    
    let postId: Int
    let replyId: Int
    
    /**
     * 언어팩 등록할 것
     */
    private let naviTitle = "댓글"
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
}

extension ReplyDetailPage: View {
    var body: some View {
        GeometryReader { geometry in
            // View 탭시, Keyboard dismiss 하기
            BackgroundTapGesture {
                VStack(spacing: 0) {
                    Divider()
                        .padding(.top, 10)
                    
                    ZStack(alignment: .bottomTrailing) {
                        ScrollViewReader { proxyReader in
                            ScrollView(showsIndicators: false) {
                                VStack(spacing: 0) {
                                    if viewModel.communityDetailReplyDetailModel_Reply.count > 0 {
                                        
                                        ForEach(viewModel.communityDetailReplyDetailModel_Reply, id: \.self) { item in
                                            ReplyRowView(viewType: ReplyType.CommunityReplyDetail, replyDetailData: item)
                                            
                                            Divider()
                                        }
                                    }
                                }
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
                    
                    /**
                     * 댓글 작성 영역
                     */
                    ReplyEditView(
                        text: $replyText,
                        isUnqualifiedImageFormats: $isUnqualifiedImageFormats,
                        isUnqualifiedImageSize: $isUnqualifiedImageSize
                    )
                }
            }
            .onTapGesture {
                // View 탭시, Keyboard dismiss 하기
                UIApplication.shared.endEditing()
            }
        }
        .onAppear {
            self.callRemoteData(postId: self.postId, replyId: self.replyId)
        }
        .navigationType(
            leftItems: [.Back],
            leftItemsForegroundColor: .black,
            rightItemsForegroundColor: .black,
            title: naviTitle,
            onPress: { buttonType in
                //
            }
        )
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }
}

extension ReplyDetailPage {
    func callRemoteData(postId: Int, replyId: Int) {
        // 회원 댓글
        self.viewModel.getCommunityDetailReplyDetail(integUid: userManager.uid, access_token: userManager.accessToken, postId: postId, replyId: replyId)
    }
}

//struct ReplyDetailPage_Previews: PreviewProvider {
//    static var previews: some View {
//        ReplyDetailPage()
//    }
//}
