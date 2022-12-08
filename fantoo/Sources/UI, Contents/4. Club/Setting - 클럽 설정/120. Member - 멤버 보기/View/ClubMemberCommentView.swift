//
//  ClubMemberCommentView.swift
//  fantoo
//
//  Created by mkapps on 2022/06/25.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct ClubMemberCommentView: View {
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0 ..< 50, id: \.self) { row in
                Text("ㅎㅎㅎㅎㅎㅎㅎ").frame(height: 50)
            }
        }
    }
}


struct ClubMemberCommentView_Previews: PreviewProvider {
    static var previews: some View {
        ClubMemberCommentView()
    }
}
