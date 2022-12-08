//
//  HomeClub_TabBankModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/18.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

struct HomeClub_TabBankModel: Codable {
    let code: Int
    let data: HomeClub_TabBankModel_Data
}

struct HomeClub_TabBankModel_Data: Codable {
    let header: HomeClub_TabBankModel_Header
    let body: HomeClub_TabBankModel_Body
    let footer: HomeClub_TabBankModel_Footer
}
struct HomeClub_TabBankModel_Header: Codable {
    let club_name, club_image: String
    let kdg: Int
}
struct HomeClub_TabBankModel_Body: Codable {
    let sdate, edate: String
    let ranking_list: [HomeClub_TabBankModel_Body_RankingList]
}
struct HomeClub_TabBankModel_Footer: Codable {
    let date: Int
    let account_list: [HomeClub_TabBankModel_Footer_AccountList]
}

struct HomeClub_TabBankModel_Body_RankingList: Codable, Hashable {
    let nickname: String
    let rank, kdg: Int
}
struct HomeClub_TabBankModel_Footer_AccountList: Codable, Hashable {
    let nickname, date: String
    let kdg, total_kdg: Int
}
