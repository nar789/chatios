//
//  CustomTextView.swift
//  fantoo
//
//  Created by fns on 2022/07/22.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI


struct CustomTextView: UIViewRepresentable {
    
    @Binding var didStartEditing: Bool
    @Binding var text: String
    var placeholder: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
       
        let myTextView = UITextView()
        
        myTextView.delegate = context.coordinator
        
        myTextView.isScrollEnabled = true
        myTextView.isEditable = true
        myTextView.isUserInteractionEnabled = true
        myTextView.autocapitalizationType = .none
        myTextView.autocorrectionType = .no
        myTextView.returnKeyType = .done
        myTextView.keyboardType = .default
        myTextView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    
        myTextView.font = UIFont.body21420Regular
        myTextView.textColor = UIColor.gray870
        myTextView.backgroundColor = UIColor.gray50
        myTextView.layer.borderWidth = 1.0
        myTextView.layer.borderColor = UIColor.gray100.cgColor
        myTextView.clipsToBounds = true
        myTextView.layer.cornerRadius = 7.0
//        myTextView.clearButtonMode = .whileEditing
        myTextView.textContainer.lineFragmentPadding = 12.0
//        myTextView.setLeftPaddingPoints(15.0)
        
        return myTextView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        if didStartEditing {
            uiView.textColor = UIColor.black
            uiView.text = text
            uiView.font = UIFont.body21420Regular
        }
        else {
            uiView.text = self.placeholder
            uiView.textColor = UIColor.gray400
            uiView.font = UIFont.body21420Regular
        }
    }
    
    class Coordinator : NSObject, UITextViewDelegate {
        
        var parent: CustomTextView
        
        init(_ uiTextView: CustomTextView) {
            self.parent = uiTextView
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }
        
        func textViewDidChange(_ textView: UITextView) {
            print("text now: \(String(describing: textView.text!))")
            self.parent.text = textView.text
        }
    }
}
