//
//  CustomDivider.swift
//  fantoo
//
//  Created by mkapps on 2022/06/04.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct CustomDivider: View {
    
    let height: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Color.gray100
            }
            .padding([.leading, .trailing], 0)
            .frame(height: 0.5)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Color.bgLightGray50
            }
            .padding([.leading, .trailing], 0)
            .frame(height: height)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Color.gray100
            }
            .padding([.leading, .trailing], 0)
            .frame(height: 0.5)
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
    }
}

struct CustomDivider_Previews: PreviewProvider {
    static var previews: some View {
        CustomDivider(height: 10.0)
            .previewLayout(.sizeThatFits)
    }
}
