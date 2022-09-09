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
import SwiftUI

struct Person {
    var name: String
    var age: Int
    var hobbys: [Hobby]
}

struct Hobby {
    var name: String
    var year: Int
}

var surchDoc:[Report] = []
var viewDoc:[Report] = []

public func docManager() {
    let viewControllerFireStore = ViewControllerFireStore()
    viewControllerFireStore.fetchDocumentDataTimesort()
    viewControllerFireStore.fetchDocumentData()
}
    
//取得するデータを宣言（これも忘れない
struct Report: Codable, Identifiable, Equatable{
    var id = UUID()
    var datetime: Date
    var img_url: String
    var latitude: String
    var longitude: String
    var text: String
    var user_name: String
    var weather: String
}

//dateとStringの相互変換用class
class DateUtils {
    class func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }

    class func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

class ViewControllerFireStore: UIViewController{

    public func fetchDocumentData(){
        var postList:[Report] = []
        let db = Firestore.firestore()

        let locationViewModel = LocationViewModel()
        let viewingView = ViewingView()
        
        //現在地に変える
        let latitude: Double = locationViewModel.getLocation().latitude
        let longitude: Double = locationViewModel.getLocation().longitude
        
        let settingSortView = SettingSortView(settingIsActive: viewingView.$settingIsActive)
        
        print(settingSortView.startDay, settingSortView.endDay)
        let frontDatetimeString = DateUtils.stringFromDate(date: settingSortView.startDay, format: "yyyy/MM/dd HH:mm:ss Z")
        let backDatetimeString = DateUtils.stringFromDate(date: settingSortView.endDay, format: "yyyy/MM/dd HH:mm:ss Z")
        
        let frontDatetime = DateUtils.dateFromString(string: frontDatetimeString, format: "yyyy/MM/dd HH:mm:ss Z")
        let backDatetime = DateUtils.dateFromString(string: backDatetimeString, format: "yyyy/MM/dd HH:mm:ss Z")
        
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
                
                //filterをかけた後の処理
                let lat_min: Double = latitude - 0.1
                let lat_max: Double = latitude + 0.1
                let long_min: Double = longitude - 0.1
                let long_max: Double = longitude + 0.1
                
                postList = menuList.filter{ document in
                    let lat: Double = Double(document.latitude) ?? 0
                    let long: Double = Double(document.longitude) ?? 0
                    let postDatetime = document.datetime
                    return lat_min < lat && lat < lat_max && long_min < long && long < long_max && frontDatetime < postDatetime && postDatetime < backDatetime
                }
                dump(postList)
                viewDoc = postList
//                docManager.distSortedDoc = postList
//                docManager.getDistSortedDoc(doc: postList)
            }else {
                print("Data Not Found")
            }
        }
    }
    
    public func fetchDocumentDataTimesort() {
        let db = Firestore.firestore()
        var nowDate = Date()
        //ここの日付を決めうちじゃなくす
        
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
                
                let postList = menuList.filter{ document in
                    let postDatetime = document.datetime
                    return Calendar.current.date(byAdding: .day, value: -3, to: Date())! < postDatetime
                }
                dump(postList)

                //値は配列になっている。取得は、「配列[index].要素名」で取得することができる。
                print(menuList[0].datetime)
                surchDoc = postList
            }else {
                print("Data Not Found")
            }
        }
    }
}
