//
//  SubPopularViewModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/06/23.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class SubPopularViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    var fetchMoreActionSubject = PassthroughSubject<(), Never>()
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    @Published var mainHomeTabPopularTrending: MainHomeTabPopularTrending?
    @Published var trendingHashList = [TrendingList]()
    @Published var mainHomePopular: MainHomeData?
    @Published var mainPostDtoList = [MainPostDtoList]()
    
    
    
    @Published var mainHomeTabPopular: MainHomeTabPopular?
    @Published var trendingList = [String]()
    @Published var afterTrendingList = [[[String]]]()
    @Published var bannerList = [Banner]()
    @Published var boardList = [ItemData]()
    @Published var clubRecoList = [itemCardClubReco]()
    @Published var trendingIndex: Int = 0
    @Published var isPageLoading: Bool = false
    @Published var trendingListSize: Int = 0
    
    @Published var testTrendingList = [String]()

    
    
    init() {
        fetchMoreActionSubject.sink { [weak self] _ in
            guard let self = self else { return }
            
            if !self.isPageLoading {
                self.fetchMore()
            }
        }.store(in: &canclelables)
    }
    
    private func fetchMore() {
        guard let currentPage = mainHomeTabPopular?.page else {
            print("페이지 정보가 업습니다.")
            return
        }
        self.isPageLoading = true
        let pageToLoad = currentPage + 1
        // 0.5초 지연
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            ApiControl.getMainHomeTab_Popular(page: pageToLoad)
                .sink { error in
                    print("error : \(error)")
                    
                    self.isPageLoading = false
                    self.offPagingLoadView()
                    
                } receiveValue: { value in
                    self.mainHomeTabPopular = value
                    guard let NOmainHomeTabPopular = self.mainHomeTabPopular else {
                        // The 'value' is nil
                        return
                    }
                    // The 'nonOptionalValue' is not nil
                    self.isPageLoading = false
                    self.boardList += NOmainHomeTabPopular.data.board
                }
                .store(in: &self.canclelables)
        }
    }
    
    func getMainHomeTabPopular() {
        ApiControl.getMainHomeTab_Popular()
            .sink { error in
                
            } receiveValue: { value in
                self.mainHomeTabPopular = value
                guard let NOmainHomeTabPopular = self.mainHomeTabPopular else {
                    // The 'value' is nil
                    return
                }
                print("getMainHomeTabPopular value : \(value)")
                
                // The 'nonOptionalValue' is not nil
//                self.trendingList = NOmainHomeTabPopular.data.trending
//                self.afterTrendingList = self.getStringCountFromWidth(arrString: self.trendingList)
                self.bannerList = NOmainHomeTabPopular.data.banner
                self.clubRecoList = NOmainHomeTabPopular.data.clubReco[0].item.club_reco
                self.boardList = NOmainHomeTabPopular.data.board
                
            }
            .store(in: &canclelables)
    }
    func requestMainHomePopular() {
        loadingStatus = .ShowWithTouchable
        
        ApiControl.getMainHome_Popular(integUid: UserManager.shared.uid, nextId: "", size: 10)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                
                print("MainHomePopular error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                self.mainHomePopular = value
                
                guard let noMainHomePopular = self.mainHomePopular else {
                    return
                }
                
                self.mainPostDtoList = noMainHomePopular.mainPostDtoList
                
                print("MainHomePopular value : \(value)")
                
            }
            .store(in: &canclelables)
    }
    
    
    func requestHomeTrendingList() {
        loadingStatus = .ShowWithTouchable
        ApiControl.getMainTabHome_PopularTrending(size: 15)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                
                print("HomeTrendingList error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                self.mainHomeTabPopularTrending = value
                self.trendingListSize = value.listSize
                
                guard let noMainHomeTabPopularTrending = self.mainHomeTabPopularTrending else {
                    return
                }
                
                self.trendingHashList = noMainHomeTabPopularTrending.searchList
                
                for i in noMainHomeTabPopularTrending.searchList {
                    if self.trendingList.count < self.trendingListSize {
                        self.trendingList.append(i.tag)
                    }
                }
                self.afterTrendingList = self.getStringCountFromWidth(arrString: self.trendingList)

                
                print("HomeTrendingList value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    /**
     * 세 줄에서 몇 개의 글자를 보여줄 수 있는지 계산.
     * 세 줄인 이유는 TabView에서 하나의 화면 단위이기 때문.
     */
    func getStringCountFromWidth(arrString: [String]) -> [[[String]]] {
        
        var arrayWidth: [CGFloat] = []
        let rootScreenWidth: CGFloat = UIScreen.screenWidth - 60  // 화면 좌우 padding 20씩 주기 때문에 40을 뺀다
        var arrayIndex: [Int] = []
        
        
        // for test
        //let getWidth = "helloWorld".widthOfString(usingFont: UIFont.systemFont(ofSize: 17, weight: .bold))
        //print("idpil_log$ getWidth : \(getWidth)" as String)
        //print("idpil_log$ UIScreen width : \(UIScreen.screenWidth)" as String)
        
        
        
        /**
         * step 1 :
         * [글자의 width] 형태의 배열 값 구하기
         */
        for singleString in arrString {
            //print("idpil_log$ singleString : \(singleString)")
            
            var stringWidth: CGFloat = singleString.widthOfString(usingFont: UIFont.systemFont(ofSize: 17, weight: .bold))
            /**
             * 계산된 String의 width에서,
             * 'text의 padding 값', 'text 배경 roundedRectangle 폭' 등 치수를 더한다.
             */
            stringWidth += 60
            arrayWidth.append(stringWidth)
        }
        
        /**
         * step 2 :
         * 한 줄에서 보여줄 수 있는 글자 수 구하기
         */
        var tmpValue: CGFloat = 0.0
        var singleStringCount: Int = 0  // 한 줄에서 보여줄 수 있는 글자 수
        for (index, element) in arrayWidth.enumerated() {
            //print("idpil_log$ singleInt : \(singleInt)")
            
            tmpValue += element
            singleStringCount += 1
            
            
            
            
            //            print("idpil_log$ tmpValue : \(tmpValue)" as String)
            //            print("idpil_log$ arrString's index : \(arrString[index])" as String)
            //            print("idpil_log$ 한 줄에서 보여줄 수 있는 글자 수 : \(singleStringCount)" as String)
            if tmpValue > rootScreenWidth {
                //                print("#####################################")
                //                print("idpil_log$ tmpValue : \(tmpValue)" as String)
                //                print("idpil_log$ 다음 줄에서 보여져야할 글자 : \(arrString[index])" as String)
                //                print("idpil_log$ 다음 줄에서 보여져야할 글자의 Index : \(index)" as String)
                //                print("idpil_log$ 한 줄에서 보여줄 수 있는 글자 수 : \(singleStringCount)" as String)
                //                print("#####################################")
                
                // 다음 계산을 위해 초기화
                tmpValue = 0.0
                singleStringCount = 0
                
                
                arrayIndex.append(index-1)
            }
        }
        /**
         *
         */
        arrayIndex.append(arrString.count-1)
        //print("idpil_log$ tmpValue : \(tmpValue)" as String)
        
        //print("idpil_log$ arrayIndex : \(arrayIndex)" as String)
        
        
        /**
         * 배열 자르기 문법
         * Arr[first_Index..<last_Index]
         * tmpArr[0..<3]
         */
        //var tmpArr: [String] = []
        var finalArr: [[String]] = []
        var leftIndex: Int = 0
        var rightIndex: Int = 0
        
        
        //        for (index, element) in arrString.enumerated() {
        //            tmpArr.append(element)
        //        }
        
        
        for item in arrayIndex {
            //print("idpil_log$ item : \(item)" as String)
            
            rightIndex = item+1
            
            
            //var test = arrString[0..<3]
            var tmpArr = arrString[leftIndex..<rightIndex]
            //            print("idpil_log$ tmpArr : \(tmpArr)" as String)
            //
            //            print("idpil_log$ tmpArr type : \(type(of: tmpArr))")           // type : ArraySlice<String>  -> 아래와 같이 Array<String> 로 변경해줘야 됨 !
            //            print("idpil_log$ tmpArr type : \(type(of: Array(tmpArr)))")    // type : Array<String>
            //            print("idpil_log$ finalArr type : \(type(of: finalArr))")
            finalArr.append(Array(tmpArr))
            
            tmpArr = []
            leftIndex = rightIndex
            
        }
        
        //print("idpil_log$ tmpArr : \(tmpArr)" as String)
        //print("idpil_log$ finalArr : \(finalArr)" as String)
        //print("idpil_log$ tmpArr 0 to 3 : \(tmpArr[0..<3])")
        
        
        var realFinalArr: [[[String]]] = []
        leftIndex = 0
        rightIndex = 0
        //print("idpil_log$ 3개로 나눈 최종 배열 : \(finalArr[leftIndex..<rightIndex])")
        for _ in finalArr {
            
            rightIndex += 3
            
            if rightIndex > finalArr.count-1 {
                //                print("idpil_log$ in if")
                //                print("idpil_log$ leftIndex : \(leftIndex)" as String)
                //                print("idpil_log$ rightIndex : \(rightIndex)" as String)
                //                print("idpil_log$ finalArr.count-1 : \(finalArr.count-1)" as String)
                
                /**
                 * 배열 마지막 아이템까지 자르기 위해서는
                 * finalArr.count-1 가 아니라 finalArr.count 로 해야됨 !!!!!!!!
                 */
                rightIndex = finalArr.count
                
                //                print("idpil_log$ 3개로 나눈 최종 배열 : \(finalArr[leftIndex..<rightIndex])")
                let tmpArr = finalArr[leftIndex..<rightIndex]
                realFinalArr.append(Array(tmpArr))
                
                break
            } else {
                //                print("idpil_log$ in else")
                //                print("idpil_log$ 3개로 나눈 최종 배열 : \(finalArr[leftIndex..<rightIndex])")
                let tmpArr = finalArr[leftIndex..<rightIndex]
                realFinalArr.append(Array(tmpArr))
                leftIndex = rightIndex
            }
        }
        //        print("idpil_log$ realFinalArr : \(realFinalArr)" as String)
        
        
        return realFinalArr
    }
    
    func onPagingLoadView() {
        // 페이지 내에서 로딩
        StatusManager.shared.loadingStatus = .ShowWithTouchable
    }
    func offPagingLoadView() {
        // 로딩 종료
        StatusManager.shared.loadingStatus = .Close
    }
    
}
