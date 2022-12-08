//
//  CommunityDetailPage.swift
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


enum CommunityDetailPageHeaderButtonType: Int {
    case Translate
}
enum CommunityDetailPageFooterButtonType: Int {
    case Like
    case Dislike
    case Comment
    case Share
}

struct CommunityDetailPage {
    @StateObject var viewModel = CommunityDetailPageViewModel()
    @StateObject var userManager = UserManager.shared
    
    @State private var naviTitle: String = ""
    
    // ScrollView Up Button
    @State private var ScrollViewOffset: CGFloat = 0
    @State private var startOffset: CGFloat = 0 // 정확한 오프셋을 얻기 위해 startOffset을 가져옴

    // 사진앱에서 이미지 선택
    // // jpg 또는 png 만 등록할 수 있음
    @State var isUnqualifiedImageFormats: Bool = false // (true : 등록 못 함)
    // 5MB 이하의 이미지만 등록할 수 있음
    @State var isUnqualifiedImageSize: Bool = false  // (true : 등록 못 함)
    
    @State var isClickTransBtn: Bool = false
    
    var viewType: BoardType? // CommunityDetailPage를 호출하는 부분 전부 다 수정되면 옵셔널 제거할 것!
    
    var selectedCode: String = ""
    var selectedPostId: Int = -1
    
    
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

extension CommunityDetailPage: View {
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .padding(.top, 5)
            // 회원
            if !userManager.isGuest {
                userView
            }
            // 비회원
//            else {
//                if let itemData = viewModel.communityDetailPageData {
//
//                    setNaviTitle(board_name: itemData.board_name)
//
//                    //Text(NOcommunityDetailPageData.board_name)
//                    ZStack(alignment: .bottomTrailing) {
//                        /**
//                         * 컨텐츠 영역
//                         */
//                        ScrollViewReader { proxyReader in
//                            ScrollView(showsIndicators: false) {
//                                LazyVStack(spacing: 0) {
//                                    CommunityDetailHeaderView(authorProfile: itemData.author_profile, authorNickname: itemData.author_nickname, boardName: itemData.board_name, boardDate: itemData.date)
//                                        .padding(EdgeInsets(top: 17, leading: 20, bottom: 0, trailing: 20))
//
//                                    CommunityDetailBodyView(boardTitle: itemData.title, boardContent: itemData.contents)
//                                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20))
//
//                                    CommunityDetailFooterView(boardLikeCount: itemData.like_count, boardCommentCount: itemData.story_count, onPress: { buttonType in
//                                        switch buttonType {
//                                        case CommunityDetailPageFooterButtonType.Like:
//                                            print("Like button clicked !")
//                                        case CommunityDetailPageFooterButtonType.Dislike:
//                                            print("Dislike button clicked !")
//                                        case CommunityDetailPageFooterButtonType.Comment:
//                                            print("Comment button clicked !")
//                                        case CommunityDetailPageFooterButtonType.Share:
//                                            print("Share button clicked !")
//                                        }
//                                    })
//                                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
//
//                                    Divider()
//
//                                    CommunityDetailCommentListView(boardComment: itemData.comment)
//
//                                }
//                                .id("SCROLL_TO_TOP")
//                                //ScrollView offset 가져오기
//                                .overlay(
//                                    //GeometrtReader를 사용하여 ScrollView offset 값을 가져옴
//                                    GeometryReader{ proxy -> Color in
//                                        DispatchQueue.main.async {
//                                            //startOffset을 정해줌
//                                            if startOffset == 0 {
//                                                self.startOffset = proxy.frame(in: .global).minY
//                                            }
//                                            let offset = proxy.frame(in: .global).minY
//                                            self.ScrollViewOffset = offset - startOffset
//                                            //print("ScrollView offset 확인 : \(self.ScrollViewOffset)" as String)
//                                        }
//                                        return Color.clear
//                                    }
//                                        .frame(width: 0, height: 0), alignment: .top
//                                )
//                            }
//                            // make disable the bouncing
//                            .introspectScrollView {
//                                $0.bounces = false
//                            }
//                            .overlay(
//                                HStack(spacing: 0) {
//                                    Button(action: {
//                                        // 애니메이션과 함께 스크롤 탑 액션 지정
//                                        withAnimation(.default) {
//                                            proxyReader.scrollTo("SCROLL_TO_TOP", anchor: .top)
//                                        }
//                                    }, label: {
//                                        Image("btn_top_go")
//                                    })
//                                }
//                                    .frame(width: 40, height: 40)
//                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 32, trailing: 20))
//                                    .opacity(-ScrollViewOffset > 450 ? 1 : 0)   // 만약 scrollViewOffset이 450보다 작으면 투명도를 적용
//                                    .animation(.easeIn), alignment: .bottomTrailing // 버튼을 오른쪽 하단에 고정
//                            )
//                        }
//                    }
//                    .frame(width: UIScreen.screenWidth)
//
//                    /**
//                     * 댓글 영역
//                     */
//                    CommunityDetailCommentInputView(
//                        text: $replyText,
//                        isUnqualifiedImageFormats: $isUnqualifiedImageFormats,
//                        isUnqualifiedImageSize: $isUnqualifiedImageSize
//                    )
//
//
//                }
//            }
            
