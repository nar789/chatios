//
//  NoticeDetailPage.swift
//  fantoo
//
//  Created by fns on 2022/10/28.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct NoticeDetailPage: View {
    
    @Environment(\.openURL) private var openURL
    @StateObject var languageManager = LanguageManager.shared
    
    @State var showList = false
    @State var leftItems: [CustomNavigationBarButtonType] = []
    @State var rightItems: [CustomNavigationBarButtonType] = [.UnLike]
    @State private var shouldShowSetting = false
    @State private var showAccontPage = false
    
    @State private var showTransPage = false
    @State private var showPushAlarmPage = false
    @State private var showMarketingPage = false
    
    @State private var showVersionPage = false
    @State private var showNoticePage = false
    @State private var showEmailInquiryPage = false
    
    @State private var showServiceTermsPage = false
    @State private var showPersonalTermPage = false
    @State private var showYouthProtectionPage = false
    
    @State private var showAlert: Bool = false
    @State private var showAgreeAlert: Bool = false
    
    @State private var lang: String = "한국어"
    @StateObject var vm = NoticeViewModel()
    @Binding var noticeId: Int

    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let cellHeight: CGFloat = 50.0
        static let cellPadding: CGFloat = 20.0
        static let cellLeadingPadding: CGFloat = 16.0
        static let cellBottomPadding: CGFloat = 5.0
        static let cellTrailingPadding: CGFloat = 16.0
        static let cellTopPadding: CGFloat = 20.0
        static let iconSize: CGSize = CGSize(width: 17, height: 16)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    Text(vm.title)
                        .font(Font.title41824Medium)
                        .foregroundColor(Color.gray870)
                        .fixedSize(horizontal: true, vertical: true)
                        .padding(.leading, sizeInfo.cellPadding)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    
                    Text(vm.createDate)
                        .font(Font.caption11218Regular)
                        .foregroundColor(Color.gray400)
                        .padding(.leading, sizeInfo.cellPadding)
                        .padding(.top, 8)
                        .fixedSize(horizontal: true, vertical: true)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    
                    Spacer().frame(height: 24)
                    
                    Text(vm.content)
                        .font(Font.body21420Regular)
                        .foregroundColor(Color.gray800)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxHeight: .infinity, alignment: .leading)
                }
            }
            .modifier(ScrollViewLazyVStackModifier())
        }
        .onAppear {
            vm.requestNoticeListDetail(noticeId: "\(noticeId)")
        }
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "", onPress: { buttonType in
            print("onPress buttonType : \(buttonType)")
        })
        .navigationBarBackground {
            Color.gray25
        }
    }
}
