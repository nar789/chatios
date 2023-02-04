//
//  ReplyRowView.swift
//  fantoo
//
//  Created by kimhongpil on 2022/10/13.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

enum CommunityReplyType: Int {
    case CommunityDetail
    case CommunityDetailChild
    case CommunityReplyDetail
}

enum CommunityReplyButtonType: Int {
    case More
    case Like
    case Dislike
    case Comment
}

struct CommunityReplyRowView {
    
    /**
     * 언어팩 등록할 것
     */
    private let translatingTitle = "b_do_translate".localized
    
    let viewType: CommunityReplyType
    var replyData: CommonReplyModel?
    var replyDetailData: CommonReplyModel?
    var onPress: ((CommunityReplyButtonType) -> Void)? // BoardRowView를 호출하는 부분 전부 다 수정되면 옵셔널 제거할 것!
    
    @State var showDetail: Bool = false
    @State var replyId: Int = 0
    @State var parentReplyId: Int = 0
    @State var comPostId: Int = 0
    @State var activeStatus: Int = 0
    @State var depth: Int = 0
    @State var likeCnt: Int = 0
    @State var dislikeCnt: Int = 0
    @State var replyCnt: Int = 0
    @State var integUid: String = ""
    @State var content: String = ""
    @State var langCode: String = ""
    @State var userNick: String = ""
    @State var userPhoto: String?
    @State var createDate: String = ""
    @State var anonymYn: Bool = false
    @State var likeYn: Bool = false
    @State var dislikeYn: Bool = false
    @State var userBlockYn: Bool = false
    @State var pieceBlockYn: Bool = false
    @State var attachList = [CommonReplyModel_AttachList]()
    @State var childReplyList: [CommonReplyModel]?
    @State var openGraphList = [CommonReplyModel_OpenGraphList]()
    
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

extension CommunityReplyRowView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                /**
                 * 원래 이미지 형식이 "userPhoto": "29a2c0b0-5777-4bb1-f522-3b84739f2700" 이렇게 와야 하는데,
                 * 댓글 이미지는 "userPhoto": "uploads/profile-1625559249059.jpg" 이렇게 오고 있다. 추후에 위와 같이 변경될 것이라고 함. 그때 수정할 것!
                 *
                 */
                WebImage(url: URL(string: "https://wfd.hcmr.gr/wp-content/uploads/2019/03/default-user-profile-image-png-2.png"))
                    .resizable()
                    .frame(width: 22, height: 22)
                    .cornerRadius(8)
                    .padding(.top, 3)
                
