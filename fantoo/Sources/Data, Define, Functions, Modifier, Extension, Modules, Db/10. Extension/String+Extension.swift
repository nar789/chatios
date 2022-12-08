//
//  String+Extension.swift
//  fantoo
//
//  Created by mkapps on 2022/04/27.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

extension String {
    var localized: String {
        return Bundle.localizedBundle.localizedString(forKey: self, value: nil, table: nil)
    }
    
    var imageOriginalUrl: String {
        return String(format: DefineUrl.Image.Original, self)
    }
    
    var videoOriginUrl: String {
        return String(format: DefineUrl.Video.Original, self)
    }
    
    /**
     숫자형 문자열에 3자리수 마다 콤마 넣기
     Double형으로 형변환 되지 않으면 원본을 유지한다.
     
     ```swift
     let stringValue = "10005000.123456789"
     print(stringValue.insertComma)
     // 결과 : "10,005,000.123456789"
     ```
     
     */
    var insertComma: String {
        let numberFormatter = NumberFormatter();
        numberFormatter.numberStyle = .decimal
        
        // 소수점이 있는 경우 처리
        if let _ = self.range(of: ".") {
            let numberArray = self.components(separatedBy: ".")
            if numberArray.count == 1 {
                var numberString = numberArray[0]
                if numberString.isEmpty {
                    numberString = "0"
                }
                
                guard let doubleValue = Double(numberString) else {
                    return self
                }
                
                return numberFormatter.string(from: NSNumber(value: doubleValue)) ?? self
                
            } else if numberArray.count == 2 {
                var numberString = numberArray[0]
                if numberString.isEmpty {
                    numberString = "0"
                }
                
                guard let doubleValue = Double(numberString) else {
                    return self
                }
                
                return (numberFormatter.string(from: NSNumber(value: doubleValue)) ?? numberString) + ".\(numberArray[1])"
            }
        } else {
            guard let doubleValue = Double(self) else {
                return self
            }
            
            return numberFormatter.string(from: NSNumber(value: doubleValue)) ?? self
        }
        return self
    }
    
    func convertToDictionary() -> [String: Any]? {
        if let data = data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        }
        
