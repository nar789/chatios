//
//  CustomButtonStyle.swift
//  fantoo
//
//  Created by fns on 2023/01/05.
//  Copyright © 2023 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct MyButtonStyle: ButtonStyle {

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .padding()
      .foregroundColor(.white)
      .background(configuration.isPressed ? Color.gray25 : Color.stateEnablePrimaryDefault)
      .cornerRadius(8.0)
  }
}
