//
//  EditProfilePage.swift
//  fantoo
//
//  Created by mkapps on 2022/05/21.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct SelectInterestsPage: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    
    //Binding
    @Binding var interests: [String]
    
    
    @StateObject var vm = SelectInterestsViewModel()
    
    @State var leftItems: [CustomNavigationBarButtonType] = [.Back]
    @State var rightItems: [CustomNavigationBarButtonType] = [.Save]
    @State var unSaveRightItems: [CustomNavigationBarButtonType] = [.UnSave]
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: sizeInfo.gridPadding, alignment: nil),
        GridItem(.flexible(), spacing: sizeInfo.gridPadding, alignment: nil),
        GridItem(.flexible(), spacing: sizeInfo.gridPadding, alignment: nil)
    ]
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let gridPadding: CGFloat = 15.0
        static let gridHeight: CGFloat = 105.0
        
        static let cornerRadius: CGFloat = 20.0
        static let borderWidth: CGFloat = 2.0
    }
    
    
    var body: some View {
        
        VStack(spacing: 0) {
            Text("se_g_select_interests".localized)
                .font(Font.body21420Regular)
                .foregroundColor(.gray600)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, DefineSize.Contents.TopPadding)
                .padding(.bottom, sizeInfo.padding)
                .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
            
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center, spacing: sizeInfo.gridPadding, pinnedViews: [], content: {
                    
                    ForEach(vm.interests, id: \.self) { item in

                        Button {
                            //선택되어 있는걸 클릭했을 경우 해제해야 한다.
                            if vm.selectedInterests.contains(item.code) {
                                vm.selectedInterests = vm.selectedInterests.filter{$0 != item.code}
                            }
                            //선택되어 있지 않으면 선택되어야 하지만 3개까지이다.
                            else {
                                if vm.selectedInterests.count < 3 {
                                    vm.selectedInterests.append(item.code)
                                }
                            }

                            if vm.selectedInterests.count > 0 {
                                rightItems = [.Save]
                            }
                            else {
                                rightItems = [.UnSave]
                            }
                        } label: {
                            Text(item.description)
                                .font(Font.buttons1420Medium)
                                .foregroundColor(vm.selectedInterests.contains(item.code) ? Color.primary500 : Color.gray800)//Primary500
                                .frame(height: sizeInfo.gridHeight)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .overlay(
                                    RoundedRectangle(cornerRadius: sizeInfo.cornerRadius)
                                        .stroke(vm.selectedInterests.contains(item.code) ? Color.primary500 : Color.gray100, lineWidth: sizeInfo.borderWidth)
                                )
                        }
                    }
                })
                    .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
                    .modifier(ScrollViewLazyVStackModifier())
            }
        }
        .onAppear(perform: {
            vm.requestInterestList()
            vm.selectedInterests = interests
        })
        .background(Color.gray25)
        .navigationType(leftItems: leftItems, rightItems: vm.selectedInterests.count > 0 ? rightItems : unSaveRightItems, leftItemsForegroundColor: .black, rightItemsForegroundColor: vm.selectedInterests.count > 0 && vm.selectedInterests != interests ? .primary500 : .gray300, title: "g_select_interests".localized, onPress: { buttonType in
            if buttonType == .Save {
                if vm.selectedInterests.count > 0 {
                    vm.requestUserInfoUpdate(userInfoType: .interest, interestList: vm.selectedInterests) { success in
                        if success {
                            interests = vm.selectedInterests
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
        
        //alert
        .showAlert(isPresented: $vm.showAlert, type: .Default, title: vm.alertTitle, message: vm.alertMessage, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
        })
    }
}
