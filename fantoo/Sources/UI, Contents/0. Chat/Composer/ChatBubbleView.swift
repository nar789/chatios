

import SwiftUI
import SocketIO
import SDWebImageSwiftUI


struct ChatBubbleView: View {
    @State var id = ""
    @State var messageId = ""
    @State var uid = ""
    @State var showAvatar = true
    @State var date = ""
    @State var name = ""
    @State var type = 0
    @State var msg = ""
    @State var unread = 0
    @State var writedate = ""
    @State var image:String?
    @State var showPreview = false
    @State var imagePreview:Image?
    @State var messageType = 1
    @Binding var showPopup:Bool
    
    @Binding var infos:[String:ChatUserInfoModel]
    
    var vm:ChatComposeViewModel?
    @State var translateMessage = ""
    @Binding var isTranslate:Bool
    
    let imgHost = "http://nar005.cafe24.com:3000/img/"
    
    @State var popupImage:UIImage?

    
    
    var body: some View {
        VStack(spacing:0) {
            //date
            if !date.isEmpty && messageType != 3 {
                Spacer().frame(width:0, height:10)
                
                Text(date)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray25)
                    .padding([.leading,.trailing], 7)
                    .padding([.top,.bottom], 3)
                    .background(Color.gray400)
                    .clipShape(Capsule())
                
                Spacer().frame(width:0, height:10)
            }
            
            if messageType == 3 {
                HStack(alignment:.center) {
                    Text(isTranslate ? "\(name) has left." :  name + "님이 퇴장했습니다.")
                        .font(Font.caption11218Regular)
                        .foregroundColor(Color.gray400)
                }
                .frame(maxWidth:.infinity)
                
            } else {
                
                //receive
                if type == 1 {
                    receiveMessage
                }
                //send
                else if type == 2 {
                    sendMessage
                }
            }
        
        }
        .padding(.bottom, writedate.isEmpty ? 4 : 15)
        .padding(.top, writedate.isEmpty ? 0 : -5)
        .padding([.leading, .trailing], 20)
        .popup(isPresented: $showPopup, closeOnTap: false, closeOnTapOutside: true) {
            let info = infos[ChatManager.shared.selectedUid]
            VStack {
                if !(info?.userPhoto ?? "").isEmpty {
                    Group {
                        WebImage(url: URL(string: info?.userPhoto.imageOriginalUrl ?? ""))
                            .placeholder(content: {
                                Image("profile_main club_bg")
                                    .resizable()
                            })
                            .resizable()
                    }
                    .frame(width: 54, height: 54)
                    .border(Color.gray25, width:2, cornerRadius: 16)
                    .zIndex(2)
                } else {
                    Image("profile_club_character")
                        .resizable()
                        .frame(width: 54, height: 54)
                        .border(Color.gray25, width:2, cornerRadius: 16)
                        .zIndex(2)
                }
                
                VStack(spacing:0) {
                    
                    HStack(alignment: .top) {
                        Spacer()
                        Image("icon_outline_cancel")
                            .resizable()
                            .frame(width:24, height:24)
                            .padding(.trailing, 18)
                    }
                    .frame(maxWidth:.infinity)
                    .padding(.top, 18)
                    .onTapGesture {
                        showPopup = false
                    }
                    
                    HStack(alignment: .top) {
                        Text(info?.userNick ?? "")
                            .font(Font.title41824Medium)
                    }.padding(.top, -5)
                    
                    Spacer()
                        .frame(height:14)
                    
                    HStack(spacing:47) {
                        let isFollow = info?.followYn ?? false
                        let isBlock = info?.blockYn ?? false
                        VStack {
                            Image("icon_outline_addfriend")
                                .resizable()
                                .frame(width:32, height:32)
                            
                            VStack {
                                
                                Text(isFollow ? "팔로잉" : "팔로우")
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(isFollow ? Color.primary500 : Color.gray25)
                            }.frame(width:50, height: 26)
                                .background(isFollow ? Color.bgLightGray50 : Color.primary500)
                                .border(Color.primary500, width: 1, cornerRadius: 6)
                                .onTapGesture {
                                    if isFollow == false {
                                        vm?.follow(targetUid: ChatManager.shared.selectedUid)
                                    } else {
                                        vm?.unfollow(targetUid: ChatManager.shared.selectedUid)
                                    }
                                }
                            
                        }
                        VStack {
                            Image("icon_outline_blockaccount")
                                .resizable()
                                .frame(width:32, height:32)
                            
                            VStack {
                                Text(isBlock ? "차단해제" : "차단하기")
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(isBlock ? Color.primary500 : Color.gray25)
                            }.frame(width:50, height: 26)
                                .background(isBlock ? Color.bgLightGray50 : Color.primary500)
                                .border(Color.primary500, width: 1, cornerRadius: 6)
                                .onTapGesture {
                                    if isBlock == false {
                                        vm?.block(targetUid: ChatManager.shared.selectedUid)
                                    } else {
                                        vm?.unblock(targetUid: ChatManager.shared.selectedUid)
                                    }
                                }
                            
                        }
                    }.padding(.top, 20)
                    
                    Spacer()
                    
                }.frame(maxWidth: 276, maxHeight: 192)
                    .background(Color.gray25)
                    .cornerRadius(30.0)
                    .padding(.top, -30)
            }
        }
        
    }
    
    var sendMessage : some View {
        VStack(alignment:.trailing, spacing:1) {
            
            HStack(alignment:.bottom, spacing:4) {
                
                Spacer()
                
                VStack(alignment:.trailing, spacing:0) {
                    if unread > 0 {
                        Text(String(unread))
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.primary500)
                        
                    }
                    
                    if !writedate.isEmpty {
                        Text(writedate)
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.gray400)
                    }
                }
                
                if !image!.isEmpty {
                    Group {
                        WebImage(url: URL(string: imgHost + image!))
                            .placeholder(content: {
                                Image("profile_main club_bg")
                                    .resizable()
                            })
                            .onSuccess { image, data, cacheType in
                                imagePreview = Image(uiImage:image)
                            }
                            .resizable()
                    }
                    .frame(width: 149, height: 178)
                    .cornerRadius(12)
                    .padding([.top, .bottom], 0)
                    .onTapGesture {
                        print("preview " + imgHost + image!)
                        showPreview = true
                    }
                    .sheet(isPresented: $showPreview) {
                        VStack {
                            Text("Preview")
                        }
                        .frame(maxWidth:.infinity, maxHeight: .infinity)
                        .overlay(ImageViewer(image:self.$imagePreview, viewerShown: $showPreview))
                    }
                    
                    
                } else {
                    HStack {
                        Text(msg)
                            .font(Font.body21420Regular)
                            .foregroundColor(Color.gray25)
                    }.padding([.leading, .trailing], 18)
                        .padding([.top, .bottom], 12)
                        .background(Color.gray700)
                        .cornerRadius([.bottomLeft, .bottomRight, .topLeft],14)
                        .shadow(radius: 2)
                }
                
            }
            .frame(maxWidth:.infinity)
        }
    }
    
    var receiveMessage : some View {
        VStack(alignment:.leading, spacing:1) {
            if showAvatar {
                HStack(spacing:6) {
                    if !(infos[uid]?.userPhoto ?? "").isEmpty {
                        Group {
                            WebImage(url: URL(string: infos[uid]!.userPhoto.imageOriginalUrl))
                                .placeholder(content: {
                                    Image("profile_club_character")
                                        .resizable()
                                })
                                .onSuccess { image, data, cacheType in
                                    popupImage = image
                                }
                                .resizable()
                        }
                        .frame(width: 22, height: 22)
                        .cornerRadius(6)
                        .onTapGesture {
                            if popupImage != nil {
                                print("popup image " + uid)
                                ChatManager.shared.selectedUid = uid
                                ChatManager.shared.selectedMessageId = id
                                showPopup = true
                            }
                        }
                    } else {
                        Image("profile_club_character")
                            .resizable()
                            .frame(width: 22, height: 22)
                            .cornerRadius(6)
                            .onTapGesture {
                                print("popup image " + uid)
                                ChatManager.shared.selectedUid = uid
                                ChatManager.shared.selectedMessageId = id
                                showPopup = true
                            }
                    }
                    
                    
                    Text(name)
                        .font(Font.caption11218Regular)
                        .foregroundColor(Color.gray400)
                    
                    Spacer()
                }
                .frame(maxWidth:.infinity)
                
                Spacer().frame(width:0, height:2)
            }
            
            HStack(alignment:.bottom, spacing:4) {
                
                Spacer().frame(width:26, height:10)
                
                if !image!.isEmpty {
                    
                    Group {
                        WebImage(url: URL(string: imgHost + image!))
                            .placeholder(content: {
                                Image("profile_main club_bg")
                                    .resizable()
                            })
                            .onSuccess { image, data, cacheType in
                                imagePreview = Image(uiImage:image)
                            }
                            .resizable()
                    }
                    .frame(width: 149, height: 178)
                    .cornerRadius(12)
                    .padding([.top, .bottom], 0)
                    .onTapGesture {
                        print("preview " + imgHost + image!)
                        showPreview = true
                    }
                    .sheet(isPresented: $showPreview) {
                        VStack {
                            Text("Preview")
                        }
                        .frame(maxWidth:.infinity, maxHeight: .infinity)
                        .overlay(ImageViewer(image:self.$imagePreview, viewerShown: $showPreview))
                    }
                    
                    
                } else {
                    HStack {
                        Text(isTranslate ? translateMessage : msg)
                            .font(Font.body21420Regular)
                            .foregroundColor(Color.gray900)
                    }.padding([.leading, .trailing], 18)
                        .padding([.top, .bottom], 12)
                        .background(Color.gray25)
                        .cornerRadius([.bottomLeft, .bottomRight, .topRight],14)
                        .shadow(radius: 2)
                }
                
                VStack(alignment:.leading, spacing:0) {
                    if unread > 0 {
                        Text(String(unread))
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.primary500)
                        
                    }
                    
                    if !writedate.isEmpty {
                        Text(writedate)
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.gray400)
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth:.infinity)
        }
        .onAppear {
            print("kkk")
            vm?.translate(id: messageId, text: msg, user: uid) { text in
                translateMessage = text
                print("t => \(text)")
            }
        }

    }
}


