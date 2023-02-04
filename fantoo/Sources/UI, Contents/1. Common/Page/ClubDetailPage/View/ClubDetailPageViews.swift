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

struct ClubDetailHeaderView: View {
    var authorProfile: String
    var authorNickname: String
    var boardDate: String
    var boardItemName: String
    @Binding var isClickTransBtn: Bool
    @Binding var isTransComplate: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                HStack(alignment: .center, spacing:0) {
                    WebImage(url: URL(string: authorProfile.imageOriginalUrl))
                        .placeholder(content: {
                            Image("profile_club_character")
                                .resizable()
                        })
                        .resizable()
                        .frame(width: 32, height: 32)
                        .cornerRadius(8)

                    VStack(alignment: .leading, spacing:0) {
                        Text(authorNickname)
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.gray900)

                        Text("".changeDateFormat_Custom(strDate: boardDate))
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.gray400)
                    }
                    .padding(.leading, 10)
                    Spacer()
                }
                Spacer()

                Image("icon_outline_translate1")
                    .renderingMode(.template)
                    .foregroundColor(isTransComplate ? Color.stateActivePrimaryDefault : Color.stateActiveGray700)
                    .onTapGesture {
                        isClickTransBtn.toggle()
                    }
            }
            
            HStack(spacing: 0) {
                Text(boardItemName)
                    .font(.caption11218Regular)
                    .foregroundColor(.primary600)
                
                Image("icon_outline_go")
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(.primary600)
                    .frame(width: 12, height: 12)
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 10)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.stateEnablePrimary100))
            .padding(.top, 16)
        }
    }
}

struct ClubDetailBodyView: View {
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
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                Text(isTransComplate ? boardContent_trans : boardContent)
                    .font(Font.body21420Regular)
                    .foregroundColor(Color.gray600)
            }
            Spacer()
        }
    }
}

struct ClubDetailImagesView: View {
    var clubDetailAttachList: [ClubCommonModel_AttachList]?

    var body: some View {
        if let NOattachList = clubDetailAttachList {
            ForEach(Array(NOattachList.enumerated()), id: \.offset) { index, element in
                // 이미지:0 / 동영상:1
                if element.attachType == 0 {
                    WebImage(url: URL(string: element.attach.imageOriginalUrl ))
                        .placeholder(content: {
                            Image("profile_club_character")
                                .resizable()
                        })
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 10)
                }
            }
        }
    }
}

struct ClubDetailVideoView: View {
    private let boardVideoUrl: String
    @State var player: AVPlayer

    init(boardVideoUrl: String) {
        self.boardVideoUrl = boardVideoUrl
        self.player = AVPlayer(url: URL(string: boardVideoUrl.videoOriginUrl)!)
    }

    var body: some View {
        PlayerViewController(player: $player)
        //            .onAppear() {
        //                self.player.play()
        //            }
            .edgesIgnoringSafeArea(.all)
            .frame(height: 268)
        //            .overlay {
        //                Text("videoplayer overlay test FullScreen시 overlay 안 보임 :)")
        //                    .foregroundColor(Color.blue)
        //            }
    }
}

struct ClubDetailTagsView: View {
    var boardTags: [String]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(boardTags, id: \.self) { item in
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 30)
                            .style(
                                withStroke: Color.gray100,
                                lineWidth: 1,
                                fill: Color.gray50
                            )
                            .padding(.vertical, 1)
                            .padding(.horizontal, 4)

                        Text("#\(item)")
                            .font(Font.body21420Regular)
                            .foregroundColor(Color.gray850)
                            .fixedSize()
                            .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                    }
                    .fixedSize()
                }
            }
            .padding(EdgeInsets(
                top: 20,
                leading: 16,
                bottom: 0,
                trailing: 16
            ))
        }
    }
}

