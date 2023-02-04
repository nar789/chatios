//
//  WalletDetailPage.swift
//  fantoo
//
//  Created by fns on 2022/06/07.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

// 디자인 변경된 거 주석처리 함

struct WalletKdgDetailPage: View {
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var vm = WalletViewModel()
    
    private struct sizeInfo {
        static let spacing20: CGFloat = 20.0
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
        static let bottomSheetHeight: CGFloat = 220.0 + DefineSize.SafeArea.bottom
        static let imageSize: CGSize = CGSize(width: 200, height: 200)
        
    }
    
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM"
        return formatter
    }()
    
    @State private var date = Date()
    @State private var selectedDay: String = ""
    @State private var listType: Bool = false
    
    @State private var dateUpLimit: Bool = false
    @State private var dateDownLimit: Bool = false

    
    var icon : String
    var title: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Spacer().frame(height: 30)
                VStack {
                    HStack {
                        Image(icon)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 30, height: 30)
                            .cornerRadius(12.5)
                        Text(title)
                            .font(Font.title51622Medium)
                            .foregroundColor(Color.gray800)
                        Spacer()
                    }
                    
                    HStack {
                        VStack {
                            HStack {
                                Text(vm.fanit)
                                    .font(Font.title32028Bold)
                                    .foregroundColor(Color.gray900)
                                Spacer()
                            }
                            
                        }
                    }
                }.padding(.horizontal, 20)
                
                ZStack {
                    ExDivider(color: .bgLightGray50, height: 56)
                    HStack {
                        Button {
                            if !dateDownLimit {
                                withAnimation {
                                    guard let newDate = Calendar.current.date(
                                        byAdding: .month,
                                        value: -1,
                                        to: vm.date
                                        
                                    ) else {
                                        return
                                    }
                                    vm.date = newDate
                                    print("date :: \(vm.date)")
                                    print("today :: \(Date())")
                                }
                                dateUpLimit = false
                            }
                            if vm.selectedSeq == 0 {
                                vm.requestUserWalletType(integUid: UserManager.shared.uid, nextId: 0, size: 10, walletListType: .all, walletType: .fanit, yearMonth: commonDate(for: vm.date))
                            }
                            else if vm.selectedSeq == 1 {
                                vm.requestUserWalletType(integUid: UserManager.shared.uid, nextId: 0, size: 10, walletListType: .paid, walletType: .fanit, yearMonth: commonDate(for: vm.date))
                            }
                            else if vm.selectedSeq == 2 {
                                vm.requestUserWalletType(integUid: UserManager.shared.uid, nextId: 0, size: 10, walletListType: .used, walletType: .fanit, yearMonth: commonDate(for: vm.date))
                            }
                        } label: {
                            Image("icon_outline_back")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundColor(Color.gray800)
                                .frame(width: 12, height: 12)
                        }
                        
                        Text(commonDate(for: vm.date))
                            .font(Font.body21420Regular)
                            .foregroundColor(Color.gray700)
                            .frame(width: 90, alignment: .center)
                        
                        Button {
                            if !dateUpLimit {
                                withAnimation {
                                    guard let newDate = Calendar.current.date(
                                        byAdding: .month,
                                        value: 1,
                                        to: vm.date
                                        
                                    ) else {
                                        return
                                    }
                                    vm.date = newDate
                                }
                                dateDownLimit = false
                            }
                            if vm.selectedSeq == 0 {
                                vm.requestUserWalletType(integUid: UserManager.shared.uid, nextId: 0, size: 10, walletListType: .all, walletType: .fanit, yearMonth: commonDate(for: vm.date))
                            }
                            else if vm.selectedSeq == 1 {
                                vm.requestUserWalletType(integUid: UserManager.shared.uid, nextId: 0, size: 10, walletListType: .paid, walletType: .fanit, yearMonth: commonDate(for: vm.date))
                            }
                            else if vm.selectedSeq == 2 {
                                vm.requestUserWalletType(integUid: UserManager.shared.uid, nextId: 0, size: 10, walletListType: .used, walletType: .fanit, yearMonth: commonDate(for: vm.date))
                            }
                        } label: {
                            Image("icon_outline_go")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundColor(Color.gray800)
                                .frame(width: 12, height: 12)
                        }
                        
                        
                        Spacer()
                        Button {
                            listType = true
                        } label: {
                            Text(vm.walletList)
                                .font(Font.body21420Regular)
                                .foregroundColor(Color.gray700)
                            Image("icon_outline_dropdown")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundColor(Color.gray700)
                                .frame(width: 12, height: 12)
                        }
                        
                    }
                    .padding(.horizontal, 27.5)
                }
                //                KdgDetailDateView()
                ZStack {
                    let walletList = vm.walletListData ?? nil
                    if walletList != nil {
                        
                        ScrollView {
                            ForEach(walletList!, id: \.self) { item in
                                KdgDetailListView(date: item.monthAndDate, text: item.title, price: item.value, type: item.comment, time: item.createDate, showLine: true)
                            }
                        }
                    }
                    
                    let wallet = vm.userWalletTypeData?.walletList.count ?? 0
                    if wallet == 0 {
                        VStack {
                            
                            Spacer().frame(height: sizeInfo.spacing20)
                            
                            Image("character_club2")
                                .frame(width: sizeInfo.imageSize.width, height: sizeInfo.imageSize.height, alignment: .center)
                            
                            Spacer().frame(height: sizeInfo.spacing20)
                            
                            Text("이용내역이 없습니다")
                                .font(Font.body21420Regular)
                                .foregroundColor(Color.gray600)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            vm.requestUserWallet(integUid: UserManager.shared.uid)
            vm.requestUserWalletType(integUid: UserManager.shared.uid, nextId: 0, size: 10, walletListType: .all, walletType: .fanit, yearMonth: commonDate(for: vm.date))
        })
        .bottomSheet(isPresented: $listType, height: sizeInfo.bottomSheetHeight, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
            WalletBottomSheet(isShow: $listType, subTitle: "n_list_select".localized, selectedText: $vm.walletList, selectedSeq: $vm.selectedSeq) {
                if vm.selectedSeq == 0 {
                    vm.requestUserWalletType(integUid: UserManager.shared.uid, nextId: 0, size: 10, walletListType: .all, walletType: .fanit, yearMonth: commonDate(for: vm.date))
                }
                else if vm.selectedSeq == 1 {
                    vm.requestUserWalletType(integUid: UserManager.shared.uid, nextId: 0, size: 10, walletListType: .paid, walletType: .fanit, yearMonth: commonDate(for: vm.date))
                }
                else if vm.selectedSeq == 2 {
                    vm.requestUserWalletType(integUid: UserManager.shared.uid, nextId: 0, size: 10, walletListType: .used, walletType: .fanit, yearMonth: commonDate(for: vm.date))
                }
            }
            //            ClubMemberDetailBottomSheet(isShow: $showBottomView, subTitle: accountBlockState ? blockClear : accountBlock) {
            //                showBottomViewAlert = true
            //            }
        })
        .showAlert(isPresented: $vm.showAlert, type: .Default, title: vm.alertTitle, message: vm.alertMessage, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
            if buttonIndex == 0 {
                if vm.date < Date() {
                    dateDownLimit = true
                }
                else if vm.date > Date() {
                    dateUpLimit = true

                }
            }
        })
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "g_coffer".localized, onPress: { buttonType in
            print("onPress buttonType : \(buttonType)")
        })
        .navigationBarBackground {
            //            Color.white.shadow(radius: 0)
        }
        .statusBarStyle(style: .darkContent)
    }
    
    func commonDate(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let weekDay = dateFormatter.string(from: date)
        return weekDay
    }
}

