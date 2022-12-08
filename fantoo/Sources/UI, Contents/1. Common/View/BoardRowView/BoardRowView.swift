//
//  BoardRowView.swift
//  NotificationService
//
//  Created by kimhongpil on 2022/07/21.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

enum BoardType: Int {
    case HomeClubType1
    case MainCommunity_Hour
    case MainCommunity_Week
    case MyClub_Storage_Post
    case MyClub_Storage_Comment
    case MyClub_Storage_Bookmark
    case MyClub_Member_Storage_Post
    case MyClub_Member_Storage_Reply
    case MyCommunity_Storage_Post
    case MyCommunity_Storage_Comment
    case MyCommunity_Storage_BookMark
    case Community_Notice_Total // 전체공지 List
    case HomeCommunity_List_YesHot
    case HomeCommunity_List_NoHot
    
    
    
    // 2.0 적용하면 삭제할 것
    case MainHome
    case MainPopular
    case MainCommunityMyBoard
    case MainCommunityMyComment
    case MainCommunityMyLocalBoard
    case MainClub_MainPage_Top10
    case MainClub_ChallengePage
    case MainClub_My
    case MyStorage_Comment
    case MainFantooTV
    case MainHanryutimes
    case HomeClub_TabHome
    case HomeClub_TabFreeboard
    case HomeClub_TabArchive_NoImageView
}

enum BoardButtonType: Int {
    case More
    case Like
    case Dislike
    case Comment
}

struct BoardRowView {
    let viewType: BoardType
    var mainCommunity_BoardItem: Community_BoardItem?
    var clubStorageReplyListData: ClubStorageReplyListData?
    var clubStorageBookmarkListData: ClubStorageBookmarkListData?
    var clubStoragePostListData: ClubStoragePostListData?
    var clubStorageMemberPostListData: ClubStoragePostListData?
    var clubStorageMemberReplyListData: ClubStorageReplyListData?
    var fantooTVHomeTabItem: Club_TabHomeModel_PostList?
    var communityStorageReplyListData: UserCommunityReplyListData?
    var communityStorageBookmarkListData: UserCommunityBookmarkListData?
    var communityStoragePostListData: UserCommunityPostListData?
    var community_Notice_List: Community_Notice_List?
    
    // 좋아요 관련
    var likeCount: Int?
    var likeBtnColor: Color = Color.stateDisabledGray200
    var dislikeBtnColor: Color = Color.stateDisabledGray200
    var likeTxtColor: Color = Color.stateActiveGray700
    
    // 2.0 적용하면 삭제할 것
    var mainHomeItem: ItemData?
    var mainPopularItem: ItemData?
    var communityBoardItem: CommunityBoardItem?
    var communityNoticeItem: CommunityBoardItem?
    var mainClub_MainPage_Top10: MainClub_MainPage_PopularTop10?
    var mainClub_ChallengePage: MainClub_MainPage_PopularTop10?
    var homeClub_TabHomeModel_BoardList: HomeClub_TabHomeModel_BoardList?
    var homeClub_TabFreeboardItem: HomeClub_TabFreeboardModel_FreeBoard?
    var onPress: ((BoardButtonType) -> Void)? // BoardRowView를 호출하는 부분 전부 다 수정되면 옵셔널 제거할 것!
    var isDeletedBoard: ((Bool) -> Void)?
    var isReportedBoard: ((Bool) -> Void)?
    
    @State var showDetail: Bool = false
    @State var authorImage: String = ""
    @State var boardName: String = ""
    @State var authorNickname: String = ""
    @State var boardDate: String = ""
    @State var title: String = ""
    @State var bodyTxt: String?
    @State var postTitle: String = ""
    @State var imageArr: [Post_Thumbnail]?
    @State var clubAttachList = [AttachListModel]()
    @State var clubAttachList_videoThumbnail: String?
    @State var video: itemCardVideo? // 2.0 적용하면 삭제할 것
    @State var webLink: itemCardWebLink?
    @State var commentCount: Int = 0
    @State var comment: Comment_Community?
    @State var isBlockedBoard: Bool? = false
    @State var topYn: Bool = false
    
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
    private struct urlImageInfo {
        // Thumbnail Image Url sample :
        // https://imagedelivery.net/peZXyXogT-VgnN1sGn2T-Q/29a2c0b0-5777-4bb1-f522-3b84739f2700/thumbnail
        // Default Image Url sample :
        // https://imagedelivery.net/peZXyXogT-VgnN1sGn2T-Q/29a2c0b0-5777-4bb1-f522-3b84739f2700/public
        static let thumbnailPath: String = "/thumbnail"
        static let defaultPath: String = "/public"
    }
}

