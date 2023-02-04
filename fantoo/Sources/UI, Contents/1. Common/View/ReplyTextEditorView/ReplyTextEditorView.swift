//
//  ReplyTextEditorView.swift
//  fantoo
//
//  Created by kimhongpil on 2022/12/08.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

/**
 * 댓글 입력 TextEditor
 */
struct ReplyTextEditorView: View {
    /**
     * 언어팩 등록할 것
     */
    @State private var placeholderText: String = "댓글을 입력해 주세요"
    @Binding var content: String
    @Binding var isKeyboardFocused: Bool
    @State private var textEditorHeight: CGFloat = CGFloat()
    var startHeight: CGFloat

    var body: some View {

        ZStack(alignment: .center) {
            //let _ = print("isKeyboardFocused : \(isKeyboardFocused)" as String)
            Text(content)
                .frame(minHeight: startHeight)
                .lineLimit(5)
                .font(Font.body21420Regular)
                .foregroundColor(.clear)
                .background(GeometryReader { proxy in
                    Color.clear.preference(key: ViewHeightKey.self,
                                           value: proxy.frame(in: .local).size.height)
                })

            Group {
                if self.content.isEmpty {
                    TextEditor(text: $placeholderText)
                        .frame(height: textEditorHeight)
                        .font(Font.body21420Regular)
                        .foregroundColor(Color.stateEnableGray400)
                        .disabled(true)
                }
                TextEditor(text: $content)
                    .frame(height: textEditorHeight)
                    .opacity(self.content.isEmpty ? 0.25 : 1)
                    .font(Font.body21420Regular)
                    .foregroundColor(Color.gray800)
                    .introspectTextView { textView in
                        textView.showsVerticalScrollIndicator = false
                    }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                //print("idpilLog::: keyboardWillShowNotification! when content is Empty!")
                /**
                 * keyboardDidShowNotification 보다 더 빨리 호출되기 때문에 여기서 설정함
                 */
                isKeyboardFocused = true
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                // Write code for keyboard opened.
                //print("idpilLog::: keyboardDidShowNotification! when content is Empty!")
                //isKeyboardFocused = true
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                //print("idpilLog::: keyboardWillHideNotification! when content is Empty!")
                /**
                 * keyboardDidHideNotification 보다 더 빨리 호출되기 때문에 여기서 설정함
                 */
                isKeyboardFocused = false
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                // Write code for keyboard closed.
                //print("idpilLog::: keyboardDidHideNotification! when content is Empty!")
                //isKeyboardFocused = false
            }
        }
        //.onPreferenceChange(ViewHeightKey.self) { textEditorHeight = $0 }
        .onPreferenceChange(ViewHeightKey.self, perform: { updatedOffset in
            textEditorHeight = updatedOffset
        })
    }

}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
