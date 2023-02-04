//
//  BottomAlertView.swift
//  fantoo
//
//  Created by fns on 2022/06/25.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//


import SwiftUI

private struct PopupContainerView<Content: View, Popup: View>: View {
    @Binding var isPresenting: Bool
    let autoDismiss: PopupAutoDismissType
    let locationType: LocationType
    let onDisappear: (() -> Void)?
    let hasShadow: Bool
    let cornerRadius: CGFloat
    let overlayColor: Color
    let isTapOutsideToDismiss: Bool
    let content: Content
    let popup: Popup
    
    @State var timer: Timer? = nil
    
    var body: some View {
        content
            .overlay(overlayView)
    }
    
    @ViewBuilder private var overlayView: some View {
        if isPresenting {
            ZStack {
                overlayColor
                if locationType == .bottom {
                    popup
                        .background(Color(UIColor.systemBackground))
                        .transition(.opacity)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

                        .onAppear {
                            self.onPopupAppear()
                        }
                        .onDisappear {
                            self.onPopupDisappear()
                        }
                    
                        .padding(EdgeInsets(top: DefineSize.Screen.Height / 1.7, leading: 0, bottom: 0, trailing: 0))
                }
                else if locationType == .middle {
                    popup
                        .background(Color(UIColor.systemBackground))
                        .transition(.opacity)
                        .onAppear {
                            self.onPopupAppear()
                        }
                        .onDisappear {
                            self.onPopupDisappear()
                        }
                }
            }
        }
    }
    
    private func onPopupAppear() {
        var showTime: TimeInterval = 0
        switch autoDismiss {
        case .after(let duration):
            showTime = duration
            
        case .auto(let message):
            let estimateWords = Double(message.count)/5
            let minDuration: TimeInterval = 2
            showTime = max(estimateWords/3, minDuration)
            
        default: break
        }
        
        if showTime > 0 {
            timer = Timer.scheduledTimer(withTimeInterval: showTime, repeats: false) { _ in
                self.isPresenting = false
            }
        }
    }
    
    private func onPopupDisappear() {
        timer?.invalidate()
        timer = nil
        onDisappear?()
    }
}

struct PopupModifier<Popup: View>: ViewModifier {
    var isPresenting: Binding<Bool>
    var hasShadow: Bool = true
    var cornerRadius: CGFloat = 10
    var overlayColor: Color = Color.clear
    var isTapOutsideToDismiss: Bool = false
    var locationType: LocationType = .top
    var autoDismiss: PopupAutoDismissType = .none
    var onDisappear: (() -> Void)? = nil
    var popup: Popup
    
    func body(content: Self.Content) -> some View {
        PopupContainerView(isPresenting: isPresenting, autoDismiss: autoDismiss, locationType: locationType, onDisappear: onDisappear, hasShadow: hasShadow, cornerRadius: cornerRadius, overlayColor: overlayColor, isTapOutsideToDismiss: isTapOutsideToDismiss, content: content, popup: popup)
    }
}

public extension View {
    func popup<Popup: View>(
        isPresenting: Binding<Bool>,
        hasShadow: Bool = true,
        cornerRadius: CGFloat = 10,
        overlayColor: Color = Color.clear,
//        overlayColor: Color = Color.gray.opacity(0.1),
        isTapOutsideToDismiss: Bool = true,
        locationType: LocationType = .top,
        autoDismiss: PopupAutoDismissType = .none,
        onDisappear: (() -> Void)? = nil,
        popup: Popup
    ) -> some View {
        modifier(PopupModifier(isPresenting: isPresenting, hasShadow: hasShadow, cornerRadius: cornerRadius, overlayColor: overlayColor, isTapOutsideToDismiss: isTapOutsideToDismiss, locationType: locationType, autoDismiss: autoDismiss, onDisappear: onDisappear, popup: popup))
    }

}

public enum PopupAutoDismissType {
    /// don't auto dismiss
    case none
    case after(TimeInterval)
    
    /// String param is the message that user will read. It is used to calculate time
    case auto(String)
}


public enum LocationType {
    case top
    case middle
    case bottom
}





struct KeypadAlertView: View {
    
    @Binding var fanitText: String
    @Binding var isPresented:Bool
    
    var body: some View {
        VStack {
            VStack {
                KeyPadRow(keys: ["1", "2", "3"])
                KeyPadRow(keys: ["4", "5", "6"])
                KeyPadRow(keys: ["7", "8", "9"])
                KeyPadRow(keys: ["00", "0", "←"])
            }
            .frame(height: DefineSize.Screen.Height / 4)
            .background(Color.gray25)
        }
        .environment(\.keyPadButtonAction, self.keyWasPressed(_:))
    }
    
    private func keyWasPressed(_ key: String) {
        switch key {
            //        case "." where string.contains("."): break
            //        case "." where string == "0": string += key
        case "←":
            
            if fanitText.count > 0 {
                fanitText.removeLast()
            }
            if fanitText.isEmpty { fanitText = "" }
            
        case _ where fanitText == "": fanitText = key
        default: fanitText += key
        }
    }
}

struct KeypadAlertViewModifier: ViewModifier {
    
    @Binding var fanitText: String
    @Binding var isPresented:Bool
    
    func body(content: Content) -> some View {
        content
            .popup(isPresented: $isPresented, type: .default, dragToDismiss: false, closeOnTap: false, closeOnTapOutside: false, backgroundColor: .black.opacity(0), view: {
                KeypadAlertView(fanitText: $fanitText, isPresented: $isPresented)
            })
    }
}

extension View {
    func showKeypadAlertSimple(isPresented: Binding<Bool>, fanitText: Binding<String>) -> some View {
        modifier(KeypadAlertViewModifier(fanitText: fanitText, isPresented: isPresented))
    }
    
    func showKeypadAlert(
        isPresented: Binding<Bool>, fanitText: Binding<String>) -> some View {
            modifier(KeypadAlertViewModifier(fanitText: fanitText, isPresented: isPresented))
        }
}
