//
//  MainClubNewClubPage.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/01.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import Combine
import SDWebImageSwiftUI


struct MainClubNewClubPage {

    @StateObject var languageManager = LanguageManager.shared
    @StateObject var viewModel = MainClubNewClubViewModel()
    @StateObject var bottomSheetManager = BottomSheetManager.shared
    
    @Binding var goBackMainClub: Bool
    let maxCharacterLength: Int = 30
    
    @State var clubJoinSubText: String = "\("g_open_public".localized)"
    @State var joinAcceptSubText: String = "\("j_auto".localized)"
    @State var memberJoinAutoYn: Bool = true
    @State var openYn: Bool = true
    
    //popup
    @State private var showSheetClubVisibility = false
    @State private var showSheetJoinMethod = false
    @State private var showSheetLanguageSetting = false
    @State private var showSheetCountrySetting = false
    
    @State var showNextPage = false
    @State var checkToken: String = ""
    
    //false일때가 사용가능임
    @State var exist: Bool = true
    @State var doubleCheckState = false
    
    private let naviTitle = "n_my_club".localized
    private let clubJoinInfo = "se_c_detail_setting_can_in_club_settings".localized
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
        static let bottomSheetHeight: CGFloat = 189.0 + DefineSize.SafeArea.bottom
        static let padding5: CGFloat = 5.0
        static let padding: CGFloat = 10.0
        static let buttonWidth: CGFloat = 86.0
        static let buttonCornerRadius: CGFloat = 7.0
        static let inputHeight: CGFloat = 42.0
        
    }
}

extension MainClubNewClubPage: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                
                clubImageView
                
                clubNameView
                
                Rectangle()
                    .fill(Color.bgLightGray50)
                    .frame(height: 8)
                    .padding(.top, 22)
                
                clubSettingView
                
                Spacer()
                
                clubJoinInfoView
            }
            .background(Color.gray25)
        }
        .background(
            NavigationLink("", destination: MainClubNewClubNextPage(goBackMainClub: $goBackMainClub, checkToken: $viewModel.checkToken, activeCountryCode: $viewModel.countryIsoTwo, bgImg: $viewModel.bgImg, clubName: $viewModel.clubName, languageCode: $viewModel.languageCode, profileImg: $viewModel.profileImg, memberJoinAutoYn: $memberJoinAutoYn, openYn: $openYn), isActive: $showNextPage).hidden()
        )
        .navigationType(
            leftItems: [.Back],
            rightItems: [.Next],
            leftItemsForegroundColor: Color.gray900,
            rightItemsForegroundColor: (viewModel.isCheckPersonalInfo && viewModel.clubName.count > 0 && viewModel.checkToken.count > 0 && viewModel.countryIsoTwo.count > 0 && viewModel.languageCode.count > 0 && !exist ) ? Color.stateActivePrimaryDefault : Color.gray300,
            title: naviTitle,
            onPress: { buttonType in
                if buttonType == .Back {
//                    goBackMainClub = false
                }
                else if buttonType == .Next {
                    if (viewModel.isCheckPersonalInfo && viewModel.clubName.count > 0 && viewModel.checkToken.count > 0 && viewModel.countryIsoTwo.count > 0 && viewModel.languageCode.count > 0) && !exist {
                        showNextPage = true
                    }
                }
            })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
        //onAppear
        .onAppear(perform: {
            viewModel.requestDefaultUserInfo()
            viewModel.setDisplayValues(countryCode: viewModel.countryIsoTwo)
            viewModel.setDisplayValues(countryCode: viewModel.activeCountryCode)
        })
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        .onChange(of: bottomSheetManager.onPressJoinApprovalSettingOfClub, perform: { (newValue) in
            switch newValue {
            case AutoOrApprovalType.Approval.description:
                memberJoinAutoYn = false
            case AutoOrApprovalType.Auto.description:
                memberJoinAutoYn = true
            default:
                print("")
            }
        })
        .onChange(of: bottomSheetManager.onPressClubOpenSettingOfClub, perform: { (newValue) in
            switch newValue {
            case OpenOrHiddenType.Hidden.description:
                openYn = false
            case OpenOrHiddenType.Open.description:
                openYn = true
            default:
                print("")
            }
        })
    
        
        //MARK: - Shpw Sheet
        
        .showAlert(isPresented: $viewModel.showAlert, type: .Default, title: "", message: viewModel.alertMessage, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
        })
        
