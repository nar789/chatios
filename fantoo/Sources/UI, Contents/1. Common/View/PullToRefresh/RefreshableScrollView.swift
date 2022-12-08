//
//  RefreshableScrollView.swift
//  fantooTests
//
//  Created by kimhongpil on 2022/06/06.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

/**
 * ScrollView Pull to Refresh
 * ScrollView에서 당겨서 새로고침 기능
 */
import SwiftUI

private enum PositionType {
    case fixed, moving
}

private struct Position: Equatable {
    let type: PositionType
    let y: CGFloat
}

private struct PositionPreferenceKey: PreferenceKey {
    typealias Value = [Position]
    static var defaultValue = [Position]()
    static func reduce(value: inout [Position], nextValue: () -> [Position]) {
        value.append(contentsOf: nextValue())
    }
}

private struct PositionIndicator: View {
    let type: PositionType

    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(key: PositionPreferenceKey.self, value: [Position(type: type, y: proxy.frame(in: .global).minY)])
        }
    }
}

typealias RefreshComplete = () -> Void
typealias OnRefresh = (@escaping RefreshComplete) -> Void
private let THRESHOLD: CGFloat = 50
private enum RefreshState {
    case waiting, primed, loading
}

struct RefreshableScrollView<Content: View>: View {
    let onRefresh: OnRefresh
    let content: Content

    @State private var state = RefreshState.waiting

    init(onRefresh: @escaping OnRefresh, @ViewBuilder content: () -> Content) {
        self.onRefresh = onRefresh
        self.content = content()
    }

    var body: some View {
        ScrollView(showsIndicators: true) {
            
            ZStack(alignment: .top) {
                PositionIndicator(type: .moving)
                    .frame(height: 0)

                content
                // 아래 .alignmentGuide 적용하면, 리프레시 직후 통통 튀는 문제가 있음.
//                    .alignmentGuide(.top, computeValue: { _ in
//                        (state == .loading) ? -THRESHOLD : 0
//                    })
                
                ActivityIndicator(isAnimating: state == .loading) {
                    $0.hidesWhenStopped = false
                }
                //.opacity((state == .loading) ? 1 : 0)
                .offset(y: (state == .loading) ? THRESHOLD : -20)
            }
        }
        .background(PositionIndicator(type: .fixed))
        .onPreferenceChange(PositionPreferenceKey.self) { values in
            if state != .loading {
                DispatchQueue.main.async {
                    let movingY = values.first { $0.type == .moving }?.y ?? 0
                    let fixedY = values.first { $0.type == .fixed }?.y ?? 0
                    let offset = movingY - fixedY

                    if offset > THRESHOLD && state == .waiting {
                        state = .primed

                    } else if offset < THRESHOLD && state == .primed {
                        state = .loading
                        onRefresh {
                            withAnimation {
                                self.state = .waiting
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ActivityIndicator: UIViewRepresentable {
    public typealias UIView = UIActivityIndicatorView
    public var isAnimating: Bool = false
    public var configuration = { (indicator: UIView) in }

    public init(isAnimating: Bool, configuration: ((UIView) -> Void)? = nil) {
        self.isAnimating = isAnimating
        if let configuration = configuration {
            self.configuration = configuration
        }
    }

    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UIView {
        UIView()
    }

    public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Self>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        configuration(uiView)
    }
}
