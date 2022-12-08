//
//  StandByJoinClubMemberPage_S.swift
//  fantoo
//
//  Created by fns on 2022/11/01.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import CoreMedia

struct StandByJoinClubMemberPage_S {

    
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var vm = ClubSettingViewModel()
    
    @Binding var clubId: String
    
    @State var approvalCheck:Bool = false
    @State var approvalDate:String = "2022.08.14"
    @State var isCheck: Bool = false
    @State var approvalMember: Bool = false
    @State var approvalRejectAlert: Bool = false
    @State var approvalMemberCount: Int = 0
    @State var approvalJoinIdList: [Int] = []
    
    
    private struct sizeInfo {
        static let cellHeight: CGFloat = 57.5
        static let stackHeight: CGFloat = 42.0
        static let checkSize: CGSize = CGSize(width: 24.0, height: 24.0)
        static let padding12: CGFloat = 12.0
        static let padding10: CGFloat = 10.0
        static let padding11: CGFloat = 11.0
        static let spacing5: CGFloat = 5.0
        static let spacing20: CGFloat = 20.0
        static let spacing12: CGFloat = 12.0
        static let spacing100: CGFloat = 100.0
        static let rectangleRadius: CGFloat = 12.0
        static let rectangleHeight: CGFloat = 52.0
        static let stackSpacing: CGFloat = -10.0
        static let dividerHeight: CGFloat = 1.0
        static let buttonWidth: CGFloat = 125.0
    }
    
}

extension StandByJoinClubMemberPage_S: View {
    
