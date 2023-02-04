//
//  LoginModel.swift
//  fantoo
//
//  Created by mkapps on 2022/05/18.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

struct JoinData : Codable {
    var isReferralCheck : Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isReferralCheck = (try? container.decode(Bool.self, forKey: .isReferralCheck)) ?? false
    }
}

struct JoinCheckData : Codable {
    let isUser : Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isUser = (try? container.decode(Bool.self, forKey: .isUser)) ?? false
    }
}

struct CheckNickNameData : Codable {
    let isCheck : Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isCheck = (try? container.decode(Bool.self, forKey: .isCheck)) ?? false
    }
}

struct SendEmailData : Codable {
    var isCheck : Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isCheck = (try? container.decode(Bool.self, forKey: .isCheck)) ?? false
    }
}

struct TokenData : Codable {
    var access_token : String
    var refresh_token: String
    var integUid: String
    var token_type: String
    var expires_in: Int = 0
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        access_token = (try? container.decode(String.self, forKey: .access_token)) ?? ""
        refresh_token = (try? container.decode(String.self, forKey: .refresh_token)) ?? ""
        integUid = (try? container.decode(String.self, forKey: .integUid)) ?? ""
        token_type = (try? container.decode(String.self, forKey: .token_type)) ?? ""
        expires_in = (try? container.decode(Int.self, forKey: .expires_in)) ?? 0
    }
}

struct LoginData : Codable {
    var authCode : String
    var state: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        authCode = (try? container.decode(String.self, forKey: .authCode)) ?? ""
        state = (try? container.decode(String.self, forKey: .state)) ?? ""
    }
}

struct IssueTokenData : Codable {
    var access_token : String
    var refresh_token: String
    var integUid: String
    var token_type: String
    var expires_in: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        access_token = (try? container.decode(String.self, forKey: .access_token)) ?? ""
        refresh_token = (try? container.decode(String.self, forKey: .refresh_token)) ?? ""
        integUid = (try? container.decode(String.self, forKey: .integUid)) ?? ""
        token_type = (try? container.decode(String.self, forKey: .token_type)) ?? ""
        expires_in = (try? container.decode(Int.self, forKey: .expires_in)) ?? 0
    }
}

struct RenewalTokenSend : Codable {
    let clientId: String
    let clientSecret: String
    let grantType:String
    let refresh_token: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        clientId = (try? container.decode(String.self, forKey: .clientId)) ?? ""
        clientSecret = (try? container.decode(String.self, forKey: .clientSecret)) ?? ""
        grantType = (try? container.decode(String.self, forKey: .grantType)) ?? ""
        refresh_token = (try? container.decode(String.self, forKey: .refresh_token)) ?? ""
    }
}

struct RenewalTokenData : Codable {
    var access_token : String
    var expires_in: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        access_token = (try? container.decode(String.self, forKey: .access_token)) ?? ""
        expires_in = (try? container.decode(Int.self, forKey: .expires_in)) ?? 0
    }
}