//        .bottomSheet(isPresented: $showSheetClubVisibility, height: sizeInfo.bottomSheetHeight, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
//            CommonSettingBottomView(title: "k_club_visibility_settings".localized, type: .ClubOpenTitleaOfClub, isShow: $showSheetClubVisibility, selectedText: $clubJoinSubText, selectedSEQ: .constant(-1), selectedYn: $openYn) { seq in
//            }
//        })
//
//        .bottomSheet(isPresented: $showSheetJoinMethod, height: sizeInfo.bottomSheetHeight, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
//            CommonSettingBottomView(title: "g_join_accept_method".localized, type: .JoinApprovalTitleOfClub, isShow: $showSheetJoinMethod, selectedText: $joinAcceptSubText, selectedSEQ: .constant(-1), selectedYn: $memberJoinAutoYn) { seq in
//
//            }
//        })
        
        .bottomSheet(isPresented: $showSheetLanguageSetting, height: DefineSize.Screen.Height, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
            BSLanguageView(isShow: $showSheetLanguageSetting, selectedLangName: $viewModel.languageName, selectedLangCode: viewModel.languageCode, isChangeAppLangCode: true, type: .ClubOpen, onClick: { language in
                viewModel.languageCode = language
            })
        })
        
        .bottomSheet(isPresented: $showSheetCountrySetting, height: DefineSize.Screen.Height, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
            
            BSCountryView(isShow: $showSheetCountrySetting, selectedCountryCode: viewModel.countryIsoTwo, type: .ClubOpen) { countryData in
                viewModel.countryIsoTwo = countryData.iso2
                viewModel.setDisplayValues(countryCode: viewModel.activeCountryCode, selectedCountryData: countryData)
                
            }
        })
    }
    
    var clubImageView: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack {
                    Image("icon_outline_camera")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(.stateEnableGray400)
                        .frame(width: 28.33, height: 28.33)
                    
                    WebImage(url: URL(string: viewModel.bgImg.imageOriginalUrl))
                        .resizable()
                }
                .frame(width: UIScreen.screenWidth, height: 140)
                .background(Color.gray50)
                .onTapGesture {
                    viewModel.showBackgoundImagePicker = true
                }
                
                Spacer()
                    .frame(height: 16)
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                ZStack(alignment: .bottomTrailing) {
                    
                    WebImage(url: URL(string: viewModel.profileImg.imageOriginalUrl))
                        .resizable()
                        .placeholder(Image(Define.ProfileDefaultImage))
                        .frame(width: 54, height: 54)
                        .clipped()
                        .cornerRadius(DefineSize.CornerRadius.ProfileThumbnailM)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray200, lineWidth: 0.5))
                    
                    Image("icon_fill_camera")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .padding(4)
                        .background(Color.gray25)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray200, lineWidth: 0.5))
                }
                .padding(.leading, sizeInfo.Hpadding)
                .onTapGesture {
                    viewModel.showProfileImagePicker = true
                }
            }
            .frame(width: UIScreen.screenWidth, alignment: .leading)
        }
        .fixedSize(horizontal: false, vertical: true)
        .sheet(isPresented: $viewModel.showProfileImagePicker, content: {
            ImagePicker(sourceType: .photoLibrary, imageType: .ProfileImage) { success, image, message in
                
                if !success {
                    viewModel.alertMessage = message
                    viewModel.showAlert = true
                    return
                }
                
                viewModel.requestUploadImage(image: image) { url in
                    viewModel.profileImg = url
                    
                }
            }
        })
        
        .sheet(isPresented: $viewModel.showBackgoundImagePicker, content: {
            ImagePicker(sourceType: .photoLibrary, imageType: .BgImage) { success, image, message in
                
                if !success {
                    viewModel.alertMessage = message
                    viewModel.showAlert = true
                    return
                }
                
                viewModel.requestUploadImage(image: image) { url in
                    viewModel.bgImg = url
                }
            }
        })
    }
    
    var clubNameView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("k_club_name".localized)
                    .font(.caption11218Regular)
                    .foregroundColor(.gray800)
                Spacer()
                (
                    Text(String(viewModel.clubName.count))
                        .font(.caption11218Regular)
                        .foregroundColor(viewModel.clubName.count > 0 ? Color.primary500 : Color.gray300)
                    +
                    Text("/\(String(maxCharacterLength))")
                        .font(.caption11218Regular)
                        .foregroundColor(.gray300)
                )
            }
            
            HStack(spacing: 0) {
                CustomTextField(text: $viewModel.clubName, correctStatus: $viewModel.correctStatus, isKeyboardEnter: $viewModel.isKeyboardEnter, placeholder: "se_n_write_nickname".localized)
                    .onChange(of: viewModel.clubName) { newValue in
                        if viewModel.clubName.count == 0 {
                            viewModel.correctStatus = .Check
                        }
                        else {
                            if viewModel.clubName.count >= 1 && viewModel.clubName.count <= 30 {
                                viewModel.correctStatus = .Correct
                            }
                            else {
                                viewModel.correctStatus = .Wrong
                            }
                        }
                        
                        if !viewModel.exist {
                            exist = true
                        }
                    }
                
                Button {
                    viewModel.requestCreatingClubNameCheck(clubName: viewModel.clubName) { success in
                        if success {
                            viewModel.checkToken = checkToken
                            exist = false
                        }
                    }
                } label: {
                    Text("j_check_duplicate".localized)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(Color.gray25)
                        .modifier(ButtonTextMinimunScaleModifier())
                }
                .buttonStyle(.borderless)
                .frame(maxHeight: .infinity)
                .frame(width: sizeInfo.buttonWidth)
                .background(viewModel.clubName.count > 0 ? Color.stateActivePrimaryDefault.cornerRadius(sizeInfo.buttonCornerRadius) :
                                Color.stateEnableGray200.cornerRadius(sizeInfo.buttonCornerRadius))
                .padding(.leading, sizeInfo.padding)
            }
            .frame(maxWidth: .infinity)
            .frame(height: sizeInfo.inputHeight)
            .padding(.top, sizeInfo.padding)
            
            ZStack {
                if viewModel.clubName.count > 0 && !exist {
                    Text(viewModel.checkDescription)
                        .font(Font.caption21116Regular)
                        .foregroundColor(viewModel.exist ? .stateDanger : .stateEnablePrimaryDefault)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .leading], sizeInfo.padding5)
                }
                else {
                    Text("se_k_can_change_club_name".localized)
                        .font(Font.caption21116Regular)
                        .foregroundColor(.gray600)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, sizeInfo.padding5)
                }
            }
            
            
            HStack(spacing: 0) {
                Button(action: {
                    viewModel.CheckPersonalInfo()
                }, label: {
                    Image("icon_fill_check")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(.gray25)
                        .frame(width: 14, height: 14)
                        .padding(3)
                        .background(
                            Circle()
                                .fill(viewModel.isCheckPersonalInfo ? Color.stateEnablePrimaryDefault : Color.stateDisabledGray200)
                        )
                })
                
                (
                    Text("\("p_fantoo".localized) ")
                        .font(.caption21116Regular)
                        .foregroundColor(.gray900)
                    +
                    Text("se_p_agree_privacy_term_of_fantoo".localized)
                        .font(.caption21116Regular)
                        .foregroundColor(.gray900)
                        .underline()
                )
                    .padding(.leading, 8)
            }
            .padding(.top, 20)
            
            
        }
        .padding(.top, 24)
        .padding(.horizontal, sizeInfo.Hpadding)
        
    }
    
    var clubSettingView: some View {
        VStack(spacing: 0) {
            
            //가입 승인 방식
            ListLinkView(text: "g_join_accept_method".localized, subText: bottomSheetManager.onPressJoinApprovalSettingOfClub.description, subTextColor: Color.gray500, type: .ClickRight) {
//                showSheetJoinMethod = true
                bottomSheetManager.show.joinApprovalSettingOfClub = true
                bottomSheetManager.customBottomSheetClickType = .JoinApprovalSettingOfClub
            }
            
            //클럽 공개 설정
            ListLinkView(text: "k_club_visibility_settings".localized, subText: bottomSheetManager.onPressClubOpenSettingOfClub.description, subTextColor: Color.gray500, type: .ClickRight) {
//                showSheetClubVisibility = true
                bottomSheetManager.show.clubOpenSettingOfClub = true
                bottomSheetManager.customBottomSheetClickType = .ClubOpenSettingOfClub

            }
            
            //주 언어 설정
            ListLinkView(text: "j_main_language_settings".localized, subText: viewModel.languageName, subTextColor: Color.gray500, type: .ClickRight) {
                showSheetLanguageSetting = true
            }
            
            //주 활동국가 설정
            ListLinkView(text: "j_main_activity_contry_settings".localized, subText: viewModel.activeCountryCode, subTextColor: Color.gray500, type: .ClickRight) {
                showSheetCountrySetting = true
            }
        }
    }
    
    var clubJoinInfoView: some View {
        HStack(alignment: .top, spacing: 0) {
            
            Text("※")
                .font(.caption21116Regular)
                .foregroundColor(.gray600)
            
            Text(clubJoinInfo)
                .font(.caption21116Regular)
                .foregroundColor(.gray600)
                .lineLimit(nil)
                .padding(.leading, 3)
            
            Spacer()
        }
        .padding(.horizontal, sizeInfo.Hpadding)
        .padding(.bottom, 24)
    }
}
