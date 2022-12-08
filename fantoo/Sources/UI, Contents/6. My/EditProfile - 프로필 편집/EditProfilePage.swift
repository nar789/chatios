//
//  EditProfilePage.swift
//  fantoo
//
//  Created by mkapps on 2022/05/21.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import BottomSheet


struct EditProfilePage: View {
    
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var vm = EditProfileViewModel()

    
    //Binding
    @Binding var profileUrl: String
    @Binding var nickName: String
    @Binding var interests: [String]
    @Binding var countryCode: String
    @Binding var gender: String
    @Binding var birthDay: String
    @State var selectedBirthDay: Date = Date()
    
    
    //show
    @State private var showCountryList = false
    @State private var showChangeNickNamePage = false
    @State private var showSelectInterestPage = false
    @State private var showGenderPage = false
    @State private var showDatePage = false
  
    
    //size
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
    }
    
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    EditProfileProfileView(profileUrl: $profileUrl)
                    
                    ListLinkView(text: "n_nickname".localized, subText: nickName, subTextColor: Color.stateEnablePrimaryDefault, type: .ClickAllWithArrow) {
                        showChangeNickNamePage = true
                    }
                    .background(
                        NavigationLink("", isActive: $showChangeNickNamePage) {
                            ChangeNickNamePage(nickName: $nickName)
                        }.hidden()
                    )
                    
                    ListLinkView(text: "g_interests".localized, subText: "", subTextColor: Color.gray800, type: .ClickAllWithArrow) {
                        showSelectInterestPage = true
                    }
                    .background(
                        NavigationLink("", isActive: $showSelectInterestPage) {
                            SelectInterestsPage(interests: $interests)
                        }.hidden()
                    )
                                        
                    ListLinkView(text: "g_country".localized, subText: vm.displayCountry, subTextColor: vm.displayCountry != "s_select".localized ? Color.stateEnablePrimaryDefault : Color.stateEnableGray400, type: .ClickRight) {
                        showCountryList = true
                    }
                    
                    ListLinkView(text: "s_gender".localized, subText: vm.displayGender, subTextColor:  vm.displayGender != "s_select".localized ? Color.stateEnablePrimaryDefault : Color.stateEnableGray400, type: .ClickRight) {
                        showGenderPage = true
                    }

                    ListLinkView(text: "s_birthday".localized, subText: vm.displayBirthDay, subTextColor: vm.displayBirthDay != "s_select".localized ? Color.stateEnablePrimaryDefault : Color.stateEnableGray400, type: .ClickRight) {
                        showDatePage = true
                    }
                }
                .modifier(ScrollViewLazyVStackModifier())
            }

            //onAppear
            .onAppear(perform: {
                vm.setDisplayValues(countryCode: countryCode, gender: gender, birthDay: birthDay)
                
                if birthDay.count > 0, let date =  birthDay.toDate(.isoDate) {
                    selectedBirthDay = date
                }
            })
            .background(Color.gray25)
            
            .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "p_edit_profile".localized, onPress: { buttonType in
                if buttonType == .Back {
                }
            })
            .navigationBarBackground {
                Color.gray25
            }
            .statusBarStyle(style: .darkContent)
            
            //alert
            .showAlert(isPresented: $vm.showAlert, type: .Default, title: vm.alertTitle, message: vm.alertMessage, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
            })
            
            //bottom sheet
            .bottomSheet(isPresented: $showDatePage, height: 350, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
                EditProfileDateView
            })
            .bottomSheet(isPresented: $showGenderPage, height: 200, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
                EditProfileGenderView(isShow: $showGenderPage, selectedGender: gender) { value in
                    if gender != value {
                        vm.requestUserInfoUpdate(userInfoType: .gender, genderType: value) { success in
                            if success {
                                gender = value
                                vm.setDisplayValues(countryCode: countryCode, gender: gender, birthDay: birthDay)
                            }
                        }
                    }
                }
            })
            .bottomSheet(isPresented: $showCountryList, height: DefineSize.Screen.Height, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
                
                BSCountryView(isShow: $showCountryList, selectedCountryCode: countryCode, type: .nonType) { countryData in
                    
                    if countryCode != countryData.iso2 {
                        vm.requestUserInfoUpdate(userInfoType: .country, countryIsoTwo: countryData.iso2) { success in
                            if success {
                                countryCode = countryData.iso2
                                
                                vm.setDisplayValues(countryCode: countryCode, selectedCountryData: countryData, gender: gender, birthDay: birthDay)
                            }
                        }
                    }
                }
            })
        }
    }

    var EditProfileDateView: some View {
        VStack {
            HStack {
                Text("s_birthday".localized)
                    .font(Font.title51622Medium)
                Spacer()
            }
            
            // Date Picker
            if LanguageManager.shared.getLanguageCode() == "ko" {
                DatePicker(selection: $selectedBirthDay, displayedComponents: .date, label:{ Text("Please enter a date") }
                )
                    .labelsHidden()
                    .environment(\.locale, Locale.init(identifier: "ko"))
                    .datePickerStyle(WheelDatePickerStyle())
            }
            else {
                DatePicker(selection: $selectedBirthDay, displayedComponents: .date, label:{ Text("Please enter a date") }
                           )
                    .labelsHidden()
                    .environment(\.locale, Locale.init(identifier: "en"))
                    .datePickerStyle(WheelDatePickerStyle())
            }
            
            Button {
                showDatePage = false
                
                if birthDay.toDate(.isoDate) != selectedBirthDay {
                    vm.requestUserInfoUpdate(userInfoType: .birthDay, birthDay: selectedBirthDay.toString("yyyy-MM-dd")) { success in
                        if success {
                            birthDay = selectedBirthDay.toString("yyyy-MM-dd")
                            vm.setDisplayValues(countryCode: countryCode, gender: gender, birthDay: birthDay)
                        }
                    }
                }
            } label: {
                CommonButton(title: "d_next".localized, bgColor: Color.stateActivePrimaryDefault)
            }
        }
        .padding(.horizontal, 32)
    }
}
