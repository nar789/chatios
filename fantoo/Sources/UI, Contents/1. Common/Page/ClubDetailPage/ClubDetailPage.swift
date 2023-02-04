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
    @StateObject var userManager = UserManager.shared
    
    @State private var naviTitle: String = ""
    @State private var commentText: String = ""
    //@State var pickedImage: UIImage = UIImage()
    @State var pickedImage: String = ""
    @State var isSecretClick: Bool = false
    @State var isUnqualifiedImageSize: Bool = false
    @State var isClickTransBtn: Bool = false
    
    // ScrollView Up Button
    @State private var ScrollViewOffset: CGFloat = 0
    @State private var startOffset: CGFloat = 0 // 정확한 오프셋을 얻기 위해 startOffset을 가져옴
    
    var postId: Int = 0
    var clubId: String = ""
    var categoryCode: String = ""
    
    /**
     * 언어팩 등록할 것
     */
    private let unqualifiedImageFormats = "없로드 가능한 파일 형식이 아닙니다.\nJPG, PNG 파일만 등록 가능합니다."
    private let unqualifiedImageSize = "업로드 가능한 용량을 초과하였습니다.\n5MB 이하의 파일을 선택해 주세요."
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
}

extension ClubDetailPage: View {
    var body: some View {
        GeometryReader { geometry in
            // View 탭시, Keyboard dismiss 하기
            BackgroundTapGesture {
                VStack(spacing: 0) {
                    Divider()
                        .padding(.top, 5)
                    
                    // 회원
                    if !userManager.isGuest {
                        userView
                    }
                    //Spacer()
                }
                
            }
            .onTapGesture {
                // View 탭시, Keyboard dismiss 하기
                UIApplication.shared.endEditing()
            }
        }
        .onAppear() {
            self.callRemoteData()
            
            // 좋아요/싫어요 호출을 위해 viewmodel 프로퍼티에 저장
            self.viewModel.setPassedInfo(postId: self.postId, clubId: self.clubId, categoryCode: self.categoryCode)
        }
        .navigationType(
            leftItems: [.Back],
            rightItems: [self.setBookMarkVisible() ? (viewModel.bookmark ?? false ? .MarkActive : .MarkInActive) : .None, .More],
            leftItemsForegroundColor: .black,
            rightItemsForegroundColor: .black,
            bookmarkForegroundColor: viewModel.bookmark ?? false ? .stateActivePrimaryDefault : .black,
            title: naviTitle,
            onPress: { buttonType in
                
                // 북마크
                if buttonType == .MarkActive || buttonType == .MarkInActive {
                    // 북마크 변경
                    viewModel.patchBookmark(
                        clubId: self.clubId,
                        categoryCode: self.categoryCode,
                        postId: self.postId,
                        integUid: userManager.uid,
                        access_token: userManager.accessToken
                    )
                }
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
//        .showAlert(isPresented: $isFileClick, type: .Default, title: "", message: unqualifiedImageFormats, detailMessage: "", buttons: [popupTitleOK], onClick: { buttonIndex in
////            if buttonIndex == 1 {
////                UserManager.shared.logout()
////            }
//        })
        .showAlert(isPresented: $isSecretClick, type: .Default, title: "", message: unqualifiedImageSize, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
//            if buttonIndex == 1 {
//                UserManager.shared.logout()
//            }
        })
        // 북마크 변경 에러
        .popup(
            isPresenting: $viewModel.showbookmarkErrorAlert,
            cornerRadius: 5,
            locationType: .bottom,
            autoDismiss: .after(2),
            popup:
                ZStack {
                    Spacer()
                    Text(viewModel.bookmarkErrorMsg)
                        .foregroundColor(Color.gray25)
                        .font(Font.body21420Regular)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.gray800)
                }
        )
        .onChange(of: isClickTransBtn) { newValue in
            if newValue {
                
                if let itemData = viewModel.clubDetailModel {
                    
                    let transModel = [
                        TransMessagesReq(
                            origin: itemData.subject ,
                            text: itemData.subject
                        ),
                        TransMessagesReq(
                            origin: itemData.content,
                            text: itemData.content
                        )
                    ]
                    
                    viewModel.getTrans(
                        language: LanguageManager.shared.getTransCode(),
                        messages: transModel
                    )
                }
            }
            else {
                viewModel.isTransMode = false
            }
        }
    }
    
