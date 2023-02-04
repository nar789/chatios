//
//  HomeClub_Member.swift
//  fantoo
//
//  Created by sooyeol on 2023/01/30.
//  Copyright © 2023 FNS CO., LTD. All rights reserved.
//

import Foundation

struct ClubHomeJoinResponse: Codable {
    let memberJoinAutoYn: Bool
}

struct ClubHomeLoginResponse: Codable {
    let delegateStatus: Int
    let joinStatus: Int
    let memberId: Int
}


struct ClubNicknameCheck: Codable {
    let checkToken: String
    let existYn: Bool
}

struct ClubJoinCancelResponse: Codable {
    let body: [String]
    let statusCode: String
    let statusCodeValue: Int
}



//클럽 가입 여부 (0:비회원, 1:가입, 2:가입 요청, 3:가입 불가)
enum ClubJoinSatus: Int {
    case NoMember
    case Momber
    case RequsetJoin
    case CannotJoin
}

//클럽위임여부 (0:없음, 1:위임 요청, 2:멤버 승인)
enum ClubDelegateSatus: Int {
    case None
    case Request
    case Approval
}

enum NicknameCheckStatus: Bool {
    case Ok
    case No
}

extension ClubHomeLoginResponse {
    func getJoinStatus() -> ClubJoinSatus {
        return ClubJoinSatus(rawValue: joinStatus) ?? .NoMember
    }
    
    func getDelegateStatus() -> ClubDelegateSatus {
        return ClubDelegateSatus(rawValue: delegateStatus) ?? .None
    }
}

extension ClubNicknameCheck {
    func getExistYn() -> NicknameCheckStatus {
        return NicknameCheckStatus(rawValue: existYn) ?? .No
    }
}


extension Bool: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = value != 0
    }
}
