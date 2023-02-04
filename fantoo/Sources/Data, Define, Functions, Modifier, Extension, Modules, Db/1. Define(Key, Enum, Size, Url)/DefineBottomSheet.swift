//
//  DefineBottomSheet.swift
//  fantoo
//
//  Created by kimhongpil on 2023/01/03.
//  Copyright © 2023 FNS CO., LTD. All rights reserved.
//

import Foundation

struct DefineBottomSheet {
    
    // 홈탭 -> Popular탭 -> GLOBAL버튼
    static let globalLanItems = [
        CustomBottomSheetModel(SEQ: 1, title: "en_global".localized),
        CustomBottomSheetModel(SEQ: 2, title: "n_setting_to_my_language".localized),
        CustomBottomSheetModel(SEQ: 3, title: "d_other_language_select".localized),
    ]
    
    static let subHomeItemMoreItems = [
        CustomBottomSheetModel(SEQ: 1, image: "icon_outline_save", title: "j_to_save".localized),
        CustomBottomSheetModel(SEQ: 2, image: "icon_outline_share", title: "g_to_share".localized),
        CustomBottomSheetModel(SEQ: 3, image: "icon_outline_join", title: "g_to_join".localized),
        CustomBottomSheetModel(SEQ: 4, image: "icon_outline_siren", title: "s_to_report".localized),
        CustomBottomSheetModel(SEQ: 5, image: "icon_outline_hide", title: "g_hide_post".localized),
        CustomBottomSheetModel(SEQ: 6, image: "icon_outline_blockaccount", title: "a_block_this_user".localized)
    ]
    
    //club setting
    static let clubOpenTitle = [
        CustomBottomSheetCommonModel(SEQ: 0, subTitle: "g_open_public".localized, subDescription: "m_all_see_searth".localized),
        CustomBottomSheetCommonModel(SEQ: 1, subTitle: "b_hidden".localized, subDescription: "n_only_see".localized)
    ]
    static let memberNumberListTitle = [
        CustomBottomSheetCommonModel(SEQ: 0, subTitle: "g_open_public".localized, subDescription: "k_show_all_member_count".localized),
        CustomBottomSheetCommonModel(SEQ: 1, subTitle: "b_hidden".localized, subDescription: "k_can_check_club_president".localized)
    ]
    static let memberListTitle = [
        CustomBottomSheetCommonModel(SEQ: 0, subTitle: "g_open_public".localized, subDescription: "k_open_all_club_members".localized),
        CustomBottomSheetCommonModel(SEQ: 1, subTitle: "b_hidden".localized, subDescription: "k_member_only_available_club_president".localized)
    ]
    static let joinApprovalTitle = [
        CustomBottomSheetCommonModel(SEQ: 0, subTitle: "j_auto".localized, subDescription: "g_join_immediately_after_apply".localized),
        CustomBottomSheetCommonModel(SEQ: 1, subTitle: "s_approval".localized, subDescription: "k_join_after_approves".localized)
    ]
    
    //club
    static let clubOpenSettingOfClub = [
        CustomBottomSheetCommonModel(SEQ: 0, subTitle: "g_open_public".localized, subDescription: "g_post_open_if_open_visiblity".localized),
        CustomBottomSheetCommonModel(SEQ: 1, subTitle: "b_hidden".localized, subDescription: "se_k_hide_post_in_club".localized)
    ]
    static let joinApprovalSettingOfClub = [
        CustomBottomSheetCommonModel(SEQ: 0, subTitle: "j_auto".localized, subDescription: "g_join_immediately_after_apply".localized),
        CustomBottomSheetCommonModel(SEQ: 1, subTitle: "s_approval".localized, subDescription: "k_join_after_approves".localized)
    ]
    
    //archive
    static var archiveVisibilityTitle = [
        CustomBottomSheetCommonModel(SEQ: 0, subTitle: "g_open_public".localized, subDescription: "se_b_can_see_non_join".localized),
        CustomBottomSheetCommonModel(SEQ: 1, subTitle: "b_hidden".localized, subDescription: "se_g_visible_post".localized)
    ]
    static var archiveTypeTitle = [
        CustomBottomSheetCommonModel(SEQ: 0, subTitle: "a_image".localized, subDescription: "".localized),
        CustomBottomSheetCommonModel(SEQ: 1, subTitle: "a_general".localized, subDescription: "d_move_weblink_text".localized)
    ]
    
    //clubMember
    static var rejoinSetting = [
        CustomBottomSheetCommonModel(SEQ: 0, subTitle: "g_prohibition".localized, subDescription: "se_h_cannot_rejoin_this_id".localized),
        CustomBottomSheetCommonModel(SEQ: 1, subTitle: "h_allow".localized, subDescription: "se_h_cannot_rejoin_this_id".localized)
    ]

}
