//
//  공통으로 뺄 것.swift
//  fantoo
//
//  Created by kimhongpil on 2022/09/04.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SwiftUIX
import SDWebImageSwiftUI
import Introspect
import AVKit
import PopupView

struct CommunityDetailHeaderView: View {
    var authorProfile: String
    var authorNickname: String
    var boardName: String
    var boardDate: String
    @Binding var isClickTransBtn: Bool
    @Binding var isTransComplate: Bool

    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0)  {
                WebImage(url: URL(string: authorProfile.imageOriginalUrl))
                    .resizable()
                    .frame(width: 28, height: 28)
                    .cornerRadius(8)

                VStack(alignment: .leading, spacing: 0) {
                    Text(boardName)
                        .font(Font.caption11218Regular)
                        .foregroundColor(Color.gray900)

                    HStack(spacing: 0) {
                        Text(authorNickname)
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.gray400)
                        Text(" • ")
                            .font(.system(size: 20))
                            .foregroundColor(Color.gray200)
                        Text("".changeDateFormat_Custom(strDate: boardDate))
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.gray400)
                    }
                }
                .padding(.leading, 10)
            }
            Spacer()

            Image("icon_outline_translate1")
                .renderingMode(.template)
                .foregroundColor(isTransComplate ? Color.stateActivePrimaryDefault : Color.stateActiveGray700)
                .onTapGesture {
                    isClickTransBtn.toggle()
                }
            
        }
    }
}

struct CommunityDetailBodyView: View {
    var boardTitle: String
    var boardContent: String
    @Binding var isTransComplate: Bool
    @Binding var boardTitle_trans: String
    @Binding var boardContent_trans: String

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text(isTransComplate ? boardTitle_trans : boardTitle)
                    .font(Font.title51622Medium)
                    .foregroundColor(Color.gray870)
                Text(isTransComplate ? boardContent_trans : boardContent)
                    .font(Font.body21420Regular)
                    .foregroundColor(Color.gray600)
                    .padding(.top, 10)
            }
            Spacer()
        }
    }
}

struct CommunityDetailFooterView: View {
    var likeCnt: Int
    var dislikeCnt: Int
    var replyCnt: Int
    var likeYn: Bool
    var dislikeYn: Bool
    var onPress: ((CommunityDetailPageFooterButtonType) -> Void)

