

import SwiftUI
import PhotosUI


struct PhotoPicker: UIViewControllerRepresentable {
    let configuration: PHPickerConfiguration
   @Binding var isPresented: Bool
   @Binding var images: [UIImage]
    @Binding var list:[TmpData]
    var itemProviders:[NSItemProvider] = []
    
   func makeUIViewController(context: Context) -> PHPickerViewController {
       let controller = PHPickerViewController(configuration: configuration)
       controller.delegate = context.coordinator
       return controller
   }
   func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
   func makeCoordinator() -> Coordinator {
       Coordinator(self)
   }
   
   // Use a Coordinator to act as your PHPickerViewControllerDelegate
   class Coordinator: PHPickerViewControllerDelegate {
     
       private var parent: PhotoPicker
       
       init(_ parent: PhotoPicker) {
           self.parent = parent
       }
       func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
           
           if !results.isEmpty {
               parent.images = []
               parent.itemProviders = []
           }
           
           parent.itemProviders = results.map(\.itemProvider)
           loadImage()
        
           parent.isPresented = false // Set isPresented to false because picking has finished.
           
       }
       
       func loadImage() {
           for itemProvider in parent.itemProviders {
               if itemProvider.canLoadObject(ofClass: UIImage.self) {
                   itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                       
                       if let image = image as? UIImage {
                           let size = CGSize(width:149,height:178)
                           UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                           image.draw(in: CGRect(origin: CGPoint.zero, size: size))
                           let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
                           UIGraphicsEndImageContext()
                           
                           let filesize = Double(resizedImage.pngData()!.count / 1024 / 1024)
                           print("img size " + String(filesize))
                           if(filesize > 0) {
                               print("file size is big")
                               return
                           }
                           let data = resizedImage.pngData()!
                           ChatSocketManager.shared.uploadImage(data: data)
                           self.parent.list.append(TmpData(type:2, showImage: true, image: image))
                       } else {
                           print("Could not load image", error?.localizedDescription ?? "")
                       }
                   }
               }
           }
       }
       
       func getArrayOfBytesFromImage(imageData:NSData) -> Array<UInt8>
       {

         // the number of elements:
         let count = imageData.length / MemoryLayout<Int8>.size

         // create array of appropriate length:
         var bytes = [UInt8](repeating: 0, count: count)

         // copy bytes into array
         imageData.getBytes(&bytes, length:count * MemoryLayout<Int8>.size)

         var byteArray:Array = Array<UInt8>()

         for i in 0 ..< count {
           byteArray.append(bytes[i])
         }

         return byteArray


       }
   }

    
}
