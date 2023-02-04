//
//  HomeClub_CategoryModel.swift
//  fantoo
//
//  Created by sooyeol on 2023/01/17.
//  Copyright © 2023 FNS CO., LTD. All rights reserved.
//

struct HomeClub_CategoryModel: Codable {
    let boardType: Int?
    let categoryCode: String?
    let categoryId: String?
    let categoryList: [HomeClub_Category_Item]?
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

struct HomeClub_Category_Item: Codable, Hashable {
    let boardType: Int?
    let categoryCode: String?
    let categoryId: String?
    let categoryName: String?
    let categoryType: Int?
    let clubId: String?
    let commonYn: Bool?
    let depth: Int?
    let firstImageList: [String]?
    let openYn: Bool?
    let parentCategoryId: String?
    let postCount: Int?
    let sort: Int?
    let url: String?
}

extension HomeClub_Category_Item {
    func toImageList() -> [Post_Thumbnail] {
        return firstImageList?.map({ urlId in Post_Thumbnail(type: "0", url: urlId.imageOriginalUrl) }) ?? []
    }
}
