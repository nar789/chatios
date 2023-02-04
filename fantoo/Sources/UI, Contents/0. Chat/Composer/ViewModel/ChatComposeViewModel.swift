
import Foundation
import Combine



class ChatComposeViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    
    @Published var infos:[String:ChatUserInfoModel] = [:]
    
    
    var loadStart = Set<String>()
    
    func unblock(targetUid: String) {
        
        let accessToken = UserManager.shared.accessToken
        
        CommonFunction.onPageLoading()
        ApiControl.chatUnblock(accessToken: accessToken, integUid: targetUid)
            .sink { error in
                CommonFunction.offPageLoading()
            } receiveValue: { value in
                CommonFunction.offPageLoading()
                self.infos[targetUid]?.blockYn = false
            }
            .store(in: &canclelables)
        
    }
    
    
    func block(targetUid: String) {
        
        let accessToken = UserManager.shared.accessToken
        
        CommonFunction.onPageLoading()
        ApiControl.chatBlock(accessToken: accessToken, integUid: targetUid)
            .sink { error in
                CommonFunction.offPageLoading()
            } receiveValue: { value in
                CommonFunction.offPageLoading()
                self.infos[targetUid]?.blockYn = true
            }
            .store(in: &canclelables)
        
    }
    
    func unfollow(targetUid: String) {
        
        let accessToken = UserManager.shared.accessToken
        
        CommonFunction.onPageLoading()
        ApiControl.chatUnfollow(accessToken: accessToken, integUid: targetUid)
            .sink { error in
                CommonFunction.offPageLoading()
            } receiveValue: { value in
                CommonFunction.offPageLoading()
                self.infos[targetUid]?.followYn = false
            }
            .store(in: &canclelables)
        
    }
    
    
    func follow(targetUid: String) {
        
        let accessToken = UserManager.shared.accessToken
        
        CommonFunction.onPageLoading()
        ApiControl.chatFollow(accessToken: accessToken, integUid: targetUid)
            .sink { error in
                CommonFunction.offPageLoading()
            } receiveValue: { value in
                CommonFunction.offPageLoading()
                self.infos[targetUid]?.followYn = true
            }
            .store(in: &canclelables)
        
    }
    
    func getUserInfo(accessToken: String, integUid: String) {
        if(loadStart.contains(integUid)) {
            return
        }
        print("hh getuserinfo " + integUid)
        let hasKey = infos.keys.contains { $0 == integUid }
        if hasKey {
            return 
        }
        loadStart.insert(integUid)
        
        CommonFunction.onPageLoading()
        ApiControl.getChatUserInfo(accessToken: accessToken, integUid: integUid)
            .sink { error in
                CommonFunction.offPageLoading()
                self.loadStart.remove(integUid)
            } receiveValue: { value in
                CommonFunction.offPageLoading()
                let info:ChatUserInfoModel = value
                self.infos[integUid] = info
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
    
    func sendMessage(message: String, conversationId: Int) {
        requestUserInfo() { nick, profile in
            
            let uid = UserManager.shared.uid
            let messageType = 1
            let image = ""
            let updated = Int(Date().timeIntervalSince1970)
            
            ChatSocketManager.shared.sendMessage(conversationId: conversationId, userId: uid, name: nick, message: message, image: image, messageType: messageType, updated: updated)
            
        }
    }
    
    func loadMyName() {
        requestUserInfo() { nick, profile in
            ChatManager.shared.myName = nick
        }
    }
    
    func isBlockConversation(success: @escaping (_ isBlock: Bool)->Void) {
        ApiControl.chatIsBlockConversation(accessToken: UserManager.shared.accessToken, conversationId: String(ChatManager.shared.conversationId))
            .sink { error in
                print("isBlockConversation error : \(error)")
            } receiveValue: { value in
                print("isBlockConversation value : \(value)")
                success(value)

            }.store(in: &canclelables)
    }
    
    
    
    func unblockConversation(id: Int) {
        ApiControl.chatUnblockConversation(accessToken: UserManager.shared.accessToken, conversationId: String(id))
            .sink { error in
                print("blockConversation error : \(error)")
            } receiveValue: { value in
                print("blockConversation value : \(value)")
            }.store(in: &canclelables)
    }
    
    
    func translate(id:String, text:String, user:String , success: @escaping (_ text: String)->Void) {
        ApiControl.chatTranslate(id: id, text: text, user: user)
            .sink { error in
                print("translate error : \(error)")
            } receiveValue: { value in
                print("translate value : \(value)")
                success(value)

            }.store(in: &canclelables)
    }
    
    
}
