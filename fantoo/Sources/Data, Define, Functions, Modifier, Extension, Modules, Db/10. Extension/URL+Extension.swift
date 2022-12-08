//
//  URL+Extension.swift
//  fantoo
//
//  Created by dklee on 2021/08/02.
//  Copyright © 2021 FNS. All rights reserved.
//

import UIKit


extension URL {
    // document 경로
    static var documentsDirectory: URL {
        do{
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory,
                                                                    in: .userDomainMask,
                                                                    appropriateFor: nil,
                                                                    create: false)
            return try! documentsDirectory
        }catch{
            return URL(string: "")!
        }
    }
    
    // document에 있는 파일 경로 전달
    static func urlInDocumentsDirectory(with filename: String) -> URL {
        return documentsDirectory.appendingPathComponent(filename)
    }
    
    // 해당 url의 openGraph 정보 가져오기.
//    var getOpenGraph: String{
//        do{
// 
//            let main = try String(contentsOf: self, encoding: .utf8)
//            let doc = try HTML(html: main, encoding: .utf8)
//            var openGraphDict : [String: String] = [:]
//          
//            for openGraphTag in doc.css("meta[property^='og']") {
//
//                guard let property = openGraphTag["property"] else { return ""}
//                guard let content = openGraphTag["content"] else { return ""}
//                
//                openGraphDict[property.remove(location: 0, length: 3)] = content
//            }
//        
//            for openGraphTag in doc.css("meta[property^='al']") {
//                guard let property = openGraphTag["property"] else { return ""}
//                guard let content = openGraphTag["content"] else { return ""}
//
//                if property == "al:ios:url" {
//                    
//                    let components = URLComponents(string: content)
//                    let items = components?.queryItems ?? []
//                    
//                    let urlValue = ("\(items[0])").substring(from: 4)
//                    let fileUrl = URL(string: urlValue)
//                    let main = try String(contentsOf: fileUrl!, encoding: .utf8)
//                    let testDoc = try HTML(html: main, encoding: .utf8)
//
//                    for value in testDoc.css("meta[property^='og']") {
//                        
//                        guard let property = value["property"] else { return ""}
//                        guard let content = value["content"] else { return ""}
//                        
//                        openGraphDict[property.remove(location: 0, length: 3)] = content
//                    }
//                }
//                
//                openGraphDict[property.remove(location: 0, length: 3)] = content
//            }
//
////            if openGraphDict.isEmpty {
////                return ""
////            }
//            
//            let jsonData = try? JSONSerialization.data(withJSONObject: openGraphDict, options: [])
//            let jsonString = String(data: jsonData!, encoding: .utf8)
//            return jsonString!
//            
//        } catch let error {
//            print("Error: \(error)")
//            return ""
//        }
//    }
    
    var hasTweetId: Bool {
        do{
            let str = self.path
            let regexStr = "^/(?:#!/)?(\\w+)/status(es)?/(\\d+)$"
            
            let range = NSRange(str.startIndex..., in: str)
            
            let regex = try NSRegularExpression(pattern: regexStr)
            let results = regex.rangeOfFirstMatch(in: str, range: range)
            
            return results.location != NSNotFound
        }
        catch{
            return false
        }
    }
    
    var queryDictionary: [String: String]? {
        guard let query = self.query else { return nil }
        
        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {
            
            let components = pair.components(separatedBy: "=")
            
            if (components.count < 2) {
                return nil
            }
            
            let key = components[0]
            
            let value = components[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""
            
            queryStrings[key] = value
        }
        return queryStrings
    }
    
    static func createFolder(folderName: String) -> URL? {
        let fileManager = FileManager.default
        // Get document directory for device, this should succeed
        if let documentDirectory = fileManager.urls(for: .cachesDirectory,
                                                    in: .userDomainMask).first {
            // Construct a URL with desired folder name
            let folderURL = documentDirectory.appendingPathComponent(folderName)
            // If folder URL does not exist, create it
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    // Attempt to create folder
                    try fileManager.createDirectory(atPath: folderURL.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                } catch {
                    // Creation failed. Print error & return nil
                    print(error.localizedDescription)
                    return nil
                }
            }
            // Folder either exists, or was created. Return URL
            return folderURL
        }
        // Will only be called if document directory not found
        return nil
    }
    
    static func deleteFolder(folderName: String) -> Bool {
        let fileManager = FileManager.default
        // Get document directory for device, this should succeed
        if let documentDirectory = fileManager.urls(for: .cachesDirectory,
                                                    in: .userDomainMask).first {
            // Construct a URL with desired folder name
            let folderURL = documentDirectory.appendingPathComponent(folderName)
            // If folder URL does not exist, create it
            if fileManager.fileExists(atPath: folderURL.path) {
                do {
                    try fileManager.removeItem(atPath: folderURL.path)
                } catch {
                    // Creation failed. Print error & return nil
                    print(error.localizedDescription)
                    return false
                }
            }
            // Folder either exists, or was created. Return URL
            return true
        }
        // Will only be called if document directory not found
        return false
    }
}
