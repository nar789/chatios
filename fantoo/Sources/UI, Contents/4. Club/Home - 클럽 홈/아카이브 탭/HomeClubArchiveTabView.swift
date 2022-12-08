//
//  HomeClubArchiveTabView.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/18.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeClubArchiveTabView {
    //@StateObject var viewModel = HomeClubArchiveTabViewModel()
    var viewModel: HomeClubArchiveTabViewModel
    @State var clickedItemPosition: Int = 0
    @State var showArchiveView: Bool = false
    @State var isThereImage: Bool = false
    @State var clickedItemImages: [Post_Thumbnail] = []
    
    /**
     * 언어팩 등록할 것
     */
    private let swiftui = ""
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
}

extension HomeClubArchiveTabView: View {
    var body: some View {
        ZStack {
            
            if showArchiveView {
                HomeClubArchiveView(
                    showArchiveView: $showArchiveView,
                    isThereImage: $isThereImage,
                    images: $clickedItemImages
                )
            } else {
                VStack(spacing: 12) {
                    
                    if let listItem = viewModel.homeClub_TabArchiveModel_Data {
                        if listItem.count > 0 {
                            
                            ForEach(Array(listItem.enumerated()), id: \.offset) { index, element in
                                
                                if element.post_thumbnail.count > 0 {
                                    imageView(
                                        title: element.title,
                                        file_count: element.file_count,
                                        post_thumbnail: element.post_thumbnail
                                    )
                                    .onTapGesture {
                                        showArchiveView = true
                                        isThereImage = true
                                        clickedItemImages = element.post_thumbnail
                                    }
                                }
                                else {
                                    noImageView(
                                        title: element.title,
                                        file_count: element.file_count
                                    )
                                    .onTapGesture {
                                        showArchiveView = true
                                        isThereImage = false
                                    }
                                }
                            }
                        }
                        else {
                            Text("Empty View")
                        }
                    }
                }
                .padding(sizeInfo.Hpadding)
        //        .onAppear {
        //            self.callRemoteData()
        //        }
            }
        }
        
    }
    
}

struct noImageView: View {
    let title: String
    let file_count: Int
    
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.body21420Regular)
                .foregroundColor(.gray870)
            Spacer()
            Text(String(file_count))
                .font(.buttons1420Medium)
                .foregroundColor(.gray870)
                .padding(.horizontal, 6)
                .frame(height: 22, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .background(RoundedRectangle(cornerRadius: 6).fill(Color(UIColor(red: 0.94, green: 0.94, blue: 1.0, alpha: 1.0))))
        }
        .padding(14)
        .frame(height: 50)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray25))
        .shadow(color: Color.gray400.opacity(0.15), radius: 3)
    }
}

struct imageView: View {
    let title: String
    let file_count: Int
    let post_thumbnail: [Post_Thumbnail]
    
    /**
     * 언어팩 등록할 것
     */
    private let imageTagName = "Photos"
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                
                Text(imageTagName)
                    .font(.caption11218Regular)
                    .foregroundColor(.gray25)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 2)
                    .frame(height: 22, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor(red: 1.0, green: 0.62, blue: 0.62, alpha: 1.0))))
                Text(title)
                    .font(.body21420Regular)
                    .foregroundColor(.gray870)
                    .padding(.leading, 8)
                Spacer()
                Text(String(file_count))
                    .font(.buttons1420Medium)
                    .foregroundColor(.gray870)
                    .padding(.horizontal, 6)
                    .frame(height: 22, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .background(RoundedRectangle(cornerRadius: 6).fill(Color(UIColor(red: 0.94, green: 0.94, blue: 1.0, alpha: 1.0))))
            }
            
            HStack(spacing: 0) {
                if post_thumbnail.count > 0 {
                    // 최상위 3개만 보여줌
                    ForEach(0..<3, id: \.self) { i in
                        WebImage(url: URL(string: post_thumbnail[i].url))
                            .resizable()
                            .frame(width: 22, height: 22, alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .padding(.trailing, 4)
                    }
                }
                Spacer()
            }
            .padding(.top, 8)
            
            Spacer()
        }
        .padding(14)
        .frame(height: 80)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray25))
        .shadow(color: Color.gray400.opacity(0.15), radius: 3)
    }
}

extension HomeClubArchiveTabView {
    func callRemoteData() {
        self.viewModel.getTabArchive()
    }
}

//struct HomeClubArchiveTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeClubArchiveTabView()
//    }
//}
