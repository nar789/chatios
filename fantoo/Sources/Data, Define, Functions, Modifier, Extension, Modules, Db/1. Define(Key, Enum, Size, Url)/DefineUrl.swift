//
//  DefineUrl.swift
//  fantoo
//
//  Created by Benoit Lee on 2022/05/18.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

struct DefineUrl {
    
    struct Domain {
        static let Login = "https://fauth.fantoo.co.kr:8121"
        static let Api = "https://fapi.fantoo.co.kr:9121"
        static let Trans = "http://ntrans.fantoo.co.kr:5000"
        static let Upload = "https://api.cloudflare.com"
    }
    
    
    
    struct Path {
        static let UploadImage = "client/v4/accounts/1df62cde067ca406bffd7f00ba21152e/images/v1"
        static let UploadStream = "client/v4/accounts/1df62cde067ca406bffd7f00ba21152e/stream"
    }
    
    struct Image {
        static let Original = "https://imagedelivery.net/peZXyXogT-VgnN1sGn2T-Q/%@/public"
    }
    
    // availableTestURL
    //"https://customer-y628kmdfbqq6rn1n.cloudflarestream.com/9111c413d3c0eb59e099066d050bb3f5/manifest/video.m3u8"
    struct Video {
        static let Original = "https://customer-y628kmdfbqq6rn1n.cloudflarestream.com/%@/manifest/video.m3u8"
    }
    
    
    // Thumbnail Image Url sample :
    // https://imagedelivery.net/peZXyXogT-VgnN1sGn2T-Q/29a2c0b0-5777-4bb1-f522-3b84739f2700/thumbnail
    // Default Image Url sample :
    // https://imagedelivery.net/peZXyXogT-VgnN1sGn2T-Q/29a2c0b0-5777-4bb1-f522-3b84739f2700/public
    static let ApiImageDomain = "https://imagedelivery.net/peZXyXogT-VgnN1sGn2T-Q/"
    
    
    
    struct Term {
        static let Service = "https://www.naver.com/"
        static let Privacy = "https://www.youtube.com/"
        static let Youth = "https://news.naver.com/main/list.naver?mode=LPOD&mid=sec&sid1=001&sid2=140&oid=001&isYeonhapFlash=Y&aid=0013324105"
        static let Event = "https://n.news.naver.com/mnews/article/001/0013324121?rc=N&ntype=RANKING"
    }
}