struct ClubDetailCommentListRowView: View {
    let index: Int
    let item: ClubDetailReplyModel_ReplyList

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                
                WebImage(url: URL(string: item.profileImg.imageOriginalUrl))
                    .placeholder(content: {
                        Image("profile_club_character")
                            .resizable()
                    })
                    .resizable()
                    .frame(width: 22, height: 22)
                    .cornerRadius(8)
                    .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 10))
                
                VStack(alignment: .leading, spacing: 0) {
                    /**
                     * Header
                     */
                    HStack(alignment: .center, spacing: 0) {
                        if let NOnickname = item.nickname {
                            Text(NOnickname)
                                .font(Font.caption11218Regular)
                                .foregroundColor(Color.gray900)
                            Text(" • ")
                                .font(.system(size: 20))
                                .foregroundColor(Color.gray400)
                        }
                        if let NOdate = item.createDate {
                            Text("".changeDateFormat_Custom(strDate: NOdate))
                                .font(Font.caption11218Regular)
                                .foregroundColor(Color.gray400)
                        }

                        Spacer()

                        Image("icon_outline_more")
                            .frame(width: 24, height: 24)
                    }
                    /**
                     * Body
                     */
                    VStack(alignment: .leading, spacing: 0) {
                        if let NOcontent = item.content {
                            Text(NOcontent)
                                .font(Font.body21420Regular)
                                .foregroundColor(Color.gray870)
                            
                            Text("b_do_translate".localized)
                                .font(Font.caption11218Regular)
                                .foregroundColor(Color.gray500)
                                .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                        }
                        
                        if let NOattachList = item.attachList {
                            if !NOattachList.isEmpty {
                                ForEach(NOattachList, id: \.self) { item in
                                    
                                    // 이미지인 경우만 보여줌
                                    // 0:이미지, 1:동영상
                                    if item.attachType == 0 {
                                        WebImage(url: URL(string: item.attach.imageOriginalUrl))
                                            .placeholder(content: {
                                                Image("profile_club_character")
                                                    .resizable()
                                            })
                                            .resizable()
                                            .frame(width: 163, height: 154)
                                            .scaledToFit()
                                            .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                                    }
                                }
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                    /**
                     * Footer
                     */
                    HStack(spacing: 0) {
                        HStack (spacing: 5) {
                            Button(action: {
                                print("좋아요 버튼 클릭")
                            }) {
                                Image("icon_fill_like")
                                    .renderingMode(.template)
                                    .resizable()
                                    .foregroundColor((self.getClubLikeInfo(index: index, type: BoardLikeInfoType.LikeBtnColor) as! Color))
                                    .frame(width: 20, height: 20)
                            }
                            /**
                             * PlainButtonStyle() 추가해주지 않으면 List에서 클릭한 Item의 버튼이 아니라 Item 전체가 깜빡이는 문제가 있음
                             */
                            .buttonStyle(PlainButtonStyle())

                            Text(String(self.getClubLikeInfo(index: index, type: BoardLikeInfoType.LikeCount) as! Int))
                                .font(Font.caption11218Regular)
                                .foregroundColor((self.getClubLikeInfo(index: index, type: BoardLikeInfoType.LikeTxtColor) as! Color))

                            Button(action: {
                                print("싫어요 버튼 클릭")
                            }) {
                                Image("icon_fill_dislike")
                                    .renderingMode(.template)
                                    .resizable()
                                    .foregroundColor((self.getClubLikeInfo(index: index, type: BoardLikeInfoType.DisLikeBtnColor) as! Color))
                                    .frame(width: 20, height: 20)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }

                        Spacer()

                        Button(action: {
                            print("대댓글 버튼 클릭")
                        }) {
                            HStack(spacing: 5) {
                                if let NOreplyCount = item.replyCount {
                                    Image("icon_fill_comment")
                                        .renderingMode(.template)
                                        .foregroundColor(Color.gray200)
                                        .frame(width: 20, height: 20)

                                    Text(String(NOreplyCount))
                                        .font(Font.caption11218Regular)
                                        .foregroundColor(Color.gray800)
                                }
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
//            ClubDetailCommentList_RecommentView(itemData: itemData.recomment)
//                .background(Color.gray50)
        }
        .frame(width: UIScreen.screenWidth)
    }
    
    
    /**
     * 클럽 게시글 좋아요/싫어요 클릭 후, 결과 값 가져오기
     */
    func getClubLikeInfo(index: Int, type: BoardLikeInfoType) -> Any {
        if type == BoardLikeInfoType.LikeCount {
            if let NOlike = item.like {
                let likeCount: Int = NOlike.likeCount - NOlike.dislikeCount
                return likeCount
            } else { return 0 }
        }
        else if type == BoardLikeInfoType.LikeBtnColor {
            if let NOlike = item.like {
                let likeBtnColor: Color = NOlike.likeYn ? Color.stateActivePrimaryDefault : Color.stateDisabledGray200
                return likeBtnColor
            } else { return Color.stateDisabledGray200 }
        }
        else if type == BoardLikeInfoType.DisLikeBtnColor {
            if let NOlike = item.like {
                let dislikeBtnColor: Color = NOlike.likeYn ? Color.stateDisabledGray200 : Color.stateActiveGray700
                return dislikeBtnColor
            } else { return Color.stateDisabledGray200 }
        }
        else if type == BoardLikeInfoType.LikeTxtColor {
            if let NOlike = item.like {
                let likeTxtColor: Color = NOlike.likeYn ? Color.stateActivePrimaryDefault : Color.stateActiveGray700
                return likeTxtColor
            } else { return Color.stateActiveGray700 }
        }
        else {
            return ""
        }
    }
}
struct ClubDetailCommentList_RecommentView: View {
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
                        ClubDetailRecommentRow(item: itemData[i])
                            .padding(EdgeInsets(top: 16, leading: sizeInfo.baseLeading, bottom: 16, trailing: 20))
                        Divider()
                    }
                }

            }

            if showRecommentView {
                ForEach(itemData, id: \.self) { item in
                    ClubDetailRecommentRow(item: item)
                        .padding(EdgeInsets(top: 16, leading: sizeInfo.baseLeading, bottom: 16, trailing: 20))
                    Divider()

                }
            }
        }
    }
}
struct ClubDetailRecommentRow: View {
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
                            print("싫어요 버튼 클릭")
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

struct ClubDetailCommentInputView: View {
    @Binding var text: String
    @Binding var isKeyboardFocused: Bool
    @Binding var isUnqualifiedImageFormats: Bool
    @Binding var isUnqualifiedImageSize: Bool

