//
//  ClubReplyRowView.swift
//  fantoo
//
//  Created by kimhongpil on 2023/01/15.
//  Copyright © 2023 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

enum ClubReplyType: Int {
    case ClubDetail
}

enum ClubReplyButtonType: Int {
    case More
    case Like
    case Dislike
    case Comment
}

struct ClubReplyRowView {
    let viewType: ClubReplyType
    var clubDetailReply: ClubDetailReplyModel_ReplyList?
    var onPress: ((ClubReplyButtonType) -> Void)
    
    // Push
    @State var showDetail: Bool = false
    // Model Data
    @State var blockType: Int?
    @State var deleteType: Int?
    @State var depth: Int?
    @State var level: Int?
    @State var memberId: Int?
    @State var parentReplyId: Int?
    @State var postId: Int?
    @State var replyCount: Int?
    @State var replyId: Int?
    @State var status: Int?
    @State var categoryCode: String?
    @State var categoryName1: String?
    @State var categoryName2: String?
    @State var clubId: String?
    @State var clubName: String?
    @State var content: String?
    @State var createDate: String?
    @State var integUid: String?
    @State var langCode: String?
    @State var nickname: String?
    @State var profileImg: String?
    @State var subject: String?
    @State var updateDate: String?
    @State var url: String?
    @State var attachList: [ClubCommonModel_AttachList]?
    @State var like: ClubCommonModel_Like?
    @State var openGraphDtoList: [ClubCommonModel_OpenGraphDtoList]?
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
}

extension ClubReplyRowView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack(alignment: .top, spacing: 0) {
                
                WebImage(url: URL(string: self.profileImg?.imageOriginalUrl ?? ""))
                    .placeholder(content: {
                        Image("profile_club_character")
                            .resizable()
                    })
                    .resizable()
                    .frame(width: 22, height: 22)
                    .cornerRadius(8)
                    .padding(.top, 3)
                
                VStack(alignment: .leading, spacing: 0) {
                    /**
                     * Header
                     */
                    if viewType == .ClubDetail {
                        header_type01
                    }
                    
                    /**
                     * Body
                     */
                    if viewType == .ClubDetail {
                        body_type01
                    }
                    
                    /**
                     * Footer
                     */
                    if viewType == .ClubDetail {
                        footer_type01
                    }
                }
                .background(
                    bodyClickNavigation()
                )
                .padding(.leading, 10)
                
            }
            .padding(.leading, ((replyId ?? 0) != (parentReplyId ?? 0)) ? 48 : 16) // 48 : 좌측 여백 치수 (좌측 여백 + 프로필 이미지 넓이 + 좌측 padding)
            .padding(.trailing, 16)
            .padding(.horizontal, sizeInfo.Hpadding)
            .padding(.vertical, 16)
            .background(((replyId ?? 0) != (parentReplyId ?? 0)) ? Color.gray50 : Color.gray25)
            
            
            /**
             * 대댓글 더보기 View
             */
            if viewType == .ClubDetail {
                childReplyMoreView
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
            if let NOnickname = self.nickname {
                Text(NOnickname)
                    .font(.caption11218Regular)
                    .foregroundColor(.gray900)
                Text(" • ")
                    .font(.system(size: 20))
                    .foregroundColor(.gray400)
            }
            if let NOcreateDate = self.createDate {
                Text("".changeDateFormat_Custom(strDate: NOcreateDate))
                    .font(.caption11218Regular)
                    .foregroundColor(.gray400)
            }
            
            Spacer()
            
            if viewType == .ClubDetail {
                if let NOreplyId = replyId,
                   let NOparentReplyId = parentReplyId {
                    if NOreplyId == NOparentReplyId {
                        Image("icon_outline_more")
                            .frame(width: 24, height: 24)
                    }
                } else {
                    EmptyView()
                }
            }
        }
    }
    
    /**
     * 텍스트
     */
    var body_type01: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let NOstatus = status {
                // 댓글 상태 (0:정상, 1:신고, 2:삭제)
                if NOstatus == 0 {
                    if let NOcontent = self.content {
                        Text(NOcontent)
                            .font(.body21420Regular)
                            .foregroundColor(.gray870)
                        
                        Text("b_do_translate".localized)
                            .font(.caption11218Regular)
                            .foregroundColor(.gray500)
                            .padding(.top, 12)
                    }
                }
                // 댓글 상태 (0:정상, 1:신고, 2:삭제)
                else if NOstatus == 1 {
                    Text("se_s_comment_hide_by_report".localized)
                        .font(.body21420Regular)
                        .foregroundColor(.gray300)
                }
                // 댓글 상태 (0:정상, 1:신고, 2:삭제)
                else if NOstatus == 2 {
                    Text("se_j_deleted_comment_by_writer".localized)
                        .font(.body21420Regular)
                        .foregroundColor(.gray300)
                }
            }
            
            
            if let NOattachList = self.attachList {
                /**
                 * 댓글 이미지
                 */
                if !NOattachList.isEmpty {
                    ForEach(NOattachList, id: \.self) { item in
                        // 0:이미지, 1:동영상
                        if item.attachType == 0 {
                            WebImage(url: URL(string: item.attach.imageOriginalUrl ))
                                .placeholder(content: {
                                    Image("comment_img_default")
                                        .resizable()
                                })
                                .resizable()
                                .scaledToFit()
                                .frame(height: 154)
                                .padding(.top, 20)
                        }
                    }
                }
            }
            
            /**
             * 댓글 OG태그(openGraphList)
             * 규칙 !
             * 1. 이미지(attachList)와 OG태그(openGraphList)가 둘 다 있는 경우에는,
             *   서버에서 이미지(attachList)만 내려준다.
             * 2. 댓글 입력창에서 OG태그 입력 방법은,
             *   텍스트(content)에서 https:// 로 시작하는 글자만 있으면,
             *   서버에서 알아서 만들어 줌.
             */
            if let _ = openGraphDtoList {
                body_OGTagView
            }
        }
        .padding(.top, 8)
    }
    
    /**
     * 좋아요 + 댓글
     */
    var footer_type01: some View {
        HStack(spacing: 5) {
            if viewType != .ClubDetail {
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

                Text(String(0))
                    .font(.caption11218Regular)
                    .foregroundColor(.gray800)

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
            }
            
            if let NOreplyId = replyId,
               let NOparentReplyId = parentReplyId {
                if NOreplyId == NOparentReplyId {
                    if let NOreplyCount = replyCount {
                        Button(action: {
                            print("댓글 버튼 클릭 !")
                        }, label: {
                            HStack(spacing: 5) {
                                Image("icon_fill_comment2")
                                    .renderingMode(.template)
                                    .resizable()
                                    .foregroundColor(.gray200)
                                    .frame(width: 16, height: 16)
                                
                                Text(String(NOreplyCount))
                                    .font(.caption11218Regular)
                                    .foregroundColor(.gray800)
                            }
                            .padding(.leading, viewType == .ClubDetail ? 0 : 24)
                        })
                        .buttonStyle(PlainButtonStyle())
                        //.padding(.top, 19)
                    }
                }
            }
            
            Spacer()
        }
        
    }
    
    /**
     * OG태그
     */
    var body_OGTagView: some View {
        HStack(spacing: 0) {
            if let NOopenGraphDtoList = openGraphDtoList {
                ForEach(Array(NOopenGraphDtoList.enumerated()), id: \.offset) { index, element in
                    
                    WebImage(url: URL(string: element.image ))
                        .placeholder(content: {
                            Image("profile_club_character")
                                .resizable()
                        })
                        .resizable()
                        .frame(width: 64, height: 64)
                        .cornerRadius(6)
                        .padding(.vertical, 9)
                        .padding(.horizontal, 10)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(element.title )
                            .font(.caption11218Regular)
                            .foregroundColor(.gray800)
                            .lineLimit(2)
                        
                        Text("c_source".localized + " \(element.url )")
                            .font(.caption11218Regular)
                            .foregroundColor(.gray400)
                            .lineLimit(1)
                            .padding(.top, 6)
                    }
                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 14, trailing: 10))
                    
                    Spacer()
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8.0)
                .style(
                    withStroke: Color.gray100,
                    lineWidth: 1,
                    fill: Color.gray25
                )
        )
        .padding(.top, 20)
    }
    
    
    var childReplyMoreView: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let NOreplyCount = replyCount {
                if NOreplyCount > 2 {
                    Divider()
                    
                    Text("+ " + String(format: "a_child_reply_more".localized, NOreplyCount-2))
                        .font(.caption11218Regular)
                        .foregroundColor(.gray900)
                        .padding(.leading, 20)
                        .padding(.vertical, 13)
                        .padding(.leading, 48) // 48 : 좌측 여백 치수 (좌측 여백 + 프로필 이미지 넓이 + 좌측 padding)
                    
                    Divider()
                }
            }
        }
    }
    
    
}

