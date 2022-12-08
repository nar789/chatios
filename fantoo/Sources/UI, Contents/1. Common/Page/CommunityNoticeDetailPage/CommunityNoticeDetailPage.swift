//
//  CommunityNoticeDetailPage.swift
//  fantoo
//
//  Created by kimhongpil on 2022/11/03.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SwiftUIX
import SDWebImageSwiftUI
import Introspect
import AVKit
import PopupView

struct CommunityNoticeDetailPage {
    @StateObject var viewModel = CommunityNoticeDetailViewModel()
    
    // 각 카테고리 Detail 인 경우 : noticeCode 값이 있음
    // 전체공지 Detail 인 경우 : noticeCode 값이 없음
    @State var noticeCode: String?
    @State var noticePostId: Int
    @State var isClickTransBtn: Bool = false
    @State var isClickShareBtn: Bool = false
    
    var popupItemArr = [
        CommunityNoticeDetailPage_Popup_Model(SEQ: 0, icon: "icon_outline_share", title: "공유하기")
    ]
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
    
    private let poppupHeight: CGFloat = 130.0
}

extension CommunityNoticeDetailPage: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                if let itemData = viewModel.communityNoticeDetail_Notice {
                    VStack(spacing: 0) {
                        
                        CommunityNoticeDetailHeaderView(
                            authorProfile: itemData.userPhoto,
                            authorNickname: itemData.userNick,
                            boardDate: itemData.createDate,
                            isClickTransBtn: $isClickTransBtn,
                            isTransComplate: $viewModel.isTransMode
                        )
                        .padding(EdgeInsets(top: 17, leading: 20, bottom: 0, trailing: 20))
                        
                        CommunityNoticeDetailBodyView(
                            boardTitle: itemData.title,
                            boardContent: itemData.content,
                            isTransComplate: $viewModel.isTransMode,
                            boardTitle_trans: $viewModel.title_afterTrans,
                            boardContent_trans: $viewModel.content_afterTrans
                        )
                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20))
                    }
                }
                
                if viewModel.communityNoticeDetail_AttachList.count > 0 {
                    ForEach(Array(viewModel.communityNoticeDetail_AttachList.enumerated()), id: \.offset) { index, element in
                        
                        VStack(spacing: 0) {
                            if element.attachType == "image" {
                                CommunityNoticeDetailImagesView(imageURL: element.id)
                            }
                            else if element.attachType == "video" {
                                if let _ = URL(string: element.id) {
                                    CommunityNoticeDetailVideoView(videoURL: element.id)
                                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                                }
                            }
                        }
                    }
                }
                
                HStack(spacing: 0) {
                    Spacer()
                    Image("icon_outline_share")
                        .onTapGesture {
                            isClickShareBtn = true
                        }
                }
                .padding(.horizontal, sizeInfo.Hpadding)
                .padding(.top, 20)
            }
        }
        .onAppear() {
            self.callRemoteData()
        }
        .onChange(of: isClickTransBtn) { newValue in
            if newValue {
                
                if let itemData = viewModel.communityNoticeDetail_Notice {
                    
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
        .navigationType(
            leftItems: [.Back],
            rightItems: [.More],
            leftItemsForegroundColor: .black,
            rightItemsForegroundColor: .black,
            title: "",
            onPress: { buttonType in
                if buttonType == .More {
                    isClickShareBtn = true
                }
            })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
        .showAlert(isPresented: $viewModel.isTransFail, type: .Default, title: "번역 알림", message: "번역에 실패했습니다.", detailMessage: "", buttons: ["확인"], onClick: { buttonIndex in
            if buttonIndex == 1 {
                //UserManager.shared.logout()
            }
        })
        .bottomSheet(isPresented: $isClickShareBtn, height: poppupHeight, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
            
            CommunityNoticeDetailPage_Popup(
                isShow: $isClickShareBtn,
                itemArr: popupItemArr,
                onClick: { selectedIndex in
                    if selectedIndex == 0 {
                        print("공유하기 눌렀음")
                    }
                }
            )
        })
    }
}

struct CommunityNoticeDetailHeaderView: View {
    var authorProfile: String
    var authorNickname: String
    var boardDate: String
    @Binding var isClickTransBtn: Bool
    @Binding var isTransComplate: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                HStack(alignment: .center, spacing:0) {
                    Group {
                        WebImage(url: URL(string: authorProfile.imageOriginalUrl))
                            .placeholder(content: {
                                Image("profile_club_character")
                                    .resizable()
                            })
                            .resizable()
                    }
                    .frame(width: 32, height: 32)
                    .cornerRadius(8)

                    VStack(alignment: .leading, spacing:0) {
                        Text(authorNickname)
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.gray900)

                        Text(boardDate)
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
        }
    }
}

struct CommunityNoticeDetailBodyView: View {
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

struct CommunityNoticeDetailImagesView: View {
    var imageURL: String

    var body: some View {
        Group {
            WebImage(url: URL(string: imageURL.imageOriginalUrl))
                .placeholder(content: {
                    Image("profile_club_character")
                        .resizable()
                        .frame(height: 375)
                })
                .resizable()
        }
        .scaledToFit()
        .padding(.top, 20)
    }
}

struct CommunityNoticeDetailVideoView: View {
    private let videoURL: String
    @State var player: AVPlayer
    
    init(videoURL: String) {
        self.videoURL = videoURL
        self.player = AVPlayer(url: URL(string: videoURL.videoOriginUrl)!)
    }

    var body: some View {
        PlayerViewController(player: $player)
//            .onAppear() {
//                self.player.play()
//            }
            .edgesIgnoringSafeArea(.all)
            .frame(height: 375)
//            .overlay {
//                Text("videoplayer overlay test FullScreen시 overlay 안 보임 :)")
//                    .foregroundColor(Color.blue)
//            }
    }
}

struct CommunityNoticeDetailPage_Popup: View {
    @Binding var isShow: Bool
    var itemArr = [CommunityNoticeDetailPage_Popup_Model]()
    let onClick: (Int) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(itemArr.enumerated()), id: \.offset) { index, element in
                
                HStack(spacing: 0) {
                    Image(element.icon)
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                    Text(element.title)
                        .font(.body11622Regular)
                        .foregroundColor(.gray870)
                        .padding(.leading, 16)
                    
                    Spacer()
                }
                .onTapGesture {
                    onClick(index)
                    isShow = false
                }
            }
            
            Spacer()
        }
        .padding(.top, 10)
        .padding(.horizontal, 20)
    }
}

struct CommunityNoticeDetailPage_Popup_Model: Hashable {
    var SEQ: Int
    var icon: String = ""
    var title: String = ""
}

extension CommunityNoticeDetailPage {
    func callRemoteData() {
        //self.viewModel.getClubDetail()
        
        self.viewModel.getCommunityNoticeDetail(type: .TotalNoticeDetail, code: nil, postId: noticePostId)
    }
    
}

//struct CommunityNoticeDetailPage_Previews: PreviewProvider {
//    static var previews: some View {
//        CommunityNoticeDetailPage()
//    }
//}
