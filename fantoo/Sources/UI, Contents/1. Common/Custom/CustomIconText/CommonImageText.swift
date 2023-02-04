//
//  CommonImageText.swift
//  fantoo
//
//  Created by fns on 2022/05/15.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI


struct CommonImageText : View {
    var image : String
    var description : String
    
    var body: some View {
        
        HStack() {
            VStack() {
                if description.count > 40 {
                    Image(image)
                        .renderingMode(.template)
                        .resizable()
                    
                        .foregroundColor(Color.gray500)
                        .frame(width: 15, height: 15, alignment: .top)
                        .padding(.bottom, 13)
                } else {
                    Image(image)
                        .renderingMode(.template)
                        .resizable()
                    //                    .padding(10)
                        .foregroundColor(Color.gray500)
                        .frame(width: 15, height: 15, alignment: .top)
                }
            }
            
            VStack() {
                Text(description)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray500)
                
            }
        }
    }
}
struct CommonImageText_Previews: PreviewProvider {
    static var previews: some View {
        CommonImageText(image: "icon_outline_danger", description: "8~20자리 이내의 숫자, 영문(대소문자 구분없음), 특수문자(!@#$%&*)조합으로 입력해주세요.")
    }
}




