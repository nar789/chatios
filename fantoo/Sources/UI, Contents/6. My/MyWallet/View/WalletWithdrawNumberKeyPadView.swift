//
//  NumberKeyPad.swift
//  fantoo
//
//  Created by fns on 2022/06/02.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI
//import CodeScanner

struct WalletWithdrawNumberKeyPadView : View {
    @StateObject var languageManager = LanguageManager.shared
    var placeholder = ""
    @State private var priceKDG = ""
    @State private var qrcodeText = ""
    @State private var isPresentingScanner = false
    @State var showTextField = false
    //    @State private var scannedCode: String?
    
    
    var body: some View {
        VStack {
            VStack {

                qrTopText()
                    .padding(.bottom, 30)
                ZStack {
                        //                    CommonTextField(placeholder: "최소 10 KDG", textFieldText: $priceKDG)
                        Color.gray50
                            .frame(height: 60)
                            .foregroundColor(.black)
                            .font(Font.body21420Regular)
                            .cornerRadius(10.0)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray100, lineWidth: 0.3))
                    HStack {
                        HideKeyboardTextField(text: $qrcodeText)
                            .placeholder(when: qrcodeText.isEmpty) {
                                Text("n_click_to_paste_address".localized)
                                    .foregroundColor(Color.gray400)
                                    .font(Font.body21420Regular)
                            }
                            .frame(height: 20)
                            .padding()
                        
                    
                            
                            Spacer()
                            Button {
                                isPresentingScanner = true
                            } label: {
                                Image("icon_outline_qr")
                                    .renderingMode(.template)
                                    .frame(width: 20, height: 20, alignment: .trailing)
                                    .font(Font.body21420Regular)
                                    .foregroundColor(Color.gray400)
                                    .padding()
                            }
                        }
                    }
                
                //                ZStack {
                //                    HideKeyboard(textFieldText: .constant(qrcodeText))
                //                    CommonTextField(placeholder: "눌러서 주소 붙여넣기", textFieldText: $qrcodeText)
                //                    HStack {
                //
                //                        Spacer()
                //                        Button {
                //                            isPresentingScanner = true
                //                        } label: {
                //                            Image("icon_outline_qr")
                //                                .renderingMode(.template)
                //                                .frame(width: 20, height: 20, alignment: .trailing)
                //                                .font(Font.body21420Regular)
                //                                .foregroundColor(Color.gray400)
                //                                .padding()
                //                        }
                //                    }
                //                }
                        //                    CommonTextField(placeholder: "최소 10 KDG", textFieldText: $priceKDG)
                    Button {
                        showTextField = true
                    } label: {
                        ZStack {
                        Color.gray50
                            .frame(height: 50)
                            .foregroundColor(.black)
                            .font(Font.body21420Regular)
                            .cornerRadius(10.0)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray100, lineWidth: 0.3))
                        HideKeyboardTextField(text: $priceKDG)
                            .placeholder(when: priceKDG.isEmpty) {
                                Text("c_minimum_10_kdg".localized)
                                    .foregroundColor(.gray)
                                    .font(Font.body21420Regular)
                            }
                            .frame(height: 50)
                            .padding()
                        
                        HStack {
                            Spacer()
                            Text("KDG")
                                .frame(width: 80, height: 10, alignment: .trailing)
                                .font(Font.body21420Regular)
                                .foregroundColor(Color.gray400)
                                .padding()
                        }
                    }
                    }.buttonStyle(.plain)
            }.padding([.leading, .trailing])
            
            
            Spacer()

            ExDivider(color: .gray100, height: 1)
            if showTextField == false {
                CustomKeyPad(string: .constant(""))
            } else {
                CustomKeyPad(string: $priceKDG)
            }
            //            ConfirmButtonView()
            Button {
            } label: {
                CommonButton(title: "d_next".localized, bgColor: Color.gray200)
            }
        }
//        .sheet(isPresented: $isPresentingScanner) {
//            CodeScannerView(codeTypes: [.qr]) { response in
//                if case let .success(result) = response {
//                    qrcodeText = result.string
//                    isPresentingScanner = false
//                }
//            }
//        }
    }
}


struct NumberKeyPadView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            WalletWithdrawNumberKeyPadView()
        }
    }
}


struct qrTopText : View {
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image("kingdom_coin_gold")
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 30, height: 30)
//                    .cornerRadius(22.5)
                
                Text("Kindom Coin Gold")
                    .fontWeight(.bold)
                    .font(Font.title51622Medium)
                    .foregroundColor(Color.gray800)
            }
            
            HStack {
                Text("j_balance".localized)
                    .fontWeight(.bold)
                    .font(Font.body21420Regular)
                    .foregroundColor(Color.gray600)
                Spacer().frame(width: 20)
                Text("123,123,123")
                    .fontWeight(.bold)
                    .font(Font.body21420Regular)
                    .foregroundColor(Color.gray600)
            }
        }
    }
}

struct HideKeyboard: View {
    
    @Binding var textFieldText: String
    
    var body: some View {
        ZStack {
            Color.gray50
                .frame(height: 50)
                .foregroundColor(.black)
                .font(Font.body21420Regular)
                .cornerRadius(10.0)
                .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray100, lineWidth: 0.3))
            HideKeyboardTextField(text: $textFieldText)
                .placeholder(when: textFieldText.isEmpty) {
                    Text("c_minimum_10_kdg".localized)
                        .foregroundColor(Color.gray400)
                        .font(Font.body21420Regular)
                }
                .frame(height: 20)
                .padding()
            
            HStack {
                Spacer()
                Text("KDG")
                    .frame(width: 80, height: 10, alignment: .trailing)
                    .font(Font.body21420Regular)
                    .foregroundColor(Color.gray400)
                    .padding()
            }
        }
    }
}

struct ConfirmButtonView: View {
    
    @State var checkState:Bool = false
    @State var showPassword = false
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Button(action:
                        {
                    self.checkState = !self.checkState
                    print("State : \(self.checkState)")
                }) {
                    HStack {
                        Image(self.checkState ? "Checkbox_login_checked" : "Checkbox_login_unchecked")
                            .frame(width:20, height:20, alignment: .center)
                            .cornerRadius(5)
                    }
                }
                .foregroundColor(Color.gray25)
                
                Text("se_m_i_understood".localized)
                    .font(Font.buttons1420Medium)
                Spacer()
            }.padding(.top, 5)
            
            ZStack(alignment: .leading) {
                Color.gray50
                    .frame(height: 55)
                    .cornerRadius(10.0)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.clear, lineWidth: 0))
                Text("se_c_check_withdraw_address".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray600)
                    .padding(.vertical, 10)
                    .padding(.leading, 15)
            }
            Spacer()
        }.padding(.all, 20)
    }
}