/**
 * View 를 채택하고 있는 struct에서 setTitleImage() 함수에서와 같은 조건문을 사용하면  "returnType '()' cannot conform to 'View'" 에러가 발생한다.
 * 그래서 아래와 같이 extension을 사용해 View 를 채택하지 않도록 해서 조건문을 적용하면 됨 !!!!!!
 */
extension ClubReplyRowView {
    
    func setData() {
        if viewType == .ClubDetail {
            if let NOboardItem = clubDetailReply {
                blockType = NOboardItem.blockType
                deleteType = NOboardItem.deleteType
                depth = NOboardItem.depth
                level = NOboardItem.level
                memberId = NOboardItem.memberId
                parentReplyId = NOboardItem.parentReplyId
                postId = NOboardItem.postId
                replyCount = NOboardItem.replyCount
                replyId = NOboardItem.replyId
                status = NOboardItem.status
                categoryCode = NOboardItem.categoryCode
                categoryName1 = NOboardItem.categoryName1
                categoryName2 = NOboardItem.categoryName2
                clubId = NOboardItem.clubId
                clubName = NOboardItem.clubName
                content = NOboardItem.content
                createDate = NOboardItem.createDate
                integUid = NOboardItem.integUid
                langCode = NOboardItem.langCode
                nickname = NOboardItem.nickname
                profileImg = NOboardItem.profileImg
                subject = NOboardItem.subject
                updateDate = NOboardItem.updateDate
                url = NOboardItem.url
                attachList = NOboardItem.attachList
                like = NOboardItem.like
                openGraphDtoList = NOboardItem.openGraphDtoList
            }
        }
    }
    
    func bodyClickNavigation() -> some View {
        NavigationLink("", isActive: $showDetail) {
            if viewType == .ClubDetail {
                if let NOboardItem = clubDetailReply {
                    if let NOpostId = NOboardItem.postId,
                       let NOreplyId = NOboardItem.replyId {
                        ReplyDetailPage(
                            viewType: .Club,
                            postId: NOpostId,
                            replyId: NOreplyId
                        )
                    }
                    
                }
            }
        }.hidden()
    }
}