    //@State private var commitDescr: String = ""

    // Image Picker
    //@State private var image = UIImage()
    @State private var image = UIImage()
    @State private var showSheet = false


    init(text: Binding<String>, isKeyboardFocused: Binding<Bool>, isUnqualifiedImageFormats: Binding<Bool>, isUnqualifiedImageSize: Binding<Bool>) {
        self._text = text
        self._isKeyboardFocused = isKeyboardFocused
        self._isUnqualifiedImageFormats = isUnqualifiedImageFormats
        self._isUnqualifiedImageSize = isUnqualifiedImageSize
    }

    var body: some View {
        VStack(spacing: 0) {
            //            let _ = print("이미지 피커 테스트")
            //            let _ = print("image : \(self.image)" as String)
            //            let _ = print("image' size : \(self.image.size.width)" as String)

            /**
             * 그림자 영역
             * Image Picker 배경색과 맞추기 위해 gray300 으로 적용했음
             */
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray300)
                .shadow(color: Color.gray850, radius: 6, x: 0, y: -3)

            /**
             * Image Picker 영역
             */
            if image.size.width > 0 {
                VStack(spacing: 0) {
                    ZStack {

                        HStack(spacing: 0) {
                            Spacer()
                            Image(uiImage: self.image)
                                .resizable()
                                .cornerRadius(10)
                                .frame(width: 52, height: 52)
                                .padding(.vertical, 8)
                                .aspectRatio(contentMode: .fill)

                            Spacer()
                        }

                        HStack(spacing: 0) {
                            Spacer()

                            Button(action: {
                                // 이미지 초기화 (self.image.size.width = 0.0)
                                self.image = UIImage()
                            }) {
                                Image("icon_outline_cancel")
                                    .renderingMode(.template)
                                    .foregroundColor(Color.gray25)
                                    .frame(width: 16, height: 16)
                            }
                        }
                        .frame(width: UIScreen.screenWidth)
                        .padding(.trailing, 20)
                    }
                    .background(Color.gray900.opacity(0.4))
                }
            }

            /**
             * 댓글 작성 영역
             */
            HStack(alignment: .bottom, spacing: 0) {
                Button(action: {
                    showSheet = true
                }) {
                    Image("icon_outline_picture")
                        .renderingMode(.template)
                        .foregroundColor(Color.gray400)
                        .frame(width: 22, height: 22)
                }
                .frame(width: UIScreen.screenWidth * 0.1)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
                /**
                 * PlainButtonStyle() 추가해주지 않으면 List에서 클릭한 Item의 버튼이 아니라 Item 전체가 깜빡이는 문제가 있음
                 */
                .buttonStyle(PlainButtonStyle())

                ZStack (alignment: .center) {
                    RoundedRectangle(cornerRadius: 30)
                        .style(
                            withStroke: Color.gray200,
                            lineWidth: 1,
                            fill: Color.gray25
                        )
                        .padding(.vertical, 1)
                        .padding(.horizontal, 3)

                    //TextEditorView(content: $commitDescr)
                    ReplyTextEditorView(content: $text, isKeyboardFocused: $isKeyboardFocused, startHeight: 36)
                    //.fixedSize()
                    //.frame(width: UIScreen.screenWidth-50)
                        .padding(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                }
                /**
                 * [by komhongpil]
                 * frame(width: UIScreen.screenWidth * 0.8) 이유 :
                 * TextEditorView() 와 RoundedRectangle() 의 가로-세로 크기를 맞추기 위해 fixedSize() 를 적용했기 때문에
                 * TextEditorView()의 가로 크기를 처음부터 아래와 같이 맞춰줘야 됨.
                 */
                .frame(width: UIScreen.screenWidth * 0.8)
                .fixedSize()

                Button(action: {
                    print("댓글 버튼 클릭")
                }) {
                    Image("icon_outline_send")
                        .renderingMode(.template)
                        .foregroundColor(self.text.count>0 ? Color.primary300 : Color.gray200)
                        .frame(width: 22, height: 22)
                }
                .frame(width: UIScreen.screenWidth * 0.1)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
                .buttonStyle(PlainButtonStyle())
            }
            .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
            .background(Color.gray25)
        }
        //.padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))

        .sheet(isPresented: $showSheet) {
            // Pick an image from the photo library:
//            ImagePicker(
//                sourceType: .photoLibrary,
//                selectedImage: self.$image,
//                isUnqualifiedImageFormats: self.$isUnqualifiedImageFormats,
//                isUnqualifiedImageSize: self.$isUnqualifiedImageSize,
//                imageCheck: { isUnqualifiedImageFormats, isUnqualifiedImageSize in
//                    print("in callback!!!")
//                    print("isUnqualifiedImageFormats : \(isUnqualifiedImageFormats)" as String)
//                    print("isUnqualifiedImageSize : \(isUnqualifiedImageSize)" as String)
//
//                    /**
//                     * 이미지 Formats과 Size의 업로드 금지 조건이 둘 다 만족하는 경우,
//                     * 팝업을 두 개 띄우면 어색하니까, Formats 팝업만 띄우도록 한다.
//                     * 일단, 임시로 내가 결정했는데, 기획쪽으로 물어보고 수정하자.
//                     */
//                    if isUnqualifiedImageFormats && isUnqualifiedImageSize {
//
//                        self.isUnqualifiedImageFormats = isUnqualifiedImageFormats
//                        self.isUnqualifiedImageSize = false
//                    }
//                    else {
//                        self.isUnqualifiedImageFormats = isUnqualifiedImageFormats
//                        self.isUnqualifiedImageSize = isUnqualifiedImageSize
//                    }
//                }
//            )

            //  If you wish to take a photo from camera instead:
            // ImagePicker(sourceType: .camera, selectedImage: self.$image)
        }
    }
}
