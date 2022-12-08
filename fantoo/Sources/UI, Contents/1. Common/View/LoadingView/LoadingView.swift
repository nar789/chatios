//
//  LoadingView.swift
//  fantoo
//
//  Created by mkapps on 2022/06/11.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct LoadingView: View {
    @StateObject var statusManager = StatusManager.shared
    
    var body: some View {
        ZStack {
//            Color.black.opacity(statusManager.loadingStatus == .ShowWithTouchable ? 0.0 : 0.4)
//                .ignoresSafeArea()
            
            Circle()
                .fill(Color.gray25.opacity(0.75))
                .frame(width: 100, height: 100)
                .shadow(color: .black.opacity(0.16), radius: 10, x: 0, y: 0)
                
            // 이상하게도..
            // Assets.xcassets 과 /Resources/Image 경로 둘 다 파일이 있어야 됨
            if statusManager.loadingStatus == .Close {
                
            }
            else {
                AnimatedImage(name: "character_loading.gif")
                    .resizable()
                    .frame(width: 200, height: 200)
            }
        }
        .animation(nil)
        .opacity(statusManager.loadingStatus == .Close ? 0.0 : 1.0)
        //.transition(.asymmetric(insertion: AnyTransition.opacity, removal: AnyTransition.opacity))
        .animation(.default)
    }
}
