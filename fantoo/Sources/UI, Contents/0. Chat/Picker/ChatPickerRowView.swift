

import SwiftUI
import SDWebImageSwiftUI

struct ChatPickerRowView: View {
    var uid = ""
    var name = ""
    var image:String = ""
    @State var isCheck = false
    @Binding var checkCount:Int
    @Binding var checkMap:[String:Any]
    
    var body: some View {
        VStack(spacing:0) {
            HStack {
                Spacer().frame(width:20)
                
                VStack(alignment:.leading,spacing:0) {
                    HStack(alignment:.center, spacing:9) {
                        
                        Group {
                            WebImage(url: URL(string: image.imageOriginalUrl))
                                .placeholder(content: {
                                    Image("profile_club_character")
                                        .resizable()
                                })
                                .resizable()
                        }
                        .frame(width: 38, height: 38)
                        .cornerRadius(10)
                        
                        VStack(alignment:.leading, spacing:2) {
                            HStack(alignment: .center, spacing:0) {
                                Text(name)
                                    .font(Font.body21420Regular)
                                    .foregroundColor(Color.gray700)
                            }
                        }.frame(alignment:.leading)
                        
                        Spacer()
                        
                        VStack(alignment:.center, spacing:0) {
                            Spacer()
                            HStack(alignment:.center, spacing: 0) {
                                Spacer()
                                Image("icon_fill_check")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Color.gray25)
                                    .frame(width:15,height:15)
                                Spacer()
                            }
                            Spacer()
                        }
                        .background(!isCheck ? Color.stateDisabledGray200 : Color.stateActivePrimaryDefault)
                        .frame(maxWidth:24, maxHeight:24)
                        .cornerRadius(24)
                    }
                    
                    Spacer().frame(maxWidth:.infinity, maxHeight: 0)
                }
                .minHeight(38)
                .background(Color.gray25)
                
                Spacer().frame(width:20)
            }
            .onTapGesture {
                isCheck.toggle()
                if isCheck == true {
                    checkCount+=1
                    checkMap[uid] = ChatComposerUser(uid:uid, nick:name, image:image)
                } else {
                    checkCount-=1
                    checkMap.removeValue(forKey: uid)
                }
            }
            
            Spacer().frame(height:12)
        }
    }
}

