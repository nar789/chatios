//
//  NotificationService.swift
//  NotificationService
//
//  Created by mkapps on 2022/02/17.
//  Copyright © 2022 SendBird. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        print("NotificationService didReceive")
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
    
        if var bestAttemptContent = bestAttemptContent {
            let userInfo = bestAttemptContent.userInfo
            let aps = userInfo["aps"] as? [String: Any] ?? [String: Any]()
            
            print("================PUSH INFO====================")
            print("userInfo :: \(userInfo)")
            print("aps   :: \(aps)")
            print("title :: \(bestAttemptContent.title)")
            print("body  :: \(bestAttemptContent.body)")
            print("=============================================")
            
            if let sendbird = userInfo["sendbird"] as? [String: Any] {
                bestAttemptContent = modifySendbirdPush(bestAttemptContent, with: sendbird)
            }
            
            if let fns = userInfo["fns"] as? String { // {"type":"management_new_application","club_code":"GIDLE_1_1583399243739"}
                bestAttemptContent = modifyFnsPush(bestAttemptContent, with: convertToDict(from: fns))
            }
            bestAttemptContent.sound = .default
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

    func modifySendbirdPush(_ content: UNMutableNotificationContent, with sendbirdMsg: [String: Any]) -> UNMutableNotificationContent{
        let channel = sendbirdMsg["channel"] as! [String: Any]
        
        let type = sendbirdMsg["type"] as! String
        let customType = channel["custom_type"] as? String ?? ""
        
        let sender = sendbirdMsg["sender"] as? [String: Any] ?? ["name": ""]
        let senderName = sender["name"] as? String ?? "(No_Name)" // TODO: Localized
        
        var title = senderName
        var message = sendbirdMsg["message"] as? String ?? ""
        
        if type == "MESG" {
            print("Sendbird Message Type : MESG")
            
            if customType == "GROUP_SECRET" || customType == "GROUP_FANCLUB_SECRET" {
                title = "FANTOO"
                message = "\(senderName)님이 비밀대화 메세지를 보냈습니다."  // TODO: Localized
            }else {
                title = senderName
            }
            
        }else if type == "FILE" {
            print("Sendbird Message Type : FILE")
            
            if customType == "GROUP_SECRET" || customType == "GROUP_FANCLUB_SECRET" {
                title = "FANTOO"
                message = "\(senderName)님이 비밀대화 메세지를 보냈습니다."  // TODO: Localized
            }else {
                title = senderName
            }
            
        }else if type == "ADMM" {
            print("Sendbird Message Type : ADMM")
            
            title = "FANTOO"
        }
        
        message = replacingEmojiTag(from: message)
        
        content.title = title
        content.body = message
        
        return content
        /*
         {
             "app_id" = "43AFC18A-E5A3-4036-8DA1-1B9567E6B0CD";
             "audience_type" = only;
             category = "messaging:offline_notification";
             channel =     {
                 "channel_url" = "sendbird_group_channel_15429891_a05a62dd42adb7124a6ba4ab730bf21ca9a1d92b";
                 "custom_type" = "";
                 name = "\Ucd08\Ucf54";
             };
             "channel_type" = messaging;
             "created_at" = 1588844699080;
             "custom_type" = "";
             files = (
             );
             "mentioned_users" = (
             );
             message = acac;
             "message_id" = 504319563;
             "push_sound" = default;
             recipient = {
                 id = testerb1;
                 name = "\Ucd08\Ucf54";
                 "push_template" = default;
             };
             sender = {
                 id = testerb3;
                 name = testerb3;
                 "profile_url" = "uploads/0F7E90E7-6BF0-4D9B-9796-549100456363-1588818059221.jpeg";
             };
             translations = {
             };
             type = MESG;
             "unread_message_count" = 31;
         }
         */
    }
    
    func replacingEmojiTag(from msg : String) -> String{
        let emojiStartTag = "<<emoji_S>>"
        let emojiEndTag = "<<emoji_E>>"
        let emojiStr = "Emoticon".localized
        
        // 이모티콘을 포함하지 않은 경우
        if !msg.contains(emojiStartTag) { return msg }
        
        var str = String()
        
        let arr = msg.components(separatedBy: emojiStartTag)
        for tmpStr in arr {
            if tmpStr.contains(emojiEndTag) {
                let arr2 = tmpStr.components(separatedBy: emojiEndTag)
                str.append(contentsOf: emojiStr)
                str.append(contentsOf: arr2[1])
            }else {
                str.append(contentsOf: tmpStr)
            }
        }
        
        // 문자열도 없이 이모티콘 하나만 보냈을 경우
        if str.components(separatedBy: emojiStr).count == 2 && str.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: emojiStr, with: "").isEmpty {
            str = "Channel_List_Emoji_Msg".localized
        }
        
        return str
    }
    
    func modifyFnsPush(_ content: UNMutableNotificationContent, with fnsMsg: [String: Any]) -> UNMutableNotificationContent{
        var title = content.title
        var body = content.body
        
        if let msg_type = fnsMsg["msg_type"] as? String {
            
            let target = fnsMsg["target"] as? String ?? ""
            
            let title_kr = fnsMsg["title_kr"] as? String ?? ""
            let title_en = fnsMsg["title_en"] as? String ?? ""
            let msg_kr = fnsMsg["msg_kr"] as? String ?? ""
            let msg_en = fnsMsg["msg_en"] as? String ?? ""
            let image_url = fnsMsg["image_url"] as? String ?? ""
            
            switch msg_type {
            case "request_club_join":      //본인 팬클럽에 가입요청이 올때
                body = String(format: "request_club_join".localized, target)
            case "declined_club_join":              //팬클럽 가입이 거절되었을때
                body = String(format: "declined_club_join".localized, target)
            case "approved_club_join":              //팬클럽 가입이 승인되었을때
                body = String(format: "approved_club_join".localized, target)
            case "new_comment_your_post":              //본인 게시물에 댓글이 달릴 때
                body = "new_comment_your_post".localized
            case "new_post_joined_club":              //가입한 클럽에 게시물이 게시되었을 때
                body = String(format: "new_post_joined_club".localized, target)
            case "custom":              //이벤트 푸시
                if deviceLanguageCode() == "ko" {
                    title = title_kr
                    body = msg_kr
                }
                else {
                    title = title_en
                    body = msg_en
                }
                
            default:
                body = content.body
            }
            
            //check image
            if image_url.count > 0 {
                do {
                    let imageData = try Data(contentsOf: URL(string: image_url)!)
                    let attachment = UNNotificationAttachment.create(imageFileIdentifier: "image.png", data: imageData, options: nil)
                    content.attachments = [attachment!]
//                    contentHandler(content.copy() as! UNNotificationContent)
                    
                } catch {
//                    failEarly()
                }
//                let imageAttachment = try? UNNotificationAttachment(
//                    identifier: "image",
//                    url: URL(string: image_url)!,
//                    options: nil)
//
//                if let imageAttachment = imageAttachment {
//                    content.attachments = [imageAttachment]
//                  }
            }
        }
        
        content.title = title
        content.body = body
        
        return content
    }
    
    func deviceLanguageCode() -> String{
        guard let defaults = UserDefaults(suiteName: "group.rndeep.fantoo") else {
            return "en"
        }
        
        if let languageCode = defaults.string(forKey: "Apple") {
            return languageCode
        }
        else {
            var lang = NSLocale.current.languageCode ?? "en"
            if lang == "zh" {
                lang = "zh-" + (NSLocale.current.scriptCode ?? "")
            }
            
            defaults.set(lang, forKey: "Apple")
            
            return lang
        }
    }
    
    func convertToDict(from strJson: String) -> [String: Any]{
        if strJson.isEmpty {
            return [:]
        }
        do{
            let data:Data? = strJson.data(using: .utf8)
            let json = try JSONSerialization.jsonObject(with: data!, options: [])

            if json is [String: Any] {
                return json as! [String: Any]
            } else {
                return [:]
            }
        }catch{
            return [:]
        }
    }
}


