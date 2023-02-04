//
//  CustomKeyPad.swift
//  fantoo
//
//  Created by fns on 2022/07/06.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI



struct KeyPadButton: View {
    var key: String
    
    var body: some View {
        Button(action: { self.action(self.key) }) {
            Text(key)
                .foregroundColor(Color.gray850)
                .font(Font.title32028Bold)
                .frame(width: UIScreen.main.bounds.width / 3, height: 90)
        }
    }
    
    enum ActionKey: EnvironmentKey {
        static var defaultValue: (String) -> Void { { _ in } }
    }
    
    @Environment(\.keyPadButtonAction) var action: (String) -> Void
}

extension EnvironmentValues {
    var keyPadButtonAction: (String) -> Void {
        get { self[KeyPadButton.ActionKey.self] }
        set { self[KeyPadButton.ActionKey.self] = newValue }
    }
}

//struct KeyPadButton_Previews: PreviewProvider {
//    static var previews: some View {
//        KeyPadButton(key: "8")
//            .padding()
//            .frame(width: 80, height: 80)
//            .previewLayout(.sizeThatFits)
//    }
//}

struct KeyPadRow: View {
    var keys: [String]
    
    var body: some View {
        HStack {
            ForEach(keys, id: \.self) { key in
                KeyPadButton(key: key)
                
                    .frame(width: DefineSize.Screen.Width / 3, height: 50)
                    .previewLayout(.sizeThatFits)
            }
        }
    }
}

struct CustomKeyPad: View {
    @Binding var string: String
    
    var body: some View {
        VStack {
            KeyPadRow(keys: ["1", "2", "3"])
            KeyPadRow(keys: ["4", "5", "6"])
            KeyPadRow(keys: ["7", "8", "9"])
            KeyPadRow(keys: ["00", "0", "←"])
        }.environment(\.keyPadButtonAction, self.keyWasPressed(_:))
    }
    
    private func keyWasPressed(_ key: String) {
        switch key {
            //        case "." where string.contains("."): break
            //        case "." where string == "0": string += key
        case "←":
            
            if string.count > 0 {
                string.removeLast()
            }
            if string.isEmpty { string = "" }
            
        case _ where string == "": string = key
        default: string += key
        }
    }
}
