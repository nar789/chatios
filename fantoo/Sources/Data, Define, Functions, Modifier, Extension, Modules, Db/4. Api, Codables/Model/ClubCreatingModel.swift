//
//  ClubCreatingModel.swift
//  fantoo
//
//  Created by fns on 2022/11/02.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

struct ClubNameCheckData: Codable {
    let existYn: Bool
    let checkToken: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        existYn = (try? container.decode(Bool.self, forKey: .existYn)) ?? false
        checkToken = (try? container.decode(String.self, forKey: .checkToken)) ?? ""
    }
}

struct CreatingClubData: Codable {
    let clubId: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        clubId = (try? container.decode(Int.self, forKey: .clubId)) ?? 0
    }
}

struct ClubInterestModel: Codable {
    let clubInterestCategoryDtoList: [ClubInterestList]
    let listSize: Int?
}

struct ClubInterestList: Codable, Hashable {
    let clubInterestCategoryId: Int
    let interestCategoryCode: String
    let langCode: String
    let codeName: String
    let description: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        clubInterestCategoryId = (try? container.decode(Int.self, forKey: .clubInterestCategoryId)) ?? 0
        interestCategoryCode = (try? container.decode(String.self, forKey: .interestCategoryCode)) ?? ""
        langCode = (try? container.decode(String.self, forKey: .langCode)) ?? ""
        codeName = (try? container.decode(String.self, forKey: .codeName)) ?? ""
        description = (try? container.decode(String.self, forKey: .description)) ?? ""
    }
}



