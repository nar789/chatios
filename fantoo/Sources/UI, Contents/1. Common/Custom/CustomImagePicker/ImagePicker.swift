//
//  ImagePicker.swift
//  fantoo
//
//  Created by kimhongpil on 2022/07/07.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import Photos   // Cannot find type 'PHAsset' in scope

/**
 * UIViewController를 SwiftUI에서 사용하기 위해서는 UIViewControllerRepresentable가 필수임
 * UIViewControllerRepresentable를 구현하기 위해서는 반드시 두 가지 메소드를 구현해야 함
 – func makeUIViewController(context: Context) -> some UIViewController
 – func updateUIViewController(_ uiViewController: some UIViewController, context: Context)
 *
 * SwiftUI 에 아직 같은 기능을 하는 View가 존재하지 않는 UIImagePickerController 사용
 *
 * UIImagePickerController에서 선택한 UIImage를 Coordinator를 사용해서 SwiftUI에 표시함
 *
 * @State property와 Binding 으로 Coordinator에서 부모View에 update를 별도로 하지않아도 구현되도록 함
 */
enum ImageType: Int {
    case BgImage
    case ProfileImage
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    let imageType: ImageType
    /*
     Bool : 성공 or 실패.
     UIImage : 성공일 때만 이미지 적용.
     String : 왜 실패했는지, 알럿에 사용하세요.
     */
    var imageCheck: ((Bool, UIImage, String) -> Void)
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        if imageType == .BgImage {
            imagePicker.sourceType = sourceType
            imagePicker.delegate = context.coordinator
        }
        else if imageType == .ProfileImage {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourceType
            imagePicker.delegate = context.coordinator
        }
        
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, imageType: imageType)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        let imageType: ImageType
        
        init(parent: ImagePicker, imageType: ImageType) {
            self.parent = parent
            self.imageType = imageType
        }
        
        
        //        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //
        ////            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        ////                parent.selectedImage = image
        ////            }
        ////
        ////            parent.presentationMode.wrappedValue.dismiss()
        //
        //
        //            let assetPath = info[UIImagePickerController.InfoKey.referenceURL] as! NSURL
        //
        //            print("absoluteString : \(assetPath.absoluteString)" as String)
        //
        //            if (assetPath.absoluteString?.hasSuffix("JPG"))! {
        //                print("JPG")
        //            }
        //            else if (assetPath.absoluteString?.hasSuffix("PNG"))! {
        //                print("PNG")
        //            }
        //            else if (assetPath.absoluteString?.hasSuffix("GIF"))! {
        //                print("GIF")
        //            }
        //            else {
        //                print("Unknown")
        //            }
        //            parent.presentationMode.wrappedValue.dismiss()
        //        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            /**
             * 갤러리에서 선택한 이미지를 UIImage 형식으로 가져오기
             */
            if imageType == .BgImage {
                
                if let image = info[.originalImage] as? UIImage {
                    parent.imageCheck(true, image, "")
                    parent.presentationMode.wrappedValue.dismiss()
                }
                else {
                    parent.imageCheck(false, UIImage(), "")
                }
            }
            else {
                if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                    parent.imageCheck(true, image, "")
                }
                else {
                    parent.imageCheck(false, UIImage(), "")
                }
            }
            
            //            if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
            //                let assetResources = PHAssetResource.assetResources(for: asset)
            //
            //                /**
            //                 * 이미지 포맷 검사
            //                 */
            //                print("선택한 파일 이름 : \(assetResources.first!.originalFilename)")
            //                if assetResources.first!.originalFilename.hasSuffix("JPG") {
            //                    parent.isUnqualifiedImageFormats = false
            //                    print("image'formats check : JPG")
            //                }
            //                else if assetResources.first!.originalFilename.hasSuffix("PNG") {
            //                    parent.isUnqualifiedImageFormats = false
            //                    print("image'formats check : PNG")
            //                }
            //                else if assetResources.first!.originalFilename.hasSuffix("HEIC") {
            //                    parent.isUnqualifiedImageFormats = false
            //                    print("image'formats check : HEIC")
            //                }
            //                else {
            //                    parent.isUnqualifiedImageFormats = true
            //                    print("image'formats check : OTHER")
            //                    print("image'formats check : \(assetResources.first!.originalFilename)")
            //                }
            //
            //                /**
            //                 * 이미지 사이즈 검사
            //                 */
            //                var sizeOnDisk: Int64 = 0
            //                if let resource = assetResources.first {
            //                    let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
            //                    sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64!))
            //
            //                    print(String(format: "%f", Double(sizeOnDisk) / (1024.0*1024.0))+" MB")
            //                    print(String(format: "%.1f", Double(sizeOnDisk) / (1024.0*1024.0))+" MB")
            //
            //                    let tmpImageMegabyte = Double(sizeOnDisk) / (1024.0*1024.0) // MB로 변환
            //                    if tmpImageMegabyte < 5.0 {
            //                        parent.isUnqualifiedImageSize = false
            //                    } else {
            //                        parent.isUnqualifiedImageSize = true
            //                    }
            //
            //                }
            //
            //                parent.imageCheck(parent.isUnqualifiedImageFormats, parent.isUnqualifiedImageSize)
            //            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        
    }
    
    
}
