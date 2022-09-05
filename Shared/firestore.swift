//
//  firestore.swift
//  asiato
//
//  Created by 山北峻佑 on 2022/09/05.
//


import UIKit
import FirebaseCore
import FirebaseFirestore


struct Person {
    var name: String
    var age: Int
    var hobbys: [Hobby]
}

struct Hobby {
    var name: String
    var year: Int
}


class ViewControllerFireStore: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // FirestoreのDB取得
        let db = Firestore.firestore()
        // personsコレクションを取得
        db.collection("post").document("LA").setData([
            "name": "Los Angeles",
            "state": "CA",
            "country": "USA"
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            }else{
                print("Documnt")
            }
        }
    
        db.collection("post").getDocuments() { querySnapshot, err in
            // エラー発生時
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                // コレクション内のドキュメントを取得
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    // hobbiesフィールドを取得
                }
            }
        }
    }
}

