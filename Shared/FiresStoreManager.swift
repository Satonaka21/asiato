import FirebaseCore
import FirebaseFirestore
import SwiftUI
import CoreLocation

struct Post: Codable, Identifiable{
    var id: String = UUID().uuidString
    var cordinate: String? //CLLocationCoordinate2D
    var datetime: String?  //Timestamp
    var img_url: String?
    var text: String?
    var user_name: String?
    var weather: String?
}

class PostViewModel: ObservableObject {
    @Published var posts = [Post]()

    private var db = Firestore.firestore()

    func getAllData() {
        db.collection("post").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
            print("No documents")
            return
        }

        self.posts = documents.map { (queryDocumentSnapshot) -> Post in
            let data = queryDocumentSnapshot.data()
            let coordinate = data["coordinate"] as? String ?? ""
            let datetime = data["datetime"] as? String ?? ""
            let img_url = data["img_url"] as? String ?? ""
            let text = data["text"] as? String ?? ""
            let user_name = data["user_name"] as? String ?? ""
            let weather = data["weather"] as? String ?? ""
            
            return Post(
                cordinate: coordinate,
                datetime: datetime,
                img_url: img_url,
                text: text,
                user_name: user_name,
                weather: weather
            )}
        }
    }

    func addNewData(name: String) {
       do {
           _ = try db.collection("post").addDocument(data: ["user_name": name])
       }
       catch {
           print(error.localizedDescription)
       }
   }
}



