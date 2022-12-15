

import SwiftUI

struct TmpData : Hashable {
    var date = ""
    var showAvatar = false
    var type = 0
    var msg = ""
    var unread = 0
    var writedate = ""
    var showImage = false
}

struct ChatComposerPage: View {
    
    @State var message = ""
    @State var showMessage = false
    @FocusState var focus
    
    var tmp:[TmpData] = [
        TmpData(date:"2022.11.01", showAvatar: true, type: 1,
                msg : "상암 경기장에서 공연한다는데 맞아?\n장소 바뀐거 아니지?",
                unread: 0,
                writedate: ""),
        TmpData(type: 1,
                msg : "같이 갈꺼지? 공연 끝나고...",
                unread: 0,
                writedate: "오후 3:22",
                showImage: false),
        TmpData(type: 2,
                msg : "당연히 같이 가야지~ 스탠딩 공연이잖아 너무 재밌을것 같어~",
                unread: 1),
        TmpData(type: 2,
                msg : "하 빨리 다음주 됐으면...",
                unread: 1,
                writedate: "오후 5:22"),
        TmpData(type: 2,
                showImage: true)
    ]
    
    var body: some View {
        VStack(spacing:0) {
            composerView
        }
        .padding(.top, 14)
        .navigationType(
            leftItems:[.Back],
            rightItems: [.Trans, .More],
            leftItemsForegroundColor: Color.gray900,
            rightItemsForegroundColor: Color.gray900,
            title: "유서연",
            onPress: { buttonType in
            }
        )
        .navigationBarBackground {
            Color.gray25
        }
    }
    
    var composerView: some View {
        VStack(spacing:0) {
            
            ScrollView() {
                ForEach(tmp, id: \.self) { itr in
                    ChatBubbleView(date : itr.date,
                                   showAvatar: itr.showAvatar,
                                   type:itr.type,
                                   msg:itr.msg,
                                   unread:itr.unread,
                                   writedate:itr.writedate,
                                   showImage:itr.showImage)
                }
            }.frame(maxWidth:.infinity, maxHeight: .infinity)
            
            
            //Spacer().frame(maxWidth:.infinity,maxHeight:.infinity)
            LazyVStack(alignment: .leading, spacing:0) {
                VStack(spacing:0) {
                    TextField("댓글을 입력해 주세요.", text:$message)
                        .lineLimit(4)
                        .font(Font.body21420Regular)
                        .foregroundColor(Color.gray800)
                        .focused($focus, equals:showMessage)
                        .frame(maxWidth:.infinity)
                        .padding(20)
                }
                .frame(maxWidth:.infinity)
                .background(Color.gray25)
                .shadow(radius: 20)
                .hidden(!showMessage)
                .padding([.bottom], -10)
                
                HStack {
                    Image("icon_outline_picture")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.stateEnableGray400)
                        .frame(width:24, height:24)
                    Text(showMessage ? "댓글을 전송해보세요." : (message.isEmpty ? "댓글을 입력해 주세요." : message))
                        .font(Font.body21420Regular)
                        .foregroundColor(message.isEmpty ? Color.stateEnableGray400 : Color.gray800)
                        .onTapGesture {
                            showMessage.toggle()
                            if showMessage == true {
                                focus = showMessage
                            }
                            
                        }
                    
                    Spacer().frame(maxWidth:.infinity)
                    
                    VStack {
                        Image("icon_outline_send")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.gray25)
                            .frame(width:16, height:16)
                    }
                    .cornerRadius(32)
                    .frame(width:32, height:32)
                    .background(Color.primary300)
                    .clipShape(Circle())
                    .hidden(message.isEmpty ? true : false)
                    .onTapGesture {
                        print("send message \(message)")
                        message = ""
                        showMessage = false;
                    }
                    
                }
                .padding([.leading, .trailing], 18)
                .frame(height:60)
                .background(Color.gray25)
                
            }
            //.background(Color.blue)
            
        }
        .padding(.top, 14)
        .background(Color.gray50)
        .frame(maxWidth:.infinity, maxHeight: .infinity)
    }
}

