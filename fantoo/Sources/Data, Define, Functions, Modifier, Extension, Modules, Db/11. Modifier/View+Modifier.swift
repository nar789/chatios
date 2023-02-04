//
//  View+Modifier.swift
//  fantoo
//
//  Created by mkapps on 2022/05/21.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func setCornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}


//placeholder custom
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}

//Divider Custom
struct ExDivider: View {
    var color: Color
    var height: CGFloat
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: height)
            .edgesIgnoringSafeArea(.horizontal)
    }
}

struct VerticalDivider: View {
    var color: Color
    var width: CGFloat
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: width)
            .edgesIgnoringSafeArea(.vertical)
    }
}

//textField 사용시, 키보드 반응 x
struct HideKeyboardTextField: UIViewRepresentable {
    //    var placeholder: String
    @Binding var text: String
    
    func makeUIView(context: UIViewRepresentableContext<HideKeyboardTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.inputView = UIView()
        textField.delegate = context.coordinator
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<HideKeyboardTextField>) {
        uiView.text = text
    }
    
    func makeCoordinator() -> HideKeyboardTextField.Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: HideKeyboardTextField

        init(parent: HideKeyboardTextField) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.parent.text = textField.text ?? ""
            }
        }
    }
//    class Coordinator : NSObject, UITextViewDelegate {
//
//           var parent: HideKeyboardTextField
//
//           init(parent: HideKeyboardTextField) {
//               self.parent = parent
//           }
//
//           func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//               return true
//           }
//
//           func textViewDidChange(_ textView: UITextView) {
//               print("text now: \(String(describing: textView.text!))")
//               self.parent.text = textView.text
//               DispatchQueue.main.async {
//                   self.parent.text = textView.text ?? ""
//               }
//           }
//       }
}

//keyboard dismiss
extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}

// bottomSheet dismiss
struct ShowingSheetKey: EnvironmentKey {
    static let defaultValue: Binding<Bool>? = nil
}

extension EnvironmentValues {
    var showingSheet: Binding<Bool>? {
        get { self[ShowingSheetKey.self] }
        set { self[ShowingSheetKey.self] = newValue }
    }
}

// Keyboard ViewTapDismiss
struct BackgroundTapGesture<Content: View>: View {
  private var content: Content
  
  init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content()
  }
  
  var body: some View {
      Color.white.opacity(0.0)
          .overlay(content)
  }
}
