
import Foundation
import Combine
import SocketIO

class ChatPickerViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    
    @Published var userList: [ChatUserModel] = []
    @Published var followList: [ChatUserModel] = []
    
    
    
    
    
    func loadMyFollow() {
        let accessToken = UserManager.shared.accessToken
        let uid = UserManager.shared.uid
        CommonFunction.onPageLoading()
        ApiControl.chatMyFollow(accessToken: accessToken, integUid: uid)
            .sink { error in
                CommonFunction.offPageLoading()
            } receiveValue: { value in
                CommonFunction.offPageLoading()
                
                self.followList = value.chatUserDtoList
            }
            .store(in: &canclelables)
    }
    
    
    func search(accessToken: String, integUid: String, keyword: String) {
        CommonFunction.onPageLoading()
        ApiControl.chatSearchUser(accessToken: accessToken, integUid: integUid, keyword: keyword)
            .sink { error in
                CommonFunction.offPageLoading()
            } receiveValue: { value in
                CommonFunction.offPageLoading()
                
                self.userList = value.chatUserDtoList
            }
            .store(in: &canclelables)
    }
    
    func requestUserInfo(success: @escaping (_ nick: String,_ profile: String)->Void) {
        ApiControl.myInfo(integUid: UserManager.shared.uid)
            .sink { error in
                print("getUserInfo error : \(error)")
            } receiveValue: { value in
                print("getUserInfo value : \(value)")
                
                let photo = value.userPhoto ?? ""
                let nick = value.userNick ?? ""
                success(nick, photo)

            }.store(in: &canclelables)
    }
    
    func getConversationInfo(users:[ChatComposerUser], nick: String, profile: String) -> String {
        let list = users
        let my = ChatComposerUser(uid: UserManager.shared.uid, nick: nick, image: profile)
        var info = [String:String]()
        var infoList:[[String:String]] = []
        info["id"] = my.uid
        info["userNick"] = my.nick
        info["userPhoto"] = my.image
        infoList.append(info)
        for user in list {
            info["id"] = user.uid
            info["userNick"] = user.nick
            info["userPhoto"] = user.image
            infoList.append(info)
        }
        
        var jsonStr = ""
        do {
            let json = try JSONSerialization.data(withJSONObject: infoList)
            print("create conversaiton json str : ")
            jsonStr = String(data: json, encoding: .utf8)!
            print(jsonStr)
        } catch {
            print(error.localizedDescription)
        }
        return jsonStr
    }
    
    func createConversation(users:[ChatComposerUser]) {
        requestUserInfo() { nick, profile in
            let str = self.getConversationInfo(users: users, nick: nick, profile: profile)
            ChatSocketManager.shared.createConversation(json: str)
        }
        
    }
    
}
