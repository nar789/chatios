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
import PhotosUI

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
            
            switch granted {
            case .authorized:
                print("Album: 권한 허용")
                UserManager.shared.authorizedAlbum = true
            case .denied:
                print("Album: 권한 거부")
                UserManager.shared.authorizedAlbum = false
            case .restricted, .notDetermined:
                print("Album: 선택하지 않음")
            default:
                break
            }
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
