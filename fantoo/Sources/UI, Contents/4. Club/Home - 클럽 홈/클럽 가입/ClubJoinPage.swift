//
//  ClubJoinPage.swift
//  fantoo
//
//  Created by sooyeol on 2023/01/27.
//  Copyright © 2023 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import Combine
import PopupView
import AttributedText

struct ClubJoinPage {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel = ClubJoinViewModel()
    
    @State private var needValidateNickname = true
    @State private var needDuplicateNickname = true
    @State private var showingToast = false
    
    @State private var textLength = 0
    
    private let maxTextLength = 20
    
    let clubId: String
    let clubName: String
    
    private struct sizeInfo {
        static let profileWidth: CGFloat = 80
        static let profileHeight: CGFloat = 80
        static let cornerRadius: CGFloat = 26
    }
    
    var joinCompletion: (Bool?) -> Void
    
}

extension ClubJoinPage: View {
    var body: some View {
        NavigationView {
            VStack {
                addProfileView
                
                nicknameView
                
                Spacer()
                
                CommonButton2(title: "가입하기", disabled: $needDuplicateNickname)
                    .onTapGesture {
                        viewModel.clubJoin(clubId: clubId,
                                           nickname: viewModel.nickname,
                                           profileImg: viewModel.profileImg) { joinAutoYn in
                            joinComplete(joinAutoYn)
                        }
                    }
                
            }
            .padding(.top, 30)
            .padding(.horizontal, 20)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: closeButton)
                }
            }
            .sheet(isPresented: $viewModel.showProfileImagePicker, content: {
                ImagePicker(sourceType: .photoLibrary, imageType: .BgImage) { success, image, message in
                    
                    if !success {
                        viewModel.errorMessage = message
                        viewModel.showErrorAlert = true
                        return
                    }
                    
                    viewModel.requestUploadImage(image: image) { id in
                        viewModel.profileImg = id
                    }
                }
            })
        }
        .popup(
            isPresented: $showingToast,
            type: .floater(),
            position: .bottom,
            animation: .spring(),
            autohideIn: 2,
            closeOnTapOutside: true,
            view: {
                ToastView(text: "닉네임은 최대 [20자]까지 입력 가능합니다.")
            }
        )
        .popup(isPresented: $viewModel.showAlert,
               type: .`default`,
               animation: Animation.easeOut(duration: 0.15),
               closeOnTap: false,
               backgroundColor: .black.opacity(0.4),
               dismissCallback: {
            if viewModel.checkNicknameResponse?.getExistYn() == .Ok {
                if viewModel.nicknameOkStep == 1 {
                    viewModel.nicknameOkStep = 2
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                        viewModel.showAlert.toggle()
                    }
                } else {
                    viewModel.nicknameOkStep = 1
                    needDuplicateNickname = false
                }
            }
        },
               view: {
            alertNickname()
        })
        .popup(isPresented: $viewModel.showJoinAlert,
               type: .`default`,
               animation: Animation.easeOut(duration: 0.15),
               closeOnTap: false,
               backgroundColor: .black.opacity(0.4),
               dismissCallback: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                presentationMode.wrappedValue.dismiss()
                self.joinCompletion(viewModel.clubJoinResponse?.memberJoinAutoYn)
            }
        },
               view: {
            alertJoinComplete()
        })
    }
    
    private var addProfileView: some View {
        Group {
            WebImage(url: URL(string: viewModel.profileImg?.imageOriginalUrl ?? ""))
                .placeholder(content: {
                    Image("profileCharacter")
                        .resizable()
                })
                .resizable()
                .frame(width: sizeInfo.profileWidth, height: sizeInfo.profileHeight)
                .cornerRadius(sizeInfo.cornerRadius)
        }
        .overlay {
            Image("icon_fill_camera")
                .resizable()
                .frame(width: 14, height: 14)
                .padding(5)
                .background(Color.gray25)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(Color.gray200, lineWidth: 1)
                }
                .offset(x: (sizeInfo.profileWidth/2) - 12, y: (sizeInfo.profileHeight/2) - 12)
        }
        .onTapGesture {
            viewModel.showProfileImagePicker = true
        }
    }
    
    private var nicknameView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("n_nickname".localized)
                    .foregroundColor(Color.gray800)
                    .font(.caption11218Regular)
                
                Spacer()
                
                (
                    Text(String(textLength))
                        .font(.caption11218Regular)
                        .foregroundColor(textLength > 0 ? Color.primary500 : Color.gray300)
                    +
                    Text("/\(String(maxTextLength))")
                        .font(.caption11218Regular)
                        .foregroundColor(.gray300)
                )
            }
            
            HStack {
                CustomTextField(
                    text: $viewModel.nickname,
                    correctStatus: $viewModel.correctStatus,
                    isKeyboardEnter: $viewModel.isKeyboardEnter,
                    placeholder: "se_n_write_nickname".localized
                )
                    .onChange(of: viewModel.nickname) { newValue in
                        if viewModel.nickname.count == 0 {
                            viewModel.correctStatus = .Check
                            needValidateNickname = true
                        }
                        else {
                            if viewModel.nickname.count >= 1 && viewModel.nickname.count <= maxTextLength {
                                needValidateNickname = false
                                viewModel.correctStatus = .Correct
                            }
                            else {
                                viewModel.correctStatus = .Wrong
                                needValidateNickname = true
                                if showingToast == false {
                                    showingToast.toggle()
                                }
                            }
                        }
                        textLength = viewModel.nickname.count
                    }
                    .frame(height: 42)
                
                CommonButton2(
                    title: "j_check_duplicate".localized,
                    cornerRadius: 8,
                    disabled: $needValidateNickname
                )
                .frame(width: 86)
                .onTapGesture {
                    if !needValidateNickname {
                        viewModel.checkClubNickname(clubId: clubId, nickname: viewModel.nickname)
                    }
                }
            }
            
            Text("se_a_need_set_profile_for_club".localized)
                .foregroundColor(Color.gray600)
                .font(.caption21116Regular)
            
            Text("se_n_change_nickname_notice_2".localized)
                .foregroundColor(Color.gray600)
                .font(.caption21116Regular)
            
        }
        .padding(.top, 30)
    }
    
    private var closeButton: some View {
        HStack(alignment: .center) {
            Image("icon_outline_cancel")
            
            Text("k_join_to_club".localized)
                .foregroundColor(Color.gray900)
                .font(.title41824Medium)
        }
    }
}