    var userView: some View {
        VStack(spacing: 0) {
            
            
            ZStack(alignment: .bottomTrailing) {
                if let item = viewModel.clubDetailModel {
                    setNaviTitle(board_name: item.categoryName1)
                    
                    /**
                     * 컨텐츠 영역
                     */
                    ScrollViewReader { proxyReader in
                        
                        /**
                         * 댓글 작성 후 작성한 댓글을 보기 위해,
                         * 스크롤 맨 아래로 이동
                         */
                        self.gotoScrollBottom(proxyReader: proxyReader)
                        
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: 0) {
                                
                                if let NOprofileImg = item.profileImg,
                                   let NOnickname = item.nickname,
                                   let NOcreateDate = item.createDate,
                                   let NOcategoryName2 = item.categoryName2 {
                                    ClubDetailHeaderView(
                                        authorProfile: NOprofileImg,
                                        authorNickname: NOnickname,
                                        boardDate: NOcreateDate,
                                        boardItemName: NOcategoryName2,
                                        isClickTransBtn: $isClickTransBtn,
                                        isTransComplate: $viewModel.isTransMode
                                    )
                                    .padding(EdgeInsets(top: 17, leading: 20, bottom: 0, trailing: 20))
                                }
                                
                                if let NOsubject = item.subject,
                                   let NOcontent = item.content {
                                    ClubDetailBodyView(
                                        boardTitle: NOsubject,
                                        boardContent: NOcontent,
                                        isTransComplate: $viewModel.isTransMode,
                                        boardTitle_trans: $viewModel.title_afterTrans,
                                        boardContent_trans: $viewModel.content_afterTrans)
                                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20))
                                }
                                
                                if let NOattachType = item.attachType {
                                    // 없음:0 / 이미지:1 / 동영상:2
                                    if NOattachType == 1 {
                                        ClubDetailImagesView(clubDetailAttachList: item.attachList)
                                    }
                                    // 없음:0 / 이미지:1 / 동영상:2
                                    else if NOattachType == 2 {
                                        /**
                                         * 이미지와 다르게 동영상이 여러개인 경우, 각각 독립된 AVPlayer 객체가 있어야 하기 때문에 여러개의 ClubDetailVideoView 를 만들어야 됨
                                         */
                                        if let NOattachList = item.attachList {
                                            ForEach(Array(NOattachList.enumerated()), id: \.offset) { index, element in
                                                
                                                // 이미지:0 / 동영상:1
                                                if element.attachType == 1 {
                                                    ClubDetailVideoView(boardVideoUrl: element.attach ?? "")
                                                        .padding(.top, 10)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                // HashTag
                                if let NOhashtagList = item.hashtagList {
                                    if !NOhashtagList.isEmpty {
                                        ClubDetailTagsView(boardTags: NOhashtagList)
                                    }
                                }
                                
                                // Footer
                                footer
                                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                                
                                Divider()
                                
                                // 댓글목록 영역
                                if !viewModel.replyList.isEmpty {
                                    ForEach(Array(viewModel.replyList.enumerated()), id: \.offset) { index, element in
                                        
                                        ClubReplyRowView(
                                            viewType: ClubReplyType.ClubDetail,
                                            clubDetailReply: element,
                                            onPress: { buttonType in
                                                //
                                            }
                                        )
                                        .onAppear {
                                            self.fetchMoreData(element)
                                        }
                                        
                                        Divider()
                                    }
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
                                    // 이미지 자체에 padding 적용되어 있음
                                    Image("btn_top_go2")
                                })
                            }
                                .frame(width: 40, height: 40)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 32, trailing: 20))
                                .opacity(-ScrollViewOffset > 450 ? 1 : 0)   // 만약 scrollViewOffset이 450보다 작으면 투명도를 적용
                                .animation(.easeIn), alignment: .bottom
                                //.animation(.easeIn), alignment: .bottomTrailing
                        )
                    }
                }
            }
            .overlay({
                if viewModel.isKeyboardFocused {
                    Rectangle()
                        .fill(Color.black.opacity(0.5))
                }
            })
            
