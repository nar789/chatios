//
//  CardContentView.swift
//  fantooUITests
//
//  Created by fns on 2022/05/20.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct WalletDetailView: View {
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var vm = WalletViewModel()

    @State private var showKDGPage = false
    @State private var showFanitPage = false
    
    var body: some View {
        
        ZStack {
            
            Color.gray25
                .cornerRadius(12)
            
            VStack(alignment: .leading) {
                Spacer().frame(height: 20)
                Text("j_assets".localized)
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                    .foregroundColor(Color.gray900)
                    .padding([.horizontal], 20)
                // 광고플랫폼 완성전까지 제외
                //                CardListRow(icon: "kingdom_coin_gold", title: "en_my_kdg".localized, description: "1,234,5678", bgColor: Color.clear, onPress: {
                //                    showKDGPage = true
                //                })
                //                    .background(
                //                        NavigationLink("", isActive: $showKDGPage) {
                //                            WalletKdgDetailPage(icon: "kingdom_coin_gold", title: "KDG")
                //                        }.hidden()
                //                    )
                //                    .padding(.bottom, 10)
                
                
                CardListRow(icon: "fanit_round", title: "en_my_fanit".localized, description: vm.fanit, bgColor: Color.clear, onPress: {
                    showFanitPage = true
                })
                    .background(
                        NavigationLink("", isActive: $showFanitPage) {
                            WalletKdgDetailPage(icon: "fanit_round", title: "FANiT")
                        }.hidden()
                    )
                    .padding(.bottom, 10)
                
                // 광고플랫폼 완성전까지 제외
                //                CardListRow(icon: "kindom_coin", title: "en_my_fanit".localized, description: "1,234,5678", bgColor: Color.clear, onPress: {
                //                    showFanitPage = true
                //                })
                //                    .background(
                //                        NavigationLink("", isActive: $showFanitPage) {
                //                            Text("showFanitPage")
                //                        }.hidden()
                //                    )
                Spacer().frame(height: 20)
            }
        }
        .padding(.horizontal, 20)
        .frame(width: UIScreen.main.bounds.width, height: 100, alignment: .center)
        .onAppear {
            vm.requestUserWallet(integUid: UserManager.shared.uid)
        }
    }
}

struct CardListRow: View {
    
    var icon : String
    var title : String
    var description : String
    var bgColor : Color
    
    let onPress: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            Image(icon)
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 45, height: 45)
                .cornerRadius(22.5)
            
            VStack(alignment: .leading, spacing: 0){
                Divider().opacity(0)
                Rectangle().frame(height: 0)
                Text(title)
                    .foregroundColor(Color.gray600)
                    .font(Font.caption11218Regular)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer().frame(height: 5)
                
                Text(description)
                    .fontWeight(.bold)
                    .font(Font.title51622Medium)
                    .foregroundColor(Color.black)
            }
            Button(
                action: {
                    onPress()
                },
                label: {
                    ZStack {
                        Capsule()
                            .fill(Color.primary100)
                            .frame(width: 80, height: 45)
                        Text("n_history".localized)
                            .font(Font.buttons1420Medium)
                            .foregroundColor(Color.primary600)
                            .padding(.all, 20)
                    }
                }
            )
                .buttonStyle(.borderless)
        }
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
}




