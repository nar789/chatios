//
//  ClubBoardSettingData.swift
//  fantoo
//
//  Created by fns on 2022/12/22.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

struct ClubBoardCategoryData: Codable, Hashable {
    let boardType: Int?
    let categoryCode: String?
    let categoryId: String?
    let categoryList: [ClubBoardCategoryListData]
    let categoryName: String?
    let categoryType: Int?
    let clubId: String?
    let commonYn: Bool?
    let depth: Int?
    let openYn: Bool?
    let showYn: Bool?
    let sort: Int?
    let url: String?
    
}

struct ClubBoardCategoryListData: Codable, Hashable {
    let boardType: Int?
    let categoryCode: String?
    let categoryId: String?
    let categoryName: String?
    let categoryType: Int?
    let clubId: String?
    let commonYn: Bool?
    let depth: Int?
    let firstImageList: [String?]
    let openYn: Bool?
    let parentCategoryId: String?
    let postCount: Int?
    let sort: Int?
    let url: String?
    
}

struct CreateClubBoardListData: Codable, Hashable {
    
    let boardType: Int
    let categoryType: Int
    let clubCategoryId: String
    let clubId: Int
    let codeNameEn: String
    let codeNameKo: String
    let commonYn: Bool
    let createBy: String
    let createDate: String
    let depth: Int
    let openYn: Bool
    let parentCategoryId: String
    let showYn: Bool
    let sort: Int
    let updateBy: String
    let updateDate: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        boardType = (try? container.decode(Int.self, forKey: .boardType)) ?? 0
        categoryType = (try? container.decode(Int.self, forKey: .categoryType)) ?? 0
        clubCategoryId = (try? container.decode(String.self, forKey: .clubCategoryId)) ?? ""
        clubId = (try? container.decode(Int.self, forKey: .clubId)) ?? 0
        codeNameEn = (try? container.decode(String.self, forKey: .codeNameEn)) ?? ""
        codeNameKo = (try? container.decode(String.self, forKey: .codeNameKo)) ?? ""
        commonYn = (try? container.decode(Bool.self, forKey: .commonYn)) ?? false
        createBy = (try? container.decode(String.self, forKey: .createBy)) ?? ""
        createDate = (try? container.decode(String.self, forKey: .createDate)) ?? ""
        depth = (try? container.decode(Int.self, forKey: .depth)) ?? 0
        openYn = (try? container.decode(Bool.self, forKey: .openYn)) ?? false
        parentCategoryId = (try? container.decode(String.self, forKey: .parentCategoryId)) ?? ""
        showYn = (try? container.decode(Bool.self, forKey: .showYn)) ?? false
        sort = (try? container.decode(Int.self, forKey: .sort)) ?? 0
        updateBy = (try? container.decode(String.self, forKey: .updateBy)) ?? ""
        updateDate = (try? container.decode(String.self, forKey: .updateDate)) ?? ""
        
    }
    
}