/*. Sendbird Call
 userInfo :: [AnyHashable("aps"): {
     alert = "Incoming call from Rndeep";
     category = "sendbird_mesg";
     "mutable-content" = 1;
     sound = default;
 }, AnyHashable("sendbird_call"): {
     command =     {
         cmd = CALL;
         "delivery_info" =         {
             type = push;
         };
         "message_id" = "3ab5375e-a5fa-4a4f-b4a5-d8fdf9b6efcb";
         payload =         {
             "call_id" = "01B569FF-EDD1-4068-A0A7-73651551B94E";
             callee =             {
                 "is_active" = 1;
                 metadata =                 {
                     "_id" = 5db8eb17ba186c686246851a;
                 };
                 nickname = testerb22;
                 "profile_url" = "uploads/8A10AF49-071A-453C-B369-99F19B9020F6-1588818125686.jpeg";
                 role = "dc_callee";
                 "user_id" = testerb2;
             };
             caller =             {
                 "is_active" = 1;
                 metadata =                 {
                 };
                 nickname = Rndeep;
                 "profile_url" = "";
                 role = "dc_caller";
                 "user_id" = 876510;
             };
             constraints =             {
                 audio = 1;
                 video = 1;
             };
             "custom_items" =             {
             };
             "is_video_call" = 0;
             "sbcall_short_lived_token" = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhIjoiNDNBRkMxOEEtRTVBMy00MDM2LThEQTEtMUI5NTY3RTZCMENEIiwidSI6InRlc3RlcmIyIiwidiI6MSwiZXhwIjoxNjAzNjk5MTA0fQ.3uttCoFguOcvie7Yb3bOJrGdWLkLu9WukvYTAf5S2I0";
             "turn_credential" =             {
                 password = "tW2ueVNr9fuWPz3aJuCZA48JzRQ=";
                 "transport_policy" = all;
                 "turn_urls" =                 (
                     "turn:turn-15-164-208-249-ap-2.calls.sendbird.com:5349",
                     "turn:turn-13-125-177-173-ap-2.calls.sendbird.com:5349"
                 );
                 username = "1603785444:01B569FF-EDD1-4068-A0A7-73651551B94E-dGVzdGVyYjI=";
             };
         };
         "sequence_number" = 0;
         type = dial;
         version = 1;
     };
     "is_voip" = 1;
     "push_alert" = "Incoming call from Rndeep";
     "push_sound" = default;
     "receiver_type" = user;
     "user_id" = testerb2;
 }]
 aps   :: ["category": sendbird_mesg, "alert": Incoming call from Rndeep, "sound": default, "mutable-content": 1]
 title ::
 body  :: Incoming call from Rndeep
 
 */
