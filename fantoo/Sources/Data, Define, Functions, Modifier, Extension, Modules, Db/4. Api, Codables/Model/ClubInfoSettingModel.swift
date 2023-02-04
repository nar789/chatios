//
//  ClubInfoSettingModel.swift
//  fantoo
//
//  Created by fns on 2022/11/10.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

struct ClubEditInfoData: Codable {
    let clubId: Int
    let clubName: String
    let memberCountOpenYn: Bool
    let memberListOpenYn: Bool
    let openYn: Bool
    let interestCategoryId: String
    let languageCode: String
    let activeCountryCode: String
    let memberJoinAutoYn: Bool
    let createDate: String
    let profileImg: String
    let memberCount: Int
    let clubMasterNickname: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        clubId = (try? container.decode(Int.self, forKey: .clubId)) ?? 0
        clubName = (try? container.decode(String.self, forKey: .clubName)) ?? ""
        memberCountOpenYn = (try? container.decode(Bool.self, forKey: .memberCountOpenYn)) ?? false
        memberListOpenYn = (try? container.decode(Bool.self, forKey: .memberListOpenYn)) ?? false
        openYn = (try? container.decode(Bool.self, forKey: .openYn)) ?? false
        interestCategoryId = (try? container.decode(String.self, forKey: .interestCategoryId)) ?? ""
        languageCode = (try? container.decode(String.self, forKey: .languageCode)) ?? ""
        activeCountryCode = (try? container.decode(String.self, forKey: .activeCountryCode)) ?? ""
        memberJoinAutoYn = (try? container.decode(Bool.self, forKey: .memberJoinAutoYn)) ?? false
        createDate = (try? container.decode(String.self, forKey: .createDate)) ?? ""
        profileImg = (try? container.decode(String.self, forKey: .profileImg)) ?? ""
        memberCount = (try? container.decode(Int.self, forKey: .memberCount)) ?? 0
        clubMasterNickname = (try? container.decode(String.self, forKey: .clubMasterNickname)) ?? ""
        
    }
}

struct ClubFullInfoData: Codable  {
    
    let activeCountryCode: String
    let bgImg: String
    let clubId: Int
    let clubMasterNickname: String
    let clubName: String
    let createDate: String
    let hashtagList: [String]
    let interestCategoryId: String
    let introduction: String
    let joinMemberCount: Int
    let languageCode: String
    let memberCount: Int
    let memberCountOpenYn: Bool
    let memberJoinAutoYn: Bool
    let memberListOpenYn: Bool
    let openYn: Bool
    let postCount: Int
    let profileImg: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        activeCountryCode = (try? container.decode(String.self, forKey: .activeCountryCode)) ?? ""
        bgImg = (try? container.decode(String.self, forKey: .bgImg)) ?? ""
        clubId = (try? container.decode(Int.self, forKey: .clubId)) ?? 0
        clubMasterNickname = (try? container.decode(String.self, forKey: .clubMasterNickname)) ?? ""
        clubName = (try? container.decode(String.self, forKey: .clubName)) ?? ""
        createDate = (try? container.decode(String.self, forKey: .createDate)) ?? ""
        hashtagList = (try? container.decode([String].self, forKey: .hashtagList)) ?? [""]
        interestCategoryId = (try? container.decode(String.self, forKey: .interestCategoryId)) ?? ""
        introduction = (try? container.decode(String.self, forKey: .introduction)) ?? ""
        joinMemberCount = (try? container.decode(Int.self, forKey: .joinMemberCount)) ?? 0
        languageCode = (try? container.decode(String.self, forKey: .languageCode)) ?? ""
        memberCount = (try? container.decode(Int.self, forKey: .memberCount)) ?? 0
        memberCountOpenYn = (try? container.decode(Bool.self, forKey: .memberCountOpenYn)) ?? false
        memberJoinAutoYn = (try? container.decode(Bool.self, forKey: .memberJoinAutoYn)) ?? false
        memberListOpenYn = (try? container.decode(Bool.self, forKey: .memberListOpenYn)) ?? false
        openYn = (try? container.decode(Bool.self, forKey: .openYn)) ?? false
        postCount = (try? container.decode(Int.self, forKey: .postCount)) ?? 0
        profileImg = (try? container.decode(String.self, forKey: .profileImg)) ?? ""
        
    }
}

struct ClubCategoryData: Codable, Hashable {
    let categoryList: [ClubCategoryListData]
    let listSize: Int?
}

struct ClubCategoryListData: Codable, Hashable, Equatable {
   let clubId: String?
   let categoryId: Int?
   let categoryCode: String?
   let boardType: Int?
   let url: String?
   let categoryName: String?
   let depth: Int?
   let sort: Int?
   let openYn: Bool?
   let categoryType: Int?
   let showYn: Int?
   let commonYn: Bool?
   let categoryList: [ClubCategoryDetailListData?]
}

struct ClubCategoryDetailListData: Codable, Hashable, Equatable  {
    let boardType: Int
    let categoryCode: String
    let categoryId: Int
    let categoryName: String
    let categoryType: Int
    let clubId: String
    let commonYn: Bool
    let depth: Int
    let firstImageList: String
    let openYn: Bool
    let parentCategoryId: String
    let postCount: Int
    let sort: Int
    let url: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        boardType = (try? container.decode(Int.self, forKey: .boardType)) ?? 0
        categoryCode = (try? container.decode(String.self, forKey: .categoryCode)) ?? ""
        categoryId = (try? container.decode(Int.self, forKey: .categoryId)) ?? 0
        categoryName = (try? container.decode(String.self, forKey: .categoryName)) ?? ""
        categoryType = (try? container.decode(Int.self, forKey: .categoryType)) ?? 0
        clubId = (try? container.decode(String.self, forKey: .clubId)) ?? ""
        commonYn = (try? container.decode(Bool.self, forKey: .commonYn)) ?? false
        depth = (try? container.decode(Int.self, forKey: .depth)) ?? 0
        firstImageList = (try? container.decode(String.self, forKey: .firstImageList)) ?? ""
        openYn = (try? container.decode(Bool.self, forKey: .openYn)) ?? false
        parentCategoryId = (try? container.decode(String.self, forKey: .parentCategoryId)) ?? ""
        postCount = (try? container.decode(Int.self, forKey: .postCount)) ?? 0
        sort = (try? container.decode(Int.self, forKey: .sort)) ?? 0
        url = (try? container.decode(String.self, forKey: .url)) ?? ""

        
    }
}

struct ClubHashtagData: Codable, Hashable {
    let clubId: Int
    let hashtagList: [String]
    let listSize: Int

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        clubId = (try? container.decode(Int.self, forKey: .clubId)) ?? 0
        hashtagList = (try? container.decode([String].self, forKey: .hashtagList)) ?? [""]
        listSize = (try? container.decode(Int.self, forKey: .listSize)) ?? 0 
    }
}
