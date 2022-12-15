

import SwiftUI


struct ChatPickerPage : View {
    
    @Binding var showChatComposerPage: Bool;
    
    @State private var searchText = ""
    @State private var checkCount = 0
    
    var str = ["ABC", "KKK", "이정헌", "안연지", "유서연", "이정헌1", "안연지1", "유서연1", "이정헌2", "안연지2", "유서연2","이정헌3", "안연지3", "유서연3"]
    
    //var str:[String] = [] //to check for empty follow friends list
    
    
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
    }
    
    var chatPickerView: some View {
        VStack(spacing:0) {
            chatSearchBar
            
            if str.isEmpty {
                
                needToFollowView
                
            } else {
                
                ScrollView {
                    followListView
                    
                    if !searchText.isEmpty {
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
                        showChatComposerPage = true
                        
                    }
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
                ForEach(str.filter { s in
                    return s.lowercased().contains(searchText.lowercased()) || searchText.isEmpty
                }, id:\.self) { s in
                    ChatPickerRowView(name:s, checkCount: $checkCount)
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
                ForEach(str.filter { s in
                    return s.lowercased().contains(searchText.lowercased()) || searchText.isEmpty
                }, id:\.self) { s in
                    ChatPickerRowView(name:s, checkCount: $checkCount)
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
