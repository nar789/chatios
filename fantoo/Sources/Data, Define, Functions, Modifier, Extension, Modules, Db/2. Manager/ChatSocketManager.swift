

import Foundation
import SocketIO

class ChatSocketManager {
    
    static let shared = ChatSocketManager()
    
    let manager = SocketManager(socketURL: URL(string: "http://nar005.cafe24.com:1225")!, config: [.log(true), .compress])
    var socket:SocketIOClient!
    var isJoined = false

    
    init() {
        socket = self.manager.defaultSocket
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        //socket.on
        socket.on("welcome") { data, ack in
            print("socket connected with hume server, welcome!!")
        }
        
        socket.on("createConversation") { data, ack in
            print("on create conversation")
            print(data)
            if !data.isEmpty {
                let response = data[0] as! NSDictionary
                let convId = response["conversationId"] as! Int
                ChatManager.shared.conversationId = convId
                print(ChatManager.shared.conversationId)
                self.loadConversation()
            }
        }
        
        socket.on("loadConversation") { data, ack in
            print("on load conversation")
            print(data)
            
            if !data.isEmpty {
                let response = data[0] as! NSDictionary
                let jsonStr:String = response["data"] as! String
                do {
                    let jsonList = try JSONSerialization.jsonObject(with: Data(jsonStr.utf8)) as! [Any]
                    var list:[ChatConversation] = []
                    for item in jsonList {
                        let json = item as! [String:Any]
                        
                        let title = json["title"] as! String
                        let thumbnail = json["thumbnail"] as! String
                        let lastMessageId = json["last_message_id"] as! Int
                        let unreads = json["unreads"] as! Int
                        let id = json["id"] as! Int
                        let userCount = json["user_count"] as! Int
                        let messageType = json["messageType"] as? Int ?? 0
                        var message = json["message"] as? String ?? ""
                        let updated = json["updated"] as? Int ?? 0
                        
                        if messageType == 2 {
                            message = "[이미지]"
                        }
                        
                        print("load conv message = " + message + ", type = " + String(unreads))
                        
                        var writedate = Date().timeSinceDate(fromDate: Date(timeIntervalSince1970: Double(updated)))
                        if (Int(Date().timeIntervalSince1970) - updated) >= 3600 {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "a hh:mm"
                            formatter.locale = Locale(identifier: "ko_KR")
                            writedate = formatter.string(from: Date(timeIntervalSince1970: Double(updated)))
                        }
                        
                        list.append(ChatConversation(id: id, thumbnail: thumbnail, title: title, unreads: unreads, lastMessageId: lastMessageId, userCount: userCount, lastMessageType: messageType, lastMessage: message, updated: updated, writedate: writedate))
                        
                    }
                    //ChatManager.shared.conversations = list.reversed()
                    ChatManager.shared.conversations = list
                    
                    print(ChatManager.shared.conversations)
                    if !list.isEmpty {
                        for conversation in ChatManager.shared.conversations {
                            if conversation.id == ChatManager.shared.conversationId {
                                ChatManager.shared.userCount = conversation.userCount
                                ChatManager.shared.conversationTitle = conversation.title
                                break;
                            }
                        }
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }
        
        socket.on("message") { data , ack in
            print("on message, is joined = " + String(self.isJoined))
            print(data)
            
            if !self.isJoined {
                return;
            }
            
            if !data.isEmpty {
                let response = data[0] as! NSDictionary
                let messageId = response["messageId"] as? Int ?? 0
                let message = response["message"] as! String
                
                let messageTypeStr = response["messageType"] as? String ?? ""
                var messageType:Int
                if messageTypeStr.isEmpty {
                    messageType = response["messageType"] as! Int
                } else {
                    messageType = Int(messageTypeStr)!
                }
                
                if messageType == 3 {
                    ChatManager.shared.userCount -= 1
                }
                
                let name = response["name"] as! String
                let userId = response["userId"] as! String
                let image = response["image"] as? String ?? ""
                
                let updatedStr = response["updated"] as? String ?? ""
                var updated:Int
                if updatedStr.isEmpty {
                    updated = response["updated"] as! Int
                } else {
                    updated = Int(updatedStr)!
                }
                
                
                var writedate = Date().timeSinceDate(fromDate: Date(timeIntervalSince1970: Double(updated)))
                if (Int(Date().timeIntervalSince1970) - updated) >= 3600 {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "a hh:mm"
                    formatter.locale = Locale(identifier: "ko_KR")
                    writedate = formatter.string(from: Date(timeIntervalSince1970: Double(updated)))
                }
                let sendType = userId == UserManager.shared.uid ? 2 : 1
                
                var chatMessage  = ChatMessage(messageId: messageId, uid: userId, name: name, message: message, image: image, messageType: messageType, updated: updated, sendType: sendType, writedate: writedate, unreads: ChatManager.shared.userCount)
                
                var before:ChatMessage? = ChatManager.shared.messages.last
                
                let date:Date = Date(timeIntervalSince1970: Double(chatMessage.updated))
                let calendar = Calendar.current
                let year =  calendar.component(.year, from: date)
                let month = calendar.component(.month, from: date)
                let day = calendar.component(.day, from: date)
                
                if before != nil {
                    
                    let beforeDate:Date = Date(timeIntervalSince1970: Double(before?.updated ?? 0))
                    let byear =  calendar.component(.year, from: beforeDate)
                    let bmonth = calendar.component(.month, from: beforeDate)
                    let bday = calendar.component(.day, from: beforeDate)
                    
                    if byear != year || bmonth != month || bday != day {
                        chatMessage.date = String(year) + "." + String(month) + "." + String(day)
                    }
                    
                    if(chatMessage.uid == before!.uid) {
                        chatMessage.showAvatar = false
                        let diff = chatMessage.updated - before!.updated
                        print("diff " + String(diff))
                        if(chatMessage.updated - before!.updated < 60) {
                            before!.writedate = ""
                            ChatManager.shared.messages.removeLast()
                            ChatManager.shared.messages.append(before!)
                        }
                    }
                    
                } else {
                    chatMessage.date = String(year) + "." + String(month) + "." + String(day)
                }
                
                ChatManager.shared.messages.append(chatMessage)
                self.sendMsgReadInfo(messageId: messageId)
            }
            
        }
        
        socket.on("loadmessage") { data, ack in
            print("on load message")
            print(data)
            
            if !data.isEmpty {
                let response = data[0] as! NSDictionary
                let row = response["rows"] as! [Any]
                var before:ChatMessage?;
                var chatMessage:ChatMessage;
                for item in row.reversed() {
                    let m = item as! NSDictionary
                    let id = m["id"] as! Int
                    let image = m["image"] as? String ?? ""
                    let message = m["message"] as! String
                    let messageType = m["message_type"] as! Int
                    let name = m["name"] as! String
                    let updated = m["updated"] as? Int ?? 0
                    let userId = m["user_id"] as! String
                    
                    var writedate = Date().timeSinceDate(fromDate: Date(timeIntervalSince1970: Double(updated)))
                    if (Int(Date().timeIntervalSince1970) - updated) >= 3600 {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "a hh:mm"
                        formatter.locale = Locale(identifier: "ko_KR")
                        writedate = formatter.string(from: Date(timeIntervalSince1970: Double(updated)))
                    }
                    let sendType = userId == UserManager.shared.uid ? 2 : 1
                    
                    
                    chatMessage = ChatMessage(messageId: id, uid: userId, name: name,
                                                  message: message, image: image, messageType: messageType,
                                              updated: updated, sendType: sendType, writedate: writedate)
                    
                    let date:Date = Date(timeIntervalSince1970: Double(chatMessage.updated))
                    let calendar = Calendar.current
                    let year =  calendar.component(.year, from: date)
                    let month = calendar.component(.month, from: date)
                    let day = calendar.component(.day, from: date)
                    
                    if before != nil {
                        let beforeDate:Date = Date(timeIntervalSince1970: Double(before?.updated ?? 0))
                        let byear =  calendar.component(.year, from: beforeDate)
                        let bmonth = calendar.component(.month, from: beforeDate)
                        let bday = calendar.component(.day, from: beforeDate)
                        
                        if byear != year || bmonth != month || bday != day {
                            chatMessage.date = String(year) + "." + String(month) + "." + String(day)
                        }
                        
                        if(chatMessage.uid == before!.uid) {
                            chatMessage.showAvatar = false
                            let diff = chatMessage.updated - before!.updated
                            print("diff " + String(diff))
                            if(chatMessage.updated - before!.updated < 60) {
                                before!.writedate = ""
                                ChatManager.shared.messages.removeLast()
                                ChatManager.shared.messages.append(before!)
                            }
                        }
                        
                    } else {
                        chatMessage.date = String(year) + "." + String(month) + "." + String(day)
                    }
                    
                    before = chatMessage;
                    
                    ChatManager.shared.messages.append(chatMessage)
                    
                }
            }
            
        }
        
        socket.on("uploadImage") { data, ack in
            
            print("on load message")
            print(data)
            
            if !data.isEmpty {
                let response = data[0] as! NSDictionary
                let filename = response["filename"] as! String
                
                let conversationId = ChatManager.shared.conversationId
                let name = ChatManager.shared.myName
                let uid = UserManager.shared.uid
                let message = ""
                let messageType = 2
                let image = filename
                let updated = Int(Date().timeIntervalSince1970)
                
                if !self.isJoined {
                    return
                }
                self.socket.emit("message", [
                    "conversationId" : String(conversationId),
                    "userId" : uid,
                    "name" : name,
                    "message" : message,
                    "image" : image,
                    "messageType" : String(messageType),
                    "updated" : String(updated)
                ])
                
                
                
            }
            
        }
        
        
        socket.on("readinfo") { data, ack in
            
            print("on read info")
            print(data)
            
            if !data.isEmpty {
                let response = data[0] as! NSDictionary
                //let conversationId = response["conversationId"] as! String
                let uid = response["userId"] as! String
                let lastMessageId = response["lastMessageId"] as? Int ?? 0
                
                print("last updated, " + uid + " : " + String(lastMessageId))
                
                ChatManager.shared.lastUpdated[uid] = lastMessageId
                ChatManager.shared.updateUnreads()
            }
            
        }
        
        print("socket init!")
    }
    
    func join(conversationId:Int) {
        leave(conversationId: conversationId)
        ChatManager.shared.messages = []
        let room = String(conversationId)
        socket.emit("join", ["room":room])
        self.isJoined = true
    }
    
    func leave(conversationId:Int) {
        let room = String(conversationId)
        socket.emit("leave", ["room":room])
        self.isJoined = false
    }
    
    func createConversation(json:String) {
        checkAndConnect()
        
        socket.emit("createConversation", ["info" : json])
        print("create conversation done")
    }
    
    func checkAndConnect() {
        if(socket.status != .connected) {
            connect()
        } else {
            print("already connected :)")
        }
        
    }
    
    func connect () {
        disconnect()
        socket.connect()
    }
    
    func disconnect() {
        //socket.removeAllHandlers()
        socket.disconnect()
    }
    
    func loadConversation() {
        checkAndConnect()
        
        let uid = UserManager.shared.uid
        socket.emit("loadConversation", ["userId" : uid])
    }
    
    func loadMessage(conversationId:Int, offset:Int, size:Int) {
        if !isJoined {
            return
        }
        socket.emit("loadmessage", ["conversationId":conversationId, "offset":offset, "size":size])
        
    }
    
    func sendMessage(conversationId:Int, userId:String, name:String, message:String, image:String, messageType:Int, updated:Int) {
        if !isJoined {
            return
        }
        socket.emit("message", [
            "conversationId" : String(conversationId),
            "userId" : userId,
            "name" : name,
            "message" : message,
            "image" : image,
            "messageType" : String(messageType),
            "updated" : String(updated)
        ])
        
    }
    
    func uploadImage(data:Any) {
        
        if !isJoined {
            return;
        }
        
        var filename = String(Int(Date().timeIntervalSince1970))
        filename = "hh" + filename
        print("uploadImage, name = " + filename)
        socket.emit("uploadImage", [
            "file" : data,
            "name" : filename
        ]);
    }
    
    func openReadInfo() {
        if !self.isJoined {
            return;
        }
        
        let conversationId = String(ChatManager.shared.conversationId)
        let uid = UserManager.shared.uid
        
        socket.emit("readinfo", [
            "conversationId" : conversationId,
            "userId" : uid
        ])
    }
    
    func sendMsgReadInfo(messageId:Int) {
        if !isJoined {
            return;
        }
        
        let conversationId = String(ChatManager.shared.conversationId)
        let uid = UserManager.shared.uid
        
        socket.emit("readinfo", [
            "conversationId" : conversationId,
            "userId" : uid,
            "lastMessageId" : messageId
        ])
        
    }
    
    func loadReadInfo() {
        
        if !isJoined {
            return;
        }
        
        let conversationId = String(ChatManager.shared.conversationId)
        
        socket.emit("loadreadinfo", [
            "conversationId" : conversationId
        ])
           
    }
    
    func outConversation(uid:String, name:String, conversationId:String) {
        
        print("out conversation => name : " + name + ", conversation id : " + conversationId)
        socket.emit("outconversation", [
            "userId" : uid,
            "name" : name,
            "conversationId" : conversationId
        ])
    
    }
    
    
    
}
