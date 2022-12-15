

import SwiftUI

struct ChatPickerRowView: View {
    var name = ""
    @State var isCheck = false
    @Binding var checkCount:Int
    
    var body: some View {
        VStack(spacing:0) {
            HStack {
                Spacer().frame(width:20)
                
                VStack(alignment:.leading,spacing:0) {
                    HStack(alignment:.center, spacing:9) {
                        
                        Image("profile_character_manager")
                            .resizable()
                            .frame(width:38, height:38)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
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
                } else {
                    checkCount-=1
                }
            }
            
            Spacer().frame(height:12)
        }
    }
}

