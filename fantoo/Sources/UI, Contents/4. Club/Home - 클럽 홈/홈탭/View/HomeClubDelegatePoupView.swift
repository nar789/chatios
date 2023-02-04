//
//  HomeClubDelegatePoupView.swift
//  fantoo
//
//  Created by sooyeol on 2023/01/31.
//  Copyright © 2023 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import AttributedText

struct HomeClubDelegatePopupView: View {

    @Binding var isPresented: Bool
    
    var clubId: String
    var clubName: String
    var model: ClubDelegateMemberData
    
    @State var checked1: Bool = false
    @State var checked2: Bool = false
    
    var buttonHandler: ((ActionType) -> Void)?

    
    private struct checkInfo {
        static let size: CGSize = CGSize(width: 24.0, height: 24.0)
        static let padding8: CGFloat = 8.0
        static let padding12: CGFloat = 12.0
    }
    
    private struct closeInfo {
        static let size: CGSize = CGSize(width: 24.0, height: 24.0)
        static let padding: CGFloat = 18
    }
    
    private struct popupSize {
        static let horizontalPadding: CGFloat = 50.0
        static let cornerRadius: CGFloat = 32.0
    }
    
    enum ActionType {
        case Accept
        case Refuse
    }
    

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                Text("클럽장 위임 동의")
                    .foregroundColor(Color.gray870)
                    .font(.title41824Medium)
                    .padding(.top, 17)
                
                AttributedText {
                    let clubName = "[\(clubName)]"
                    let str = "클럽장이 회원님께\n\(clubName)클럽장을 위임하였습니다."
                    let result = NSMutableAttributedString(string: str)
                    
                    let para = NSMutableParagraphStyle()
                    para.alignment = .center
                    
                    result.addAttributes(
                        [
                            .font: UIFont.caption11218Regular,
                            .foregroundColor: UIColor.gray850,
                            .paragraphStyle: para
                        ],
                        range: NSRange(location: 0, length: str.count)
                    )
                    
                    result.addAttributes(
                        [.foregroundColor: UIColor.primaryDefault],
                        range: (str as NSString).range(of: clubName)
                    )
                    
                    return result
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding([.top, .bottom], 10)
                
                VStack(alignment: .leading) {
                    Button {
                        checked1.toggle()
                    } label: {
                        HStack(alignment: .top, spacing: 0) {
                            Image(checked1 ? "checkboxLoginChecked" : "checkboxLogin")
                                .frame(width: checkInfo.size.width, height: checkInfo.size.height)
                                .padding(.leading, checkInfo.padding12)
                                .padding(.trailing, checkInfo.padding8)
                            
                            Text("클럽장 위임을 수락하시면, \(model.expectCompleteDate.changeDateString("yyyy-MM-dd HH:mm:ss","{yyyy}.{MM}.{dd}"))에 위임이 완료됩니다")
                                .foregroundColor(Color.stateDanger)
                                .font(.caption21116Regular)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding(.trailing, 24)
                    
                    Text("(단, 클럽장이 \(model.expectCompleteDate.changeDateString("yyyy-MM-dd HH:mm:ss","{yyyy}.{MM}.{dd}"))까지 위임을 취소하면, 클럽장 위임이 취소됩니다.)")
                        .foregroundColor(Color.gray700)
                        .font(.caption21116Regular)
                        .padding(EdgeInsets(top: 0, leading: 44, bottom: 0, trailing: 12))
                    
                    Button {
                        checked2.toggle()
                    } label: {
                        HStack(alignment: .top, spacing: 0) {
                            Image(checked2 ? "checkboxLoginChecked" : "checkboxLogin")
                                .frame(width: checkInfo.size.width, height: checkInfo.size.height)
                                .padding(.leading, checkInfo.padding12)
                                .padding(.trailing, checkInfo.padding8)
                            
                            Text("se_a_cannot_cancel_after_delegating_agree".localized)
                                .foregroundColor(Color.stateDanger)
                                .font(.caption21116Regular)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding(.trailing, 24)
                }
                .padding(.vertical, 12)
                .background(Color.bgLightGray50.cornerRadius(12))
                
                Text("위임을 수락하시겠습니까?")
                    .foregroundColor(Color.gray850)
                    .font(.buttons1420Medium)
                    .padding(.top, 10)
                    .padding(.bottom, 26)
                
                CommonButton2(
                    title: "a_agree_to_delegate".localized,
                    type: .defaults(),
                    disabled: notCheckedAll()
                )
                .padding(.horizontal, 22)
                .onTapGesture {
                    if !notCheckedAll().wrappedValue {
                        buttonHandler?(.Accept)
                        isPresented.toggle()
                    }
                }
                
                CommonButton2(
                    title: "g_rejection".localized,
                    type: .defaults(
                        textColor: Color.stateEnableGray400,
                        backgroundColor: Color.gray25
                    )
                )
                .onTapGesture {
                    if !notCheckedAll().wrappedValue {
                        buttonHandler?(.Refuse)
                        isPresented.toggle()
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 18, bottom: 16, trailing: 18))
            .background(Color.gray25.cornerRadius(popupSize.cornerRadius))
            .padding(.horizontal, popupSize.horizontalPadding)
            
            Button(action: {
                isPresented.toggle()
            }, label: {
                Image("icon_outline_cancel")
                    .resizable()
            })
            .frame(width: closeInfo.size.width, height: closeInfo.size.height)
            .padding(.trailing, closeInfo.padding + popupSize.horizontalPadding)
            .padding(.top, closeInfo.padding)
        }
    }
}

extension HomeClubDelegatePopupView {
    func notCheckedAll() -> Binding<Bool> {
        return .constant(!(checked1 && checked2))
    }
}

