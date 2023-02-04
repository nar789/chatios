//
//  ClubCategorySettingPage.swift
//  fantoo
//
//  Created by Benoit Lee on 2022/06/30.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct ClubCategorySettingPage: View {
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let gridPadding: CGFloat = 15.0
        static let gridHeight: CGFloat = 105.0
        static let cornerRadius: CGFloat = 20.0
        static let borderWidth: CGFloat = 2.0
    }
    
    @Environment(\.presentationMode) private var presentationMode
    @StateObject var vm = ClubCategorySettingViewModel()
    
    @Binding var clubId: String
    @Binding var interests: Int
    @Binding var memberCountOpenYn: Bool
    @Binding var memberJoinAutoYn: Bool
    @Binding var memberListOpenYn: Bool
    @Binding var openYn: Bool

    let data = Array(1...100).map { "카테고리 \($0)"}
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: sizeInfo.gridPadding, alignment: nil),
        GridItem(.flexible(), spacing: sizeInfo.gridPadding, alignment: nil),
        GridItem(.flexible(), spacing: sizeInfo.gridPadding, alignment: nil)
    ]
    
    @State var leftItems: [CustomNavigationBarButtonType] = [.Back]
    @State var rightItems: [CustomNavigationBarButtonType] = [.UnSave]
    
    @State var completeState: Bool = false
    
    @State var selectedCode: Int = 0

    var body: some View {
        
        VStack(spacing: 0) {
            Text("se_k_select_club_interest".localized)
                .font(Font.body21420Regular)
                .foregroundColor(.gray600)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, DefineSize.Contents.TopPadding)
                .padding(.bottom, sizeInfo.padding)
                .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
            
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center, spacing: sizeInfo.gridPadding, pinnedViews: [], content: {
                    ForEach(vm.clubInterestList, id: \.self) { item in
                        Button {
                            vm.selectedInterests = [item.clubInterestCategoryId]

                            if vm.selectedInterests.count > 0 {
                                rightItems = [.Save]
                            }
                            else {
                                rightItems = [.UnSave]
                            }
                            
                            if let firstElement = vm.selectedInterests.first {
                                print("First Element : \(firstElement)")
                                selectedCode = firstElement
                            }
                            
                            if vm.selectedInterests.count > 0 && selectedCode != interests {
                                completeState = true
                            }
                            else {
                                completeState = false
                            }
                                                        
                        } label: {
                            Text(item.description)
                                .font(Font.buttons1420Medium)
                                .foregroundColor(vm.selectedInterests.contains(item.clubInterestCategoryId) ? Color.primary500 : Color.gray800)//Primary500
                                .frame(height: sizeInfo.gridHeight)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .overlay(
                                    RoundedRectangle(cornerRadius: sizeInfo.cornerRadius)
                                        .stroke(vm.selectedInterests.contains(item.clubInterestCategoryId) ? Color.primary500 : Color.gray100, lineWidth: sizeInfo.borderWidth)
                                )
                        }
                    }
                })
                    .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
                    .modifier(ScrollViewLazyVStackModifier())
            }
        }
        
        .background(Color.gray25)
        .onAppear(perform: {
            vm.requestClubInterestList()
            vm.selectedInterests = [interests]
        })
                          
        .navigationType(leftItems: [.Back], rightItems: [.PurpleDone], leftItemsForegroundColor: .black, rightItemsForegroundColor: completeState ? Color.primary500 : Color.black, title: "k_club_info_setting".localized, onPress: { buttonType in
            if completeState {
                vm.requestClubInfoEdit(clubId: clubId, integUid: UserManager.shared.uid, interestCategoryId: selectedCode, memberCountOpenYn: memberCountOpenYn, memberJoinAutoYn: memberJoinAutoYn, memberListOpenYn: memberListOpenYn, openYn: openYn) { success in
                    self.presentationMode.wrappedValue.dismiss()

                }
            }
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }
}


struct ClubCategorySettingPage_Previews: PreviewProvider {
    static var previews: some View {
        ClubCategorySettingPage(clubId: .constant(""), interests: .constant(1), memberCountOpenYn: .constant(false), memberJoinAutoYn: .constant(false), memberListOpenYn: .constant(false), openYn: .constant(false))
    }
}


