//
//  HomeClubFreeboardTabView.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/18.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeClubFreeboardTabView {
    //@StateObject var viewModel = HomeClubFreeboardTabViewModel()
    var viewModel: HomeClubFreeboardTabViewModel
    @State var clickedCategoryPosition: Int = 0
    
    /**
     * 언어팩 등록할 것
     */
    private let swiftui = ""
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
}

extension HomeClubFreeboardTabView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            
            categoryView
            
            Divider()
            
            clubListView
            
            Spacer()
        }
//        .onAppear {
//            self.callRemoteData()
//        }
        
    }
    
    var categoryView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                if let category = viewModel.homeClub_TabFreeboardModel_Category {
                    if category.count > 0 {
                        ForEach(Array(category.enumerated()), id: \.offset) { index, element in
                            
                            Button(action: {
                                clickedCategoryPosition = index
                            }, label: {
                                Text(element)
                                    .font(.caption11218Regular)
                                    .foregroundColor(clickedCategoryPosition==index ? Color.gray25 : Color.gray850)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .frame(height: 26)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(clickedCategoryPosition==index ? Color.primary500 : Color.gray200, lineWidth: 0.5))
                                    .background(RoundedRectangle(cornerRadius: 12).fill(clickedCategoryPosition==index ? Color.primary500 : Color.gray50))
                                    .padding(.top, 10)
                                    .padding(.bottom, 8)
                                    .padding(.leading, index==0 ? 20 : 8)
                                    .padding(.trailing, index==category.count-1 ? 20 : 0)
                            })
                            // 버튼 누르고 있을 때, 흰색으로 깜빡이는 효과 제거
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
        }
        .background(Color.gray25)
    }
    
    var clubListView: some View {
        VStack(spacing: 8) {
            if let freeboards = viewModel.homeClub_TabFreeboardModel_FreeBoard {
                ForEach(freeboards, id: \.self) { item in
                    BoardRowView(
                        viewType: BoardType.HomeClub_TabFreeboard,
                        homeClub_TabFreeboardItem: item
                    )
                    .background(Color.gray25)
                }
            }
            
        }
        .background(Color.bgLightGray50)
    }
}

extension HomeClubFreeboardTabView {
    func callRemoteData() {
        self.viewModel.getTabFreeboard()
    }
}

//struct HomeClubFreeboardTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeClubFreeboardTabView()
//    }
//}