extension ClubJoinPage {
    func limitText(_ upper: Int) {
        if viewModel.nickname.count > upper {
            viewModel.nickname = String(viewModel.nickname.prefix(upper))
        }
        textLength = viewModel.nickname.count
        if textLength > 0 && needValidateNickname == true {
            needValidateNickname.toggle()
        } else if textLength == 0 && needValidateNickname == false {
            needValidateNickname.toggle()
        }
    }
    
    func joinComplete(_ joinAutoYn: Bool) {
        let name = "[\(clubName)]"
        var str = ""
        if joinAutoYn {
            str = "\(name)클럽에 가입되었습니다.\n많은 활동 기대하겠습니다."
        } else {
            str = "\(name)클럽에 가입신청이 완료되었습니다.\n클럽장 승인 후 알림 메시지가 발송됩니다."
        }
        let attributedString = NSMutableAttributedString(string: str)
        
        let para = NSMutableParagraphStyle()
        para.alignment = .center
        
        attributedString.addAttributes(
            [
                .font: UIFont.buttons1420Medium,
                .foregroundColor: UIColor.gray870,
                .paragraphStyle: para
            ],
            range: NSRange(location: 0, length: str.count)
        )
        
        attributedString.addAttributes(
            [.foregroundColor: UIColor.primary500],
            range: (str as NSString).range(of: name)
        )
        viewModel.joinMessage = attributedString
        
        viewModel.showJoinAlert.toggle()
    }
}


extension ClubJoinPage {
    func alertNickname() -> some View {
        return VStack(spacing: 0) {
            
            AttributedText {
                let nick = "[\(viewModel.nickname)]"
                let str = "\(nick) 설정"
                let result = NSMutableAttributedString(string: str)
                
                let para = NSMutableParagraphStyle()
                para.alignment = .center
                
                result.addAttributes(
                    [
                        .font: UIFont.title51622Medium,
                        .foregroundColor: UIColor.gray870,
                        .paragraphStyle: para
                    ],
                    range: NSRange(location: 0, length: str.count)
                )
                
                result.addAttributes(
                    [.foregroundColor: UIColor.primary500],
                    range: (str as NSString).range(of: nick)
                )
                
                return result
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            AttributedText {
                let nick = "[\(viewModel.nickname)]"
                var str = ""
                if viewModel.checkNicknameResponse?.getExistYn() == .Ok && viewModel.nicknameOkStep == 1 {
                    str = "사용 가능한 \(nick)입니다."
                } else if viewModel.checkNicknameResponse?.getExistYn() == .Ok && viewModel.nicknameOkStep == 2 {
                    str = "\(nick)은 30일에 한번 변경 가능합니다. 15일 후에 다시 변경하실 수 있습니다."
                } else {
                    str = "이미 사용중인 \(nick)입니다."
                }
                let result = NSMutableAttributedString(string: str)
                
                let para = NSMutableParagraphStyle()
                para.alignment = .center
                
                result.addAttributes(
                    [
                        .font: UIFont.buttons1420Medium,
                        .foregroundColor: UIColor.gray870,
                        .paragraphStyle: para
                    ],
                    range: NSRange(location: 0, length: str.count)
                )
                
                result.addAttributes(
                    [.foregroundColor: UIColor.primary500],
                    range: (str as NSString).range(of: nick)
                )
                
                if viewModel.checkNicknameResponse?.getExistYn() == .Ok && viewModel.nicknameOkStep == 2 {
                    result.addAttributes(
                        [.foregroundColor: UIColor.primary500],
                        range: (str as NSString).range(of: "30")
                    )
                    result.addAttributes(
                        [.foregroundColor: UIColor.primary500],
                        range: (str as NSString).range(of: "15")
                    )
                }
                
                return result
            }
            .padding(.top, 12)
            .frame(maxWidth: .infinity, alignment: .center)
            
            CommonButton(title: "확인", bgColor: Color.stateEnablePrimaryDefault)
                .padding(.top, 24)
                .onTapGesture {
                    viewModel.showAlert.toggle()
                }
        }
        .padding(EdgeInsets(top: 37, leading: 32, bottom: 40, trailing: 32))
        .background(Color.gray25.cornerRadius(24))
        .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 0)
        .shadow(color: .black.opacity(0.16), radius: 24, x: 0, y: 0)
        .padding(.horizontal, 50)
    }
    
    func alertJoinComplete() -> some View {
        return VStack(spacing: 0) {
            
            AttributedText {
                viewModel.joinMessage ?? NSAttributedString(string: "")
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            CommonButton(title: "확인", bgColor: Color.stateEnablePrimaryDefault)
                .padding(.top, 24)
                .onTapGesture {
                    viewModel.showJoinAlert.toggle()
                }
        }
        .padding(EdgeInsets(top: 37, leading: 32, bottom: 40, trailing: 32))
        .background(Color.gray25.cornerRadius(24))
        .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 0)
        .shadow(color: .black.opacity(0.16), radius: 24, x: 0, y: 0)
        .padding(.horizontal, 50)
    }
}
