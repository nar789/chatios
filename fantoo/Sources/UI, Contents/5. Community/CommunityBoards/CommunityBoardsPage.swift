//
//  CommunityBoardsPage.swift
//  fantoo
//
//  Created by mkapps on 2022/06/14.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct CommunityBoardsPage: View {
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let padding5: CGFloat = 5.0
    }
    
    @State var isFavorite: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            CommunityBoardsSortView(isOn: $isFavorite)
            
            ZStack {
                if isFavorite {
                    CommunityBoardsNodataView()
                }
                else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            CommunityBoardsListView(onPress: { buttonType in
                                print("buttonType : \(buttonType)")
                            })
                            CommunityBoardsListView(onPress: { buttonType in
                            })
                            CommunityBoardsListView(onPress: { buttonType in
                            })
                            CommunityBoardsListView(onPress: { buttonType in
                            })
                            CommunityBoardsListView(onPress: { buttonType in
                            })
                            CommunityBoardsListView(onPress: { buttonType in
                            })
                            CommunityBoardsListView(onPress: { buttonType in
                            })
                        }
                        .modifier(ScrollViewLazyVStackModifierBottom())
                    }
                }
                
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
        }
        
        .background(Color.gray25)
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "k_community_board".localized, onPress: { buttonType in
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
        
    }
}


struct CommunityBoardsPage_Previews: PreviewProvider {
    static var previews: some View {
        CommunityBoardsPage()
    }
}