            Spacer()
            
            /**
             * 댓글작성  영역
             */
            DetailPageReplyWritingView(
                viewType: .Club,
                text: $viewModel.txtReply,
                isKeyboardFocused: $viewModel.isKeyboardFocused,
                pickedImage: $viewModel.pickedImage,
                isSecretClick: $viewModel.isSecretClick,
                isUnqualifiedImageSize: $viewModel.isUnqualifiedImageSize,
                isClickSend: { isClick in
                    if isClick {
                        // 이미지 있는 경우
                        if !viewModel.pickedImage.isEmpty {
                            viewModel.requestUploadImage(image: viewModel.pickedImage.toImage() ?? UIImage()) { url in
                                //print("업로드한 이미지 url : \(url.imageOriginalUrl)" as String)
                                
                                // 이미지 업로드 실패
                                if url.isEmpty {
                                    viewModel.resetReplyImage()
                                }
                                // 이미지 업로드 성공
                                else {
                                    
                                    
                                    viewModel.postReply(
                                        clubId: viewModel.clubId,
                                        categoryCode: viewModel.categoryCode,
                                        postId: viewModel.postId,
                                        langCode: LanguageManager.shared.getLanguageCode(),
                                        imageName: url,
                                        mediaType: "image",
                                        replyTxt: viewModel.txtReply,
                                        integUid: userManager.uid,
                                        access_token: userManager.accessToken,
                                        isPostComplete: { isComplete in
                                            
                                            if isComplete {
                                                // 입력한 댓글 내용 reset
                                                viewModel.resetReplyAll()
                                                
                                                // 작성된 댓글 갱신
                                                viewModel.getClubDetailReply(
                                                    clubId: viewModel.clubId,
                                                    categoryCode: viewModel.categoryCode,
                                                    postId: viewModel.postId,
                                                    integUid: userManager.uid,
                                                    access_token: userManager.accessToken,
                                                    size: String(DefineSize.ListSize.Common),
                                                    isReplyWrite: true // 댓글 작성시 호출하는 것인지 확인
                                                )

                                            }
                                        }
                                    )
                                    
                                }
                                
                            }
                        }
                        // 텍스트만 있는 경우
                        else {
                            viewModel.postReply(
                                clubId: viewModel.clubId,
                                categoryCode: viewModel.categoryCode,
                                postId: viewModel.postId,
                                langCode: LanguageManager.shared.getLanguageCode(),
                                imageName: "",
                                mediaType: "",
                                replyTxt: viewModel.txtReply,
                                integUid: userManager.uid,
                                access_token: userManager.accessToken,
                                isPostComplete: { isComplete in
                                    
                                    if isComplete {
                                        // 입력한 댓글 내용 reset
                                        viewModel.resetReplyAll()
                                        
                                        // 작성된 댓글 갱신
                                        viewModel.getClubDetailReply(
                                            clubId: viewModel.clubId,
                                            categoryCode: viewModel.categoryCode,
                                            postId: viewModel.postId,
                                            integUid: userManager.uid,
                                            access_token: userManager.accessToken,
                                            size: String(DefineSize.ListSize.Common),
                                            isReplyWrite: true // 댓글 작성시 호출하는 것인지 확인
                                        )

                                    }
                                }
                            )
                            
                        }
                    }
                }
            )
        }
        
        
    }
    
    var clubDetailCommentListView: some View {
        LazyVStack(spacing: 0) {
            Divider()
            if !viewModel.replyList.isEmpty {
                ForEach(Array(viewModel.replyList.enumerated()), id: \.offset) { index, element in
                    
                    ClubReplyRowView(
                        viewType: ClubReplyType.ClubDetail,
                        clubDetailReply: element,
                        onPress: { buttonType in
                            //
                        }
                    )
                    .onAppear {
                        self.fetchMoreData(element)
                    }
                    
                    Divider()
                }
            }
        }
        .padding(.top, 20)
    }
    
    var footer: some View {
        HStack (alignment: .center, spacing: 0) {
            Button(action: {
                print("댓글 버튼 클릭")
            }) {
                HStack (alignment: .center, spacing: 5) {
                    if let item = viewModel.clubDetailModel {
                        Image("icon_fill_comment")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(Color.gray200)
                            .frame(width: 20, height: 20)
                        Text(String(item.replyCount))
                            .font(.caption11218Regular)
                            .foregroundColor(.gray800)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())

            Spacer()

            Button(action: {
                print("공유 버튼 클릭")
            }) {
                HStack (alignment: .center, spacing: 0) {
                    Image("icon_outline_share")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
}

extension ClubDetailPage {
    func callRemoteData() {
        CommonFunction.onPageLoading()
        
        // 본문 내용 조회
        viewModel.getClubDetail(
            clubId: self.clubId,
            categoryCode: self.categoryCode,
            postId: self.postId,
            integUid: userManager.uid,
            access_token: userManager.accessToken
        )
        
        // 북마크 조회
        viewModel.fetchBookmark(
            clubId: self.clubId,
            categoryCode: self.categoryCode,
            postId: self.postId,
            integUid: userManager.uid,
            access_token: userManager.accessToken
        )
    }
    
    fileprivate func fetchMoreData(_ boardList: ClubDetailReplyModel_ReplyList) {
        if self.viewModel.replyList.last == boardList {
            //print("[마지막]에 도달했다")
            self.viewModel.fetchMoreActionSubject.send()
        }
    }
    
    func setNaviTitle(board_name: String) -> some View {
        DispatchQueue.main.async {
            self.naviTitle = board_name
        }
        return EmptyView()
    }
    
    /**
     * 클럽 게시글 좋아요/싫어요 클릭 후, 결과 값 가져오기
     */
    func getClubLikeInfo(type: BoardLikeInfoType) -> Any {
        if type == BoardLikeInfoType.LikeCount {
            if let NOlike = viewModel.clubDetailModel?.like {
                let likeCount: Int = NOlike.likeCount - NOlike.dislikeCount
                return likeCount
            }
            else {
                return 0
            }
        }
        else if type == BoardLikeInfoType.LikeBtnColor {
            if let NOlike = viewModel.clubDetailModel?.like {
                let likeBtnColor: Color = NOlike.likeYn ? Color.stateActivePrimaryDefault : Color.stateDisabledGray200
                return likeBtnColor
            }
            else {
                return Color.stateDisabledGray200
            }
        }
        else if type == BoardLikeInfoType.DisLikeBtnColor {
            if let NOlike = viewModel.clubDetailModel?.like {
                let dislikeBtnColor: Color = NOlike.likeYn ? Color.stateDisabledGray200 : Color.stateActiveGray700
                return dislikeBtnColor
            }
            else {
                return Color.stateDisabledGray200
            }
        }
        else if type == BoardLikeInfoType.LikeTxtColor {
            if let NOlike = viewModel.clubDetailModel?.like {
                let likeTxtColor: Color = NOlike.likeYn ? Color.stateActivePrimaryDefault : Color.stateActiveGray700
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
    
    func gotoScrollBottom(proxyReader: ScrollViewProxy) -> some View {
        if viewModel.isReplyComplete {
            // 애니메이션과 함께 스크롤 바텀 액션 지정
            withAnimation(.default) {
                DispatchQueue.main.async {
                    proxyReader.scrollTo("SCROLL_TO_BOTTOM", anchor: .bottom)
                }
            }
            
            self.viewModel.isReplyComplete.toggle()
        }
        
        return EmptyView()
    }
    
    
    func setBookMarkVisible() -> Bool {
        /**
         * 팬투TV 또는 한류타임즈인 경우 => 북마크 안 보여줌
         */
        if clubId == "fantoo_tv" || clubId == "hanryu_times" {
            let _ = print("팬투TV 또는 한류타임즈인 경우!")
            return false
        } else {
            return true
        }
    }
}

struct ClubDetailPage_Previews: PreviewProvider {
    static var previews: some View {
        ClubDetailPage()
    }
}
