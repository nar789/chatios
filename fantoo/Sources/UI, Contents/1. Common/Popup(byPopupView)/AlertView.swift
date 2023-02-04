//
//  Alerts.swift
//  fantoo
//
//  Created by mkapps on 2022/06/09.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import PopupView

struct AlertView: View {
    enum alertType: Int {
        case Default
        case ImageAlert
        case DateAlert
    }
    
    private struct sizeInfo {
        static let textSpacing: CGFloat = 12.0
        static let outLinePadding: CGFloat = 32.0
        static let buttonTop: CGFloat = 30.0
        static let buttonHeight: CGFloat = 36.0
        static let buttonTextSpacing: CGFloat = 5.0
    }
    
    @Binding var isPresented:Bool
    @Binding var buttonIndex:Int
    
    let type: alertType
    let title:String
    let message:String
    var detailMessage:String = ""
    let buttons:[String]
    
    let releaseDate = Date()
    static let stackDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 0) {
            if type == .ImageAlert {
                HStack {
                    Spacer()
                    Button {
                        buttonIndex = 0
                        isPresented = false
                    } label: {
                        Text("SKIP")
                            .foregroundColor(Color.gray600)
                            .font(Font.caption11218Regular)
                    }
                }
                if title.count > 0 {
                    Text(title)
                        .font(Font.title51622Medium)
                        .foregroundColor(.primary500)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding([.bottom], message.count > 0 ? sizeInfo.textSpacing : sizeInfo.buttonTop)
                }
                
                if message.count > 0 {
                    Text(message)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(.gray870)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding([.bottom], sizeInfo.buttonTop)
                }
                
                Image("character_login")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
                    .padding(.bottom, 10)
                
                if detailMessage.count > 0 {
                    Text(detailMessage)
                        .font(Font.caption11218Regular)
                        .foregroundColor(.gray700)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding([.bottom], sizeInfo.buttonTop)
                }
            }
            else if type == .Default {
                if title.count > 0 {
                    Text(title)
                        .font(Font.title51622Medium)
                        .foregroundColor(.primary500)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding([.bottom], message.count > 0 ? sizeInfo.textSpacing : sizeInfo.buttonTop)
                }
                
                if message.count > 0 {
                    Text(message)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(.gray870)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding([.bottom], sizeInfo.buttonTop)
                }
            }
            else if type == .DateAlert {
                if title.count > 0 {
                    Text(title)
                        .font(Font.title51622Medium)
                        .foregroundColor(.primary500)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding([.bottom], message.count > 0 ? sizeInfo.textSpacing : sizeInfo.buttonTop)
                }
                
                if message.count > 0 {
                    Text(message)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(.gray870)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding([.bottom], sizeInfo.textSpacing)
                }
                
                
                Text("\(releaseDate, formatter: Self.stackDateFormat)")
                    .font(Font.caption11218Regular)
                    .foregroundColor(.gray700)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding([.bottom], sizeInfo.textSpacing)
                
            }
            
            if buttons.count > 0 {
                if buttons.count == 1 {
                    Button {
                        buttonIndex = 0
                        isPresented = false
                    } label: {
                        Text(buttons[0])
                            .font(Font.buttons1420Medium)
                            .foregroundColor(Color.gray25)
                            .padding([.leading], sizeInfo.buttonTextSpacing)
                            .padding([.trailing], sizeInfo.buttonTextSpacing)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(height: sizeInfo.buttonHeight)
                            .background(Color.stateEnablePrimaryDefault)
                            .cornerRadius(sizeInfo.buttonHeight/2)
                    }
                    .buttonStyle(.borderless)
                }
                //2개 까지만 하자.
                else {
                    HStack(spacing: 0) {
                        Button {
                            buttonIndex = 0
                            isPresented = false
                        } label: {
                            Text(buttons[0])
                                .font(Font.buttons1420Medium)
                                .foregroundColor(Color.gray25)
                                .padding([.leading], sizeInfo.buttonTextSpacing)
                                .padding([.trailing], sizeInfo.buttonTextSpacing)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .frame(height: sizeInfo.buttonHeight)
                                .background(Color.stateEnableGray200)
                                .cornerRadius(sizeInfo.buttonHeight/2)
                        }
                        .buttonStyle(.borderless)
                        
                        Spacer().frame(width: sizeInfo.textSpacing)
                        
                        Button {
                            buttonIndex = 1
                            isPresented = false
                        } label: {
                            Text(buttons[1])
                                .font(Font.buttons1420Medium)
                                .foregroundColor(Color.gray25)
                                .padding([.leading], sizeInfo.buttonTextSpacing)
                                .padding([.trailing], sizeInfo.buttonTextSpacing)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .frame(height: sizeInfo.buttonHeight)
                                .background(Color.stateEnablePrimaryDefault)
                                .cornerRadius(sizeInfo.buttonHeight/2)
                        }
                        .buttonStyle(.borderless)
                    }
                }
                
            }
            else {
                Button {
                    buttonIndex = 0
                    isPresented = false
                } label: {
                    Text("h_confirm".localized)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(Color.gray25)
                        .padding([.leading], sizeInfo.buttonTextSpacing)
                        .padding([.trailing], sizeInfo.buttonTextSpacing)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: sizeInfo.buttonHeight)
                        .background(Color.stateEnablePrimaryDefault)
                        .cornerRadius(sizeInfo.buttonHeight/2)
                }
                .buttonStyle(.borderless)
            }
        }
        .padding(EdgeInsets(top: 37, leading: sizeInfo.outLinePadding, bottom: 40, trailing: sizeInfo.outLinePadding))
        .background(Color.gray25.cornerRadius(24))
        .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 0)
        .shadow(color: .black.opacity(0.16), radius: 24, x: 0, y: 0)
        .padding(.horizontal, 50)
    }
}