    var body: some View {
        ZStack {
        VStack {
            Spacer().frame(height: sizeInfo.spacing12)
            ZStack {
                RoundedRectangle(cornerRadius: sizeInfo.rectangleRadius)
                    .fill(Color.bgLightGray50)
                    .frame(height: sizeInfo.rectangleHeight)
                Text("※ 가입신청일로부터 30일간 승일하지 않을 경우, \n자동으로 승인 불가 처리 됩니다.")
                    .font(Font.caption21116Regular)
                    .foregroundColor(Color.gray600)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, sizeInfo.padding11)
                    .padding(.vertical, sizeInfo.padding10)
            }
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
            
            Button {
                isCheck = !isCheck
                
                isCheck = isCheck
                approvalCheck = isCheck
                
            } label: {
                ZStack {
                    HStack {
                        Image(isCheck ? "Checkbox_login_checked" : "Checkbox_login_unchecked")
                            .frame(width:sizeInfo.checkSize.width, height:sizeInfo.checkSize.height)
                            .padding(.trailing, sizeInfo.padding12)
                        Text("j_all".localized)
                            .font(Font.title51622Medium)
                            .foregroundColor(Color.stateEnableGray900)
                        Spacer().frame(width: sizeInfo.spacing5)
                        Text("\(vm.approvalMemberCount)")
                            .font(Font.body21420Regular)
                            .foregroundColor(Color.gray500)
                        
                        Spacer()
                    }
                    .frame(height: sizeInfo.cellHeight, alignment: .center)
                    .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
                    if approvalMemberCount > 0 {
                        ExDivider(color: .bgLightGray50, height: sizeInfo.dividerHeight)
                            .frame(height: DefineSize.LineHeight, alignment: .bottom)
                            .padding(EdgeInsets(top: sizeInfo.cellHeight - DefineSize.LineHeight, leading:0, bottom: 0, trailing: 0))
                    }
                }
            }
            if vm.approvalMemberCount > 0 {
                GeometryReader { geo in
                    ScrollView {
                        
                        ForEach(Array(vm.clubJoinListData.enumerated()), id: \.offset) { index, element in
            
                            
                            StandByJoinClubMemberPage_S_RowView(
                                isCheck: $approvalCheck,
                                index: index,
                                element: element,
                                viewModel: vm,
                                showLine: true,
                                onPress: { type in
                                if type == .Check {
                                    approvalCheck.toggle()
                                }
                                approvalJoinIdList.append(element.joinId)
                            }
//                                index: index,
//                                element: element,
//                                favoriteYn: element.favoriteYn,
//                                viewModel: vm
                            )
                                .padding(.top, 16)
                        }
//                        let clubJoinListData = vm.clubJoinListData ?? nil
//                        if clubJoinListData != nil {
//                            ForEach(clubJoinListData!, id : \.self) { i in
//
//                                StandByMemberCheckSubView(isCheck: $approvalCheck, approvalDate: i.createDate, title: i.nickname, showLine: true, onPress: { type in
//                                    if type == .Check {
//                                        approvalCheck.toggle()
//                                    }
//                                    approvalJoinIdList.append(i.joinId)
//                                })
//                            }
//                        }
                    }
                    .padding(.top, sizeInfo.stackSpacing)
                }
                .frame(maxHeight: .infinity)
                
                Spacer().frame(height: sizeInfo.spacing20)
                
                if approvalCheck {
                    HStack {
                        Button {
                            vm.requestClubJoinMemberRejection(clubId: clubId, joinIdList: approvalJoinIdList)
                            approvalRejectAlert = true
                        } label: {
                            CommonButton(title: "g_rejection".localized, bgColor: Color.stateEnableGray200)
                                .frame(maxWidth: sizeInfo.buttonWidth, alignment: .leading)
                        }
                        
                        Spacer().frame(width: sizeInfo.spacing12)
                        
                        Button {
                            vm.requestClubJoinMemberApproval(clubId: clubId, joinIdList: approvalJoinIdList)
                            approvalMemberCount = 0
                            isCheck = false
                        } label: {
                            CommonButton(title: "g_join_approval".localized, bgColor: Color.stateActivePrimaryDefault)
                        }
                    }
                    .frame(height: sizeInfo.stackHeight)
                    .padding([.horizontal, .bottom], DefineSize.Contents.HorizontalPadding)
                }
            } else {
                Spacer().frame(height: sizeInfo.spacing100)
                Text("se_g_no_exist_join".localized)
                    .font(Font.body21420Regular)
                    .foregroundColor(Color.gray400)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .modifier(ScrollViewLazyVStackModifier())
        
        .showAlert(isPresented: $approvalRejectAlert, type: .Default, title: "g_rejection_of_join_approval".localized, message: "se_g_refuse_join".localized, detailMessage: "", buttons: ["c_cancel".localized, "g_rejection".localized], onClick: { buttonIndex in
            if buttonIndex == 1 {
                
            }
        })
        
        .onAppear(perform: {
            vm.requestClubJoinMemberList(clubId: clubId)
        })
        .background(
            NavigationLink("", isActive: $approvalMember) {
                ClubMemberManegementPage(clubId: $clubId)
            }.hidden()
        )
        
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "g_waiting_for_join_approval".localized, onPress: { buttonType in
            print("onPress buttonType : \(buttonType)")
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
        LoadingViewInPage(loadingStatus: $vm.loadingStatus)
        }
    }
}


struct StandByJoinClubMemberPage_S_RowView: View {
    
    private let isOwner = "a_operate".localized // MainClubPage.swift 에서 이미 있음
    
//    =-=-=-=-=-=-=-=-=-=-=
    
    @StateObject var languageManager = LanguageManager.shared
    
    enum AgreeCheckSubViewButtonType {
        case More
        case Check
    }
    
    private struct sizeInfo {
        static let cellHeight: CGFloat = 57.5
        static let checkSize: CGSize = CGSize(width: 24.0, height: 24.0)
        static let cellImageSize: CGSize = CGSize(width: 36.0, height: 36.0)
        static let padding12: CGFloat = 12.0
        static let padding10: CGFloat = 10.0
        static let textSpacing: CGFloat = 4.0
        static let cellTextHeight: CGFloat = 16.0
        static let dividerHeight: CGFloat = 1.0
        static let StackHeight: CGFloat = 36.0
    }
    
    
    @Binding var isCheck: Bool
    let index: Int
    let element: ClubJoinListData
    var viewModel = ClubSettingViewModel()
    let showLine: Bool
    let onPress: (AgreeCheckSubViewButtonType) -> Void
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Button {
                    onPress(.Check)
                } label: {
                        Image(isCheck ? "Checkbox_login_checked" : "Checkbox_login_unchecked")
                            .frame(width:sizeInfo.checkSize.width, height:sizeInfo.checkSize.height)
                            .padding(.trailing, sizeInfo.padding12)
                    WebImage(url: URL(string: element.profileImg.imageOriginalUrl))
                            .resizable()
                            .placeholder(Image(Define.ProfileDefaultImage))
                            .frame(width: sizeInfo.cellImageSize.width, height: sizeInfo.cellImageSize.height, alignment: .leading)
                            .clipped()
                            .cornerRadius(DefineSize.CornerRadius.ProfileThumbnailS)
                            .padding([.trailing], sizeInfo.padding10)
                        
                        VStack {
                            Text(element.nickname)
                                .font(Font.body21420Regular)
                                .foregroundColor(Color.gray900)
                                .frame(maxWidth: .infinity, maxHeight: sizeInfo.cellTextHeight, alignment: .leading)
                            Spacer().frame(width: sizeInfo.textSpacing)
                            HStack {
                                Text("s_application_date".localized)
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(Color.gray400)
                                    .frame(maxHeight: sizeInfo.cellTextHeight, alignment: .leading)

                                Text(element.createDate)
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(Color.gray400)
                                    .frame(maxHeight: sizeInfo.cellTextHeight, alignment: .leading)
                                Spacer()
                            }
                        }
                        .frame(height: sizeInfo.StackHeight, alignment: .center)
                }
            }
            .frame(height: sizeInfo.cellHeight, alignment: .center)
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
    
            if showLine {
                ExDivider(color: .bgLightGray50, height: sizeInfo.dividerHeight)
                    .frame(height: DefineSize.LineHeight, alignment: .bottom)
                    .padding(EdgeInsets(top: sizeInfo.cellHeight - DefineSize.LineHeight, leading:0, bottom: 0, trailing: 0)
                    )}
        }
    }
}
