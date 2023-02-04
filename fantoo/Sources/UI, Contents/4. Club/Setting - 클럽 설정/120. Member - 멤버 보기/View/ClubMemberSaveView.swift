//
//  ClubMemberSaveView.swift
//  fantoo
//
//  Created by mkapps on 2022/06/25.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct ClubMemberSaveView: View {
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0 ..< 50, id: \.self) { row in
                Text("ㅋㅋㅋㅋㅋㅋ").frame(height: 50)
            }
        }
    }
}


struct ClubMemberSaveView_Previews: PreviewProvider {
    static var previews: some View {
        ClubMemberSaveView()
    }
}
