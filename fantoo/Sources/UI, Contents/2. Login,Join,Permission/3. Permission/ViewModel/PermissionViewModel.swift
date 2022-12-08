//
//  PermissionViewModel.swift
//  fantoo
//
//  Created by mkapps on 2022/06/14.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import AVFoundation
import Photos

class PermissionViewModel {
    func requestPermission() {
        requestAccessCamera()
    }
    
    func requestAccessCamera(){
        AVCaptureDevice.requestAccess(for: .video) { granted in
            self.requestAccessAlbum()
        }
    }
    
    func requestAccessAlbum(){
        PHPhotoLibrary.requestAuthorization(){ granted in
            self.requestCapture()
        }
    }
    
    func requestCapture() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            DispatchQueue.main.async {
                UserManager.shared.isFirstLaunching = false
                UserManager.shared.showLoginView = true
            }
        })
    }
}
