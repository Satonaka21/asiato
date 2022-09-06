//
//  firestore.swift
//  asiato
//
//  Created by 山北峻佑 on 2022/09/05.
//


import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import AVFoundation


struct Person {
    var name: String
    var age: Int
    var hobbys: [Hobby]
}

struct Hobby {
    var name: String
    var year: Int
}

//取得するデータを宣言（これも忘れない
struct Report: Codable{
    var datetime: Date
    var img_url: String
    var latitude: String
    var longitude: String
    var text: String
    var user_name: String
    var weather: String
}

class ViewControllerFireStore: UIViewController{

    public func fetchDocumentData() {
        let db = Firestore.firestore()
        //現在地に変える
        let latitude: Double = 34.4827065
        let longitude: Double = 136.8254649
        
        print("関数呼び出し")
        db.collection("post").getDocuments  {(_snapShot, _error) in
            if let snapShot = _snapShot {
                //取得した値を変数にlistとして格納する（全選択）
                let menuList = snapShot.documents.map {menu -> Report in
                    let data = menu.data()
                    let datetime = data["datetime"] as! Timestamp
                    let date = datetime.dateValue()
                    let img_url: String = data["img_url"] as! String
                    let latitude: String = data["latitude"] as! String
                    let longitude: String = data["longitude"] as! String
                    let text: String = data["text"] as! String
                    let user_name: String = data["user_name"] as! String
                    let weather: String = data["weather"] as! String
                    return Report(datetime: date, img_url: img_url, latitude: latitude, longitude: longitude, text: text, user_name: user_name, weather: weather)
                }
               dump(menuList)
//                print(menuList)
                //filterをかけた後の処理
                let lat_min: Double = latitude - 0.1
                let lat_max: Double = latitude + 0.1
                let long_min: Double = longitude - 0.1
                let long_max: Double = longitude + 0.1
                
                let postList = menuList.filter{ document in
                    let lat: Double = Double(document.latitude) ?? 0
                    let long: Double = Double(document.longitude) ?? 0
                    return lat_min < lat && lat < lat_max && long_min < long && long < long_max

                }
                dump(postList)

                //値は配列になっている。取得は、「配列[index].要素名」で取得することができる。
                print(menuList[0].datetime)
                
            }else {
                print("Data Not Found")
            }
        }
    }
    
//    public func fetchDocumentData() {
//        let db = Firestore.firestore()
//        print("関数呼び出し")
//        db.collection("post").getDocuments  {(_snapShot, _error) in
//            if let snapShot = _snapShot {
//                let documents = snapShot.documents
//                print(documents)
//                let menuList = documents.compactMap{
//                    return try? $0.data(as: Report.self)
//                }
//                print(menuList)
//            }else {
//                print("Data Not Found")
//            }
//        }
//    }
       // FirestoreのDB取得
        //        // personsコレクションを取得
//        db.collection("post").document("LA").setData([
//            "name": "Los Angeles",
//            "state": "CA",
//            "country": "USA"
//        ]) { err in
//            if let err = err {
//                print("Error writing document: \(err)")
//            }else{
//                print("Document")
//            }
//        }
}
