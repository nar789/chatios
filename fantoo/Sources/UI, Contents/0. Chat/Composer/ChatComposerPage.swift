

import SwiftUI
import PhotosUI

struct TmpData : Hashable {
    var date = ""
    var showAvatar = false
    var type = 0
    var msg = ""
    var unread = 0
    var writedate = ""
    var showImage = false
    var image:UIImage?
}

struct ChatComposerPage: View {
    
    @Binding var showChatComposerPage: Bool
    @Binding var showPopup: Bool
    
    @StateObject var chatManager = ChatManager.shared
    @StateObject var vm = ChatComposeViewModel()
    
    
    
    @State var message = ""
    @State var chatFocus = false
    @State var showKeyboard = false
    @State var prevOffset:CGFloat = 0
    @State var scrollingReady = false
    
    @State var showMessage = false
    @FocusState var focus
    @State private var isPresented: Bool = false
    @State private var images:[UIImage] = []
    
    @State var showBottomsheet = false
    
    @State var toggleAlarm = false
    
    @State var isBlockChat = false
    
    @State var isTrans = false
    
    @State var offset = 0;
    @State var size = 100;
    @State var isTranslate = false
    let defaults = UserDefaults.standard
    
    @State var tmp:[TmpData] = [
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
        .navigationType(
            leftItems:[.Back],
            rightItems: [isTranslate ? .TransOn : .TransOff, .More],
            leftItemsForegroundColor: Color.gray900,
            rightItemsForegroundColor: Color.gray900,
            title: self.chatManager.conversationTitle,
            onPress: { buttonType in
                if buttonType == .More {
                    showBottomsheet = true
                    if chatFocus {
                        hideKeyboard()
                        showMessage.toggle()
                        chatFocus.toggle()
                    }
                } else if buttonType == .Back {
                    ChatSocketManager.shared.leave(conversationId: chatManager.conversationId)
                }
                else {
                    if isTranslate {
                        print("start translate")
                        //vm.translate
                    }
                    isTranslate.toggle()
                    defaults.set(isTranslate, forKey: "isTranslate\(chatManager.conversationId)")
                }
            }
        )
        .navigationBarBackground {
            Color.gray25
        }
        .bottomSheet(isPresented: $showBottomsheet, height: 142) {
            VStack(alignment: .leading) {
                Toggle("알림 ON", isOn: $toggleAlarm)
                    .toggleStyle(SwitchToggleStyle(tint: Color.primary300))
                    .font(Font.body11622Regular)
                    .foregroundColor(Color.gray870)
            
                Text("채팅방 나가기")
                    .font(Font.body11622Regular)
                    .foregroundColor(Color.gray870)
                    .onTapGesture {
                        let uid = UserManager.shared.uid
                        let name = chatManager.myName
                        let conversationId = String(chatManager.conversationId)
                        ChatSocketManager.shared.outConversation(uid: uid, name: name, conversationId: conversationId)
                        print("leave chat room")
                        showChatComposerPage = false
                    }
            }
            .padding(.horizontal, 32)
            .background(Color.gray25)
        }
        .onAppear {
            vm.loadMyName()
            ChatSocketManager.shared.join(conversationId: chatManager.conversationId)
            ChatSocketManager.shared.loadMessage(conversationId: chatManager.conversationId,
                                                 offset: self.offset, size: self.size)
            ChatSocketManager.shared.openReadInfo()
            ChatSocketManager.shared.loadReadInfo()
            vm.isBlockConversation() { isBlock in
                isBlockChat = isBlock
            }
            isTranslate = defaults.bool(forKey: "isTranslate\(chatManager.conversationId)")
        }
    }
    
