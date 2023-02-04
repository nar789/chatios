//
//  ClubMemberPostView.swift
//  fantoo
//
//  Created by mkapps on 2022/06/25.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//


import SwiftUI

struct ClubMemberPostView: View {
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
    }
    
    var body: some View {
        ScrollView {
            
            LazyVStack {
                ForEach(0 ..< 50, id: \.self) { row in
                    Text("123123").frame(height: 50)
                }
            }
        }
    }
}


struct ClubMemberPostView_Previews: PreviewProvider {
    static var previews: some View {
        ClubMemberPostView()
    }
}
