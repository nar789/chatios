//
//  HomeClubBankTabView.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/18.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeClubBankTabView {
    //@StateObject var viewModel = HomeClubBankTabViewModel()
    var viewModel: HomeClubBankTabViewModel
    
    /**
     * 언어팩 등록할 것
     */
    private let headerTab1 = "누적기부랭킹"
    private let headerTab2 = "기부하기"
    private let headerTab3 = "쇼핑"
    private let bodyTitle = "이번달 기부 랭킹"
    private let bodyTotalView = "전체보기"
    private let footerTitle = "입출금 내역"
    private let footersubTitle = "월 내역"
    private let footerMore = "+ 더보기"
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
}

extension HomeClubBankTabView: View {
    var body: some View {
        VStack(spacing: 8) {
            
            club_header
            
            club_body
            
            club_footer
        }
//        .onAppear {
//            self.callRemoteData()
//        }
    }
    
    var club_header: some View {
        VStack(spacing: 0) {
            if let club_header = viewModel.homeClub_TabBankModel_Header {
                
                HStack(spacing: 0) {
                    WebImage(url: URL(string: club_header.club_image))
                        .resizable()
                        .frame(width: 54, height: 54)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(club_header.club_name)
                            .font(.body21420Regular)
                            .foregroundColor(.gray900)
                        Text("\(self.numberFormatter(number: club_header.kdg)) KDG")
                            .font(.title32028Bold)
                            .foregroundColor(.gray900)
                    }
                    .padding(.leading, 12)
                    
                    Spacer()
                }
                
                GeometryReader { geometry in
                    HStack(alignment: .center, spacing: 0) {
                        Text(headerTab1)
                            .font(.caption11218Regular)
                            .foregroundColor(.gray800)
                            .frame(width: geometry.size.width/3)
                        Rectangle()
                            .foregroundColor(Color.gray200.opacity(0.8))
                            .frame(width: 1, height: 14)
                        Text(headerTab2)
                            .font(.caption11218Regular)
                            .foregroundColor(.gray800)
                            .frame(width: geometry.size.width/3)
                        Rectangle()
                            .foregroundColor(Color.gray200.opacity(0.8))
                            .frame(width: 1, height: 14)
                        Text(headerTab3)
                            .font(.caption11218Regular)
                            .foregroundColor(.gray300)
                            .frame(width: geometry.size.width/3)
                    }
                    .frame(height: geometry.size.height)
                }
                .frame(height: 42)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.bgLightGray50))
                .padding(.top, 24)
            }
        }
        .padding(.horizontal, sizeInfo.Hpadding)
        .padding(.vertical, 30)
        .background(Color.gray25)
    }
    
    var club_body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let club_body = viewModel.homeClub_TabBankModel_Body {
                
                HStack(spacing: 0) {
                    Text(bodyTitle)
                        .font(.title51622Medium)
                        .foregroundColor(.gray900)
                    Spacer()
                    Text(bodyTotalView)
                        .font(.caption11218Regular)
                        .foregroundColor(.gray700)
                }
                
                (
                    Text(club_body.sdate)
                    +
                    Text(" ~ ")
                    +
                    Text(club_body.edate)
                )
                .font(.caption11218Regular)
                .foregroundColor(.gray600)
                .padding(.top, 8)
            }
            
            club_body_list
        }
        .padding(.horizontal, sizeInfo.Hpadding)
        .padding(.top, 20)
        .padding(.bottom, 12)
        .background(Color.gray25)
    }
    var club_body_list: some View {
        VStack(spacing: 0) {
            if let club_body = viewModel.homeClub_TabBankModel_Body {
                if club_body.ranking_list.count > 0 {
                    ForEach(Array(club_body.ranking_list.enumerated()), id: \.offset) { index, element in
                        
                        HStack(spacing: 0) {
                            Group {
                                if element.rank == 1 {
                                    Image("safe_ranking1")
                                        .resizable()
                                        .frame(width: 29, height: 29)
                                } else if element.rank == 2 {
                                    Image("safe_ranking2")
                                        .resizable()
                                        .frame(width: 29, height: 29)
                                } else if element.rank == 3 {
                                    Image("safe_ranking3")
                                        .resizable()
                                        .frame(width: 29, height: 29)
                                } else {
                                    Text(String(element.rank))
                                        .font(.buttons1420Medium)
                                        .foregroundColor(.primary500)
                                }
                            }
                            .frame(width: 34, height: 34, alignment: .center)
                            
                            Text(element.nickname)
                                .font(.body21420Regular)
                                .foregroundColor(.gray700)
                                .padding(.leading, 10)
                                .padding(.vertical, 13.5)
                            
                            Spacer()
                            
                            Text("\(self.numberFormatter(number: element.kdg)) KDG")
                                .font(.body21420Regular)
                                .foregroundColor(.gray870)
                        }
                        
                        if element.rank != 5 {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray400.opacity(0.12))
                        }
                        
                    }
                }
            }
        }
        .padding(.top, 14)
        
    }
    
    var club_footer: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let club_footer = viewModel.homeClub_TabBankModel_Footer {
                Group {
                    Text(footerTitle)
                        .font(.title51622Medium)
                        .foregroundColor(.gray900)
                    
                    HStack(spacing: 0) {
                        Text("\(String(club_footer.date))\(footersubTitle)")
                            .font(.caption11218Regular)
                            .foregroundColor(.gray600)
                        
                        Image("icon_outline_dropdown")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(.gray600)
                            .frame(width: 12, height: 12)
                            .padding(.leading, 10)
                        
                        Spacer()
                    }
                    .padding(.top, 5)
                }
                .padding(.horizontal, sizeInfo.Hpadding)
                
                club_footer_list
                
                Text(footerMore)
                    .font(.caption11218Regular)
                    .foregroundColor(.gray900)
                    .padding(.vertical, 14)
                    .frame(width: UIScreen.screenWidth)
                    .background(Color.bgLightGray50)
            }
        }
        .padding(.top, 20)
        .background(Color.gray25)
        .padding(.bottom, 34)
    }
    var club_footer_list: some View {
        VStack(spacing: 0) {
            if let club_footer = viewModel.homeClub_TabBankModel_Footer {
                if club_footer.account_list.count > 0 {
                    ForEach(Array(club_footer.account_list.enumerated()), id: \.offset) { index, element in
                        
                        Group {
                            HStack(spacing: 0) {
                                Text(element.nickname)
                                    .font(.body21420Regular)
                                    .foregroundColor(.gray800)
                                
                                Spacer()
                                
                                Text("\(self.numberFormatter(number: element.kdg)) KDG")
                                    .font(.buttons1420Medium)
                                    .foregroundColor(.plusPrimaryDefault)
                            }
                            .padding(.top, 23.5)
                            
                            HStack(spacing: 0) {
                                Text(element.date)
                                    .font(.caption11218Regular)
                                    .foregroundColor(.gray400)
                                
                                Spacer()
                                
                                Text("\(self.numberFormatter(number: element.total_kdg)) KDG")
                                    .font(.caption11218Regular)
                                    .foregroundColor(.gray400)
                            }
                            .padding(.top, 8)
                            .padding(.bottom, 23.5)
                        }
                        .padding(.horizontal, sizeInfo.Hpadding)
                        
                        if index != 4 {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray400.opacity(0.12))
                        }
                    }
                }
            }
        }
    }
}

extension HomeClubBankTabView {
    func callRemoteData() {
        self.viewModel.getTabBank()
    }
    
    // 숫자를 세자리수씩 끊고 콤마(,) 넣기
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
}

//struct HomeClubBankTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeClubBankTabView()
//    }
//}
