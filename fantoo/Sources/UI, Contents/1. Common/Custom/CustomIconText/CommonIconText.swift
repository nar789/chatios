//
//  CommonIconText.swift
//  fantoo
//
//  Created by fns on 2022/05/03.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct CommonIconText : View {
    var icon : String
    var description : String
    
    
    var body: some View {
        HStack() {
            VStack() {
            Text(icon)
                .font(Font.caption11218Regular)
                .foregroundColor(Color.gray500)
            }
            
            VStack() {
            Text(description)
                .font(Font.caption11218Regular)
                .foregroundColor(Color.gray500)
            }
        }
        .padding(.horizontal, 20)
    }
}

struct CommonIconText_Previews: PreviewProvider {
    static var previews: some View {
        CommonIconText(icon: "•", description: "")
    }
}
