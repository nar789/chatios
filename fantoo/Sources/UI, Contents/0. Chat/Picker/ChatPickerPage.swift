

import SwiftUI


struct ChatPickerPage : View {
    
    @StateObject var viewModel = ChatPickerViewModel()
    @StateObject var chatManager = ChatManager.shared
    
    @Binding var showChatComposerPage: Bool;
    
    @State private var searchText = ""
    @State private var checkCount = 0
    @State private var checkMap:[String:Any] = [:]
    
    var str = ["ABC", "KKK"]
    
    
    var body: some View {
        
        chatPickerView
        .padding(.top, 14)
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .background(Color.gray25)
        .navigationType(
            leftItems:[.Back],
            leftItemsForegroundColor: Color.gray900,
            rightItemsForegroundColor: Color.clear,
            title: "새 채팅 추가",
            onPress: { buttonType in
            }
        )
        .navigationBarBackground {
            Color.gray25
        }
        .onAppear {
            ChatSocketManager.shared.checkAndConnect()
            viewModel.loadMyFollow()
        }
    }
    
    var chatPickerView: some View {
        VStack(spacing:0) {
            chatSearchBar
            
            if viewModel.followList.isEmpty && viewModel.userList.isEmpty {
                
                needToFollowView
                
            } else {
                
                ScrollView {
                    followListView
                    
                    if !searchText.isEmpty && !viewModel.userList.isEmpty {
                        fantooSearchListView
                    }
                    
                    Spacer().frame(height:50)
                }
                
                
                CommonButton(title: "채팅 시작하기",
                             bgColor: checkCount > 0 ?
                             Color.stateActivePrimaryDefault :
                                Color.stateDisabledGray200)
                .padding([.leading, .trailing], 20)
                .onTapGesture {
                    if checkCount > 0 {
                        print("open chat room")
                        self.createConversation()
                        
                    }
                }
                .onChange(of:chatManager.conversations.count) { _ in
                    print("asdfasdfasdfasdfasdf")
                    showChatComposerPage = true
                }
                
            }
            
            Spacer()
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
    }
    
    var needToFollowView : some View {
        VStack(alignment:.center,spacing:0) {
            Spacer().frame(height:150)
            Image("character_main2")
                .resizable()
                .frame(width: 118, height: 124)
            
            Text("아직 아무도 팔로우하지 않으셨네요.\n프로필에서 팔로우를 눌러 채팅해보세요.")
                .multilineTextAlignment(.center)
                .foregroundColor(Color.gray870)
                .font(Font.body21420Regular)
            Spacer()
        }.frame(maxWidth:.infinity, maxHeight: .infinity)
    }
    
    var fantooSearchListView: some View {
        LazyVStack(alignment:.leading, spacing:8) {
            Spacer()
                .frame(maxWidth:.infinity, maxHeight: 10)
                .background(Color.gray50)
            
            VStack(alignment:.leading, spacing:0) {
                Text("팬투 검색")
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray600)
                    .padding(.leading, 20)
                    .padding(.top, 16)
            }
            
            LazyVStack {
                ForEach(viewModel.userList) { user in
                    ChatPickerRowView(uid:user.id, name:user.userNick, image:user.userPhoto,
                                      checkCount: $checkCount, checkMap: $checkMap)
                }
            }
        }
    }
    
    var followListView: some View {
        LazyVStack(alignment:.leading, spacing:8) {
            VStack(alignment:.leading, spacing:0) {
                Text("팔로우 목록")
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray600)
                    .padding(.leading, 20)
                    .padding(.top, 16)
            }
            LazyVStack(spacing:0) {
                ForEach(viewModel.followList, id: \.id) { follow in
                    ChatPickerRowView(uid:follow.id, name:follow.userNick, image:follow.userPhoto,
                                      checkCount: $checkCount, checkMap: $checkMap)
                }
            }
        }
    }
    
    var chatSearchBar : some View {
        VStack(alignment:.center, spacing:0) {
            Spacer().frame(maxHeight:20)
            HStack(alignment:.center) {
                Image("icon_outline_search")
                    .resizable()
                    .frame(width:20, height:20)
                    .foregroundColor(Color.gray700)
                TextField("친구를 검색해주세요.", text:$searchText)
                    .font(Font.body21420Regular)
                    .foregroundColor(Color.gray870)
                    .onChange(of:searchText) {
                        self.search(keyword: $0)
                    }
                Spacer()
            }
            .padding([.leading, .trailing], 6)
            .frame(maxHeight:36)
            .background(Color.gray25)
            .border(Color.gray700, width:0.1, cornerRadius: 5)
            
            Spacer().frame(maxWidth:.infinity, maxHeight: 14)
        }
        .padding([.leading, .trailing], 19)
        .background(Color.bgLightGray50)
    }
    
}

extension ChatPickerPage {
    
    func search(keyword: String) {
        let integUid = UserManager.shared.uid
        let accessToken = UserManager.shared.accessToken
        viewModel.userList = []
        viewModel.search(accessToken: accessToken, integUid: integUid, keyword: keyword)
    }
    
    func createConversation() {
        if checkMap.isEmpty {
            return
        }
        for (_, value) in checkMap {
            let user:ChatComposerUser = value as! ChatComposerUser
            ChatManager.shared.clear()
            ChatManager.shared.currentComposerUsers.append(user)
        }
        viewModel.createConversation(users: ChatManager.shared.currentComposerUsers)
    }
}
