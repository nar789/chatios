//
//  LoadingViewInPage.swift
//  fantoo
//
//  Created by mkapps on 2022/06/11.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct LoadingViewInPage: View {
    
    @Binding var loadingStatus: LoadingStatus
    @StateObject var vm = LoadingViewModel()
    @StateObject var statusManager = StatusManager.shared

    
    var body: some View {
        ZStack {
            Color.black.opacity((vm.loadingStatus == .ShowWithTouchable || vm.loadingStatus == .Close) ? 0.0 : 0.4)
                .ignoresSafeArea()
                .onChange(of: loadingStatus) { newValue in
                    if vm.loadingStatus != newValue {
                        vm.loadingStatus = newValue
                    }
                }
                .onChange(of: vm.loadingStatus) { newValue in
                    if loadingStatus != newValue {
                        loadingStatus = newValue
                    }
                }
                .onChange(of: statusManager.stopAllLoadingState) { newValue in
                    loadingStatus = .Close
                    vm.loadingStatus = .Close
                }
            
            if vm.loadingStatus == .Close {
            }
            else {
                AnimatedImage(name: "character_loading.gif")
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
                    .animation(nil)
            }
        }
        
        .animation(nil)
        .opacity(vm.loadingStatus == .Close ? 0.0 : 1.0)
        //.transition(.asymmetric(insertion: AnyTransition.opacity, removal: AnyTransition.opacity))
        .animation(.default)
    }
}