                VStack(alignment: .leading, spacing: 0) {
                    /**
                     * Header
                     */
                    if viewType == .CommunityDetail {
                        header_type01
                    }
                    else if viewType == .CommunityDetailChild {
                        header_type01
                    }
                    else if viewType == .CommunityReplyDetail {
                        header_type01
                    }
                    
                    /**
                     * Body
                     */
                    if viewType == .CommunityDetail {
                        body_type01
                    }
                    else if viewType == .CommunityDetailChild {
                        body_type01
                    }
                    else if viewType == .CommunityReplyDetail {
                        body_type01
                    }
                    
                    /**
                     * Footer
                     */
                    if viewType == .CommunityDetail {
                        footer_type01
                    }
                    else if viewType == .CommunityDetailChild {
                        footer_type01
                    }
                    else if viewType == .CommunityReplyDetail {
                        footer_type01
                    }
                }
                // 배경색상을 지정해줘야, 빈 공간을 눌렀을 때 onTapGesture 가 호출됨
                // 대댓글에는 .background(Color.gray50) 를 해줬기 때문에, 아래 clear 로 설정한 것
                .background(viewType == .CommunityDetail ? Color.gray25 : Color.clear)
                .background(
                    bodyClickNavigation()
                )
                .padding(.leading, 10)
                
                
            }
            .padding(.vertical, 16)
            .padding(.horizontal, sizeInfo.Hpadding)
            
            /**
             * 대댓글
             */
            if viewType == .CommunityDetail {
                CommunityDetailReplyListView_ChildReplyView(totalReplyCnt: self.replyCnt, childReplyList: self.childReplyList)
                    .background(Color.gray50)
            }
        }
        .onAppear {
            self.setData()
        }
        .onTapGesture {
            // View 탭시, Keyboard dismiss 하기
            UIApplication.shared.endEditing()
            
            showDetail = true
        }
    }
    
    /**
     * 이미지 + 닉네임 + 날짜 + 더보기
     */
    var header_type01: some View {
        HStack(spacing: 0) {
            Text(self.userNick)
                .font(.caption11218Regular)
                .foregroundColor(.gray900)
            Text(" • ")
                .font(.system(size: 20))
                .foregroundColor(.gray400)
            Text("".changeDateFormat_Custom(strDate: self.createDate))
                .font(.caption11218Regular)
                .foregroundColor(.gray400)
            
            Spacer()
            
            /**
             * childReplyList 값이 nil 이 아니면, '댓글'인 경우 이다.
             * 댓글은 더보기 있고,
             * 대댓글은 더보기 없음
             */
            if let _ = childReplyList {
                Image("icon_outline_more")
                    .frame(width: 24, height: 24)
            } else {
                EmptyView()
            }
            
            if viewType == .CommunityReplyDetail {
                Image("icon_outline_more")
                    .frame(width: 24, height: 24)
            }
            
        }
    }
    
    /**
     * 텍스트
     */
    var body_type01: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 작성자가 삭제한 댓글은 글자만 보여줌
            if self.activeStatus == 2 {
                Text(self.content)
                    .font(.body21420Regular)
                    .foregroundColor(.gray400)
                
                Text(translatingTitle)
                    .font(.caption11218Regular)
                    .foregroundColor(.gray500)
                    .padding(.top, 12)
            } else {
                Text(self.content)
                    .font(.body21420Regular)
                    .foregroundColor(.gray870)
                
                Text(translatingTitle)
                    .font(.caption11218Regular)
                    .foregroundColor(.gray500)
                    .padding(.top, 12)
                
                /**
                 * 댓글 이미지
                 */
                if self.attachList.count > 0 {
                    if self.attachList[0].attachType == "image" {
                        let imgName: String = DefineUrl.ApiImageDomain + self.attachList[0].id + "/thumbnail"
                        
                        WebImage(url: URL(string: imgName))
                            .resizable()
                            .frame(width: 163, height: 154)
                            .scaledToFit()
                            .padding(.top, 20)
                    }
                }
                /**
                 * 댓글 OG태그(openGraphList)
                 * 규칙 !
                 * 1. 이미지(attachList)와 OG태그(openGraphList)가 둘 다 있는 경우에는,
                 *   서버에서 이미지(attachList)만 내려준다.
                 * 2. 댓글 입력창에서 OG태그 입력 방법은,
                 *   텍스트(content)에서 https:// 로 시작하는 글자만 있으면,
                 *   서버에서 알아서 만드어 줌.
                 */
                if self.openGraphList.count > 0 {
                    body_OGTagView
                        .padding(.top, 20)
                }
                
            }
        }
        .padding(.top, 8)
    }
    
    /**
     * 좋아요 + 댓글
     */
    var footer_type01: some View {
        HStack(spacing: 0) {
            Button(action: {
                print("좋아요 버튼 클릭 !")
            }, label: {
                Image("icon_fill_like")
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(.gray200)
                    .frame(width: 16, height: 16)
            })
            .buttonStyle(PlainButtonStyle())
            
            Text(String(self.likeCnt))
                .font(.caption11218Regular)
                .foregroundColor(.gray800)
                .padding(.leading, 4)
            
            Button(action: {
                print("싫어요 버튼 클릭 !")
            }, label: {
                Image("icon_fill_dislike")
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(.gray200)
                    .frame(width: 16, height: 16)
            })
            .buttonStyle(PlainButtonStyle())
            .padding(.leading, 4)
            
            Spacer()
            
            /**
             * childReplyList 값이 nil 이 아니면, '댓글'인 경우 이다.
             * 댓글은 댓글수 있고,
             * 대댓글은 댓글수 없음
             */
            if let _ = childReplyList {
                Group {
                    Button(action: {
                        print("댓글 버튼 클릭 !")
                    }, label: {
                        Image("icon_fill_comment")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(.gray200)
                            .frame(width: 16, height: 16)
                    })
                    .buttonStyle(PlainButtonStyle())
                    
                    Text(String(self.replyCnt))
                        .font(.caption11218Regular)
                        .foregroundColor(.gray800)
                        .padding(.leading, 4)
                }
            } else {
                EmptyView()
            }
            
            if viewType == .CommunityReplyDetail {
                Group {
                    Button(action: {
                        print("댓글 버튼 클릭 !")
                    }, label: {
                        Image("icon_fill_comment")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(.gray200)
                            .frame(width: 16, height: 16)
                    })
                    .buttonStyle(PlainButtonStyle())
                    
                    Text(String(self.replyCnt))
                        .font(.caption11218Regular)
                        .foregroundColor(.gray800)
                        .padding(.leading, 4)
                }
            }
        }
        .padding(.top, 19)
    }
    
    /**
     * OG태그
     */
    var body_OGTagView: some View {
        HStack(spacing: 0) {
            WebImage(url: URL(string: openGraphList[0].image))
                .resizable()
                .frame(width: 64, height: 64)
                .cornerRadius(6)
                .padding(.vertical, 9)
                .padding(.horizontal, 10)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(openGraphList[0].title)
                    .font(.caption11218Regular)
                    .foregroundColor(.gray800)
                    .lineLimit(2)
                
                Text("출처: \(openGraphList[0].url)")
                    .font(.caption11218Regular)
                    .foregroundColor(.gray400)
                    .lineLimit(1)
                    .padding(.top, 6)
            }
            .padding(EdgeInsets(top: 12, leading: 0, bottom: 14, trailing: 10))
        }
        .background(
            RoundedRectangle(cornerRadius: 8.0)
                .style(
                    withStroke: Color.gray100,
                    lineWidth: 1,
                    fill: Color.gray25
                )
        )
        
    }
}

