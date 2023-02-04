//
//  ClubSearchHashTagView.swift
//  fantoo
//
//  Created by fns on 2022/07/07.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI
import Swift

struct ClubSearchHashTagView: View {
    
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var vm = ClubSearchHashtagViewModel()
    
    private struct sizeInfo {
        static let tagHeight: CGFloat = 32.0
        static let tagLineWidth: CGFloat = 2.0
        static let padding10: CGFloat = 10.0
        static let tagWidthPadding: CGFloat = 40.0
        static let spacing: CGFloat = 4.0
        static let cornerRadius: CGFloat = 15.0
        static let cancelIconSize: CGSize = CGSize(width: 12, height: 12)
    }
    
    var maxLimit: Int
    @Binding var tags: [ClubSearchHashTag]
    let fontSize: CGFloat = 16
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ForEach(getRows(),id: \.self){rows in
                HStack(spacing: sizeInfo.spacing) {
                    ForEach(rows){ row in
                        RowView(tag: row)
                    }
                }
            }
            .frame(width: DefineSize.Screen.Width - sizeInfo.tagWidthPadding, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .onChange(of: tags) { newValue in
            guard let last = tags.last else { return }
            let font = UIFont.systemFont(ofSize: fontSize)
            let attibutes = [NSAttributedString.Key.font: font]
            let size = (last.text as NSString).size(withAttributes: attibutes)
//            print(size)
            tags[getIndex(tag: last)].size = size.width
        }
        .onAppear {
            vm.requestClubHashtag(clubId: "81", integUid: UserManager.shared.uid) { success in
                if success {
                    
                }
            }
        }
        // 필요없으면 뺌
        // .animation(.easeInOut, value: tags)
    }
}


extension ClubSearchHashTagView {
    //    @ViewBuilder
    func RowView(tag: ClubSearchHashTag) -> some View {
        HStack {
            Text("#\(tag.text)")
                .font(Font.body21420Regular)
                .foregroundColor(Color.primary500)
            
            Button(
                action: {
                    deleteTag(getIndex(tag: tag))
//                    deleteHashtag(element: "")
//                    print("@\(vm.hashtagList)")
                },
                label: {
                    Image("icon_outline_cancel")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(Color.primary500)
                        .frame(width: sizeInfo.cancelIconSize.width, height: sizeInfo.cancelIconSize.height)
                }
            )
        }
        .padding(.horizontal, sizeInfo.padding10)
        .frame(height: sizeInfo.tagHeight)
        .buttonStyle(BorderlessButtonStyle())
        .overlay(RoundedRectangle(cornerRadius: sizeInfo.cornerRadius)
                    .stroke(Color.primary500, lineWidth: sizeInfo.tagLineWidth))
        .cornerRadius(sizeInfo.cornerRadius)
        .background(Color.gray25)
    }
    
    func getIndex(tag: ClubSearchHashTag) -> Int {
        let index = tags.firstIndex { currentTag in
            return tag.id == currentTag.id } ?? 0
        
        return index
    }
    
    func getRows()->[[ClubSearchHashTag]]{
        var rows: [[ClubSearchHashTag]] = []
        var currentRow: [ClubSearchHashTag] = []
        
        var totalWidth: CGFloat = 0
        let screenWidth: CGFloat = (DefineSize.Screen.Width - sizeInfo.tagWidthPadding) - sizeInfo.tagWidthPadding
        //        let screenWidth: CGFloat = UIScreen.main.bounds.width - 90
        
        tags.forEach { tag in
            totalWidth += (tag.size + sizeInfo.tagWidthPadding)
            if totalWidth > screenWidth {
                
                totalWidth = (!currentRow.isEmpty ? (tag.size + sizeInfo.tagWidthPadding) : 0)
                
                rows.append(currentRow)
                currentRow.removeAll()
                currentRow.append(tag)
                
            } else {
                currentRow.append(tag)
            }
        }
        if !currentRow.isEmpty {
            rows.append(currentRow)
            currentRow.removeAll()
        }
        return rows
    }
    
    func deleteTag(_ i: Int) {
        tags.remove(at: i)
    }

//    func deleteHashtag(element: String) {
//        if vm.hashtagList.contains(element) {
//            vm.hashtagList = vm.hashtagList.filter{ $0 != element}
//        }
//    }

}