//struct WalletKdgDetailPage_Previews: PreviewProvider {
//    static var previews: some View {
//        WalletKdgDetailPage()
//    }
//}


struct  KdgDetailTopView: View {
    
    var body: some View {
        VStack {
            HStack {
                Image("kingdom_coin_gold")
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 30, height: 30)
                    .cornerRadius(12.5)
                Text("KDG")
                    .font(Font.title51622Medium)
                    .foregroundColor(Color.gray800)
                Spacer()
            }
            
            HStack {
                VStack {
                    HStack {
                        //                        Text("j_balance".localized)
                        //                            .font(Font.body21420Regular)
                        //                            .foregroundColor(Color.gray700)
                        Text("1,123,123")
                            .font(Font.title32028Bold)
                            .foregroundColor(Color.gray900)
                        Spacer()
                    }
                    //                    Spacer().frame(height: 10)
                    //                    HStack {
                    //                        Text("Total")
                    //                            .font(Font.body21420Regular)
                    //                            .foregroundColor(Color.gray700)
                    //                        Text("323,268,065")
                    //                            .font(Font.body21420Regular)
                    //                            .foregroundColor(Color.gray600)
                    //                        Spacer()
                    //                    }
                }
                //                Spacer()
                //                NavigationLink(
                //                    destination: WalletWithdrawPage()) {
                //                        ZStack {
                //                            Capsule()
                //                                .fill(Color.stateEnablePrimary100)
                //                                .frame(width: 80, height: 45)
                //                            Text("c_widthdraw".localized)
                //                                .font(Font.buttons1420Medium)
                //                                .foregroundColor(Color.primary600)
                //                                .padding(.all, 20)
                //                        }
                //                    }
            }
        }.padding(.horizontal, 20)
    }
}