struct AlertViewModifier: ViewModifier {
    @Binding var isPresented:Bool
    @State var buttonIndex: Int = 0
    
    let type: AlertView.alertType
    let title:String
    let message:String
    let buttons:[String]
    let detailMessage:String
    
    let onClick: (Int) -> Void
    
    func body(content: Content) -> some View {
        content
            .popup(isPresented: $isPresented, type: .default, dragToDismiss: true, closeOnTap: true, closeOnTapOutside: true, backgroundColor: .black.opacity(0.4), view: {
                AlertView(isPresented: $isPresented, buttonIndex: $buttonIndex, type: type, title: title, message: message, detailMessage: detailMessage, buttons: buttons)
            })
            .onChange(of: isPresented) { newValue in
                if !newValue {
                    print("\n--- close alert -------------------\nbuttonIndex : \(buttonIndex)\n")
                    onClick(buttonIndex)
                }
            }
    }
}

extension View {
    func showAlertSimple(
        isPresented: Binding<Bool>,
        type: AlertView.alertType,
        title:String = "", message:String,
        detailMessage:String = "",
        onClick:@escaping(Int) -> Void) -> some View {
            modifier(AlertViewModifier(isPresented: isPresented, type: type, title: title, message: message, buttons: [], detailMessage: detailMessage, onClick: onClick))
        }
    
    func showAlert(
        isPresented: Binding<Bool>,
        type: AlertView.alertType,
        title:String = "", message:String,
        detailMessage:String = "",
        buttons:[String],
        onClick:@escaping(Int) -> Void) -> some View {
            modifier(AlertViewModifier(isPresented: isPresented, type: type, title: title, message: message, buttons: buttons, detailMessage: detailMessage, onClick: onClick))
        }
}



//struct AlertView_Previews: PreviewProvider {
//    static var previews: some View {
//        Text("Click")
//            .popup(isPresented: .constant(true), type: .default, dragToDismiss: true, closeOnTap: true, closeOnTapOutside: true, backgroundColor: .black.opacity(0.4), view: {
//                AlertView(isPresented: .constant(true), buttonIndex: .constant(0), type: type, title: "추천인 코드가 정상 등록되었습니다.", message: "500 팬잇이 지급되었습니다.보유한 팬잇 수량은 ‘메뉴 > 내 지갑'\n에서 확인하실 수 있습니다.", detailMessage: "", buttons: ["cancel", "ok"])
//            })
//    }
//}