/**
 * View 를 채택하고 있는 struct에서 setTitleImage() 함수에서와 같은 조건문을 사용하면  "returnType '()' cannot conform to 'View'" 에러가 발생한다.
 * 그래서 아래와 같이 extension을 사용해 View 를 채택하지 않도록 해서 조건문을 적용하면 됨 !!!!!!
 */
extension CommunityReplyRowView {
    
    func setData() {
        if viewType == .CommunityDetail || viewType == .CommunityDetailChild {
            if let NOboardItem = replyData {
                replyId = NOboardItem.replyId
                parentReplyId = NOboardItem.parentReplyId
                comPostId = NOboardItem.comPostId
                activeStatus = NOboardItem.activeStatus
                depth = NOboardItem.depth
                likeCnt = NOboardItem.likeCnt
                dislikeCnt = NOboardItem.dislikeCnt
                replyCnt = NOboardItem.replyCnt
                integUid = NOboardItem.integUid
                content = NOboardItem.content
                langCode = NOboardItem.langCode
                userNick = NOboardItem.userNick
                userPhoto = NOboardItem.userPhoto
                createDate = NOboardItem.createDate
                anonymYn = NOboardItem.anonymYn
                likeYn = NOboardItem.likeYn
                dislikeYn = NOboardItem.dislikeYn
                userBlockYn = NOboardItem.userBlockYn
                pieceBlockYn = NOboardItem.pieceBlockYn
                attachList = NOboardItem.attachList
//                if let NOchildReplyList = NOboardItem.childReplyList {
//                    childReplyList = NOchildReplyList
//                }
                childReplyList = NOboardItem.childReplyList
                openGraphList = NOboardItem.openGraphList
            }
        }
        else if viewType == .CommunityReplyDetail {
            if let NOboardItem = replyDetailData {
                replyId = NOboardItem.replyId
                parentReplyId = NOboardItem.parentReplyId
                comPostId = NOboardItem.comPostId
                activeStatus = NOboardItem.activeStatus
                depth = NOboardItem.depth
                likeCnt = NOboardItem.likeCnt
                dislikeCnt = NOboardItem.dislikeCnt
                replyCnt = NOboardItem.replyCnt
                integUid = NOboardItem.integUid
                content = NOboardItem.content
                langCode = NOboardItem.langCode
                userNick = NOboardItem.userNick
                userPhoto = NOboardItem.userPhoto
                createDate = NOboardItem.createDate
                anonymYn = NOboardItem.anonymYn
                likeYn = NOboardItem.likeYn
                dislikeYn = NOboardItem.dislikeYn
                userBlockYn = NOboardItem.userBlockYn
                pieceBlockYn = NOboardItem.pieceBlockYn
                attachList = NOboardItem.attachList
//                if let NOchildReplyList = NOboardItem.childReplyList {
//                    childReplyList = NOchildReplyList
//                }
                childReplyList = NOboardItem.childReplyList
                openGraphList = NOboardItem.openGraphList
            }
        }
    }
    
    func bodyClickNavigation() -> some View {
        NavigationLink("", isActive: $showDetail) {
            if viewType == .CommunityDetail {
                if let NOboardItem = replyData {
                    ReplyDetailPage(
                        viewType: .Community,
                        postId: NOboardItem.comPostId,
                        replyId: NOboardItem.replyId
                    )
                }
            }
        }.hidden()
    }
}