struct KdgDetailListView: View {
    
    let date: String
    let text: String
    let price: Int
    let type: String
    let time: String
    let showLine: Bool
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let cellHeight: CGFloat = 104.0
        static let cellPadding: CGFloat = 20.0
        static let iconSize: CGSize = CGSize(width: 17, height: 16)
    }
    
    var body: some View {
        ZStack {
            HStack {
                VStack{
                    Text(date)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(Color.gray600)
                        .padding([.leading, .top], sizeInfo.cellPadding)
                        .padding([.trailing], 10)
                        .fixedSize(horizontal: true, vertical: true)
                    Spacer()
                }
                .frame(maxWidth: 30, alignment: .leading)
                
                
                VStack {
                    HStack(spacing: 0) {
                        Text(text)
                            .font(Font.buttons1420Medium)
                            .foregroundColor(Color.gray800)
                            .padding(.top, sizeInfo.cellPadding)
                            .padding(.leading, sizeInfo.cellPadding)
                            .fixedSize(horizontal: true, vertical: true)
                        //                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        
                        Spacer().frame(maxWidth: .infinity)
                        
                        Text("\(price)")
                            .font(Font.buttons1420Medium)
                            .foregroundColor(Color.plusPrimaryDefault)
                            .padding([.trailing, .top], sizeInfo.cellPadding)
                    }
                    //                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                    HStack(spacing: 0) {
                        Text(type)
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.gray500)
                            .padding(.leading, sizeInfo.cellPadding)
                            .fixedSize(horizontal: true, vertical: true)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        Spacer()
                        
                    }
                    Spacer().frame(height: 10)
                    
                    HStack(spacing: 0) {
                        Text(time)
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.gray500)
                            .padding(.leading, sizeInfo.cellPadding)
                            .padding(.bottom, sizeInfo.cellPadding)
                            .fixedSize(horizontal: true, vertical: true)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        Spacer()
                        
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if showLine {
                ExDivider(color: .bgLightGray50, height: 1)
                    .frame(height: DefineSize.LineHeight, alignment: .bottom)
                    .padding(EdgeInsets(top: sizeInfo.cellHeight - DefineSize.LineHeight, leading:0, bottom: 0, trailing: 0))
            }
        }
        .modifier(ListRowModifier(rowHeight: sizeInfo.cellHeight))
        
        //        ZStack {
        //            VStack {
        //                HStack() {
        //                    Text(date)
        //                        .font(Font.buttons1420Medium)
        //                        .foregroundColor(Color.gray600)
        //                        .padding([.leading, .top], sizeInfo.cellPadding)
        //                        .padding([.trailing], 10)
        //                        .fixedSize(horizontal: true, vertical: true)
        ////                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        //
        //                    Text(text)
        //                        .font(Font.buttons1420Medium)
        //                        .foregroundColor(Color.gray800)
        //                        .padding(.top, sizeInfo.cellPadding)
        //                        .fixedSize(horizontal: true, vertical: true)
        ////                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        //
        //                    Spacer().frame(maxWidth: .infinity)
        //
        //                    Text(price)
        //                        .font(Font.buttons1420Medium)
        //                        .foregroundColor(Color.plusPrimaryDefault)
        //                        .padding([.leading], 10)
        //                        .padding([.trailing, .top], sizeInfo.cellPadding)
        ////                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
        //                }
        //                HStack() {
        //                    Text(type)
        //                        .font(Font.caption11218Regular)
        //                        .foregroundColor(Color.gray500)
        //                        .padding(.leading, 62)
        //                        .fixedSize(horizontal: true, vertical: true)
        //                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        //                    Spacer()
        //
        //                }
        //
        //                HStack() {
        //                    Text(time)
        //                        .font(Font.caption11218Regular)
        //                        .foregroundColor(Color.gray500)
        //                        .padding(.leading, 62)
        //                        .padding(.bottom, sizeInfo.cellPadding)
        //                        .fixedSize(horizontal: true, vertical: true)
        //                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        //                    Spacer()
        //
        //                }
        //            }
        //            .frame(maxWidth: .infinity, maxHeight: .infinity)
        //
        //            if showLine {
        //                ExDivider(color: .bgLightGray50, height: 1)
        //                    .frame(height: DefineSize.LineHeight, alignment: .bottom)
        //                    .padding(EdgeInsets(top: sizeInfo.cellHeight - DefineSize.LineHeight, leading:0, bottom: 0, trailing: 0))
        //            }
        //        }
        //        .modifier(ListRowModifier(rowHeight: sizeInfo.cellHeight))
    }
}

