import SwiftUI
import Firebase
import FirebaseStorage
import MapKit

class PostInfomation: ObservableObject{
    @Published public var isNotSelected = false
    var ciImage: CIImage? = nil
    
    func postInfo(imageData: Data, coordinate: CLLocationCoordinate2D, text: String) {
        let setPostData = SetPostData()
        let postData = PostData()
        
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
                        let img_url = downloadURL?.absoluteString ?? ""
                        let postData = postData.genePostData(
                            datetime: Timestamp(date: Date()),
                            latitude: String(coordinate.latitude),
                            longitude: String(coordinate.longitude),
                            img_url: img_url,
                            text: text,
                            userName: "watasi2022",
                            weather: "none"
                        )
                        setPostData.post(postData: postData)
                    } else{
                        print("error:\(error)")
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
    
    public func post(postData: [String: Any]) {
        //setDataメソッドを使うことでFirestoreへのデータ追加が可能
        print(postData)
        saveDocument.setData(postData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}

class PostData{
    func genePostData(datetime: Timestamp,
                      latitude: String,
                      longitude: String,
                      img_url: String,
                      text: String,
                      userName: String,
                      weather: String) -> [String: Any] {
        return [
            "datetime": datetime,
            "latitude" : latitude,
            "longitude" : longitude,
            "img_url" : img_url,
            "text" : text,
            "user_name": userName,
            "weather": weather
        ]
    }
}