        return nil
    }
    
    
    //MARK: - Validate
    func validatePassword() -> Bool {
        let passwordRegex: String = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[,.!@#$%&*]).{8,20}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    func validateEmail() -> Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    func validateHashTag() -> Bool {
        let hashTagRegex: String = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9]{0,15}"
        return NSPredicate(format: "SELF MATCHES %@", hashTagRegex).evaluate(with: self)
    }
    
    
    
    //MARK: - Caclulate
    /**
     * 입력받은 String의 width 값 얻기
     */
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    public enum DateFormatType {
        
        /// The ISO8601 formatted year "yyyy" i.e. 1997
        case isoYear
        
        /// The ISO8601 formatted year and month "yyyy-MM" i.e. 1997-07
        case isoYearMonth
        
        /// The ISO8601 formatted date "yyyy-MM-dd" i.e. 1997-07-16
        case isoDate
        
        /// The ISO8601 formatted date and time "yyyy-MM-dd'T'HH:mmZ" i.e. 1997-07-16T19:20+01:00
        case isoDateTime
        
        /// The ISO8601 formatted date, time and sec "yyyy-MM-dd'T'HH:mm:ssZ" i.e. 1997-07-16T19:20:30+01:00
        case isoDateTimeSec
        
        /// The ISO8601 formatted date, time and millisec "yyyy-MM-dd'T'HH:mm:ss.SSSZ" i.e. 1997-07-16T19:20:30.45+01:00
        case isoDateTimeMilliSec
        
        /// The dotNet formatted date "/Date(%d%d)/" i.e. "/Date(1268123281843)/"
        case dotNet
        
        /// The RSS formatted date "EEE, d MMM yyyy HH:mm:ss ZZZ" i.e. "Fri, 09 Sep 2011 15:26:08 +0200"
        case rss
        
        /// The Alternative RSS formatted date "d MMM yyyy HH:mm:ss ZZZ" i.e. "09 Sep 2011 15:26:08 +0200"
        case altRSS
        
        /// The http header formatted date "EEE, dd MM yyyy HH:mm:ss ZZZ" i.e. "Tue, 15 Nov 1994 12:45:26 GMT"
        case httpHeader
        
        /// A generic standard format date i.e. "EEE MMM dd HH:mm:ss Z yyyy"
        case standard
        
        /// A custom date format string
        case custom(String)
        
        /// The local formatted date and time "yyyy-MM-dd HH:mm:ss" i.e. 1997-07-16 19:20:00
        case localDateTimeSec
        
        /// The local formatted date  "yyyy-MM-dd" i.e. 1997-07-16
        case localDate
        
        /// The local formatted  time "hh:mm a" i.e. 07:20 am
        case localTimeWithNoon
        
        /// The local formatted date and time "yyyyMMddHHmmss" i.e. 19970716192000
        case localPhotoSave
        
        case birthDateFormatOne
        
        case birthDateFormatTwo
        
        ///
        case messageRTetriveFormat
        
        ///
        case emailTimePreview
        
        var stringFormat:String {
            switch self {
                //handle iso Time
            case .birthDateFormatOne: return "dd/MM/YYYY"
            case .birthDateFormatTwo: return "dd-MM-YYYY"
            case .isoYear: return "yyyy"
            case .isoYearMonth: return "yyyy-MM"
            case .isoDate: return "yyyy-MM-dd"
            case .isoDateTime: return "yyyy-MM-dd'T'HH:mmZ"
            case .isoDateTimeSec: return "yyyy-MM-dd'T'HH:mm:ssZ"
            case .isoDateTimeMilliSec: return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            case .dotNet: return "/Date(%d%f)/"
            case .rss: return "EEE, d MMM yyyy HH:mm:ss ZZZ"
            case .altRSS: return "d MMM yyyy HH:mm:ss ZZZ"
            case .httpHeader: return "EEE, dd MM yyyy HH:mm:ss ZZZ"
            case .standard: return "EEE MMM dd HH:mm:ss Z yyyy"
            case .custom(let customFormat): return customFormat
                
                //handle local Time
            case .localDateTimeSec: return "yyyy-MM-dd HH:mm:ss"
            case .localTimeWithNoon: return "hh:mm a"
            case .localDate: return "yyyy-MM-dd"
            case .localPhotoSave: return "yyyyMMddHHmmss"
            case .messageRTetriveFormat: return "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            case .emailTimePreview: return "dd MMM yyyy, h:mm a"
            }
        }
    }
    
    func toDate(_ format: DateFormatType = .isoDate) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.stringFormat
        let date = dateFormatter.date(from: self)
        return date
    }
    
    func changeDateFormat(format: DateFormatType = .isoDate, changeFormat: DateFormatType = .isoDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.stringFormat
        let convertDate = dateFormatter.date(from: self)   // Date 타입으로 변환
        
        let myDateFormatter = DateFormatter()
        //myDateFormatter.locale = Locale(identifier:"ko_KR") // PM, AM을 언어에 맞게 setting (ex: PM -> 오후)
        myDateFormatter.dateFormat = changeFormat.stringFormat
        
        if let NOconvertDate = convertDate {
            let convertStr = myDateFormatter.string(from: NOconvertDate)
            return convertStr
        }
        else {
            return ""
        }
        
    }
    
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
    /**
     * yyyy-MM-dd'T'HH:mm:ss -> MM월 dd일
     */
    func changeDateFormat_Custom(strDate: String) -> String {
        return strDate.changeDateFormat(format: .custom("yyyy-MM-dd'T'HH:mm:ss"), changeFormat: .custom("MM월 dd일")) // yyyy년 MM월 dd일 a hh시 mm분
    }
    
    
    func convertDate(_ format:String = "MMM dd, yyyy hh:mm:ss a") -> Date {
        let df = DateFormatter()
        //df.timeZone = TimeZone(abbreviation: "GMT")
        df.dateFormat = format
        
        return df.date(from: self) ?? Date()
    }
    
    func changeDateString(_ format:String = "MMM dd, yyyy hh:mm:ss a", _ toFormat:String = "MMM dd, yyyy hh:mm:ss a") -> String {
        let df = DateFormatter()
        //df.timeZone = TimeZone(abbreviation: "GMT")
        df.dateFormat = format
        
        let date = df.date(from: self) ?? Date()
        df.dateFormat = toFormat
        
        return df.string(from: date)
    }
}
