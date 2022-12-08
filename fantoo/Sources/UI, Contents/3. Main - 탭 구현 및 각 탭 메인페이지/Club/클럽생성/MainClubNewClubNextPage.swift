//
//  MainClubNewClubNextPage.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/11.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct MainClubNewClubNextPage: View {
    
    @StateObject var vm = MainClubNewClubViewModel()
    @Binding var goBackMainClub: Bool
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let gridPadding: CGFloat = 15.0
        static let padding30: CGFloat = 30.0
        static let gridHeight: CGFloat = 105.0
        
        static let cornerRadius: CGFloat = 20.0
        static let borderWidth: CGFloat = 2.0
    }
    
    let data = Array(1...100).map { "카테고리 \($0)"}
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: sizeInfo.gridPadding, alignment: nil),
        GridItem(.flexible(), spacing: sizeInfo.gridPadding, alignment: nil),
        GridItem(.flexible(), spacing: sizeInfo.gridPadding, alignment: nil)
    ]
    
    @State var leftItems: [CustomNavigationBarButtonType] = [.Back]
    @State var rightItems: [CustomNavigationBarButtonType] = [.UnSave]
    
    @State var selectedString: Int = 0
    @State var showDetailClub: Bool = false
    
    @Binding var checkToken: String
    @Binding var activeCountryCode: String
    @Binding var bgImg: String
    @Binding var clubName: String
    @Binding var languageCode: String
    @Binding var profileImg: String
    @Binding var memberJoinAutoYn: Bool
    @Binding var openYn: Bool
    
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
                                selectedString = firstElement
                            }
                                                        
                        } label: {
                            Text(item.categoryName)
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
            print("---------------------\n checkToken ::: \(checkToken)\n activeCountryCode ::: \(activeCountryCode)\n bgImg ::: \(bgImg)\n clubName ::: \(clubName)\n languageCode ::: \(languageCode)\n profileImg ::: \(profileImg)\n memberJoinAutoYn ::: \(memberJoinAutoYn)\n openYn ::: \(openYn)\n ---------------------")
        })
        .showAlert(isPresented: $vm.showAlert, type: .Default, title: "", message: vm.alertMessage, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
        })
        
        .navigationType(
            leftItems: [.Back],
            rightItems: [.Done],
            leftItemsForegroundColor: .black,
            rightItemsForegroundColor: (clubName.count > 0 && checkToken.count > 0 && activeCountryCode.count > 0 && languageCode.count > 0 && vm.selectedInterests.count > 0) ? Color.stateActivePrimaryDefault : Color.gray300,
            title: "k_club_info_setting".localized,
            onPress: { buttonType in
            
            if buttonType == .Done {
                goBackMainClub = true
                vm.requestCreatingClub(activeCountryCode: activeCountryCode, bgImg: bgImg, checkToken: checkToken, clubName: clubName, integUid: UserManager.shared.uid, interestCategoryId: selectedString, languageCode: languageCode, memberJoinAutoYn: memberJoinAutoYn, openYn: openYn, profileImg: profileImg) { success in
                    if !success {
                        vm.showAlert = true
                    }
                }
            }
            
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }
}
