//
//  Apis+Upload.swift
//  fantoo
//
//  Created by mkapps on 2022/10/27.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Moya
import Foundation
import Alamofire
import UIKit

enum ApisUpload {
    case UploadImage(image:UIImage)
    case UploadStream
}

extension ApisUpload: Moya.TargetType {
    var baseURL: URL {
        switch self {
        case .UploadImage:
            return URL(string: DefineUrl.Domain.Upload)!
        case .UploadStream:
            return URL(string: DefineUrl.Domain.Upload)!
        }
    }
    
    var path: String {
        switch self {
        case .UploadImage:
            return DefineUrl.Path.UploadImage
        case .UploadStream:
            return DefineUrl.Path.UploadStream
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .UploadImage:
            return .post
        case .UploadStream:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .UploadImage(let image):
            let imageData = image.pngData() ?? Data()
            let fileName = String(format: "image_%ld.jpeg", Date().millisecondsSince1970)
            let imageMultipartFormData = MultipartFormData(provider: .data(imageData), name: "file", fileName: fileName, mimeType: "image/jpeg")

            return .uploadMultipart([imageMultipartFormData])
            
        case .UploadStream:
            let params = defaultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = CommonFunction.defaultHeader()
        
        switch self {
        case .UploadImage:
            header["Content-Type"] = "multipart/form-data"
            header["Authorization"] = "Bearer etE-IoTh7y1CSbqKVbmxcaUxA9WUl0ehAsl0USqt"
            
        case .UploadStream:
            header["Content-Type"] = "multipart/form-data"
            header["Authorization"] = "Bearer yPZzSlLTXamgT31vTZTWs3--usOENNCw5JEjgpeu"
            
        }
        return header
    }
    
    var defaultParams: [String : Any] {
        let params: [String: Any] = [:]
        return params
    }
    
    func log(params: [String: Any]) {
        if self.isApiLogOn() {
            print("\n--- API : \(baseURL)/\(path) -----------------------------------------------------------\n\(params)\n------------------------------------------------------------------------------------------------------------------------------\n")
        }
    }
}

extension ApisUpload {
    var cacheTime: NSInteger {
        var time = 0
        switch self {
        default: time = 60
        }
        
        return time
    }
}

//MARK: - Log On/Off
extension ApisUpload {
    func isAlLogOn() -> Bool {
        return true
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        case .UploadImage:
            return [true, true]
            
        case .UploadStream:
            return [true, true]
        }
    }
    
    func isApiLogOn() -> Bool {
        if self.isAlLogOn(), self.isLogOn()[0] {
            return true
        }
        return false
    }
    
    func isResponseLog() -> Bool {
        if self.isAlLogOn(), self.isLogOn()[1] {
            return true
        }
        return false
    }
}

//MARK: - Check Token or not
extension ApisUpload {
    func isCheckToken() -> Bool {
        switch self {
        case .UploadImage:
            return true
            
        case .UploadStream:
            return true
        }
    }
}


//MARK: - Caching Time : Seconds
extension ApisUpload {
    func dataCachingTime() -> Int {
        switch self {
        case .UploadImage:
            return DataCachingTime.None.rawValue
            
        case .UploadStream:
            return DataCachingTime.None.rawValue
        }
    }
}

