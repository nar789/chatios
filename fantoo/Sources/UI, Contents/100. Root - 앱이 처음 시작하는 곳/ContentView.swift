//
//  ContentView.swift
//  fantoo
//
//  Created by mkapps on 2022/04/22.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @StateObject var userManager = UserManager.shared
    
    init() {
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        
        UITableView.appearance().sectionFooterHeight = 0
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().selectionStyle = .none
        UITableView.appearance().separatorStyle = .none
        
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor.gray25
        
        UITextField.appearance().tintColor = .black
        UITextView.appearance().tintColor = .black
    }
    
    
    var body: some View {
        ZStack {
            
            Main()
                .fullScreenCover(isPresented: $userManager.showLoginView, content: {
                    LoginPage()
                })
            
            PermissionPage()
                .animation(nil)
                .opacity(userManager.isFirstLaunching ? 1.0 : 0.0)
                .animation(.default)
            
            LoadingView()
        }
        .modifier(ContentViewAlert())
        .modifier(ContentViewPopup())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//struct ContentView: View {
//
//    @State private  var isPresented: Bool = false
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                Button(action: {
//                    self.isPresented.toggle()
//                }, label: {
//                    Text("Button")
//                })
//            }
//        }
//        .sheet(isPresented: $isPresented, content: {
//            ModalView()
//        })
//    }
//}
//
//struct ModalView: View {
//    var body: some View {
//        NavigationView {
//            NavigationLink(
//                destination: TabbarView(),
//                label: {
//                   Text("Navigate")
//                })
//        }
//    }
//}
//
//
//struct TabbarView: View {
//    private var items: [String] = ["One", "Two", "Three"]
//
//    @Namespace var animation:Namespace.ID
//
//    @State var selected: String = ""    // change here
//    var body: some View {
//        ScrollView(.horizontal) {
//            HStack {
//                ForEach(items, id: \.self) { item in
//                    Button(action: {
//                        withAnimation{
//                            self.selected = item
//                        }
//                    }) {
//                        Text(item)
//                            .font(Font.subheadline.weight(.medium))
//                            .foregroundColor(selected == item ? .white : .accentColor)
//                            .padding(.horizontal, 25)
//                            .padding(.vertical, 10)
//                            .background(zStack(item: item))
//                    }
//
//                }
//            } .padding()
//                .animation(.easeIn(duration: 5))
//        }
//        .onAppear { self.selected = "One" }  // add this
//    }
//
//    private func zStack(item: String) -> some View {
//        ZStack{
//            if selected == item {
//                Color.accentColor
//                    .clipShape(Capsule())
//                    .matchedGeometryEffect(id: "Tab", in: animation)
//            } else {
//                Color(.gray)
//                    .clipShape(Capsule())
//            }}
//    }
//}
