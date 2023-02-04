//
//  NoDataView.swift
//  fantoo
//
//  Created by sooyeol on 2023/01/18.
//  Copyright © 2023 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct NoDataView: View {
    
    @State var type: NoDataType
    
    public enum NoDataType {
        case privateClub(message: String)
        case noBoard(message: String)
    }
    
    private struct sizeInfo {
        static let spacing14: CGFloat = 14.0
        static let topPadding: CGFloat = 130.0
        static let privateClubImageSize: CGSize = CGSize(width: 118, height: 153)
        static let noBoardImageSize: CGSize = CGSize(width: 100, height: 100)
    }
    
    private struct imageInfo {
        static let privateClubImage = "character_club1"
        static let noBoardImage = "character_club2"
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            VStack(spacing: 0) {
                
                switch type {
                case .privateClub(let msg):
                    Image(imageInfo.privateClubImage)
                        .resizable()
                        .frame(
                            width: sizeInfo.privateClubImageSize.width,
                            height: sizeInfo.privateClubImageSize.height
                        )
                    
                    Text(msg)
                        .font(.body21420Regular)
                        .foregroundColor(.gray600)
                        .padding(.top, sizeInfo.spacing14)
                        .multilineTextAlignment(.center)
                    
                case .noBoard(let msg):
                    Image(imageInfo.noBoardImage)
                        .resizable()
                        .frame(
                            width: sizeInfo.noBoardImageSize.width,
                            height: sizeInfo.noBoardImageSize.height
                        )
                    
                    Text(msg)
                        .font(.body21420Regular)
                        .foregroundColor(.gray600)
                        .padding(.top, sizeInfo.spacing14)
                        .multilineTextAlignment(.center)
                }
                
            }
            Spacer()
        }
        .padding(.top, sizeInfo.topPadding)
    }
}

struct NoDataView_Previews: PreviewProvider {
    static var previews: some View {
        NoDataView(type: .privateClub(message: "no data"))
    }
}
