

import SwiftUI


struct ChatListRowView : View {
    
    
    var body : some View {
        VStack(spacing:0) {
            HStack {
                Spacer().frame(width:16)
                
                VStack(alignment:.leading,spacing:0) {
                    HStack(alignment:.top, spacing:12) {
                        
                        Image("profile_character_manager")
                            .resizable()
                            .frame(width:46, height:46)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        VStack(alignment:.leading, spacing:2) {
                            HStack(alignment: .center, spacing:0) {
                                Text("Dasol")
                                    .font(Font.body21420Regular)
                                    .foregroundColor(Color.gray700)
                                Image("icon_outline_alarm_off")
                                    .resizable()
                                    .frame(width:12, height:12)
                                    .padding(.top, 4)
                                    .tint(Color.gray400)
                            }
                            Text("안녕ㅎㅎ")
                                .font(Font.caption11218Regular)
                                .foregroundColor(Color.gray400)
                        }.frame(alignment:.leading)
                        
                        Spacer()
                        
                        VStack(alignment:.trailing, spacing:6) {
                            Text("오전 9:53")
                                .font(Font.caption21116Regular)
                                .foregroundColor(Color.gray300)
                            VStack(spacing:0) {
                                Text("2")
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(Color.gray800)
                                    .fixedSize(horizontal: true, vertical:true)
                                    .frame(minWidth:26, minHeight:18)
                            }.background(Color.primary100)
                                .cornerRadius(10)
                        }
                        
                    }
                    
                    Spacer().frame(maxWidth:.infinity, maxHeight: 0)
                }.padding()
                    .minHeight(78)
                    .background(Color.gray25)
                    .border(Color.gray700, width:0.2, cornerRadius: 10)
                
                Spacer().frame(width:16)
            }
            
            Spacer().frame(height:10)
        }.swipeActions {
            
            Button("채팅방\n나가기") {
                print("out room")
            }
            .tint(Color.stateDanger)
            .font(Font.caption21116Regular)
            
            Button("차단") {
                print("block user")
            }
            .tint(Color.gray700)
            .font(Font.caption21116Regular)
            
            Button("알림\nON") {
                print("alarm on")
            }
            .tint(Color.primaryDefault)
            .font(Font.caption21116Regular)
            
        }
        
    }
}