extension BoardRowView: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            /**
             * Header
             */
            Group {
                if viewType == .HomeClubType1 {
                    header_type02
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MyClub_Storage_Comment {
                    header_type02
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MyClub_Storage_Bookmark {
                    header_type02
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MyClub_Member_Storage_Post {
                    header_type02
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MyClub_Member_Storage_Reply {
                    header_type02
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MyClub_Storage_Post {
                    header_type02
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MyCommunity_Storage_Comment {
                    header_type02
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MyCommunity_Storage_BookMark {
                    header_type02
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MyCommunity_Storage_Post {
                    header_type02
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .HomeCommunity_List_YesHot {
                    header_type03
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .HomeCommunity_List_NoHot {
                    header_type02
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                
                
                // 2.0 적용하면 삭제할 것
                else if viewType == .MainHome {
                    header_type03
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MainPopular {
                    header_type03
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if (viewType == .MainCommunity_Hour) || (viewType == .MainCommunity_Week) {
                    header_type03
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MainCommunityMyBoard {
                    header_type03
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MainCommunityMyComment {
                    header_type03
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MainCommunityMyLocalBoard {
                    header_type03
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MainClub_MainPage_Top10 {
                    header_type03
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MainClub_ChallengePage {
                    header_type02
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MainClub_My {
                    header_type03
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .HomeClub_TabHome {
                    header_type03
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .HomeClub_TabFreeboard {
                    header_type02
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .HomeClub_TabArchive_NoImageView {
                    header_type02
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MyStorage_Comment {
                    header_type03
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MainFantooTV {
                    header_type02
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MainHanryutimes {
                    header_type02
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .Community_Notice_Total {
                    header_type02
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
            }
            
            /**
             * Body
             */
            Group {
                if viewType == .HomeClubType1 {
                    body_type05
                }
                else if viewType == .MyClub_Storage_Post {
                    body_type02
                        .padding(EdgeInsets(top: 10, leading: sizeInfo.Hpadding, bottom: 10, trailing: sizeInfo.Hpadding))
                }
                else if viewType == .MyClub_Storage_Comment {
                    body_type01
                        .padding(EdgeInsets(top: 10, leading: sizeInfo.Hpadding, bottom: 10, trailing: sizeInfo.Hpadding))
                }
                else if viewType == .MyClub_Storage_Bookmark {
                    body_type03
                        .padding(EdgeInsets(top: 10, leading: sizeInfo.Hpadding, bottom: 10, trailing: sizeInfo.Hpadding))
                }
                else if viewType == .MyClub_Member_Storage_Post {
                    body_type02
                        .padding(EdgeInsets(top: 10, leading: sizeInfo.Hpadding, bottom: 10, trailing: sizeInfo.Hpadding))
                }
                else if viewType == .MyClub_Member_Storage_Reply {
                    body_type01
                        .padding(EdgeInsets(top: 10, leading: sizeInfo.Hpadding, bottom: 10, trailing: sizeInfo.Hpadding))
                }
                else if viewType == .MyCommunity_Storage_Post {
                    body_type02
                        .padding(EdgeInsets(top: 10, leading: sizeInfo.Hpadding, bottom: 10, trailing: sizeInfo.Hpadding))
                }
                else if viewType == .MyCommunity_Storage_Comment {
                    body_type01
                        .padding(EdgeInsets(top: 10, leading: sizeInfo.Hpadding, bottom: 10, trailing: sizeInfo.Hpadding))
                }
                else if viewType == .MyCommunity_Storage_BookMark {
                    body_type02
                        .padding(EdgeInsets(top: 10, leading: sizeInfo.Hpadding, bottom: 10, trailing: sizeInfo.Hpadding))
                }
                
                // 2.0 적용하면 삭제할 것
                else if viewType == .MainHome {
                    if let NOvideo = video,
                       let NOimageArr = imageArr,
                       let NOwebLink = webLink {
                        
                        /**
                         * 컨텐츠 노출 우선순위
                         * 1. 동영상
                         * 2. 이미지
                         * 3. 웹링크
                         * 4. 텍스트
                         */
                        if NOvideo.video_url != "" {
                            body_type05
                        }
                        else {
                            if NOimageArr.count > 0 {
                                body_type04
                            }
                            else if NOwebLink.link_url != "" {
                                body_type06
                            }
                            else {
                                body_type07
                            }
                        }
                    }
                }
                else if viewType == .MainPopular {
                    if let NOvideo = video,
                       let NOimageArr = imageArr,
                       let NOwebLink = webLink {
                        
                        /**
                         * 컨텐츠 노출 우선순위
                         * 1. 동영상
                         * 2. 이미지
                         * 3. 웹링크
                         * 4. 텍스트
                         */
                        if NOvideo.video_url != "" {
                            body_type05
                        }
                        else {
                            if NOimageArr.count > 0 {
                                body_type04
                            }
                            else if NOwebLink.link_url != "" {
                                body_type06
                            }
                            else {
                                body_type07
                            }
                        }
                    }
                }
                else if (viewType == .MainCommunity_Hour) || (viewType == .MainCommunity_Week) || (viewType == .HomeCommunity_List_YesHot) || (viewType == .HomeCommunity_List_NoHot) {
                    body_type02
                        .padding(EdgeInsets(top: 15, leading: sizeInfo.Hpadding, bottom: 0, trailing: sizeInfo.Hpadding))
                }
                else if viewType == .MainCommunityMyBoard {
                    body_type02
                        .padding(EdgeInsets(top: 10, leading: sizeInfo.Hpadding, bottom: 10, trailing: sizeInfo.Hpadding))
                }
                else if viewType == .MainCommunityMyComment {
                    body_type08
                        .padding(EdgeInsets(top: 2, leading: 58, bottom: 0, trailing: sizeInfo.Hpadding))
                }
                else if viewType == .MainCommunityMyLocalBoard {
                    body_type02
                        .padding(EdgeInsets(top: 10, leading: sizeInfo.Hpadding, bottom: 10, trailing: sizeInfo.Hpadding))
                }
                else if viewType == .MainClub_MainPage_Top10 {
                    body_type03
                        .padding(EdgeInsets(top: 10, leading: sizeInfo.Hpadding, bottom: 10, trailing: sizeInfo.Hpadding))
                }
                else if viewType == .MainClub_ChallengePage {
                    body_type02
                        .padding(EdgeInsets(top: 10, leading: sizeInfo.Hpadding, bottom: 10, trailing: sizeInfo.Hpadding))
                }
                else if viewType == .MainClub_My {
                    body_type03
                        .padding(EdgeInsets(top: 10, leading: sizeInfo.Hpadding, bottom: 10, trailing: sizeInfo.Hpadding))
                }
                else if viewType == .HomeClub_TabHome {
                    if let NOvideo = video,
                       let NOimageArr = imageArr,
                       let NOwebLink = webLink {
                        
                        /**
                         * 컨텐츠 노출 우선순위
                         * 1. 동영상
                         * 2. 이미지
                         * 3. 웹링크
                         * 4. 텍스트
                         */
                        if NOvideo.video_url != "" {
                            body_type05
                        }
                        else {
                            if NOimageArr.count > 0 {
                                body_type04
                            }
                            else if NOwebLink.link_url != "" {
                                body_type06
                            }
                            else {
                                body_type07
                            }
                        }
                    }
                }
                else if viewType == .HomeClub_TabFreeboard {
                    body_type03
                        .padding(EdgeInsets(top: 10, leading: sizeInfo.Hpadding, bottom: 10, trailing: sizeInfo.Hpadding))
                }
                else if viewType == .HomeClub_TabArchive_NoImageView {
                    body_type05
                }
                else if viewType == .MyStorage_Comment {
                    body_type01
                        .padding(EdgeInsets(top: 10, leading: sizeInfo.Hpadding, bottom: 10, trailing: sizeInfo.Hpadding))
                }
                else if viewType == .MainFantooTV {
                    if let NOvideo = video,
                       let NOimageArr = imageArr,
                       let NOwebLink = webLink {
                        
                        /**
                         * 컨텐츠 노출 우선순위
                         * 1. 동영상
                         * 2. 이미지
                         * 3. 웹링크
                         * 4. 텍스트
                         */
                        if NOvideo.video_url != "" {
                            body_type05
                        }
                        else {
                            if NOimageArr.count > 0 {
                                body_type04
                            }
                            else if NOwebLink.link_url != "" {
                                body_type06
                            }
                            else {
                                body_type07
                            }
                        }
                    }
                }
                else if viewType == .MainHanryutimes {
                    if let NOvideo = video,
                       let NOimageArr = imageArr,
                       let NOwebLink = webLink {
                        
                        /**
                         * 컨텐츠 노출 우선순위
                         * 1. 동영상
                         * 2. 이미지
                         * 3. 웹링크
                         * 4. 텍스트
                         */
                        if NOvideo.video_url != "" {
                            body_type05
                        }
                        else {
                            if NOimageArr.count > 0 {
                                body_type04
                            }
                            else if NOwebLink.link_url != "" {
                                body_type06
                            }
                            else {
                                body_type07
                            }
                        }
                    }
                }
                else if viewType == .Community_Notice_Total {
                    body_type02
                        .padding(EdgeInsets(top: 15, leading: sizeInfo.Hpadding, bottom: 0, trailing: sizeInfo.Hpadding))
                }
            }
            
            /**
             * Footer
             */
            Group {
                if viewType == .HomeClubType1 {
                    footer_type03_renew
                        .padding(.top, 15)
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MyClub_Storage_Post {
                    footer_type01
                        .padding(.top, 15)
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MyClub_Storage_Comment {
                    footer_type04
                        .padding(.top, 15)
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MyClub_Storage_Bookmark {
                    footer_type01
                        .padding(.top, 15)
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MyClub_Member_Storage_Post {
                    footer_type01
                        .padding(.top, 15)
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MyClub_Member_Storage_Reply {
                    footer_type04
                        .padding(.top, 15)
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MyCommunity_Storage_Post {
                    footer_type01
                        .padding(.top, 15)
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MyCommunity_Storage_Comment {
                    footer_type04
                        .padding(.top, 15)
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MyCommunity_Storage_BookMark {
                    footer_type01
                        .padding(.top, 15)
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                
                // 2.0 적용하면 삭제할 것
                else if viewType == .MainHome {
                    footer_type03
                        .padding(.top, 15)
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MainPopular {
                    footer_type03
                        .padding(.top, 15)
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if (viewType == .MainCommunity_Hour) || (viewType == .MainCommunity_Week) || (viewType == .HomeCommunity_List_YesHot) || (viewType == .HomeCommunity_List_NoHot) {
                    footer_type03
                        .padding(.top, 17)
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MainCommunityMyBoard {
                    footer_type03
                        .padding(.top, 17)
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MainCommunityMyComment {
                    footer_type04
                        .padding(.top, 15)
                        .padding(.leading, 58)
                        .padding(.trailing, 20)
                }
                else if viewType == .MainCommunityMyLocalBoard {
                    footer_type03
                        .padding(.top, 17)
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MainClub_MainPage_Top10 {
                    footer_type01
                        .padding(.top, 15)
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MainClub_ChallengePage {
                    footer_type01
                        .padding(.top, 15)
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MainClub_My {
                    footer_type03
                        .padding(.top, 15)
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .HomeClub_TabHome {
                    footer_type01
                        .padding(.top, 15)
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .HomeClub_TabFreeboard {
                    footer_type01
                        .padding(.top, 15)
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .HomeClub_TabArchive_NoImageView {
                    footer_type01
                        .padding(.top, 15)
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MyStorage_Comment {
                    footer_type04
                        .padding(.top, 15)
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MainFantooTV {
                    footer_type03
                        .padding(.top, 15)
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
                else if viewType == .MainHanryutimes {
                    footer_type02
                        .padding(.top, 15)
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
            }
        }
        .background(Color.gray25) // 빈 공간 클릭시 상세화면으로 넘어가게 하려면, background()로 빈 공간을 차지해야 함.
        .onTapGesture {
            if viewType == .MyCommunity_Storage_Comment {
                if let NOboardItem = communityStorageReplyListData {
                    if NOboardItem.activeStatus == 2 {
                        guard let NOisDeletedBoard = isDeletedBoard else { return }
                        NOisDeletedBoard(true)
                    }
                    else if NOboardItem.activeStatus == 0 {
                        guard let NOisReportedBoard = isReportedBoard else { return }
                        NOisReportedBoard(true)
                    }
                    else {

                        showDetail = true
                    }
                }
            }
            if viewType == .MyCommunity_Storage_Post {
                if let NOboardItem = communityStoragePostListData {
                    if NOboardItem.activeStatus == 2 {
                        guard let NOisDeletedBoard = isDeletedBoard else { return }
                        NOisDeletedBoard(true)
                    }
                    else if NOboardItem.activeStatus == 0 {
                        guard let NOisReportedBoard = isReportedBoard else { return }
                        NOisReportedBoard(true)
                    }
                    else {

                        showDetail = true
                    }
                }
            }
            if viewType == .MyCommunity_Storage_BookMark {
                if let NOboardItem = communityStorageBookmarkListData{
                    if NOboardItem.activeStatus == 2 {
                        guard let NOisDeletedBoard = isDeletedBoard else { return }
                        NOisDeletedBoard(true)
                    }
                    else if NOboardItem.activeStatus == 0 {
                        guard let NOisReportedBoard = isReportedBoard else { return }
                        NOisReportedBoard(true)
                    }
                    else {

                        showDetail = true
                    }
                }
            }
            else {
                showDetail = true
            }
        }
        .background(
            bodyClickNavigation()
        )
        .padding(EdgeInsets(top: 18, leading: 0, bottom: 18, trailing: 0))
        .onAppear {
            self.setData()
        }
    }
    
    /**
     * 이미지 + 게시글이름 + 더보기
     */
    var header_type01: some View {
        HStack(spacing: 0) {
            Group {
                WebImage(url: URL(string: self.authorImage.imageOriginalUrl))
                    .placeholder(content: {
                        Image("profile_club_character")
                            .resizable()
                    })
                    .resizable()
            }
            .frame(width: 28, height: 28)
            .cornerRadius(8)
            
            Text(self.boardName)
                .font(.caption11218Regular)
                .foregroundColor(.gray900)
                .padding(.leading, 10)
            
            Spacer()
            
            Image("icon_outline_more")
                .resizable()
                .frame(width: 24, height: 24)
        }
    }
    /**
     * 이미지 + 게시글이름 + 날짜 + 더보기
     */
    var header_type02: some View {
        HStack(spacing: 0) {
            HStack (spacing: 0) {
                Group {
                    WebImage(url: URL(string: self.authorImage.imageOriginalUrl))
                        .placeholder(content: {
                            Image("profile_club_character")
                                .resizable()
                        })
                        .resizable()
                }
                .frame(width: 28, height: 28)
                .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(self.boardName)
                        .font(.caption11218Regular)
                        .foregroundColor(.gray900)
                    Text("".changeDateFormat_Custom(strDate: self.boardDate))
                        .font(.caption11218Regular)
                        .foregroundColor(.gray400)
                }
                .padding(.leading, 10)
                
                Spacer()
            }
            
            Spacer()
            
            if viewType != .HomeClubType1, viewType != .MainCommunity_Hour, viewType != .MainCommunity_Week, viewType != .MyClub_Storage_Post, viewType != .MyClub_Storage_Comment, viewType != .MyClub_Storage_Bookmark, viewType != .MyClub_Member_Storage_Post, viewType != .MyClub_Member_Storage_Reply, viewType != .MyCommunity_Storage_Comment, viewType != .MyCommunity_Storage_Post, viewType != .MyCommunity_Storage_BookMark, viewType != .Community_Notice_Total, viewType != .HomeCommunity_List_YesHot, viewType != .HomeCommunity_List_NoHot {
                Image("icon_outline_more")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
    }
    /**
     * 이미지 + 게시글이름 + 닉네임 + 날짜 + 더보기
     */
    var header_type03: some View {
        HStack(spacing: 0) {
            HStack (spacing: 0) {
                Group {
                    WebImage(url: URL(string: self.authorImage.imageOriginalUrl))
                        .placeholder(content: {
                            Image("profile_club_character")
                                .resizable()
                        })
                        .resizable()
                }
                .frame(width: 28, height: 28)
                .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(self.boardName)
                        .font(.caption11218Regular)
                        .foregroundColor(.gray900)
                    HStack(spacing: 0) {
                        Text(self.authorNickname)
                            .font(.caption11218Regular)
                            .foregroundColor(.gray400)
                        Text("   ●   ")
                            .font(.system(size: 6))
                            .foregroundColor(.gray200)
                        Text("".changeDateFormat_Custom(strDate: self.boardDate))
                            .font(.caption11218Regular)
                            .foregroundColor(.gray400)
                    }
                }
                .padding(.leading, 10)
                
                Spacer()
            }
            
            Spacer()
            
            if viewType != .MainCommunity_Hour, viewType != .MainCommunity_Week {
                Button(action: {
                    guard let NOonPress = onPress else { return }
                    NOonPress(BoardButtonType.More)
                }, label: {
                    Image("icon_outline_more")
                        .resizable()
                        .frame(width: 24, height: 24)
                })
            }
            
        }
    }
    /**
     * 이미지 + 게시글이름 + 날짜 + 더보기 (HStack)
     */
    var header_type04: some View {
        HStack(spacing: 0) {
            HStack (spacing: 0) {
                Group {
                    WebImage(url: URL(string: self.authorImage.imageOriginalUrl))
                        .placeholder(content: {
                            Image("profile_club_character")
                                .resizable()
                        })
                        .resizable()
                }
                .frame(width: 28, height: 28)
                .cornerRadius(8)
                
                HStack(spacing: 0) {
                    Text(self.boardName)
                        .font(.caption11218Regular)
                        .foregroundColor(.gray400)
                    Text("   ●   ")
                        .font(.system(size: 6))
                        .foregroundColor(.gray200)
                    Text("".changeDateFormat_Custom(strDate: self.boardDate))
                        .font(.caption11218Regular)
                        .foregroundColor(.gray400)
                    Spacer()
                }
                .padding(.leading, 10)
            }
            
            Button(action: {
                guard let NOonPress = onPress else { return }
                NOonPress(BoardButtonType.More)
            }, label: {
                Image("icon_outline_more")
                    .resizable()
                    .frame(width: 24, height: 24)
            })
        }
    }
    
    /**
     * 본문글
     */
    var body_type01: some View {
        Text(" \(title)")
            .font(.body21420Regular)
            .foregroundColor(.gray870)
            .multilineTextAlignment(.leading)
            .lineLimit(2)
            .lineSpacing(5)
    }
    /**
     * 아이콘 + 본문글
     */
    var body_type02: some View {
        Group {
            if let NOisBlockedBoard = isBlockedBoard {
                if NOisBlockedBoard {
                    Text(title)
                        .font(.body21420Regular)
                        .foregroundColor(.gray400)
                }
                else {
                    if viewType == .Community_Notice_Total {
                        if topYn {
                            (
                                Text(Image(self.setTitleImage())).baselineOffset(-1.5)
                                +
                                Text(" \(title)").font(.body21420Regular).foregroundColor(.gray870)
                            )
                        } else if !topYn {
                            Text(" \(title)").font(.body21420Regular).foregroundColor(.gray870)
                        }
                    }
                    else {
                        /**
                         * Text 연산자 사용하기 (이미지와 텍스트 합치기)
                         */
                        (
                            // 아이콘 높이는 텍스트 높이보다 약간 높기 때문에, 1.5만큼 아래로 낮춰줘서 텍스트와 중앙을 맞춰준다.
                            Text(Image(self.setTitleImage())).baselineOffset(-1.5)
                            +
                            Text(" \(title)").font(.body21420Regular).foregroundColor(.gray870)
                        )
                    }
                }
                
            }
            else {
                (
                    Text(Image(self.setTitleImage())).baselineOffset(-1.5)
                    +
                    Text(" \(title)").font(.body21420Regular).foregroundColor(.gray870)
                )
            }
        }
        .multilineTextAlignment(.leading)
        .lineLimit(2)
        .lineSpacing(5)
    }
    /**
     * 말머리 + 아이콘 + 본문글
     */
    var body_type03: some View {
        /**
         * Text 연산자 사용하기 (이미지와 텍스트 합치기)
         */
        (
            Text("[말머리] ").font(.buttons1420Medium.weight(.bold)).foregroundColor(.primary500)
            +
            // 아이콘 높이는 텍스트 높이보다 약간 높기 때문에, 1.5만큼 아래로 낮춰줘서 텍스트와 중앙을 맞춰준다.
            Text(Image(self.setTitleImage())).baselineOffset(-1.5)
            +
            Text(" \(title)").font(.body21420Regular).foregroundColor(.gray870)
        )
            .multilineTextAlignment(.leading)
            .lineLimit(2)
            .lineSpacing(5)
    }
    /**
     * 제목 + 본문글 + 이미지
     */
    var body_type04: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            body_TitleAndBodyTxt
            
            Group {
                if let NOimageArr = imageArr {
                    if NOimageArr.count > 0 {
                        if NOimageArr.count == 1 {
                            body_ImageView_One
                        }
                        else if NOimageArr.count == 2 {
                            body_ImageView_Two
                        }
                        else if NOimageArr.count > 2 {
                            body_ImageView_Many
                        }
                    }
                }
            }
            .frame(height: 280)
            .padding(.top, 12)
        }
        .frame(width: UIScreen.screenWidth)
    }
    /**
     * 제목 + 본문글 + 영상
     */
    var body_type05: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            body_TitleAndBodyTxt
            
            if viewType == .HomeClubType1 {
                body_VideoView
                    .frame(height: 280)
                    .padding(.top, 12)
            } else {
                // 2.0 api 적용 완료시, 삭제할 것
                if let _ = video {
                    body_VideoView
                        .frame(height: 280)
                        .padding(.top, 12)
                }
            }
        }
        .frame(width: UIScreen.screenWidth, alignment: .leading)
    }
    /**
     * 제목 + 본문글 + 웹링크
     */
    var body_type06: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            body_TitleAndBodyTxt
            
            if let _ = webLink {
                body_WebLinkView
                    .padding(EdgeInsets(top: 6, leading: sizeInfo.Hpadding, bottom: 0, trailing: sizeInfo.Hpadding))
            }
        }
        .frame(width: UIScreen.screenWidth)
    }
    /**
     * 제목 + 본문글
     */
    var body_type07: some View {
        body_TitleAndBodyTxt
    }
    /**
     * 댓글 글자 + 댓글 이미지
     */
    var body_type08: some View {
        body_CommentTxtAndImage
    }
    
    /**
     * 댓글
     */
    var footer_type01: some View {
        HStack (alignment: .center, spacing: 0) {
            
            Spacer()
            
            Button(action: {
                print("댓글 버튼 클릭")
            }) {
                HStack (alignment: .center, spacing: 0) {
                    Image("icon_fill_comment")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(Color.gray200)
                        .frame(width: 16, height: 16)
                    Text(String(commentCount))
                        .font(.caption11218Regular)
                        .foregroundColor(.stateActiveGray700)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    /**
     * 좋아요
     */
    var footer_type02: some View {
        HStack (alignment: .center) {
            
            HStack (alignment: .center) {
                Button(action: {
                    print("좋아요 버튼 클릭")
                }) {
                    Image("icon_fill_like")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(Color.gray200)
                        .frame(width: 16, height: 16)
                }
                /**
                 * PlainButtonStyle() 추가해주지 않으면 List에서 클릭한 Item의 버튼이 아니라 Item 전체가 깜빡이는 문제가 있음
                 */
                .buttonStyle(PlainButtonStyle())
                
                Text(String(7))
                    .font(.caption11218Regular)
                    .foregroundColor(.stateActiveGray700)
                
                Button(action: {
                    print("싫어요 버튼 클릭")
                }) {
                    Image("icon_fill_dislike")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(Color.gray200)
                        .frame(width: 16, height: 16)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Spacer()
        }
    }
    /**
     * 좋아요 + 댓글
     */
    var footer_type03: some View {
        HStack (alignment: .center) {
            HStack (alignment: .center) {
                Button(action: {
                    guard let NOonPress = onPress else { return }
                    NOonPress(BoardButtonType.Like)
                }) {
                    Image("icon_fill_like")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(likeBtnColor)
                        .frame(width: 16, height: 16)
                }
                /**
                 * PlainButtonStyle() 추가해주지 않으면 List에서 클릭한 Item의 버튼이 아니라 Item 전체가 깜빡이는 문제가 있음
                 */
                .buttonStyle(PlainButtonStyle())
                
                if let NOlikeCount = likeCount {
                    Text(String(NOlikeCount))
                        .font(.caption11218Regular)
                        .foregroundColor(likeTxtColor)
                }
                
                Button(action: {
                    guard let NOonPress = onPress else { return }
                    NOonPress(BoardButtonType.Dislike)
                }) {
                    Image("icon_fill_dislike")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(dislikeBtnColor)
                        .frame(width: 16, height: 16)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Spacer()
            
            Button(action: {
                guard let NOonPress = onPress else { return }
                NOonPress(BoardButtonType.Comment)
            }) {
                HStack (alignment: .center) {
                    Image("icon_fill_comment")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(Color.gray200)
                        .frame(width: 16, height: 16)
                    Text(String(commentCount))
                        .font(.caption11218Regular)
                        .foregroundColor(Color.stateActiveGray700)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    /**
     * fantootv_좋아요 + 댓글 (이 버전으로 수정할 것)
     */
    var footer_type03_renew: some View {
        HStack (alignment: .center) {
            HStack (alignment: .center) {
                Button(action: {
                    guard let NOonPress = onPress else { return }
                    NOonPress(BoardButtonType.Like)
                }) {
                    Image("icon_fill_like")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(likeBtnColor)
                        .frame(width: 16, height: 16)
                }
                /**
                 * PlainButtonStyle() 추가해주지 않으면 List에서 클릭한 Item의 버튼이 아니라 Item 전체가 깜빡이는 문제가 있음
                 */
                .buttonStyle(PlainButtonStyle())
                
                if let NOlikeCount = likeCount {
                    Text(String(NOlikeCount))
                        .font(.caption11218Regular)
                        .foregroundColor(likeTxtColor)
                }
                
                Button(action: {
                    guard let NOonPress = onPress else { return }
                    NOonPress(BoardButtonType.Dislike)
                }) {
                    Image("icon_fill_dislike")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(dislikeBtnColor)
                        .frame(width: 16, height: 16)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Spacer()
            
            Button(action: {
                guard let NOonPress = onPress else { return }
                NOonPress(BoardButtonType.Comment)
            }) {
                HStack (alignment: .center) {
                    Image("icon_fill_comment")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(Color.gray200)
                        .frame(width: 16, height: 16)
                    Text(String(commentCount))
                        .font(.caption11218Regular)
                        .foregroundColor(Color.stateActiveGray700)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    /**
     * 댓글(상세보기)
     */
    var footer_type04: some View {
        HStack (alignment: .center) {
            VStack {
                ExDivider(color: Color.bgLightGray50, height: 1)
                
                HStack (alignment: .center) {
                    //Text(String(commentCount))
                    Text(postTitle)
                        .font(Font.caption11218Regular)
                        .foregroundColor(.gray870)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Spacer()
                    Image("icon_outline_go")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(Color.gray700)
                        .frame(width: 16, height: 16)
                }
            }
        }
        .background(Color.gray25)
        .onTapGesture {
            showDetail = true
        }
    }
    
    /**
     * 이미지 한 개
     */
    var body_ImageView_One: some View {
        WebImage(url: URL(string: imageArr![0].url))
            .resizable()
    }
    /**
     * 이미지 두 개
     */
    var body_ImageView_Two: some View {
        HStack {
            WebImage(url: URL(string: imageArr![0].url))
                .resizable()
            
            WebImage(url: URL(string: imageArr![1].url))
                .resizable()
        }
    }
    /**
     * 이미지 세 개 이상
     */
    var body_ImageView_Many: some View {
        GeometryReader { geometry in
            HStack {
                WebImage(url: URL(string: imageArr![0].url))
                    .resizable()
                    .frame(width: geometry.size.width / 1.8)    // 절반에서 0.2 정도 더 길게
                VStack {
                    WebImage(url: URL(string: imageArr![1].url))
                        .resizable()
                    
                    ZStack {
                        WebImage(url: URL(string: imageArr![2].url))
                            .resizable()
                        
                        Color.black.opacity(0.5)
                        
                        Text("+ \(String(imageArr!.count-3))")
                            .font(.title41824Medium)
                            .foregroundColor(.gray25)
                    }
                }
                .frame(width: geometry.size.width / 2.2)    // 절반에서 0.2 정도 더 짧게
            }
        }
    }
    /**
     * 영상
     */
    var body_VideoView: some View {
        Group {
            if viewType == .HomeClubType1 {
                if let NOclubAttachList_videoThumbnail = clubAttachList_videoThumbnail {
                    
                    let thumbImg: String = "https://customer-y628kmdfbqq6rn1n.cloudflarestream.com/" + NOclubAttachList_videoThumbnail + "/thumbnails/thumbnail.jpg"
                    
                    ZStack(alignment: .center) {
                        WebImage(url: URL(string: thumbImg))
                            .resizable()
                            .overlay(Color.gray900.opacity(0.5))
                        
                        Image("icon_outline_play")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(Color.gray200)
                            .frame(width: 40, height: 40)
                    }
                    .frame(height: 280)
                }
            }
            // 2.0 적용하면 지울 것
            else {
                ZStack(alignment: .center) {
                    WebImage(url: URL(string: video!.video_thumbnail))
                        .resizable()
                        .overlay(Color.gray900.opacity(0.5))
                    
                    Image("icon_outline_play")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(Color.gray200)
                        .frame(width: 40, height: 40)
                }
                .frame(height: 280)
            }
        }
    }
    /**
     * 웹링크
     */
    var body_WebLinkView: some View {
        
        HStack(alignment: .top, spacing: 0) {
            WebImage(url: URL(string: webLink!.link_image))
                .resizable()
                .frame(width: 88, height: 88)
                .cornerRadius(6.0)
                .padding(EdgeInsets(top: 8, leading: 9, bottom: 8, trailing: 13))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(webLink!.link_title)
                    .font(.caption11218Regular)
                    .foregroundColor(.gray800)
                    .lineLimit(2)
                Text("출처: \(webLink!.link_url)")
                    .font(.caption11218Regular)
                    .foregroundColor(.gray400)
                    .lineLimit(1)
            }
            .padding(EdgeInsets(top: 14, leading: 0, bottom: 14, trailing: 12))
        }
        .background(
            RoundedRectangle(cornerRadius: 8.0)
                .style(
                    withStroke: Color.gray100,
                    lineWidth: 1,
                    fill: Color.gray50
                )
        )
    }
    
    /**
     * 하위 뷰 모음
     */
    var body_TitleAndBodyTxt: some View {
        Group {
            // title
            if viewType == .HomeClub_TabHome {
                (
                    Text("[말머리] ").font(.buttons1420Medium.weight(.bold)).foregroundColor(.primary500)
                    +
                    Text(title)
                        .font(.title51622Medium.weight(.bold))
                        .foregroundColor(.gray870)
                )
                    .padding(EdgeInsets(top: 16, leading: sizeInfo.Hpadding, bottom: 0, trailing: sizeInfo.Hpadding))
            }
            else {
                Text(title)
                    .font(.title51622Medium.weight(.bold))
                    .foregroundColor(.gray870)
                    .padding(EdgeInsets(top: 16, leading: sizeInfo.Hpadding, bottom: 0, trailing: sizeInfo.Hpadding))
            }
            
            // congtent
            if viewType != .HomeClubType1 {
                if let NObodyTxt = bodyTxt {
                    Text(NObodyTxt)
                        .font(.body21420Regular)
                        .foregroundColor(.gray700)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .lineSpacing(5)
                        .padding(EdgeInsets(top: 6, leading: sizeInfo.Hpadding, bottom: 0, trailing: sizeInfo.Hpadding))
                }
            }
        }
    }
    
    var body_CommentTxtAndImage: some View {
        Group {
            if let NOcomment = comment {
                Text(NOcomment.content)
                    .font(.body21420Regular)
                    .foregroundColor(.gray870)
                    .lineLimit(2)
                    .allowsTightening(false) // 글자 압축 안 함 - '점점점'으로 처리
                
                if NOcomment.image != "" {
                    WebImage(url: URL(string: NOcomment.image))
                        .resizable()
                        .frame(width: 163, height: 154)
                        .padding(.top, 20)
                }
            }
        }
    }
    
}

/**
 * View 를 채택하고 있는 struct에서 setTitleImage() 함수에서와 같은 조건문을 사용하면  "returnType '()' cannot conform to 'View'" 에러가 발생한다.
 * 그래서 아래와 같이 extension을 사용해 View 를 채택하지 않도록 해서 조건문을 적용하면 됨 !!!!!!
 */
extension BoardRowView {
    
    func setData() {
        
        if viewType == .HomeClubType1 {
            if let NOboardItem = fantooTVHomeTabItem {
                authorImage = NOboardItem.profileImg
                boardName = NOboardItem.categoryName2
                boardDate = NOboardItem.createDate
                title = NOboardItem.subject
                bodyTxt = NOboardItem.content
                clubAttachList = NOboardItem.attachList
                
                if NOboardItem.attachList.count > 0 {
                    for item in NOboardItem.attachList {
                        // 0: 이미지
                        // 1: 영상
                        if item.attachType==1 {
                            // 영상 있는 경우
                            clubAttachList_videoThumbnail = item.attach
                        }
                    }
                }
                
                if let NOreplyCount = NOboardItem.replyCount {
                    commentCount = NOreplyCount
                }
            }
        }
        
        else if viewType == .MyClub_Storage_Comment {
            if let NOboardItem = clubStorageReplyListData {
                authorImage = NOboardItem.profileImg
                boardName = NOboardItem.clubName
                authorNickname = NOboardItem.nickname
                boardDate = NOboardItem.createDate
                title = NOboardItem.content
                postTitle = NOboardItem.subject
                //                imageArr = NOboardItem.post_thumbnail
                //                video = NOboardItem.post_video
                commentCount = NOboardItem.replyCount
            }
        }
        else if viewType == .MyClub_Storage_Post {
            if let NOboardItem = clubStoragePostListData {
                authorImage = NOboardItem.profileImg ?? ""
                boardName = NOboardItem.clubName ?? ""
                authorNickname = NOboardItem.nickname ?? ""
                boardDate = NOboardItem.createDate ?? ""
                title = NOboardItem.subject ?? ""
                //                imageArr = NOboardItem.post_thumbnail
                //                video = NOboardItem.post_video
                commentCount = NOboardItem.replyCount ?? 0
            }
        }
        else if viewType == .MyClub_Storage_Bookmark {
            if let NOboardItem = clubStorageBookmarkListData {
                authorImage = NOboardItem.profileImg ?? ""
                boardName = NOboardItem.clubName ?? ""
                authorNickname = NOboardItem.nickname ?? ""
                boardDate = NOboardItem.createDate ?? ""
                title = NOboardItem.subject ?? ""
                //                imageArr = NOboardItem.post_thumbnail
                //                video = NOboardItem.post_video
                commentCount = NOboardItem.replyCount ?? 0
            }
        }
        else if viewType == .MyClub_Member_Storage_Post {
            if let NOboardItem = clubStorageMemberPostListData {
                authorImage = NOboardItem.profileImg ?? ""
                boardName = NOboardItem.clubName ?? ""
                authorNickname = NOboardItem.nickname ?? ""
                boardDate = NOboardItem.createDate ?? ""
                title = NOboardItem.subject ?? ""
                //                imageArr = NOboardItem.post_thumbnail
                //                video = NOboardItem.post_video
                commentCount = NOboardItem.replyCount ?? 0
            }
        }
        
        else if viewType == .MyClub_Member_Storage_Reply {
            if let NOboardItem = clubStorageMemberReplyListData {
                authorImage = NOboardItem.profileImg
                boardName = NOboardItem.clubName
                authorNickname = NOboardItem.nickname
                boardDate = NOboardItem.createDate
                title = NOboardItem.subject
                //                imageArr = NOboardItem.post_thumbnail
                //                video = NOboardItem.post_video
                commentCount = NOboardItem.replyCount
            }
        }
        else if viewType == .MyCommunity_Storage_Comment {
            if let NOboardItem = communityStorageReplyListData {
                authorImage = NOboardItem.userPhoto ?? ""
                boardName = NOboardItem.code ?? ""
                authorNickname = NOboardItem.userNick ?? ""
                boardDate = NOboardItem.createDate ?? ""
                title = NOboardItem.content ?? ""
                postTitle = NOboardItem.postTitle ?? ""
                //                imageArr = NOboardItem.post_thumbnail
                //                video = NOboardItem.post_video
                commentCount = NOboardItem.replyCnt ?? 0
            }
        }
        else if viewType == .MyCommunity_Storage_Post {
            if let NOboardItem = communityStoragePostListData {
                authorImage = NOboardItem.userPhoto
                boardName = NOboardItem.code
                authorNickname = NOboardItem.userNick
                boardDate = NOboardItem.createDate
                title = NOboardItem.content
                //                imageArr = NOboardItem.post_thumbnail
                //                video = NOboardItem.post_video
                commentCount = NOboardItem.replyCnt
            }
        }
        else if viewType == .MyCommunity_Storage_BookMark {
            if let NOboardItem = communityStorageBookmarkListData {
                authorImage = NOboardItem.userPhoto
                boardName = NOboardItem.code
                authorNickname = NOboardItem.userNick
                boardDate = NOboardItem.createDate
                title = NOboardItem.title
//                imageArr = NOboardItem.post_thumbnail
                //                video = NOboardItem.post_video
                commentCount = NOboardItem.replyCnt
            }
        }
        else if viewType == .Community_Notice_Total {
            if let NOboardItem = community_Notice_List {
                authorImage = NOboardItem.userPhoto
                boardName = NOboardItem.userNick
                boardDate = NOboardItem.createDate
                title = NOboardItem.title
                topYn = NOboardItem.topYn
            }
        }
        
        // 2.0 적용하면 지울 것
        else if viewType == .MainHome {
            if let NOboardItem = mainHomeItem {
                authorImage = NOboardItem.item.author_profile
                boardName = NOboardItem.item.board_name
                authorNickname = NOboardItem.item.author_nickname
                boardDate = NOboardItem.item.date
                title = NOboardItem.item.title
                bodyTxt = NOboardItem.item.contents
                imageArr = NOboardItem.item.post_thumbnail
                video = NOboardItem.item.post_video
                webLink = NOboardItem.item.web_link
                commentCount = NOboardItem.item.story_count
            }
        }
        else if viewType == .MainPopular {
            if let NOboardItem = mainPopularItem {
                authorImage = NOboardItem.item.author_profile
                boardName = NOboardItem.item.board_name
                authorNickname = NOboardItem.item.author_nickname
                boardDate = NOboardItem.item.date
                title = NOboardItem.item.title
                bodyTxt = NOboardItem.item.contents
                imageArr = NOboardItem.item.post_thumbnail
                video = NOboardItem.item.post_video
                webLink = NOboardItem.item.web_link
                commentCount = NOboardItem.item.story_count
            }
        }
        else if viewType == .HomeCommunity_List_NoHot {
            if let NOboardItem = mainCommunity_BoardItem {
                authorImage = NOboardItem.userPhoto
                boardName = NOboardItem.userNick
                //authorNickname = NOboardItem.userNick
                boardDate = NOboardItem.createDate
                title = NOboardItem.title
                commentCount = NOboardItem.replyCnt
                isBlockedBoard = NOboardItem.pieceBlockYn
            }
        }
        else if (viewType == .MainCommunity_Hour) || (viewType == .MainCommunity_Week) || (viewType == .HomeCommunity_List_YesHot) || (viewType == .HomeCommunity_List_NoHot) {
            if let NOboardItem = mainCommunity_BoardItem {
                authorImage = NOboardItem.userPhoto
                boardName = NOboardItem.code
                authorNickname = NOboardItem.userNick
                boardDate = NOboardItem.createDate
                title = NOboardItem.title
                commentCount = NOboardItem.replyCnt
                isBlockedBoard = NOboardItem.pieceBlockYn
            }
        }
        else if viewType == .MainCommunityMyBoard {
            if let NOboardItem = communityBoardItem {
                authorImage = NOboardItem.author_profile
                boardName = NOboardItem.board_name
                authorNickname = NOboardItem.author_nickname
                boardDate = NOboardItem.date
                title = NOboardItem.title
                imageArr = NOboardItem.post_thumbnail
                video = NOboardItem.post_video
                commentCount = NOboardItem.story_count
            }
        }
        else if viewType == .MainCommunityMyComment {
            if let NOboardItem = communityBoardItem {
                authorImage = NOboardItem.author_profile
                boardName = NOboardItem.board_name
                authorNickname = NOboardItem.author_nickname
                boardDate = NOboardItem.date
                title = NOboardItem.title
                imageArr = NOboardItem.post_thumbnail
                video = NOboardItem.post_video
                commentCount = NOboardItem.story_count
                comment = NOboardItem.comment[2]
            }
        }
        else if viewType == .MainCommunityMyLocalBoard {
            if let NOboardItem = communityBoardItem {
                authorImage = NOboardItem.author_profile
                boardName = NOboardItem.board_name
                authorNickname = NOboardItem.author_nickname
                boardDate = NOboardItem.date
                title = NOboardItem.title
                imageArr = NOboardItem.post_thumbnail
                video = NOboardItem.post_video
                commentCount = NOboardItem.story_count
            }
        }
        else if viewType == .MainClub_MainPage_Top10 {
            if let NOboardItem = mainClub_MainPage_Top10 {
                authorImage = NOboardItem.author_profile
                boardName = NOboardItem.board_name
                authorNickname = NOboardItem.author_nickname
                boardDate = NOboardItem.date
                title = NOboardItem.title
                commentCount = NOboardItem.story_count
            }
        }
        else if viewType == .MainClub_ChallengePage {
            if let NOboardItem = mainClub_ChallengePage {
                authorImage = NOboardItem.author_profile
                boardName = NOboardItem.board_name
                authorNickname = NOboardItem.author_nickname
                boardDate = NOboardItem.date
                title = NOboardItem.title
                commentCount = NOboardItem.story_count
            }
        }
        else if viewType == .MainClub_My {
            if let NOboardItem = communityBoardItem {
                authorImage = NOboardItem.author_profile
                boardName = NOboardItem.board_name
                authorNickname = NOboardItem.author_nickname
                boardDate = NOboardItem.date
                title = NOboardItem.title
                imageArr = NOboardItem.post_thumbnail
                video = NOboardItem.post_video
                commentCount = NOboardItem.story_count
            }
        }
        else if viewType == .MyStorage_Comment {
            if let NOboardItem = communityBoardItem {
                authorImage = NOboardItem.author_profile
                boardName = NOboardItem.board_name
                authorNickname = NOboardItem.author_nickname
                boardDate = NOboardItem.date
                title = NOboardItem.title
                imageArr = NOboardItem.post_thumbnail
                video = NOboardItem.post_video
                commentCount = NOboardItem.story_count
            }
        }
        else if viewType == .HomeClub_TabHome {
            if let NOboardItem = homeClub_TabHomeModel_BoardList {
                authorImage = NOboardItem.author_profile
                boardName = NOboardItem.board_name
                authorNickname = NOboardItem.author_nickname
                boardDate = NOboardItem.date
                title = NOboardItem.title
                imageArr = NOboardItem.post_thumbnail
                video = NOboardItem.post_video
                bodyTxt = NOboardItem.contents
                imageArr = NOboardItem.post_thumbnail
                video = NOboardItem.post_video
                webLink = NOboardItem.web_link
                commentCount = NOboardItem.story_count
            }
        }
        else if viewType == .HomeClub_TabFreeboard {
            if let NOboardItem = homeClub_TabFreeboardItem {
                authorImage = NOboardItem.author_profile
                boardName = NOboardItem.board_name
                authorNickname = NOboardItem.author_nickname
                boardDate = NOboardItem.date
                title = NOboardItem.title
                bodyTxt = NOboardItem.contents
                imageArr = NOboardItem.post_thumbnail
                video = NOboardItem.post_video
                commentCount = NOboardItem.story_count
            }
        }
        else if viewType == .HomeClub_TabArchive_NoImageView {
            if let NOboardItem = homeClub_TabFreeboardItem {
                authorImage = NOboardItem.author_profile
                boardName = NOboardItem.board_name
                authorNickname = NOboardItem.author_nickname
                boardDate = NOboardItem.date
                title = NOboardItem.title
                imageArr = NOboardItem.post_thumbnail
                video = NOboardItem.post_video
                bodyTxt = NOboardItem.contents
                imageArr = NOboardItem.post_thumbnail
                video = NOboardItem.post_video
                commentCount = NOboardItem.story_count
            }
        }
        else if viewType == .MainFantooTV {
            if let NOboardItem = homeClub_TabHomeModel_BoardList {
                authorImage = NOboardItem.author_profile
                boardName = NOboardItem.board_name
                authorNickname = NOboardItem.author_nickname
                boardDate = NOboardItem.date
                title = NOboardItem.title
                imageArr = NOboardItem.post_thumbnail
                video = NOboardItem.post_video
                bodyTxt = NOboardItem.contents
                imageArr = NOboardItem.post_thumbnail
                video = NOboardItem.post_video
                webLink = NOboardItem.web_link
                commentCount = NOboardItem.story_count
            }
        }
        else if viewType == .MainHanryutimes {
            if let NOboardItem = homeClub_TabHomeModel_BoardList {
                authorImage = NOboardItem.author_profile
                boardName = NOboardItem.board_name
                authorNickname = NOboardItem.author_nickname
                boardDate = NOboardItem.date
                title = NOboardItem.title
                imageArr = NOboardItem.post_thumbnail
                video = NOboardItem.post_video
                bodyTxt = NOboardItem.contents
                imageArr = NOboardItem.post_thumbnail
                video = NOboardItem.post_video
                webLink = NOboardItem.web_link
                commentCount = NOboardItem.story_count
            }
        }
    }
    
    func setTitleImage() -> String {
        var result: String
        
        if viewType == .Community_Notice_Total {
            result = "posting_fix"
        }
        else {
            /**
             * 이미지, 영상, 태그 없으면 => 텍스트 아이콘
             * 이미지, 영상, 태그 있으면 => 파일 아이콘
             */
            if imageArr == nil &&
                video == nil &&
                webLink == nil {
                result = "posting_text" // 아이콘 이미지 이름
            }
            else if viewType == .MainClub_My {
                result = "posting_image"
            }
            else {
                result = "posting_file" // 아이콘 이미지 이름
            }
        }
        return result
    }
    
    func bodyClickNavigation() -> some View {
        NavigationLink("", isActive: $showDetail) {
            if viewType == .HomeClubType1 {
                if let NOboardItem = fantooTVHomeTabItem {
                    ClubDetailPage()
                }
            }
            else if viewType == .MainHome {
                if let NOboardItem = mainHomeItem {
                    ClubDetailPage()
                }
            }
            else if viewType == .MainPopular {
                if let NOboardItem = mainPopularItem {
                    CommunityDetailPage()
                }
            }
            else if (viewType == .MainCommunity_Hour) || (viewType == .MainCommunity_Week) || (viewType == .HomeCommunity_List_YesHot) || (viewType == .HomeCommunity_List_NoHot) {
                if let NOboardItem = mainCommunity_BoardItem {
                    CommunityDetailPage(viewType: viewType, selectedCode: boardName, selectedPostId: NOboardItem.postId)
                }
            }
            else if viewType == .HomeClub_TabHome {
                if let NOboardItem = homeClub_TabHomeModel_BoardList {
                    ClubDetailPage()
                }
            }
            else if viewType == .HomeClub_TabFreeboard {
                if let NOboardItem = homeClub_TabFreeboardItem {
                    CommunityDetailPage()
                }
            }
            else if viewType == .HomeClub_TabArchive_NoImageView {
                if let NOboardItem = homeClub_TabFreeboardItem {
                    CommunityDetailPage()
                }
            }
            else if viewType == .MyClub_Storage_Post {
                if let NOboardItem = clubStoragePostListData {
                    ClubDetailPage()
                }
            }
            else if viewType == .MyClub_Storage_Comment {
                if let NOboardItem = clubStorageReplyListData {
                    ClubDetailPage()
                    //                    ReplyDetailPage(postId: NOboardItem.clubId, replyId: NOboardItem.replyId)
                }
            }
            else if viewType == .MyClub_Storage_Bookmark {
                if let NOboardItem = clubStorageBookmarkListData {
                    ClubDetailPage()
                }
            }
            else if viewType == .MyCommunity_Storage_Post {
                if let NOboardItem = communityStoragePostListData {
                    CommunityDetailPage(selectedCode: NOboardItem.code, selectedPostId: NOboardItem.postId)
                    
                }
            }
            else if viewType == .MyCommunity_Storage_Comment {
                if let NOboardItem = communityStorageReplyListData, let NOPostId = NOboardItem.comPostId, let NOReplyId = NOboardItem.replyId {
                    ReplyDetailPage(postId: NOPostId, replyId: NOReplyId)
                }
            }
            else if viewType == .MyCommunity_Storage_BookMark {
                if let NOboardItem = communityStorageBookmarkListData {
                    CommunityDetailPage(selectedCode: NOboardItem.code, selectedPostId: NOboardItem.postId)
                }
            }
            else if viewType == .Community_Notice_Total {
                if let NOboardItem = community_Notice_List {
                    CommunityNoticeDetailPage(noticePostId: NOboardItem.postId)
                }
            }
            
        }.hidden()
    }
}
