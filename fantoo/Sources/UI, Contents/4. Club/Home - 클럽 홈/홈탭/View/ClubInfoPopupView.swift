//
//  ClubInfoPopupView.swift
//  fantoo
//
//  Created by sooyeol on 2023/01/19.
//  Copyright © 2023 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ClubInfoPopupView: View {

    @Binding var isPresented: Bool
    @Binding var model: HomeClub_Basic_Info?
    
    private struct profileSize {
        static let size: CGSize = CGSize(width: 54.0, height: 54.0)
        static let cornerRadius: CGFloat = 16
    }
    
    private struct starSize {
        static let size: CGSize = CGSize(width: 24.0, height: 24.0)
        static let padding: CGFloat = 18
    }
    
    private struct popupSize {
        static let horizontalPadding: CGFloat = 50.0
        static let cornerRadius: CGFloat = 32.0
    }
    

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                Text(model?.clubName ?? "")
                    .foregroundColor(Color.gray870)
                    .font(.title41824Medium)
                    .padding(.top, 45)
                
                Text(model?.clubMasterNickname ?? "")
                    .foregroundColor(Color.gray400)
                    .font(.caption21116Regular)
                    .padding(.bottom, 10)
                
                HStack(alignment: .firstTextBaseline) {
                    Spacer()
                    VStack(alignment: .leading, spacing: 0) {
                        Text("g_create_date".localized)
                            .foregroundColor(Color.gray400)
                            .font(.caption11218Regular)
                            .padding(.top, 8)
                        
                        Text("멤버")
                            .foregroundColor(Color.gray400)
                            .font(.caption11218Regular)
                            .padding(.bottom, 10)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text((model?.createDate ?? "").changeDateString("yyyy-MM-dd HH:mm:ss", "yyyy. MM. dd"))
                            .foregroundColor(Color.gray800)
                            .font(.caption11218Regular)
                            .padding(.top, 8)
                        
                        Text("\(model?.memberCount ?? 0)명")
                            .foregroundColor(Color.gray800)
                            .font(.caption11218Regular)
                            .padding(.bottom, 10)
                    }
                    
                    Spacer()
                }
                .background(Color.bgLightGray50.cornerRadius(12))
                
                Text(model?.introduction ?? " ")
                    .foregroundColor(Color.gray700)
                    .font(.caption11218Regular)
                    .padding(.top, 14)
                    .padding(.bottom, 20)
                
                CommonButton(
                    title: "g_to_share".localized,
                    bgColor: Color.stateEnablePrimaryDefault
                )
                .padding(.horizontal, 22)
                .onTapGesture {
                    isPresented = false
                    print("공유하기 클릭~")
                }
                
                CommonButton2(
                    title: "d_close".localized,
                    type: .defaults(
                        textColor: Color.stateEnableGray400,
                        backgroundColor: Color.gray25
                    )
                )
                .onTapGesture {
                    isPresented = false
                    print("닫기 클릭")
                }
            }
            .padding(EdgeInsets(top: 0, leading: 18, bottom: 16, trailing: 18))
            .background(Color.gray25.cornerRadius(popupSize.cornerRadius))
            .padding(.horizontal, popupSize.horizontalPadding)
            .overlay {
                GeometryReader { geometry in
                    Group {
                        WebImage(url: URL(string: model?.profileImg?.imageOriginalUrl ?? ""))
                            .placeholder(content: {
                                Image("profile_club_character")
                                    .resizable()
                            })
                            .resizable()
                            .frame(width: profileSize.size.width, height: profileSize.size.height)
                            .cornerRadius(profileSize.cornerRadius)
                    }
                    .offset(x: geometry.size.width/2 - profileSize.size.width/2, y: -(profileSize.size.width/2))
                    
                }
            }
            Button(action: {
                print("즐겨찾기 클릭")
            }, label: {
                Image("icon_fill_bookmark")
                    .renderingMode(.template)
                    .foregroundColor(Color.stateEnableGray200)
            })
            .frame(width: starSize.size.width, height: starSize.size.height)
            .padding(.trailing, starSize.padding + popupSize.horizontalPadding)
            .padding(.top, starSize.padding)
        }
    }
}
