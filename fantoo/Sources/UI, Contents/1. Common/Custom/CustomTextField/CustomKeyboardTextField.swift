//
//  CustomKeyboardTextField.swift
//  fantoo
//
//  Created by fns on 2022/07/12.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct CustomKeyboardTextField: UIViewRepresentable {
    //    let contentType: UITextContentType
    let returnVal: UIReturnKeyType
    let placeholder: String
    let tag: Int
    @Binding var text: String
    @Binding var isfocusAble: [Bool]
    var isFirstResponder: Bool = false
    var onCommit: ()->()
    func makeUIView(context: UIViewRepresentableContext<CustomKeyboardTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        //        textField.textContentType = contentType
        //        textField.returnKeyType = returnVal
        
        textField.tag = tag
        textField.delegate = context.coordinator
        textField.placeholder = self.placeholder
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.keyboardType = .default
        textField.placeHolderColor = UIColor.gray400
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        textField.font = UIFont.body21420Regular
        textField.textColor = UIColor.gray870
        textField.backgroundColor = UIColor.gray50
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.gray100.cgColor
        textField.clipsToBounds = true
        textField.layer.cornerRadius = DefineSize.CornerRadius.TextField
        textField.clearButtonMode = .whileEditing
        textField.setLeftPaddingPoints(15.0)
        
        return textField
    }
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomKeyboardTextField>) {
        uiView.text = text
        
        if isFirstResponder && !context.coordinator.didFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.didFirstResponder = true
        }
        
        //        if uiView.window != nil {
        //            if isfocusAble[tag] {
        //                if !uiView.isFirstResponder {
        //                    uiView.becomeFirstResponder()
        //                }
        //            } else {
        //                uiView.resignFirstResponder()
        //
        //            }
        //        }
    }
    
    func makeCoordinator() -> CustomKeyboardTextField.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        var parent: CustomKeyboardTextField
        var didFirstResponder = false
        
        init(_ textField: CustomKeyboardTextField) {
            self.parent = textField
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            // Without async this will modify the state during view update.
            DispatchQueue.main.async {
                self.parent.text = textField.text ?? ""
            }
        }
        
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            setFocus(tag: parent.tag)
            return true
        }
        func setFocus(tag: Int) {
            let reset = tag >= parent.isfocusAble.count || tag < 0
            
            if reset || !parent.isfocusAble[tag] {
                var newFocus = [Bool](repeatElement(false, count: parent.isfocusAble.count))
                if !reset {
                    newFocus[tag] = true
                }
                // Without async this will modify the state during view update.
                DispatchQueue.main.async {
                    self.parent.isfocusAble = newFocus
                    //                    self.parent.onCommit()
                }
            }
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            setFocus(tag: parent.tag + 1)
            self.parent.onCommit()
            return true
        }
    }
}

struct CustomKeyboardTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomKeyboardTextField(returnVal: .next,
                        placeholder: "Email",
                        tag: 0,
                        text: .constant(""),
                        isfocusAble: .constant([false]), onCommit: {
            print("123")
            
        })
    }
}

