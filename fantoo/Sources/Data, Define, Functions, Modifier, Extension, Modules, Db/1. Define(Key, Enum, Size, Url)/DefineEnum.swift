//
//  DefineEnum.swift
//  fantoo
//
//  Created by mkapps on 2022/06/11.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Darwin

enum LoadingStatus {
    case Close
    case ShowWithTouchable
    case ShowWithUntouchable
    case ShowWithUntouchableUnlimited       //터치불가능하고, 자동 close가 안되는.
}

enum CheckCorrectStatus {
    case Check
    case Correct
    case Wrong
}

enum LoginType: String {
    case google, facebook, kakao, apple, twitter, line, email
}

enum HomePageBottomType: Int {
    case SubHomeItemMore
    case SubHomeGlobalLan
}

enum HomePageItemMoreType: Int {
    case Save
    case Share
    case Join
    case Notice
    case Hide
    case Block
}

enum HomePageGlobalLanType: Int {
    case Global
    case MyLan
    case AnotherLan
}

enum UserInfoType: String {
    case birthDay, country, gender, interest, userNick, userPhoto
}

enum WalletListType: String {
    case all, paid, used
}

enum WalletType: String {
    case fanit, kdg
}

enum AlimType: String {
    case COMMUNITY, CLUB
}

enum DataCachingTime: Int {
    case None = 0
    case Sec_5 = 5
    case Sec_30 = 30
    case Min_1 = 60
    case Min_3 = 180
    case Min_5 = 300
}

enum BoardLikeInfoType: Int {
    case LikeCount
    case LikeBtnColor
    case DisLikeBtnColor
    case LikeTxtColor
}

enum MainCommunityLikeInfoType: Int {
    case Hour
    case Week
}

enum ImageSizeType: Int {
    case Profile
    case Background
}
