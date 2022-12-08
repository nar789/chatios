//
//  SettingProfileView.swift
//  fantoo
//
//  Created by fns on 2022/05/18.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
//사용안하는중
struct SettingProfileView: View {
    @StateObject var languageManager = LanguageManager.shared
  @State private var pickedImage: Image = Image("icon_fill_my_t")
  @State private var isPickerPresented: Bool = false
  @State private var nickname: String = ""
  
  // MARK: Body
  
  var body: some View {
    NavigationView {
      VStack {
          profileImage
          nicknameTextField
      }
      .navigationBarTitle("마이 페이지")
    }
    .sheet(isPresented: $isPickerPresented) {
      ImagePickerView(pickedImage: self.$pickedImage)
    }
  }
}


private extension SettingProfileView {
  
  var profileImage: some View {
    pickedImage
      .resizable()
      .padding(.all, 30)
      .frame(width: 110, height: 110)
      .background(Color.gray100)
      .overlay(pickImageButton.offset(x: 3, y: 0), alignment: .bottomTrailing)
      .cornerRadius(25)
  }
  
  var pickImageButton: some View {
    Button(action: {
      self.isPickerPresented = true
    }) {
      Rectangle()
        .fill(Color.orange)
        .overlay(Image("").foregroundColor(.black))
        .frame(width: 32, height: 32)
        .cornerRadius(16)
    }
  }
  
  var nicknameTextField: some View {
      TextField("n_nickname".localized, text: $nickname)
      .font(.system(size: 25, weight: .medium))
      .textContentType(.nickname)
      .multilineTextAlignment(.center)
      .autocapitalization(.none)
  }
}


// MARK: - Previews

struct SettingProfileView_Previews : PreviewProvider {
  static var previews: some View {
        SettingProfileView()
  }
}

