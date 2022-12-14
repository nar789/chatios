//
//  HomeClubArchiveView.swift
//  fantoo
//
//  Created by kimhongpil on 2022/09/16.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeClubArchiveView {
    @StateObject var viewModel = HomeClubArchiveViewModel()
    @Binding var showArchiveView: Bool
    @Binding var isThereImage: Bool
    @State var noImageViewItems = [HomeClub_TabFreeboardModel_FreeBoard]()
    
    /**
     * Images View
     */
    @Binding var images: [Post_Thumbnail]
    let columns = [
        GridItem(.fixed(123)),
        GridItem(.fixed(123)),
        GridItem(.fixed(123))
    ]
    
    /**
     * 언어팩 등록할 것
     */
    private let swiftui = ""
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
}

extension HomeClubArchiveView: View {
    var body: some View {
        ZStack {
            /**
             * 목록에서 아이템 클릭시, struct 를 새로 불러오는 구조가 아니기 때문에
             * 아래와 같이 어느 View (imagesView / noImagesView)를 보여줄 것인지 결정하는 함수를 만들어 적용했음
             */
            observeViewState()
            
            VStack(spacing: 0) {
                commenHeader
                
                if isThereImage {
                    imagesView
                } else {
                    Divider()
                    noImagesView
                }
            }
        }
    }
    
    var commenHeader: some View {
        HStack(spacing: 0) {
            Button(action: {
                showArchiveView = false
            }, label: {
                Image("icon_outline_move_favorite")
            })
             
            Text("BTS 라이브 모음집")
                .font(.caption11218Regular)
                .foregroundColor(.primary600)
                .padding(.vertical, 4)
                .padding(.horizontal, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20).fill(Color.stateEnablePrimary100)
                )
                .padding(.leading, 10)
            
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, sizeInfo.Hpadding)
    }
    
    var imagesView: some View {
        ScrollView {
            LazyVGrid(columns: columns, content: {
                ForEach(images, id: \.self) { row in
                    WebImage(url: URL(string: row.url))
                        .resizable()
                        .frame(height: 123)
                }
            })
        }
    }
    
    var noImagesView: some View {
        VStack(spacing: 8) {
            ForEach(viewModel.homeClub_TabFreeboardModel_FreeBoard, id: \.self) { item in
                
                BoardRowView(
                    viewType: BoardType.HomeClub_TabArchive_NoImageView,
                    homeClub_TabFreeboardItem: item
                )
                .background(Color.gray25)
            }
        }
    }
    
    func observeViewState() -> some View {
        if showArchiveView && !isThereImage {
            viewModel.getNoImageView()
        }
        
        return EmptyView()
    }
}

extension HomeClubArchiveView {
    func callRemoteData() {
        self.viewModel.getNoImageView()
    }
}

//struct HomeClubArchiveView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeClubArchiveView()
//    }
//}