struct KdgDetailDateView: View {
    
    @State var checkState:Bool = false
    
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd"
        return formatter
    }()
    var today = Date()
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 5) {
                if !self.checkState {
                    KdgDetailDateButtonView(checkState: false, date: "num_1week".localized)
                } else {
                    KdgDetailDateButtonView(checkState: true, date: "num_1week".localized)
                }
                
                if !self.checkState {
                    KdgDetailDateButtonView(checkState: true, date: "num_1month".localized)
                } else {
                    KdgDetailDateButtonView(checkState: false, date: "num_1month".localized)
                }
                
                if !self.checkState {
                    KdgDetailDateButtonView(checkState: true, date: "num_6month".localized)
                } else {
                    KdgDetailDateButtonView(checkState: false, date: "num_6month".localized)
                }
                
                if !self.checkState {
                    KdgDetailDateButtonView(checkState: true, date: "s_search_detail".localized)
                } else {
                    KdgDetailDateButtonView(checkState: false, date: "s_search_detail".localized)
                }
                Spacer()
            }.padding(.horizontal, 10)
            
            HStack {
                Text("\(today, formatter: KdgDetailDateView.dateFormat)")
                    .font(Font.body21420Regular)
                    .foregroundColor(Color.gray600)
                Spacer()
            }.padding(.horizontal, 20)
        }
    }
}


struct KdgDetailDateButtonView : View {
    
    @State var checkState:Bool = false ;
    let date: String
    //    let width: CGFloat
    var body: some View {
        
        Button(action:
                {
            self.checkState = !self.checkState
            print("State : \(self.checkState)")
        }) {
            HStack(alignment: .top, spacing: 10) {
                ZStack {
                    Capsule()
                        .fill(self.checkState ? Color.clear : Color.stateActiveGray700)
                        .frame(width: 70, height: 35)
                    Text(date)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(self.checkState ? Color.gray100 : Color.gray25)
                }
            }
        }
        .foregroundColor(Color.gray25)
        .padding([.vertical, .leading], 10)
    }
}
