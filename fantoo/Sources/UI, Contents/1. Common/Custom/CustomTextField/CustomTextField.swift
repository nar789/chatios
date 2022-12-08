//
//  CustomTextField.swift
//  fantoo
//
//  Created by mkapps on 2022/06/04.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct CustomTextField: UIViewRepresentable {
    enum CustomTextFieldType: Int {
        case Default
        case Security
        case Search
    }
    
    @Binding var text: String
    @Binding var correctStatus: CheckCorrectStatus
    @Binding var isKeyboardEnter: Bool
    
    var placeholder: String
    var isFirstResponder: Bool = false
    var type: CustomTextFieldType = .Default
    let textField = UITextField(frame: .zero)
    
    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
//        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.placeholder = self.placeholder
        
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.keyboardType = .default
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
        else if type == .Security {
            textField.font = UIFont.body21420Regular
            textField.textColor = UIColor.gray870
            textField.backgroundColor = UIColor.gray50
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor.gray100.cgColor
            textField.clipsToBounds = true
            textField.layer.cornerRadius = 7.0
            textField.isSecureTextEntry = true
            textField.setLeftPaddingPoints(15.0)
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 42))
  
            let normalImage = UIImage(named: "icon_outline_eye")?.withRenderingMode(.alwaysTemplate)
            let selectedImage = UIImage(named: "icon_outline_eye_closed")?.withRenderingMode(.alwaysTemplate)
            
            let button = UIButton(type: .custom)
            button.setImage(normalImage, for: .selected)
            button.setImage(selectedImage, for: .normal)
            button.tintColor = UIColor.gray400
//            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 100)
            button.frame = CGRect(x: 0, y: 0, width: 50, height: 42)
            button.addTarget(context.coordinator, action: #selector(Coordinator.checkVisible(_:)), for: .touchUpInside)
            paddingView.addSubview(button)
            
            textField.rightView = paddingView
            textField.rightViewMode = .always
            
//            let checkButton = UIImageView()
//            checkButton.image = UIImage(named: "icon_fill_check")
//            checkButton.frame = CGRect(x: 0, y: 0, width: 50, height: 42)
//            checkButton.alpha = 0
            
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
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.text = self.text
        if isFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.didFirstResponder = true
        }
        if isFirstResponder && !context.coordinator.didFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.didFirstResponder = true
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
    
    func makeCoordinator() -> CustomTextField.Coordinator {
        Coordinator(textField: self.textField, text: self.$text, correctStatus: self.$correctStatus, isKeyboardEnter: self.$isKeyboardEnter)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        @Binding var correctStatus: CheckCorrectStatus
        @Binding var isKeyboardEnter: Bool
        var didFirstResponder = false
        var textField = UITextField(frame: .zero)
        
        init(textField:UITextField, text: Binding<String>, correctStatus: Binding<CheckCorrectStatus>, isKeyboardEnter: Binding<Bool>) {
            self.textField = textField
            self._text = text
            self._correctStatus = correctStatus
            self._isKeyboardEnter = isKeyboardEnter
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            self.text = textField.text ?? ""
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
        @objc func checkVisible(_ sender: UIButton) {
            if sender.isSelected {
                self.textField.isSecureTextEntry = true
                sender.isSelected = false
                
            }
            else {
                self.textField.isSecureTextEntry = false
                sender.isSelected = true
            }
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
//            self.isFocused = true
//
//            if correctStatus == .Check {
//                textField.layer.borderColor = UIColor.gray100.cgColor
//            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            self.isKeyboardEnter = true
            
//            self.isFocused = false
//
//            if correctStatus == .Check {
//                textField.layer.borderColor = UIColor.primary500.cgColor
//            }
        }
    }
}
