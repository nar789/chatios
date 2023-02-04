//
//  CustomFocusTextField.swift
//  fantoo
//
//  Created by fns on 2022/07/21.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI
import Swift

struct CustomFocusTextField: UIViewRepresentable {
    enum CustomFocusTextFieldType: Int {
        case Default
        case Search
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String
        @Binding var correctStatus: CheckCorrectStatus
        @Binding var isKeyboardEnter: Bool
        var didBecomeFirstResponder = false
        var didFirstResponder = false
        var textField = UITextField(frame: .zero)
        
        init(textField:UITextField, text: Binding<String>, correctStatus: Binding<CheckCorrectStatus>, isKeyboardEnter: Binding<Bool>) {
            self.textField = textField
            self._text = text
            self._correctStatus = correctStatus
            self._isKeyboardEnter = isKeyboardEnter
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
    
    let textField = UITextField(frame: .zero)
    var placeholder: String
    var isFirstResponder: Bool = false
    
    @Binding var text: String
    @Binding var correctStatus: CheckCorrectStatus
    @Binding var isKeyboardEnter: Bool
    var type: CustomFocusTextFieldType = .Default
    
    
    func makeUIView(context: UIViewRepresentableContext<CustomFocusTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.placeholder = self.placeholder
        
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.keyboardType = .asciiCapable
        textField.placeHolderColor = UIColor.gray400
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        if type == .Default {
            textField.font = UIFont.body21420Regular
            textField.textColor = UIColor.gray870
            textField.backgroundColor = UIColor.gray50
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor.gray100.cgColor
            textField.clipsToBounds = true
            textField.layer.cornerRadius = 7.0
            textField.clearButtonMode = .whileEditing
            textField.setLeftPaddingPoints(15.0)
        }
        else if type == .Search {
            textField.font = UIFont.body21420Regular
            textField.textColor = UIColor.gray870
            textField.backgroundColor = UIColor.gray50
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor.gray100.cgColor
            textField.clipsToBounds = true
            textField.layer.cornerRadius = 7.0
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 42))
            
            let image = UIImage(named: "icon_outline_search")?.withRenderingMode(.alwaysTemplate)
            
            let imageView = UIImageView(image: image)
            imageView.tintColor = UIColor.stateEnableGray400
            imageView.contentMode = .center
            imageView.frame = CGRect(x: 15, y: 0, width: 18, height: 42)
            paddingView.addSubview(imageView)
            
            textField.leftView = paddingView
            textField.leftViewMode = .always
        }
        
        return textField
    }
    
    
    func makeCoordinator() -> CustomFocusTextField.Coordinator {
        //        return Coordinator(text: $text)
        
        return Coordinator(textField: self.textField, text: self.$text, correctStatus: self.$correctStatus, isKeyboardEnter: self.$isKeyboardEnter)
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomFocusTextField>) {
        uiView.text = text
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
        if correctStatus == .Correct {
            uiView.layer.borderColor = UIColor.primary500.cgColor
        }
        else if correctStatus == .Wrong {
            uiView.layer.borderColor = UIColor.stateDanger.cgColor
        }
        else {
            uiView.layer.borderColor = UIColor.gray100.cgColor
        }
    }
}
