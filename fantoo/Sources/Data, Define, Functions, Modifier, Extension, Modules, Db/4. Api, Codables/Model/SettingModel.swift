//
//  SettingModel.swift
//  fantoo
//
//  Created by mkapps on 2022/07/05.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

struct UserInfoData : Codable, Hashable {
    var birthDay : String
    var countryIsoTwo: String
    var genderType: String
    var integUid: String
//    var interestList: [UserInfoInterestListData]
    var userNick: String
    var userPhoto: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        birthDay = (try? container.decode(String.self, forKey: .birthDay)) ?? ""
        countryIsoTwo = (try? container.decode(String.self, forKey: .countryIsoTwo)) ?? ""
        genderType = (try? container.decode(String.self, forKey: .genderType)) ?? ""
        integUid = (try? container.decode(String.self, forKey: .integUid)) ?? ""
//        interestList = (try? container.decode(String.self, forKey: .interestList)) ?? ""
        userNick = (try? container.decode(String.self, forKey: .userNick)) ?? ""
        userPhoto = (try? container.decode(String.self, forKey: .userPhoto)) ?? ""
    }
}

struct UserInfoInterestListData : Codable, Hashable {
    var code : String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = (try? container.decode(String.self, forKey: .code)) ?? ""
     
    }
}

struct LanguageListData : Codable, Hashable {
    var nameKr : String
    var name: String
    var langCode: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        nameKr = (try? container.decode(String.self, forKey: .nameKr)) ?? ""
        name = (try? container.decode(String.self, forKey: .name)) ?? ""
        langCode = (try? container.decode(String.self, forKey: .langCode)) ?? ""
    }
}

struct CountryListData : Codable, Hashable {
    let countryCode: String
    let countryNum: String
    let nameKr, nameEn, iso2, iso3: String
    let coinStatus : Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        countryCode = (try? container.decode(String.self, forKey: .countryCode)) ?? ""
        countryNum = (try? container.decode(String.self, forKey: .countryNum)) ?? ""
        nameKr = (try? container.decode(String.self, forKey: .nameKr)) ?? ""
        nameEn = (try? container.decode(String.self, forKey: .nameEn)) ?? ""
        iso2 = (try? container.decode(String.self, forKey: .iso2)) ?? ""
        iso3 = (try? container.decode(String.self, forKey: .iso3)) ?? ""
        coinStatus = (try? container.decode(Int.self, forKey: .coinStatus)) ?? 0
    }
    
    func getCountryName() -> String {
        if LanguageManager.shared.getLanguageCode() == "ko" {
            return nameKr
        }
        else {
            return nameEn
        }
    }
}

struct AlimListData : Codable, Hashable {
      let alimClubConfigDtoList: [AlimClubConfigDtoList]
      let alimConfigId: Int?
      let comAgree: Bool?

}

struct AlimClubConfigDtoList : Codable, Hashable, Identifiable {
    var id: Int
    let alimClubConfigId: Int
    var clubAgree: Bool
    var clubId: Int
    let clubName: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? container.decode(Int.self, forKey: .id)) ?? 0
        alimClubConfigId = (try? container.decode(Int.self, forKey: .alimClubConfigId)) ?? 0
        clubAgree = (try? container.decode(Bool.self, forKey: .clubAgree)) ?? false
        clubId = (try? container.decode(Int.self, forKey: .clubId)) ?? 0
        clubName = (try? container.decode(String.self, forKey: .clubName)) ?? ""
    }
}

struct CommunityAlimSettingData : Codable, Hashable {
    let comAgree: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        comAgree = (try? container.decode(Bool.self, forKey: .comAgree)) ?? false

    }
}


struct ClubAlimSettingData : Codable, Hashable {
    let clubAgree: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        clubAgree = (try? container.decode(Bool.self, forKey: .clubAgree)) ?? false

    }
}

struct NoticeData: Codable, Hashable {
    let listSize: Int?
    let nextId: Int?
    let fantooNoticeDtoList: [FantooNoticeDtoList]
}

struct FantooNoticeDtoList: Codable, Hashable {
    let fantooNoticeId: Int
    let title: String
    let langCode: String
    let createDate: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fantooNoticeId = (try? container.decode(Int.self, forKey: .fantooNoticeId)) ?? 0
        title = (try? container.decode(String.self, forKey: .title)) ?? ""
        langCode = (try? container.decode(String.self, forKey: .langCode)) ?? ""
        createDate = (try? container.decode(String.self, forKey: .createDate)) ?? ""
    }
}

struct NoticeDetailList: Codable, Hashable {
    let fantooNoticeId: Int
    let title: String
    let content: String
    let langCode: String
    let createDate: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fantooNoticeId = (try? container.decode(Int.self, forKey: .fantooNoticeId)) ?? 0
        title = (try? container.decode(String.self, forKey: .title)) ?? ""
        content = (try? container.decode(String.self, forKey: .content)) ?? ""
        langCode = (try? container.decode(String.self, forKey: .langCode)) ?? ""
        createDate = (try? container.decode(String.self, forKey: .createDate)) ?? ""
    }
}