    var body: some View {
        HStack (alignment: .center) {
            HStack (alignment: .center) {
                Button(action: {
                    onPress(CommunityDetailPageFooterButtonType.Like)
                }) {
                    Image("icon_fill_like")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(likeYn ? Color.stateActivePrimaryDefault : Color.stateDisabledGray200)
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(PlainButtonStyle())

                Text(String(likeCnt - dislikeCnt))
                    .font(.caption11218Regular)
                    .foregroundColor(likeYn ? Color.stateActivePrimaryDefault : Color.stateActiveGray700)

                Button(action: {
                    //print("싫어요 버튼 클릭")
                    onPress(CommunityDetailPageFooterButtonType.Dislike)
                }) {
                    Image("icon_fill_dislike")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(dislikeYn ? Color.stateActiveGray700 : Color.stateDisabledGray200)
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(PlainButtonStyle())
            }

            Button(action: {
                print("댓글 버튼 클릭")
                onPress(CommunityDetailPageFooterButtonType.Comment)
            }) {
                HStack (alignment: .center) {
                    Image("icon_fill_comment")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(Color.stateEnableGray200)
                        .frame(width: 20, height: 20)
                    Text(String(replyCnt))
                        .font(.caption11218Regular)
                        .foregroundColor(.gray800)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))

            Spacer()

            Button(action: {
                print("공유 버튼 클릭")
                onPress(CommunityDetailPageFooterButtonType.Share)
            }) {
                HStack (alignment: .center) {
                    Image("icon_outline_share")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

//struct CommunityDetailReplyListView: View {
//    /**
//     * 언어팩 등록할 것
//     */
//    private let translatingTitle = "번역하기"
//
//    var viewModel: CommunityDetailPageViewModel
//    @Binding var boardReply: [CommonReplyModel]
//
//    var body: some View {
//
//    }
//}
struct CommunityDetailReplyListView_ChildReplyView: View {
    /**
     * 언어팩 등록할 것
     */
    private let beforeReplyTitle1 = "이전 대댓글"
    private let beforeReplyTitle2 = "개 더보기"
    
    var totalReplyCnt: Int
    var childReplyList: [CommonReplyModel]?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let NOchildReplyList = childReplyList {
                if NOchildReplyList.count > 0 {
                    
                    if totalReplyCnt > 2 {
                        Divider()
                        let tmpTitle: String = "+ " + beforeReplyTitle1 + " \(String(totalReplyCnt - 2))" + beforeReplyTitle2
                        Text(tmpTitle)
                            .font(.caption11218Regular)
                            .foregroundColor(.gray900)
                            .padding(.leading, 20)
                            .padding(.vertical, 13)
                            .padding(.leading, 32) // 좌측 여백 치수 (프로필 이미지 넓이 + 우측 padding)
                    }
                    
                    Divider()
                    
                    ForEach(NOchildReplyList, id: \.self) { item in
                        CommunityReplyRowView(viewType: CommunityReplyType.CommunityDetailChild, replyData: item)
                            .padding(.leading, 32) // 좌측 여백 치수 (프로필 이미지 넓이 + 우측 padding)
                        
                        Divider()
                    }
                }
            }
        }
    }
}

struct CommunityDetailCommentListView: View {
    var boardComment: [Comment_Community]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(boardComment, id: \.self) { item in
                CommunityDetailCommentListRowView(itemData: item)
                Divider()
            }
        }
    }
}
struct CommunityDetailCommentListRowView: View {
    var itemData: Comment_Community

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {

                WebImage(url: URL(string: itemData.comment_profile))
                    .resizable()
                    .frame(width: 22, height: 22)
                    .cornerRadius(8)
                    .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 10))

                VStack(alignment: .leading, spacing: 0) {
                    /**
                     * Header
                     */
                    HStack(alignment: .center, spacing: 0) {
                        Text(itemData.comment_nickname)
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.gray900)
                        Text(" • ")
                            .font(.system(size: 20))
                            .foregroundColor(Color.gray400)
                        Text(itemData.createAt)
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.gray400)

                        Spacer()

                        Image("icon_outline_more")
                            .frame(width: 24, height: 24)
                    }
                    /**
                     * Body
                     */
                    VStack(alignment: .leading, spacing: 0) {
                        Text(itemData.content)
                            .font(Font.body21420Regular)
                            .foregroundColor(Color.gray870)

                        Text("번역하기")
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.gray500)
                            .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))

                        if itemData.image != "" {
                            WebImage(url: URL(string: itemData.image))
                                .resizable()
                                .frame(width: 163, height: 154)
                                .scaledToFit()
                                .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                    /**
                     * Footer
                     */
                    HStack(alignment: .center, spacing: 0) {
                        HStack (alignment: .center) {
                            Button(action: {
                                print("좋아요 버튼 클릭")
                            }) {
                                Image("icon_fill_like")
                                    .renderingMode(.template)
                                    .foregroundColor(Color.gray200)
                                    .frame(width: 20, height: 20)
                            }
                            /**
                             * PlainButtonStyle() 추가해주지 않으면 List에서 클릭한 Item의 버튼이 아니라 Item 전체가 깜빡이는 문제가 있음
                             */
                            .buttonStyle(PlainButtonStyle())

                            Text(String(itemData.comment_like_count))
                                .font(Font.caption11218Regular)
                                .foregroundColor(.gray800)

                            Button(action: {
                                //print("싫어요 버튼 클릭")
                            }) {
                                Image("icon_fill_dislike")
                                    .renderingMode(.template)
                                    .foregroundColor(Color.gray200)
                                    .frame(width: 20, height: 20)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }

                        Spacer()

                        Button(action: {
                            print("대댓글 버튼 클릭")
                        }) {
                            HStack(alignment: .center) {
                                Image("icon_fill_comment")
                                    .renderingMode(.template)
                                    .foregroundColor(Color.gray200)
                                    .frame(width: 20, height: 20)

                                Text(String(itemData.recomment.count))
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(Color.gray800)
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .padding(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
            /**
             * ReComment
             */
            CommunityDetailCommentList_RecommentView(itemData: itemData.recomment)
                .background(Color.gray50)
        }
        .frame(width: UIScreen.screenWidth)
    }
}
struct CommunityDetailCommentList_RecommentView: View {
    var itemData: [Recomment_Community]
    @State private var showRecommentView = false

    private struct sizeInfo {
        static let baseLeading: CGFloat = 50
    }

    var body: some View {
        VStack(spacing: 0) {
            Divider()

            if itemData.count>0 && !showRecommentView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("+ "+"이전 대댓글 : \(String(itemData.count-2))개 더보기")
                        .font(Font.caption11218Regular)
                        .foregroundColor(Color.gray900)
                        .padding(.leading, sizeInfo.baseLeading)
                        .padding(.vertical, 14)
                        .onTapGesture(perform: {
                            showRecommentView = true
                        })

                    Divider()

                    ForEach(0..<2, id: \.self) { i in
                        CommunityDetailRecommentRow(item: itemData[i])
                            .padding(EdgeInsets(top: 16, leading: sizeInfo.baseLeading, bottom: 16, trailing: 20))
                        Divider()
                    }
                }

            }

            if showRecommentView {
                ForEach(itemData, id: \.self) { item in
                    CommunityDetailRecommentRow(item: item)
                        .padding(EdgeInsets(top: 16, leading: sizeInfo.baseLeading, bottom: 16, trailing: 20))
                    Divider()

                }
            }
        }
    }
}
struct CommunityDetailRecommentRow: View {
    var item: Recomment_Community

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            WebImage(url: URL(string: item.comment_profile))
                .resizable()
                .frame(width: 22, height: 22)
                .cornerRadius(8)
                .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 10))

            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    Text(item.comment_nickname)
                        .font(Font.caption11218Regular)
                        .foregroundColor(Color.gray900)
                    Text(" • ")
                        .font(.system(size: 20))
                        .foregroundColor(Color.gray400)
                    Text(item.createAt)
                        .font(Font.caption11218Regular)
                        .foregroundColor(Color.gray400)

                    Spacer()
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text(item.content)
                        .font(Font.body21420Regular)
                        .foregroundColor(Color.gray870)

                    Text("번역하기")
                        .font(Font.caption11218Regular)
                        .foregroundColor(Color.gray500)
                        .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))

                    if item.image != "" {
                        WebImage(url: URL(string: item.image))
                            .resizable()
                            .frame(width: 163, height: 154)
                            .scaledToFit()
                            .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))

                HStack(alignment: .center, spacing: 0) {
                    HStack (alignment: .center) {
                        Button(action: {
                            print("좋아요 버튼 클릭")
                        }) {
                            Image("icon_fill_like")
                                .renderingMode(.template)
                                .foregroundColor(Color.gray200)
                                .frame(width: 20, height: 20)
                        }
                        /**
                         * PlainButtonStyle() 추가해주지 않으면 List에서 클릭한 Item의 버튼이 아니라 Item 전체가 깜빡이는 문제가 있음
                         */
                        .buttonStyle(PlainButtonStyle())

                        Text(String(item.comment_like_count))
                            .font(Font.caption11218Regular)
                            .foregroundColor(.gray800)

                        Button(action: {
                            //print("싫어요 버튼 클릭")
                        }) {
                            Image("icon_fill_dislike")
                                .renderingMode(.template)
                                .foregroundColor(Color.gray200)
                                .frame(width: 20, height: 20)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                    Spacer()
                }
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
            }

        }
    }
}

struct PlayerViewController: UIViewControllerRepresentable {
    @Binding var player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller =  AVPlayerViewController()
        //controller.modalPresentationStyle = .fullScreen
        controller.player = player
        //controller.videoGravity = .resizeAspectFill
        controller.showsPlaybackControls = true
        return controller
    }

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        //none
    }
}
