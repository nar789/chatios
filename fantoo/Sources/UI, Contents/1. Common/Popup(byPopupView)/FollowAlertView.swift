//
//  FollowAlertView.swift
//  fantoo
//
//  Created by fns on 2022/08/31.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import PopupView

struct FollowAlertView: View {
    enum alertType: Int {
        case VoteAlert
        case FanitAlert
        case DateAlert
    }
    
    private struct sizeInfo {
        static let textSpacing: CGFloat = 12.0
        static let outLinePadding: CGFloat = 32.0
        static let buttonTop: CGFloat = 30.0
        static let buttonHeight: CGFloat = 36.0
    }
    
    @State var buttonToggle = false
    
    let title:String
    let message:String
    let number:String
    var detailMessage:String = ""
    let buttons:[String]
    let onClick: (Int) -> Void
    let onPress: () -> Void
    @Binding var isPresented:Bool
    
    var body: some View {
        ZStack {
            VStack {
                Image("profile_character_manager")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 54, height: 54, alignment: .center)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray25, lineWidth: 1)
                            .frame(width: 54, height: 54)
                    )
                    .padding(EdgeInsets(top: -65, leading: 0, bottom: 0, trailing: 0))
                
                HStack {
                    Spacer().frame(maxWidth: .infinity)
                    ZStack {
                        Text("팔로우")
                            .frame(width: 50, height: 26)
                            .font(.caption11218Regular)
                            .foregroundColor(.gray25)
                        
                            .background(Color.primary500)
                            .cornerRadius(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.primary100, lineWidth: 1)
                                    .frame(width: 50, height: 26)
                            )
                    }
                }
                .padding(EdgeInsets(top: -30, leading: 0, bottom: 0, trailing: -10))
                
                if title.count > 0 {
                    Text(title)
                        .font(Font.title41824Medium)
                        .foregroundColor(.gray870)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding([.bottom], message.count > 0 ? sizeInfo.textSpacing : sizeInfo.buttonTop)
                        .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
                }
                
                if message.count > 0 {
                    ZStack {
                        HStack {
                            Text("팔로워")
                                .font(Font.caption11218Regular)
                                .foregroundColor(Color.gray400)
                            Text(message)
                                .font(Font.caption11218Regular)
                                .foregroundColor(Color.gray700)
                        }
                    }
                    .frame(width: 240, height: 36, alignment: .center)
                    .background(Color.bgLightGray50)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.bgLightGray50, lineWidth: 0)
                            .frame(width: 240, height: 36)
                    )
                }
                if detailMessage.count > 0 {
                    Text(detailMessage)
                        .font(Font.caption11218Regular)
                        .foregroundColor(Color.gray700)
                        .multilineTextAlignment(.center)
                }
                
                if buttons.count > 0 {
                    if buttons.count == 1 {
                        Button(buttons[0]) {
                            isPresented = false
                            onClick(0)
                        }
                        .buttonStyle(.borderless)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(Color.gray25)
                        
                        .frame(maxWidth: .infinity)
                        .frame(height: sizeInfo.buttonHeight)
                        
                        .background(Color.stateEnablePrimaryDefault)
                        .cornerRadius(sizeInfo.buttonHeight/2)
                    }
                    //2개 까지만 하자.
                    else {
                        VStack(spacing: 0) {
                            Button {
                                isPresented = false
                                buttonToggle = false
                                onClick(0)
                            } label: {
                                Text(buttons[0])
                                    .font(Font.buttons1420Medium)
                                    .foregroundColor(buttonToggle ? Color.stateEnableGray400 : Color.gray25)
                                    .frame(width: 196, height: sizeInfo.buttonHeight)
                                    .background(buttonToggle ? Color.gray25 : Color.stateEnablePrimaryDefault)
                                    .cornerRadius(sizeInfo.buttonHeight / 2)
                            }
                            
                            Spacer().frame(height: 10)
                            
                            Button {
                                isPresented = false
                                buttonToggle = true
                                onClick(1)
                            } label: {
                                Text(buttons[1])
                                    .font(Font.buttons1420Medium)
                                    .foregroundColor(buttonToggle ? Color.gray25 : Color.stateEnableGray400)
                                    .frame(width: 196, height: sizeInfo.buttonHeight)
                                    .background(buttonToggle ? Color.stateEnablePrimaryDefault : Color.gray25)
                                    .cornerRadius(sizeInfo.buttonHeight/2)
                            }
                        }
                    }
                    
                }
                else {
                    Button("h_confirm".localized) {
                        isPresented = false
                        onClick(0)
                    }
                    .buttonStyle(.borderless)
                    .font(Font.buttons1420Medium)
                    .foregroundColor(Color.gray25)
                    
                    .frame(maxWidth: .infinity)
                    .frame(height: sizeInfo.buttonHeight)
                    
                    .background(Color.stateEnablePrimaryDefault)
                    .cornerRadius(sizeInfo.buttonHeight/2)
                }
            }
        }
        //        .frame(width: 276)
        .padding(EdgeInsets(top: 37, leading: sizeInfo.outLinePadding, bottom: 40, trailing: sizeInfo.outLinePadding))
        .background(Color.gray25.cornerRadius(24))
//                .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 0)
//                .shadow(color: .black.opacity(0.16), radius: 24, x: 0, y: 0)
        .padding(.horizontal, 50)
        .padding(.top, 32)

    }
}

struct FollowAlertViewModifier: ViewModifier {
    
    
    @Binding var isPresented:Bool
    
    let title:String
    let message:String
    let number:String
    let buttons:[String]
    var detailMessage:String = ""
    let onClick: (Int) -> Void
    let onPress: () -> Void
    
    func body(content: Content) -> some View {
        content
            .popup(isPresented: $isPresented, dragToDismiss: true, closeOnTap: true, closeOnTapOutside: true, backgroundColor: .black.opacity(0.4), view: {
                FollowAlertView(title: title, message: message, number: number, detailMessage: detailMessage, buttons: buttons, onClick: onClick, onPress: onPress, isPresented: $isPresented)
                
            })
    }
}

extension View {
    func showFollowAlert(
        isPresented: Binding<Bool>,
        title:String = "", message:String = "", number:String = "",
        detailMessage:String = "",
        buttons:[String],
        onClick:@escaping(Int) -> Void,
        onPress:@escaping() -> Void) -> some View {
            modifier(FollowAlertViewModifier(isPresented: isPresented, title: title, message: message, number: number, buttons: buttons, detailMessage: detailMessage, onClick: onClick, onPress: onPress))
        }
}
