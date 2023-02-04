

import Foundation


class ChatManager:ObservableObject {
    
    static let shared = ChatManager()
    
    
    @Published var currentComposerUsers:[ChatComposerUser] = []
    @Published var messages:[ChatMessage] = []
    @Published var conversations:[ChatConversation] = []
    @Published var conversationId = 0
    @Published var conversationTitle = ""
    @Published var myName = ""
    @Published var userCount = 0
    @Published var lastUpdated:[String:Int] = [:]
    
    @Published var selectedUid = ""
    @Published var selectedMessageId = ""
    
    
    func clear() {
        currentComposerUsers = [];
        conversationId = 0;
    }
    
    func updateUnreads() {
        var list:[ChatMessage] = []
        for message in messages {
            var item:ChatMessage = message
            var sum = 0
            for (_, value) in lastUpdated {
                if(message.messageId <= value) {
                    sum += 1
                }
            }
            item.unreads = userCount - sum
            print(item.id + "  , unreads : " + String(item.unreads))
            list.append(item)
        }
        messages = list

    }
    
    func removeConversationItem(id: Int) {
        var newList:[ChatConversation] = []
        for covnversation:ChatConversation in conversations {
            if covnversation.id != id {
                newList.append(covnversation)
            }
        }
        conversations = newList
        
    }

}

struct ChatMessage : Identifiable {
    var id: String { String(messageId) + writedate + String(unreads)}
    var messageId:Int
    var uid:String
    var name:String
    var message:String
    var image:String
    var messageType:Int
    var updated:Int
    var sendType:Int
    
    var avatar = ""
    var writedate = ""
    var date = ""
    
    var showAvatar = true
    
    var unreads = 0

}


struct ChatConversation : Identifiable {
     var id:Int
     var thumbnail:String
     var title:String
     var unreads:Int
     var lastMessageId:Int
     var userCount:Int
     var lastMessageType:Int
    var lastMessage:String
    var updated:Int
    
    var writedate = ""
    
}

struct ChatComposerUser {
    var uid:String
    var nick:String
    var image:String
}
