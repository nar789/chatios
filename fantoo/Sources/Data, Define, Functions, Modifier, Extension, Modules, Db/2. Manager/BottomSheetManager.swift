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

enum CustomBottomSheetClickType: Int {
    case None
    case SubHomeItemMore
    case GlobalLan
    case CommunityDetailNaviMore
    case Language
    case ClubSettingLanguage
    case SettingCountry
    //club setting
    case ClubOpenTitle
    case MemberNumberListTitle
    case MemberListTitle
    case JoinApprovalTitle
    //club creating
    case ClubOpenSettingOfClub
    case JoinApprovalSettingOfClub
    
    case ArchiveVisibilityTitle
    case ArchiveTypeTitle
    
    case RejoinSetting
}

enum HomePageItemMoreType: Int {
    case None
    case Save
    case Share
    case Join
    case Notice
    case Hide
    case Block
}

// enum to String
enum GlobalLanType : CustomStringConvertible {
    case Global
    case MyLan
    case AnotherLan
    
    var description : String {
        switch self {
        case .Global: return "en_global".localized
        case .MyLan: return "n_setting_to_my_language".localized
        case .AnotherLan: return "d_other_language_select".localized
        }
    }
}

// enum to String
enum AutoOrApprovalType : CustomStringConvertible {
    case Auto
    case Approval
    
    var description : String {
        switch self {
        case .Auto: return "j_auto".localized
        case .Approval: return "s_approval".localized
        }
    }
}

enum OpenOrHiddenType : CustomStringConvertible {
    case Open
    case Hidden
    
    var description : String {
        switch self {
        case .Open: return "g_open_public".localized
        case .Hidden: return "b_hidden".localized
        }
    }
}

enum ImageOrGeneralType : CustomStringConvertible {
    case Image
    case General
    
    var description : String {
        switch self {
        case .Image: return "a_image".localized
        case .General: return "a_general".localized
        }
    }
}

enum ProhibitionOrAllowType : CustomStringConvertible {
    case Prohibition
    case Allow
    
    var description : String {
        switch self {
        case .Prohibition: return "g_prohibition".localized
        case .Allow: return "h_allow".localized
        }
    }
}

class BottomSheetManager: ObservableObject {
    static let shared = BottomSheetManager()
    var canclelables = Set<AnyCancellable>()
    
    @Published var loadingStatus: LoadingStatus = .Close

    
    //MARK: - Variables : State
    struct Show {
        var popularItemMore: Bool = false
        var popularGlobal: Bool = false
        var language: Bool = false
        var clubSettingLanguage: Bool = false
        var clubSettingCountry: Bool = false
        var clubOpenTitle: Bool = false
        var memberNumberListTitle: Bool = false
        var memberListTitle: Bool = false
        var joinApprovalTitle: Bool = false
        var clubOpenSettingOfClub: Bool = false
        var joinApprovalSettingOfClub: Bool = false
        var archiveVisibilityTitle: Bool = false
        var archiveTypeTitle: Bool = false
        var rejoinSetting: Bool = false
    }
    
    //    let ver = PopupType.BottomSheet.Post
    @Published var show = Show()
    
    // 홈탭 -> Popular탭 -> GLOBAL버튼
    @Published var onPressPopularGlobal: String = "en_global".localized
    @Published var onPressJoinApprovalSettingOfClub: String = "j_auto".localized
    @Published var onPressClubOpenSettingOfClub: String = "g_open_public".localized
    @Published var onPressClubOpenTitle: String = "g_open_public".localized
    @Published var onPressMemberNumberListTitle: String = "g_open_public".localized
    @Published var onPressMemberListTitle: String = "g_open_public".localized
    @Published var onPressJoinApprovalTitle: String = "j_auto".localized
    @Published var onPressArchiveTypeTitle: String = "a_image".localized
    @Published var onPressArchiveVisibilityTitle: String = "g_open_public".localized
    @Published var onPressRejoinSetting: String = "h_allow".localized
    @Published var onPressRejoinSettingType: Bool = false
    @Published var onPressClubLanguage: String = "한국어"
    @Published var onPressClubLanguageCode: String = "ko"
    @Published var onPressClubCountry: String = ""
    @Published var onPressClubCountryCode: String = "KR"
    
    // 어디서 BottomSheet를 호출했는가?
    @Published var customBottomSheetClickType: CustomBottomSheetClickType = .None
    
    //활동국가
    var countryCode: String = ""
    
    // countryApi
    func setDisplayValues(countryCode: String = "", selectedCountryData: CountryListData? = nil) {
        
        //국가
        if countryCode.count > 0 {
            if self.countryCode != countryCode {
                self.countryCode = countryCode
                
                if selectedCountryData != nil {
                    if LanguageManager.shared.getLanguageCode() == "ko" {
                        self.onPressClubCountry = selectedCountryData?.nameKr ?? ""
                    }
                    else {
                        self.onPressClubCountry = selectedCountryData?.nameEn ?? ""
                    }
                }
                //api 콜해서 구해오자.
                else {
                    //국적
                    ApiControl.countryIsoTwoList(isoCode: self.countryCode)
                        .sink { error in
                            print("getIsoTwoList error : \(error)")
                        } receiveValue: { value in
                            print("getIsoTwoList value : \(value)")
                            if LanguageManager.shared.getLanguageCode() == "ko" {
                                self.onPressClubCountry = value.nameKr
                            }
                            else {
                                self.onPressClubCountry = value.nameEn
                            }
                        }.store(in: &self.canclelables)
                }
            }
        }
        else {
            self.countryCode = ""
//            self.activeCountryCode = ""
        }
    }
    
}
