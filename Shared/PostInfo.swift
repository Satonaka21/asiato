import SwiftUI
import FirebaseStorage
import MapKit

class PostInfomation: ObservableObject{
    @Published public var isNotSelected = false
    var ciImage: CIImage? = nil
    
    func postInfo(imageData: Data, coordinate: CLLocationCoordinate2D) {
        let nowDate = Date()
        
        print(imageData.count)
        print(coordinate)
        print(type(of:nowDate))
        
        if(imageData.count != 0){
            // fireStorageに画像をアップロード
            let storage = Storage.storage()
            let storageRef = storage.reference(forURL: "gs://toratora-dev.appspot.com")
            let randomStr = randomString(length: 20)
            let imageRef = storageRef.child("pic/" + randomStr + ".png")
            let uploadTask = imageRef.putData(imageData)
            var downloadURL: URL?
            uploadTask.observe(.success){ _ in
                imageRef.downloadURL{ url, error in
                    if let url = url {
                        downloadURL = url
                    }
                }
            }
            
            uploadTask.observe(.failure){ snapshot in
                if let message = snapshot.error?.localizedDescription{
                    print(message)
                }
            }
            
            
            
        }else{
            isNotSelected = true
        }
    }
}

