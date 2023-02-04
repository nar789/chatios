

import SwiftUI
import SDWebImageSwiftUI
import SwipeCellSUI

struct ChatListRowView : View {
    
    var id = 0
    var thumbnail = ""
    var title = ""
    var unreads = 0
    var messageType = 0
    var message = ""
    var updated = 0
    var writedate = ""
    @State var currentUserInteractionCellID: String?
    @StateObject var vm:ChatPageViewModel
    let defaults = UserDefaults.standard
    @State var isAlarmOff = false
    
    
    
    
    var body : some View {
        VStack(spacing:0) {
            HStack {
                Spacer().frame(width:16)
                
                VStack(alignment:.leading,spacing:0) {
                    HStack(alignment:.top, spacing:12) {
                        
                        
                        Group {
                            WebImage(url: URL(string: self.thumbnail.imageOriginalUrl))
                                .placeholder(content: {
                                    Image("profile_club_character")
                                        .resizable()
                                })
                                .resizable()
                        }
                        .frame(width: 46, height: 46)
                        .cornerRadius(10)
                        
                        VStack(alignment:.leading, spacing:2) {
                            HStack(alignment: .center, spacing:0) {
                                Text(title)
                                    .font(Font.body21420Regular)
                                    .foregroundColor(Color.gray700)
                                if isAlarmOff {
                                    Image("icon_outline_alarm_off")
                                        .resizable()
                                        .frame(width:12, height:12)
                                        .padding(.top, 4)
                                    //.tint(Color.gray400)
                                }
                            }
                            Text(message)
                                .font(Font.caption11218Regular)
                                .foregroundColor(Color.gray400)
                        }.frame(alignment:.leading)
                        
                        Spacer()
                        
                        VStack(alignment:.trailing, spacing:6) {
                            Text(writedate)
                                .font(Font.caption21116Regular)
                                .foregroundColor(Color.gray300)
                            VStack(spacing:0) {
                                Text(String(unreads))
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(Color.gray800)
                                    .fixedSize(horizontal: true, vertical:true)
                                    .frame(minWidth:26, minHeight:18)
                            }.background(Color.primary100)
                                .cornerRadius(10)
                                .visible(unreads != 0)
                        }
                        
                    }
                    
                    Spacer().frame(maxWidth:.infinity, maxHeight: 0)
                }.padding()
                    .minHeight(78)
                    .background(Color.gray25)
                    .border(Color(red: 91/255.0, green: 93/255.0, blue: 123/255.0, opacity: 0.3), width:0.7, cornerRadius: 10)
                    
                
                Spacer().frame(width:16)
            }
            .swipeCell(id:String(id), leadingSideGroup: [], trailingSideGroup: rightGroup(),  currentUserInteractionCellID:$currentUserInteractionCellID)
            
            Spacer().frame(height:10)
        }
        
    }
    
    
    
    func rightGroup()->[SwipeCellActionItem] {
        
        let items =  [
            SwipeCellActionItem(buttonView: {
    
                    VStack(spacing: 2)  {
                        Text(isAlarmOff ? "알림\nON" : "알림\nOFF")
                                .font(Font.caption21116Regular)
                                .foregroundColor(Color.stateActiveGray25)
                    }.frame(maxHeight: 80).castToAnyView()

            }, backgroundColor: .primaryDefault)
            {
                print("is alarm status = \(isAlarmOff)")
                isAlarmOff.toggle()
                defaults.set(isAlarmOff, forKey: "isConversationAlarmOff\(id)")
                
            },
            SwipeCellActionItem(buttonView: {
                    
                VStack(spacing: 2)  {
                    Text("차단")
                            .font(Font.caption21116Regular)
                            .foregroundColor(Color.stateActiveGray25)
                }.frame(maxHeight: 80).castToAnyView()
          
            }, backgroundColor: .gray700, actionCallback: {
                print("block conversation, conv id = \(id)")
                vm.blockConversation(id: id)
                
            }),
            
            SwipeCellActionItem(buttonView: {
                
                VStack(spacing: 2)  {
                    Text("채팅방\n나가기")
                            .font(Font.caption21116Regular)
                            .foregroundColor(Color.stateActiveGray25)
                }.frame(maxHeight: 80).castToAnyView()
                
                
            }, backgroundColor: .stateDanger, actionCallback: {
                print("out conversation")
                ChatManager.shared.removeConversationItem(id: id)
                vm.outConversation(conversatinoId: id)
            })
        ]
        
        return items
    }
    
}
