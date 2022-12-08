//
//  HomePageBottomView.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/31.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct HomePageBottomView: View {
    /**
     * 언어팩 등록할 것
     */
    var subHomeItemMoreItems = [
        HomePagePopupItemModel(SEQ: 1, image: "icon_outline_save", title: "저장하기"),
        HomePagePopupItemModel(SEQ: 2, image: "icon_outline_share", title: "공유하기"),
        HomePagePopupItemModel(SEQ: 3, image: "icon_outline_join", title: "가입하기"),
        HomePagePopupItemModel(SEQ: 4, image: "icon_outline_siren", title: "신고하기"),
        HomePagePopupItemModel(SEQ: 5, image: "icon_outline_hide", title: "게시글 숨기기"),
        HomePagePopupItemModel(SEQ: 6, image: "icon_outline_blockaccount", title: "이 사용자 차단하기")
    ]
    var subHomeGlobalLanItems = [
        HomePagePopupItemModel(SEQ: 1, image: nil, title: "GLOBAL"),
        HomePagePopupItemModel(SEQ: 2, image: nil, title: "내 언어로 세팅"),
        HomePagePopupItemModel(SEQ: 3, image: nil, title: "다른 언어 선택")
    ]

    let title: String
    let type: HomePageBottomType
    let onPressItemMore: ((HomePageItemMoreType) -> Void)
    let onPressGlobalLan: ((HomePageGlobalLanType) -> Void)
    @Binding var selectedTitle: String?
    @Binding var isShow: Bool

    private struct sizeInfo {
        static let titleBottomPadding: CGFloat = 14.0
        static let padding: CGFloat = 30.0
    }
    
    var body: some View {
        VStack {
            if type == .SubHomeGlobalLan {
                HStack {
                    Text(title)
                        .font(Font.title51622Medium)
                        .foregroundColor(Color.gray870)
                    Spacer()
                }.padding(.bottom, sizeInfo.titleBottomPadding)
            }
            
            if type == .SubHomeItemMore {
                
                ForEach(Array(subHomeItemMoreItems.enumerated()), id: \.offset) { index, element in
                    
                    HomePageItemMoreView(
                        item: element,
                        onPress: { buttonType in
                            onPressItemMore(buttonType)
                            isShow = false
                        }
                    )
                    .padding(.top, index==0 ? 0 : 10)
                }
            }
            else if type == .SubHomeGlobalLan {
                ForEach(Array(subHomeGlobalLanItems.enumerated()), id: \.offset) { index, element in
                    
                    HomePageGlobalLanBottomView(
                        item: element,
                        selectedTitle: $selectedTitle,
                        onPress: { buttonType in
                            onPressGlobalLan(buttonType)
                            isShow = false
                        }
                    )
                    .padding(.top, index==0 ? 0 : 10)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, sizeInfo.padding)
    }
}

struct HomePageItemMoreView: View {
    let item: HomePagePopupItemModel
    let onPress: ((HomePageItemMoreType) -> Void)
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Image(item.image ?? "")
                .resizable()
                .frame(width: 22, height: 22)
            
            Text(item.title)
                .font(.body11622Regular)
                .foregroundColor(.gray870)
                .padding(.leading, 18)
            
            Spacer()
        }
        .padding(.vertical, 6)
        .onTapGesture {
            switch item.SEQ {
            case 1:
                onPress(HomePageItemMoreType.Save)
            case 2:
                onPress(HomePageItemMoreType.Share)
            case 3:
                onPress(HomePageItemMoreType.Join)
            case 4:
                onPress(HomePageItemMoreType.Notice)
            case 5:
                onPress(HomePageItemMoreType.Hide)
            case 6:
                onPress(HomePageItemMoreType.Block)
            default:
                print("")
            }
        }
    }
}

struct HomePageGlobalLanBottomView: View {

    let item: HomePagePopupItemModel
    @Binding var selectedTitle: String?
    let onPress: ((HomePageGlobalLanType) -> Void)
    //let onPress: () -> Void

    private struct sizeInfo {
        static let subTitleHeight: CGFloat = 80.0
        static let bottomPadding: CGFloat = 14.0
        static let iconSize: CGSize = CGSize(width: 24, height: 24)
    }

    var body: some View {

        HStack(spacing: 0) {
            Button {
                self.selectedTitle = self.item.title // Binding 변수 selectedTitle에 클릭한 제목 대입
                //onPress()
                switch item.SEQ {
                case 1:
                    onPress(HomePageGlobalLanType.Global)
                case 2:
                    onPress(HomePageGlobalLanType.MyLan)
                case 3:
                    onPress(HomePageGlobalLanType.AnotherLan)
                default:
                    print("")
                }
            } label: {
                Text(item.title)
                    .font(.body11622Regular)
                    .foregroundColor(item.title == selectedTitle ? Color.primaryDefault : Color.gray800)

                Spacer()
                Image(systemName: "checkmark")
                    .foregroundColor(Color.primary300)
                    .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height)
                    .opacity( item.title == selectedTitle ? 1 : 0)
            }
        }
        .padding(.bottom, sizeInfo.bottomPadding)
    }
}

struct HomePagePopupItemModel {
    var SEQ: Int
    let image: String?
    let title: String
}
//struct HomePageLanChoiceModel {
//    var SEQ: Int
//    var subTitle: String = ""
//    var subDescription: String = ""
//}