            Spacer()
        }
        .onAppear {
            if !userManager.isGuest {
                self.callRemoteData_FantooUser(code: selectedCode, postId: selectedPostId)
            } else {
                self.callRemoteData_Guest()
            }
        }
        .onChange(of: isClickTransBtn) { newValue in
            if newValue {
                
                if let itemData = viewModel.communityDetail_Post {
                    
                    let transModel = [
                        TransMessagesReq(
                        origin: itemData.title,
                        text: itemData.title
                        ),
                        TransMessagesReq(
                            origin: itemData.content,
                            text: itemData.content
                        )
                    ]
                    
                    self.viewModel.getTrans(
                        language: LanguageManager.shared.getTransCode(),
                        messages: transModel
                    )
                }
            }
            else {
                viewModel.isTransMode = false
            }
        }
        /**
         * 북마크 아이템 :
         * - viewModel.communityDetail_Post 값 없으면 기본 false
         * - bookmarkYn 값이 true 이면 .MarkActive, false 이면 .MarkInActive
         * 북마크 아이템 색상 :
         * - viewModel.communityDetail_Post 값 없으면 기본 false
         * - bookmarkYn 값이 true 이면 Color.stateActivePrimaryDefault, false 이면 Color.black
         */
        .navigationType(
            leftItems: [.Back],
            rightItems: [viewModel.communityDetail_Post?.bookmarkYn ?? false ? .MarkActive:.MarkInActive, .More],
            leftItemsForegroundColor: .black,
            rightItemsForegroundColor: .black,
            bookmarkForegroundColor: viewModel.communityDetail_Post?.bookmarkYn ?? false ? .stateActivePrimaryDefault:.black,
            title: naviTitle,
            onPress: { buttonType in
                
                // 북마크 삭제
                if buttonType == .MarkActive {
                    if let NOcommunityDetail_Post = viewModel.communityDetail_Post {
                        viewModel.deleteBookmark(postId: NOcommunityDetail_Post.postId, integUid: UserManager.shared.uid, access_token: UserManager.shared.accessToken, isPostComplete: { isComplete in
                            viewModel.completeBookmark()
                        })
                    }
                }
                // 북마크 등록
                else if buttonType == .MarkInActive {
                    if let NOcommunityDetail_Post = viewModel.communityDetail_Post {
                        viewModel.postBookmark(postId: NOcommunityDetail_Post.postId, integUid: UserManager.shared.uid, access_token: UserManager.shared.accessToken, isPostComplete: { isComplete in
                            viewModel.completeBookmark()
                        })
                    }
                }
                else if buttonType == .More {
                    print("idpilLog::: 커뮤니티상세, 더보기 클릭")
                }
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
    
    var userView: some View {
        VStack(spacing: 0) {
            if let itemData = viewModel.communityDetail_Post {
                setNaviTitle(board_name: itemData.subCode)
                
                ZStack(alignment: .bottomTrailing) {
                    ScrollViewReader { proxyReader in
                        
                        /**
                         * 댓글 작성 후 작성한 댓글을 보기 위해,
                         * 스크롤 맨 아래로 이동
                         */
                        //let _ = print("\(type(of: proxyReader))" as String)
                        self.gotoScrollBottom(proxyReader: proxyReader)
                        
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: 0) {
                                CommunityDetailHeaderView(
                                    authorProfile: itemData.userPhoto,
                                    authorNickname: itemData.userNick,
                                    boardName: itemData.code,
                                    boardDate: itemData.createDate,
                                    isClickTransBtn: $isClickTransBtn,
                                    isTransComplate: $viewModel.isTransMode
                                )
                                .padding(EdgeInsets(top: 17, leading: 20, bottom: 0, trailing: 20))
                                
                                CommunityDetailBodyView(
                                    boardTitle: itemData.title,
                                    boardContent: itemData.content,
                                    isTransComplate: $viewModel.isTransMode,
                                    boardTitle_trans: $viewModel.title_afterTrans,
                                    boardContent_trans: $viewModel.content_afterTrans
                                )
                                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20))
                                
                                CommunityDetailFooterView(likeCnt: itemData.likeCnt, dislikeCnt: itemData.dislikeCnt, replyCnt: itemData.replyCnt, likeYn: itemData.likeYn, dislikeYn: itemData.dislikeYn, onPress: { buttonType in
                                    switch buttonType {
                                    case CommunityDetailPageFooterButtonType.Like:
                                        
                                        if itemData.likeYn {
                                            //print("눌렀던 좋아요를 다시 누른 경우")
                                            if let NOviewType = viewType {
                                                self.clickDeleteLike(targetType: "post", targetId: itemData.postId, boardType: NOviewType)
                                            }
                                        } else if !itemData.likeYn {
                                            //print("처음 좋아요를 누른 경우")
                                            if let NOviewType = viewType {
                                                self.clickLike(likeType: "like", targetType: "post", targetId: itemData.postId, boardType: NOviewType)
                                            }
                                        }
                                        
                                    case CommunityDetailPageFooterButtonType.Dislike:
                                        
                                        if itemData.dislikeYn {
                                            //print("눌렀던 싫어요를 다시 누른 경우")
                                            if let NOviewType = viewType {
                                                self.clickDeleteLike(targetType: "post", targetId: itemData.postId, boardType: NOviewType)
                                            }
                                        } else if !itemData.dislikeYn {
                                            //print("처음 싫어요를 누른 경우")
                                            if let NOviewType = viewType {
                                                self.clickLike(likeType: "dislike", targetType: "post", targetId: itemData.postId, boardType: NOviewType)
                                            }
                                        }
                                    case CommunityDetailPageFooterButtonType.Comment:
                                        print("Comment button clicked !")
                                    case CommunityDetailPageFooterButtonType.Share:
                                        print("Share button clicked !")
                                    }
                                })
                                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                                
                                Divider()
                                
                                // 댓글 영역
                                if viewModel.communityDetailReplyModel_Reply.count > 0 {
                                    CommunityDetailReplyListView(boardReply: $viewModel.communityDetailReplyModel_Reply)
                                }
                            }
                            .id("SCROLL_TO_TOP")
                            .id("SCROLL_TO_BOTTOM")
                            
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
                    text: $viewModel.txtReply,
                    isUnqualifiedImageFormats: $isUnqualifiedImageFormats,
                    isUnqualifiedImageSize: $isUnqualifiedImageSize,
                    isPostComplete: { isComplete in
                        if isComplete {
                            if let NOcommunityDetail_Post = viewModel.communityDetail_Post {
                                viewModel.postReply(
                                    postId: NOcommunityDetail_Post.postId,
                                    anonymYn: false,
                                    attachList: [],
                                    content: viewModel.txtReply,
                                    integUid: UserManager.shared.uid,
                                    access_token: UserManager.shared.accessToken,
                                    isPostComplete: { isComplete in
                                        if isComplete {
                                            viewModel.txtReply = ""
                                            
                                            
                                            // 작성된 댓글 갱신
                                            viewModel.getCommunityDetailReply(integUid: UserManager.shared.uid, access_token: UserManager.shared.accessToken, postId: NOcommunityDetail_Post.postId, size: 30, isReplyWrite: true)
                                        }
                                    }
                                )
                            }
                        }
                    }
                )
            }
        }
    }
    
