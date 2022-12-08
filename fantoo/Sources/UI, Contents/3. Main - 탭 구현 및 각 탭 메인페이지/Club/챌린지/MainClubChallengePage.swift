//
//  MainClubChallengePage.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/01.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct MainClubChallengePage {
    @StateObject var viewModel = MainClubChallengeViewModel()
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
    
    /**
     * 언어팩 등록할 것
     */
    private let naviTitle = "챌린지"
}

extension MainClubChallengePage: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                challengeListView
            }
            .background(Color.bgLightGray50)
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            self.callRemoteData()
        }
        .navigationType(
            leftItems: [.Back],
            rightItems: [],
            leftItemsForegroundColor: .black,
            rightItemsForegroundColor: .black,
            title: naviTitle,
            onPress: { buttonType in
                
            })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }
    
    var challengeListView: some View {
        LazyVStack(spacing: 10) {
            if viewModel.mainClub_MainPage_Top10.count > 0 {
                ForEach(Array(viewModel.mainClub_MainPage_Top10.enumerated()), id: \.offset) { index, element in
                    
                    BoardRowView(
                        viewType: BoardType.MainClub_ChallengePage,
                        mainClub_ChallengePage: element
                    )
                    .background(Color.gray25)
                }
            }
            
            
        }
        
    }
}

extension MainClubChallengePage {
    func callRemoteData() {
        self.viewModel.getMainClub_Challenge()
    }
}

struct MainClubChallengePage_Previews: PreviewProvider {
    static var previews: some View {
        MainClubChallengePage()
    }
}
