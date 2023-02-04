//
//  AlertPage.swift
//  fantoo
//
//  Created by kimhongpil on 2022/09/06.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct AlertPage {
    @StateObject var viewModel = AlertPageViewModel()
    
    /**
     * 언어팩 등록할 것
     */
    private let naviTitle = "알림"
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
}

extension AlertPage: View {
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.primary600.opacity(0.12))
                .padding(.top, 10)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    itemView
                    
                    Spacer()
                }
            }
        }
        .onAppear() {
            self.callRemoteData()
        }
        .navigationType(
            leftItems: [.Back],
            rightItems: [.AlertAllRead],
            leftItemsForegroundColor: .black,
            rightItemsForegroundColor: viewModel.isClickAllRead ? Color.stateEnableGray200 : Color.primary500,
            title: naviTitle,
            onPress: { buttonType in
                if buttonType == .AlertAllRead {
                    viewModel.isClickAllRead = true
                }
            })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }
    
    var itemView: some View {
        Group {
            if let itemData = viewModel.alertData {
                ForEach(Array(itemData.enumerated()), id: \.offset) { index, element in
                    
                    HStack(alignment: .top, spacing: 0) {
                        WebImage(url: URL(string: element.alert_thumbnail))
                            .resizable()
                            .frame(width: 36, height: 36)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        VStack(alignment: .leading, spacing: 0) {
                            
                            Group {
                                Text(element.alert_message)
                                    .font(.buttons1420Medium)
                                    .foregroundColor(.gray870)
                                
                                if element.alert_title != "" {
                                    Text(element.alert_title)
                                        .font(.caption11218Regular)
                                        .foregroundColor(.gray800)
                                        .padding(.top, 6)
                                }
                                
                                HStack(spacing: 0) {
                                    Text(element.alert_category)
                                        .font(.caption11218Regular)
                                        .foregroundColor(.gray400)

                                    Text(" • ")
                                        .font(.system(size: 20))
                                        .foregroundColor(.gray400)

                                    Text(element.alert_date)
                                        .font(.caption11218Regular)
                                        .foregroundColor(.gray400)
                                }
                                .padding(.top, 6)
                            }
                        }
                        .padding(.leading, 12)
                        
                        Spacer()
                    }
                    .padding(.vertical, 16)
                    .padding(.leading, sizeInfo.Hpadding)
                    .padding(.trailing, 60)
                    .background(viewModel.isClickAllRead ? Color.bgLightGray50 : Color.gray25)
                    
                    Divider()
                        .padding(.horizontal, sizeInfo.Hpadding)
                }
            }
        }
    }
}

extension AlertPage {
    func callRemoteData() {
        self.viewModel.getHomeNaviAlert()
    }
}

struct AlertPage_Previews: PreviewProvider {
    static var previews: some View {
        AlertPage()
    }
}