    func setNaviTitle(board_name: String) -> some View {
        DispatchQueue.main.async {
            self.naviTitle = board_name
        }
        return EmptyView()
    }
    
    func clickLike(likeType: String, targetType: String, targetId: Int, boardType: BoardType) {

        self.viewModel.postCommunityLike(likeType: likeType, targetType: targetType, targetId: targetId, integUid: UserManager.shared.uid, access_token: UserManager.shared.accessToken, postId: selectedPostId, boardType: boardType)
    }
    
    func clickDeleteLike(targetType: String, targetId: Int, boardType: BoardType) {

        self.viewModel.deleteCommunityLike(targetType: targetType, targetId: targetId, integUid: UserManager.shared.uid, access_token: UserManager.shared.accessToken, postId: selectedPostId, boardType: boardType)
    }
    
    func gotoScrollBottom(proxyReader: ScrollViewProxy) -> some View {
        if self.viewModel.isReplyComplete {
            // 애니메이션과 함께 스크롤 바텀 액션 지정
            withAnimation(.default) {
                DispatchQueue.main.async {
                    proxyReader.scrollTo("SCROLL_TO_BOTTOM", anchor: .bottom)
                }
                
            }

            self.viewModel.isReplyComplete = false
        }
        return EmptyView()
    }
}

extension CommunityDetailPage {
    func callRemoteData_FantooUser(code: String = "", postId: Int = -1, size: Int = 30) {
        // 회원 본문
        self.viewModel.getCommunityDetail(integUid: userManager.uid, access_token: userManager.accessToken, code: code, postId: postId)
        // 회원 댓글
        self.viewModel.getCommunityDetailReply(integUid: userManager.uid, access_token: userManager.accessToken, postId: postId, size: size, isReplyWrite: false)
    }
    
    func callRemoteData_Guest() {
        self.viewModel.getCommunityDetailPage()
    }
}

struct CommunityDetailPage_Previews: PreviewProvider {
    static var previews: some View {
        CommunityDetailPage()
    }
}