    var composerView: some View {
        
        
    
        
        VStack(spacing:0) {
            
            ScrollViewReader { value in
                ScrollView {
                    ForEach(chatManager.messages, id: \.id) { message in
                        ChatBubbleView(
                            id: message.id,
                            uid: message.uid,
                            showAvatar: message.showAvatar,
                            date : message.date,
                            name: message.name,
                            type: message.sendType,
                            msg: message.message ,
                            unread: message.unreads,
                            writedate: message.writedate,
                            image: message.image,
                            messageType: message.messageType,
                            showPopup:$showPopup, infos:$vm.infos, vm:vm,
                            isTranslate: $isTranslate)
                        
                        
                        scrollObservableView
                        
                        
                        .onAppear {
                            print("bubble, nick = " + message.name + ", msg = " + message.message)
                            vm.getUserInfo(accessToken: UserManager.shared.accessToken, integUid: message.uid)
                            let lastId:String = chatManager.messages.last?.id ?? ""
                            if lastId == message.id {
                                withAnimation {
                                    value.scrollTo(message.id)
                                }
                            }
                        }
                    }
                }
                .onTapGesture {
                    if chatFocus {
                        hideKeyboard()
                        showMessage.toggle()
                        chatFocus.toggle()
                    }
                }
                .onPreferenceChange(OffsetPreferenceKey.self) {
                    
                    let offset:CGFloat = $0
                    let diff = abs(prevOffset - offset)
                    self.prevOffset = offset
                    
                    if scrollingReady && chatFocus && !showKeyboard {
                        
                        if diff > 3000 && diff < 10000 {
                            //print("scroll view offset diff = \(diff)")
                            chatFocus.toggle()
                            scrollingReady.toggle()
                            hideKeyboard()
                            showMessage.toggle()
                        }
                    }
                }
                .onChange(of: showKeyboard) { _ in
                    if chatFocus && !showKeyboard {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            scrollingReady = true
                        }
                    }
                }
                
                
                if isBlockChat {
                    
                    VStack(spacing:14) {
                        Text("차단 해제 후 메시지를 보낼 수 있습니다.")
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.gray400)
                            .padding(.top, 14)
                        
                        Text("차단 해제")
                            .foregroundColor(Color.gray25)
                            .font(Font.buttons1420Medium)
                            .frame(width:335, height:36)
                            .background(Color.stateDisabledGray200)
                            .cornerRadius(50)
                            .onTapGesture {
                                vm.unblockConversation(id: chatManager.conversationId)
                                isBlockChat = false
                            }
                        
                        Spacer()
                    }
                    .frame(maxWidth:.infinity, maxHeight: 120)
                    .background(Color.stateEnableGray25)
                    
                } else {
                    
                    LazyVStack(alignment: .leading, spacing:0) {
                        if showMessage {
                            VStack(spacing:0) {
                                
                                ChatTextField(placeholder:"댓글을 입력해 주세요.",text: $message, chatFocus: $chatFocus, showKeyboard: $showKeyboard)
                                    .lineLimit(4)
                                    .font(Font.body21420Regular)
                                    .foregroundColor(Color.gray800)
                                    .frame(maxWidth:.infinity)
                                    .padding(20)
                            }
                            .frame(maxWidth:.infinity)
                            .background(Color.gray25)
                            .shadow(radius: 20)
                            .padding([.bottom], -10)
                        }
                        
                        HStack {
                            
                            Image("icon_outline_picture")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(Color.stateEnableGray400)
                                .frame(width:24, height:24)
                                .onTapGesture {
                                    images = []
                                    vm.loadMyName()
                                    isPresented.toggle()
                                }
                                .sheet(isPresented: $isPresented) {
                                    var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
                                    let _=configuration.selectionLimit = 0
                                    let _=configuration.filter = .any(of: [.images])
                                    
                                    PhotoPicker(configuration: configuration,
                                                isPresented: $isPresented,
                                                images: $images, list:$tmp)
                                    
                                }
                            
                            
                            Text(showMessage ? "" : (message.isEmpty ? "댓글을 입력해 주세요." : message))
                                .font(Font.body21420Regular)
                                .foregroundColor(message.isEmpty ? Color.stateEnableGray400 : Color.gray800)
                                .onTapGesture {
                                    showMessage.toggle()
                                    chatFocus.toggle()
                                }
                                .onChange(of:showKeyboard) { _ in
                                    if showKeyboard && chatFocus {
                                        withAnimation {
                                            let lastId:String = chatManager.messages.last?.id ?? ""
                                            value.scrollTo(lastId)
                                            showKeyboard.toggle()
                                        }
                                    }
                                }
                            
                            Spacer().frame(maxWidth:.infinity, maxHeight:50)
                                .background(Color.gray25)
                                .onTapGesture {
                                    showMessage.toggle()
                                    chatFocus.toggle()
                                }
                            
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
                                vm.sendMessage(message: message, conversationId: chatManager.conversationId)
                                message = ""
                                showMessage = false
                                chatFocus = false
                                scrollingReady = false
                                showKeyboard = false
                            }
                         
                        }
                        .padding([.leading, .trailing], 18)
                        .frame(height:60)
                        .background(Color.gray25)
                    }
                }
                
            }
            
            
        }
        .background(Color.gray50)
        .frame(maxWidth:.infinity, maxHeight: .infinity)
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


private struct OffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = .zero
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
      value += nextValue()
  }
}

private var scrollObservableView: some View {
    GeometryReader { proxy in
        let offsetY = proxy.frame(in: .global).origin.y
        Color.clear
            .preference(
                key: OffsetPreferenceKey.self,
                value: offsetY
            )
    }
    .frame(height: 0)
}

struct ChatTextField: UIViewRepresentable {
    var placeholder:String
    @Binding var text: String
    @Binding var chatFocus:Bool
    @Binding var showKeyboard:Bool
    
    var textField:UITextField = UITextField()
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text:String
        @Binding var chatFocus:Bool
        @Binding var showKeyboard:Bool
        var becameFirstResponder = false
        
        init(text: Binding<String>, chatFocus: Binding<Bool>, showKeyboard: Binding<Bool>) {
            self._text = text
            self._chatFocus = chatFocus
            self._showKeyboard = showKeyboard
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showKeyboard.toggle()
            }
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            self.text = textField.text ?? ""
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.text! += "\n"
            return true
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: self.$text, chatFocus: self.$chatFocus, showKeyboard:self.$showKeyboard)
    }
    
    func makeUIView(context: Context) -> UITextField {
        textField.delegate = context.coordinator
        textField.font = UIFont.body21420Regular
        textField.textColor = UIColor.gray800
        textField.placeholder = self.placeholder
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = self.text
        if chatFocus == true && context.coordinator.becameFirstResponder != true {
            uiView.becomeFirstResponder()
            context.coordinator.becameFirstResponder = true
        } else if chatFocus != true && context.coordinator.becameFirstResponder != false {
            uiView.resignFirstResponder()
            context.coordinator.becameFirstResponder = false
        }
        
    }
}
