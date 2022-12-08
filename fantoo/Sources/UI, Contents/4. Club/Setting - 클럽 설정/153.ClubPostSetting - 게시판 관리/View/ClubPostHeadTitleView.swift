//
//  ClubPostHeadTitleView.swift
//  fantoo
//
//  Created by fns on 2022/07/19.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI
import Swift
import SwiftUIX

struct ClubPostHeadTitleView: View {
    
    enum HeadTitleType {
        case Default
        case AddHeadTitle
    }
    
    @StateObject var languageManager = LanguageManager.shared
    
    private struct sizeInfo {
        static let tagLineWidth: CGFloat = 2.0
        static let spacing: CGFloat = 4.0
        static let padding10: CGFloat = 10.0
        static let cornerRadius: CGFloat = 15.0
        static let tagHeight: CGFloat = 32.0
        static let tagWidthPadding: CGFloat = 40.0
        static let cancelIconSize: CGSize = CGSize(width: 12, height: 12)
    }
    @State var tagToggle: Bool = false
    
    var maxLimit: Int
    let headTitleType: HeadTitleType
    @Binding var tags: [ClubPostHeadTitleHashTag]
    let fontSize: CGFloat = 16

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(getRows(),id: \.self){ rows in
                
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
            print(size)
            tags[getIndex(tag: last)].size = size.width
        }
    }
}


extension ClubPostHeadTitleView {
    //    @ViewBuilder
    func RowView(tag: ClubPostHeadTitleHashTag) -> some View {
        HStack {
            Text("#\(tag.text)")
                .font(Font.body21420Regular)
                .foregroundColor(Color.primary500)
            
            Button(
                action: {
                    deleteTag(getIndex(tag: tag))
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
    
    func getIndex(tag: ClubPostHeadTitleHashTag)->Int {
        let index = tags.firstIndex { currentTag in
            return tag.id == currentTag.id } ?? 0
        
        return index
    }
    
    func getRows()->[[ClubPostHeadTitleHashTag]]{
        var rows: [[ClubPostHeadTitleHashTag]] = []
        var currentRow: [ClubPostHeadTitleHashTag] = []
        
        var totalWidth: CGFloat = 0
        let screenWidth: CGFloat = (DefineSize.Screen.Width - sizeInfo.tagWidthPadding) - sizeInfo.tagWidthPadding
        
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
        if headTitleType == .AddHeadTitle {
        tags.remove(at: i)
        } else {
            
        }
    }
}



struct ClubPostHeadTitleDescriptionView: View {
    
    let headTitleDescription: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(" • ")
                .font(.system(size: 10))
                .foregroundColor(Color.gray500)
            Text(headTitleDescription)
                .font(Font.caption11218Regular)
                .foregroundColor(Color.gray500)
        }
    }
}

