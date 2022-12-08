//
//  PopupManager.swift
//  fantoo
//
//  Created by mkapps on 2022/10/06.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

/*
 문서위치
 https://34gbyc.axshare.com/#id=4r6y0i&p=%EB%AA%A9%EB%A1%9D__%EA%B8%80_%EB%8C%93%EA%B8%80_%EB%8D%94%EB%B3%B4%EA%B8%B0_%EB%B2%84%ED%8A%BC&g=12&sc=1
 */

import Foundation
import Combine


//어디서 더보기를 눌렀는가
enum MorePositionType: Int {
    
    //커뮤니티
    case CommunityMainPost      //커뮤니티 메인 - 공지, 커뮤니티 각 카테고리 - 공지
    case CommunityPost      //커뮤니티 - 게시글 (홈/파퓰러 피드에도 공통 적용)
    case CommunityReply     //커뮤니티 - 댓글 (홈/파퓰러 피드에도 공통 적용)
    
    //클럽
    case ClubMainPost       //클럽 메인 - 챌린지 - 게시글
    case ClubMainReply      //클럽 메인 - 챌린지 - 댓글
    case ClubNoticePost     //클럽 - 공지 - 게시글
    case ClubNoticeReply        //클럽 - 공지 - 댓글
    case ClubPost       //클럽 - 게시글 (홈/파퓰러 피드에도 공통 적용)
    case ClubReply      //클럽 - 댓글 (홈/파퓰러 피드에도 공통 적용)
    
    //팬투티비, 한류타임스
    case MainClubPost       //팬투 TV, 한류타임스 - 게시글 (홈/파퓰러 피드에도 공통 적용)
    case MainClubReply      //팬투 TV, 한류타임스 - 댓글 (홈/파퓰러 피드에도 공통 적용)
}

//더보기 버튼
enum MoreActionType: Int {
    case Join   //가입(클럽한정)
    case Follow     //팔로우(팬투티비, 한류타임스만), 팔로우시 언팔로우는 없고 해당 버튼은 사라진다.
    case Mark       //저장
    case MarkCancel     //저장취소
    case Share      //공유
    case Report     //신고
    case Blind      //차단
    case BlindCancel        //차단취소
    case Block      //계정차단
    case BlockCancel        //계정차단취소
    case Edit       //수정
    case Delete     //삭제
}

//회원타입
enum MoreTargetType: Int {
    case LogOut     //비회원
    case Login      //회원
    case ClubMember     //회원 + 클럽멤버
    case NonClubMember      //회원 + 클럽비회원
    case ClubMaster     //클럽장
}

//글을 썼냐
enum MoreWriteType: Int {
    case None
    case Write
}


class MoreManager: ObservableObject {
    static let shared = MoreManager()
    
    
    //MARK: - Variables : State
    struct Show {
        var bottomSheet: Bool = false
    }
    
//    let ver = PopupType.BottomSheet.Post
    
    
    @Published var show = Show()
}
