//
//  DefineSize.swift
//  fantoo
//
//  Created by mkapps on 2022/06/11.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct DefineSize {
    
    //safe area insets
    struct SafeArea {
        @Environment(\.safeAreaInsets) static var safeAreaInsets
        
        static let top: CGFloat = safeAreaInsets.top
        static let bottom: CGFloat = safeAreaInsets.bottom
    }
    
    //contents
    struct Contents {
        static let TopPadding: CGFloat = 15.0           //컨텐츠 네비와의 간격
        static let BottomPadding: CGFloat = 15.0
        static let HorizontalPadding: CGFloat = 20.0        //컨텐츠 좌우 여백
    }
    
    
    static let LineHeight: CGFloat = 1.0
    
    //corner radius
    struct CornerRadius {
        static let ProfileThumbnailS: CGFloat = 12.0
        static let ProfileThumbnailM: CGFloat = 12.0
        static let ProfileThumbnailL: CGFloat = 12.0
        
        static let ClubThumbnailS: CGFloat = 12.0
        static let ClubThumbnailM: CGFloat = 12.0
        static let ClubThumbnailL: CGFloat = 12.0
        
        static let BottomSheet: CGFloat = 30.0
        
        static let TextField: CGFloat = 7.0
    }
    
    //size
    struct Size {
        static let ProfileThumbnailS: CGSize = CGSize(width: 36.0, height: 36.0)
        static let ProfileThumbnailM: CGSize = CGSize(width: 54.0, height: 54.0)
        static let ProfileThumbnailL: CGSize = CGSize(width: 80.0, height: 80.0)
        
        static let ClubThumbnailS: CGSize = CGSize(width: 38.0, height: 38.0)
        static let ClubThumbnailM: CGSize = CGSize(width: 54.0, height: 54.0)
    }
    
    //listHeight
    struct ListHeight {
        
    }
    
    //screen
    struct Screen {
        static let Width = UIScreen.main.bounds.size.width
        static let Height = UIScreen.main.bounds.size.height
        static let Size = UIScreen.main.bounds.size
    }
    
    //list size
    struct ListSize {
        static let Common: Int = 20
        
    }
}
