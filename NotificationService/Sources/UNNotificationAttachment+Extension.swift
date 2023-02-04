//
//  UNNotificationAttachment+Extension.swift
//  fantoo
//
//  Created by mkapps on 2022/02/17.
//  Copyright © 2022 SendBird. All rights reserved.
//

import UIKit

extension UNNotificationAttachment {
    /// Save the image to disk
    static func create(imageFileIdentifier: String, data: Data, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            
            let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
            
            try data.write(to: fileURL)
            
            let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier, url: fileURL, options: options)
            
            return imageAttachment
        } catch let error {
            print(error)
        }
        
        return nil
    }
}
