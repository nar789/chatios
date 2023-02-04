
import Foundation
import Combine

class ChatPageViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    
    
    
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
    
    
    func outConversation(conversatinoId:Int) {
        requestUserInfo() { nick, profile in
            ChatManager.shared.myName = nick
            let uid = UserManager.shared.uid
            ChatSocketManager.shared.outConversation(uid: uid, name: nick, conversationId: String(conversatinoId))
            print("out conversation done.")
        }
    }
    
    func blockConversation(id: Int) {
        ApiControl.chatBlockConversation(accessToken: UserManager.shared.accessToken, conversationId: String(id))
            .sink { error in
                print("blockConversation error : \(error)")
            } receiveValue: { value in
                print("blockConversation value : \(value)")
            }.store(in: &canclelables)
    }
    
    
}
