

import SwiftUI

struct ChatBubbleView: View {
    
    @State var date = ""
    @State var showAvatar = false
    @State var type = 0
    @State var msg = ""
    @State var unread = 0
    @State var writedate = ""
    @State var showImage = false;
    
    
    var body: some View {
        VStack(spacing:0) {
            //date
            if !date.isEmpty {
                Text(date)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray25)
                    .padding([.leading,.trailing], 7)
                    .padding([.top,.bottom], 3)
                    .background(Color.gray400)
                    .clipShape(Capsule())
                
                Spacer().frame(width:0, height:24)
            }
            
            //receive
            if type == 1 {
                receiveMessage
            }
            //send
            else if type == 2 {
                sendMessage
            }
        
        }
        .padding(.bottom, writedate.isEmpty ? 4 : 24)
        .padding([.leading, .trailing], 20)
    }
    
    var sendMessage : some View {
        VStack(alignment:.trailing, spacing:1) {
            
            HStack(alignment:.bottom, spacing:4) {
                
                Spacer()
                
                VStack(alignment:.trailing, spacing:0) {
                    if unread != 0 {
                        Text(String(unread))
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.primary500)
                        
                    }
                    
                    if !writedate.isEmpty {
                        Text("오후 3:22")
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.gray400)
                    }
                }
                
                if showImage {
                    
                    Image("profile_main club_bg")
                        .resizable()
                        .frame(width:149, height:178)
                        .cornerRadius(12)
                    
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
                    Image("profile_character_manager")
                        .resizable()
                        .frame(width:22, height:22)
                    
                    Text("Dasol")
                        .font(Font.caption11218Regular)
                        .foregroundColor(Color.gray400)
                    
                    Spacer()
                }
                .frame(maxWidth:.infinity)
                
                Spacer().frame(width:0, height:2)
            }
            
            HStack(alignment:.bottom, spacing:4) {
                
                Spacer().frame(width:26, height:10)
                
                if showImage {
                    
                    Image("profile_main club_bg")
                        .resizable()
                        .frame(width:149, height:178)
                        .cornerRadius(12)
                    
                } else {
                    HStack {
                        Text(msg)
                            .font(Font.body21420Regular)
                            .foregroundColor(Color.gray900)
                    }.padding([.leading, .trailing], 18)
                        .padding([.top, .bottom], 12)
                        .background(Color.gray25)
                        .cornerRadius([.bottomLeft, .bottomRight, .topRight],14)
                        .shadow(radius: 2)
                }
                
                VStack(alignment:.leading, spacing:0) {
                    if unread != 0 {
                        Text(String(unread))
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.primary500)
                        
                    }
                    
                    if !writedate.isEmpty {
                        Text("오후 3:22")
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.gray400)
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth:.infinity)
        }

    }
}


