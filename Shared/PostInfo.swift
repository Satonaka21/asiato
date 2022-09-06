import SwiftUI
import Firebase
import FirebaseStorage
import MapKit

class PostInfomation: ObservableObject{
    @Published public var isNotSelected = false
    var ciImage: CIImage? = nil
    
    func postInfo(imageData: Data, coordinate: CLLocationCoordinate2D) {
        let nowDate = Date()
        let setPostData = SetPostData()
        
        print(imageData.count)
        print(coordinate)
        print(type(of:nowDate))
        setPostData.post()
        
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

class SetPostData{
    //ここでFirestoreValueとドキュメントパスを定義
    let db = Firestore.firestore()
    let saveDocument = Firestore.firestore().collection("post").document()
    
    public func post() {
        //setDataメソッドを使うことでFirestoreへのデータ追加が可能
        let postData: [String: Any] = [
            "datetime": Timestamp(date: Date()),
            "latitude" : 35,
            "longitude" : 135,
            "img_url" : "https://tekito",
            "text" : "yatta",
            "user_name": "watasi2022",
            "weather": "none"
        ]
        
        saveDocument.setData(postData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}
