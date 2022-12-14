import SwiftUI
import MapKit   //地図を表示する
import CoreLocation //位置情報を取得する
import PhotosUI
import AVFoundation

import FirebaseStorage

struct ViewingView: View {
    @State var settingIsActive = false
    @EnvironmentObject var modeConfig: ModeConfig
    
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    
    @ObservedObject private var postViewModel = PostViewModel()
    @ObservedObject private var locationViewModel = LocationViewModel.shared
    
    private let viewControllerFireStore = ViewControllerFireStore()
    private let pinConfig = PinConfig()
    
    func dateToString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        print("called")
        print(dateFormatter.string(from: date))
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        ZStack{
//            MapView(chosenDoc: modeConfig.viewDoc).environmentObject(ModeConfig())
            Map(coordinateRegion: $locationViewModel.region,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: $userTrackingMode,
                annotationItems: viewDoc,
                annotationContent: { (annotation) in MapAnnotation(coordinate: CLLocationCoordinate2D(
                    latitude: Double(annotation.latitude) ?? 35.0,
                    longitude: Double(annotation.longitude) ?? 135.0
                )) {
                    PinBase(
                        img_url: annotation.img_url,
                        datetime: dateToString(date: annotation.datetime),
                        text: annotation.text,
                        userName: annotation.user_name,
                        weather: annotation.weather
                    ).offset(x: 0, y: -0.5*(pinConfig.frameSize + pinConfig.tailHeight))
                }
            }
            )
            VStack {
                Spacer().frame(height: 5)
                HStack{
                    Spacer().frame(width: 5)
                    Button(action: {
                        settingIsActive = true
                    }, label: {
                        Image(systemName: "gearshape")
                    }).background(Color.white)
                        .fullScreenCover(isPresented: $settingIsActive) {
                            SettingSortView(settingIsActive: $settingIsActive)
                        }
                           
                    Spacer()
                    Button(action: {
                        docManager(startDay: modeConfig.startDay, endDay: modeConfig.endDay)
                    }, label: {
                        Image(systemName: "arrow.triangle.2.circlepath")
                    }).background(Color.white)
                    Spacer().frame(width: 5)
                }
                Spacer()
            }
        }
    }
}

struct SearchingView: View{
    @State var settingIsActive = false
    @EnvironmentObject var modeConfig: ModeConfig
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    
    @ObservedObject private var postViewModel = PostViewModel()
    @ObservedObject private var locationViewModel = LocationViewModel.shared
    
    private let viewControllerFireStore = ViewControllerFireStore()
    private let pinConfig = PinConfig()
    
    func dateToString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        print("called")
        print(dateFormatter.string(from: date))
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        ZStack{
//            MapView(chosenDoc: modeConfig.searchDoc).environmentObject(ModeConfig())
            Map(coordinateRegion: $locationViewModel.region,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: $userTrackingMode,
                annotationItems: searchDoc, // No ObservableObject of type ModeConfig found. A View.environmentObject(_:) for ModeConfig may be missing as an ancestor of this view
                annotationContent: { (annotation) in MapAnnotation(coordinate: CLLocationCoordinate2D(
                    latitude: Double(annotation.latitude) ?? 35.0,
                    longitude: Double(annotation.longitude) ?? 135.0
                )) {
                    PinBase(
                        img_url: annotation.img_url,
                        datetime: dateToString(date: annotation.datetime),
                        text: annotation.text,
                        userName: annotation.user_name,
                        weather: annotation.weather
                    ).offset(x: 0, y: -0.5*(pinConfig.frameSize + pinConfig.tailHeight))
                }
            }
            )
            VStack {
                Spacer().frame(height: 5)
                HStack{
                    Spacer()
                    Button(action: {
                        docManager(startDay: modeConfig.startDay, endDay: modeConfig.endDay)
                    }, label: {
                        Image(systemName: "arrow.triangle.2.circlepath")
                    }).background(Color.white)
                    Spacer().frame(width: 5)
                }
                Spacer()
            }
        }
    }
}

struct MapView: View {
    @State var chosenDoc:[Report]
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State var settingIsActive = false
    
    @ObservedObject private var postViewModel = PostViewModel()
    @ObservedObject private var locationViewModel = LocationViewModel.shared
    
    private let viewControllerFireStore = ViewControllerFireStore()
    private let pinConfig = PinConfig()
    
    func dateToString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        print("called")
        print(dateFormatter.string(from: date))
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        HStack{
            Map(coordinateRegion: $locationViewModel.region,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: $userTrackingMode,
                annotationItems: chosenDoc,
                annotationContent: { (annotation) in MapAnnotation(coordinate: CLLocationCoordinate2D(
                    latitude: Double(annotation.latitude) ?? 35.0,
                    longitude: Double(annotation.longitude) ?? 135.0
                )) {
                    PinBase(
                        img_url: annotation.img_url,
                        datetime: dateToString(date: annotation.datetime),
                        text: annotation.text,
                        userName: annotation.user_name,
                        weather: annotation.weather
                    ).offset(x: 0, y: -0.5*(pinConfig.frameSize + pinConfig.tailHeight))
                }
              }
            ).edgesIgnoringSafeArea(.all)
        }.onAppear() {
            locationViewModel.requestPermission()
        }
    }
}

struct SettingSortView: View {
    @EnvironmentObject var modeConfig: ModeConfig
    @Binding var settingIsActive: Bool

    var body: some View{
        VStack{
            HStack(){
                Spacer().frame(width: 5)
                Button(action: {
                    docManager(startDay: modeConfig.startDay, endDay: modeConfig.endDay)
                    settingIsActive = false
                }, label: {
                    Image(systemName: "xmark.circle")
                })
                Spacer()
            }
            
            Spacer()
            
            HStack(){
                Form{
                    Section{
                        VStack {
                            Spacer().frame(height: 5)
                            DatePicker("開始日時",
                                       selection: $modeConfig.startDay)
                            Spacer()
                            DatePicker("終了日時",
                                       selection: $modeConfig.endDay)
                            Spacer()
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }
            }
            Spacer()
        }
    }
}

struct PostingView: View {
    @State private var sentence = ""
    @ObservedObject var postInfomation = PostInfomation()
    @ObservedObject private var locationViewModel = LocationViewModel.shared
    
    @State var isPushed = false
    @State var imageData: Data = .init(capacity:0)
    @EnvironmentObject var modeConfig: ModeConfig
    
    let viewControllerFireStore = ViewControllerFireStore()
    let viewingView = ViewingView()
    
    var body: some View {
        ZStack {
            VStack{
                CameraView(imageData: $imageData)
                Spacer().frame(height: 5)
                TextField("思い出を書こう", text: $sentence)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Spacer()
            }
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button("post", action: {
                        postInfomation.postInfo(
                            imageData: imageData,
                            coordinate: locationViewModel.getLocation(),
                            text: sentence
                        )
                        isPushed.toggle()
                        docManager(startDay: modeConfig.startDay, endDay: modeConfig.endDay)
                    }).buttonStyle(.borderedProminent).alert( isPresented: $isPushed) {
                        var shownAlert:Alert = Alert(title: Text("写真を撮影してください。"))
                        if postInfomation.isNotSelected {
                            shownAlert = Alert(title: Text("写真を撮影してください。"))
                        } else{
                            shownAlert = Alert(title: Text("投稿しました！"))
                        }
                        return shownAlert
                    }
                    Spacer().frame(width: 5)
                }
                Spacer().frame(height: 5)
            }
        }
    }
}

struct CameraView: View {
    @Binding var imageData: Data
    @State var source:UIImagePickerController.SourceType = .camera
    @State var isImagePicker = false
    
    var body: some View {
//        NavigationView{
//            NavigationLink(
//                destination: Imagepicker(show: $isImagePicker, image: $imageData, sourceType: source),
//                isActive:$isImagePicker,
//                label: {
//                    Button(action: {
//                        self.source = .camera
//                        self.isImagePicker.toggle()
//                    }, label: {
//                        if imageData.count != 0{
//                            Image(uiImage: UIImage(data: self.imageData)!)
//                                .resizable()
//                                .frame(width: UIScreen.main.bounds.width, height: CGFloat(UIScreen.main.bounds.height / 1.5))
//                                .scaledToFill()
//                                .clipped()
//                        } else {
//                            VStack{
//                                Image(systemName: "camera")
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: CGFloat(UIScreen.main.bounds.width / 5), height: CGFloat(UIScreen.main.bounds.height / 5))
//                                    .padding(.all, UIScreen.main.bounds.width)
//                                Text("思い出を撮ろう！")
//                            }.background(Color.gray)
//                        }
//                    })
//                }
//            )
//        }
        Button(action: {
            self.source = .camera
            self.isImagePicker.toggle()
        }, label: {
            if imageData.count != 0{
                Image(uiImage: UIImage(data: self.imageData)!)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: CGFloat(UIScreen.main.bounds.height / 1.5))
                    .scaledToFill()
                    .clipped()
            } else {
                VStack(alignment: .center){
                    Image(systemName: "camera")
                        .resizable()
                        .scaledToFill()
                        .frame(width: CGFloat(UIScreen.main.bounds.width / 5), height: CGFloat(UIScreen.main.bounds.height / 5))
                    Text("写真を撮影")
                }
                .frame(width: UIScreen.main.bounds.width, height: CGFloat(UIScreen.main.bounds.height / 1.5))
                .background(Color.gray)
            }
        }).fullScreenCover(
            isPresented: $isImagePicker
        ) {
            Imagepicker(show: $isImagePicker, image: $imageData, sourceType: source)
        }
    }
}

func randomString(length: Int) -> String {
    let characters = "abcdefghijklmnopqrstuvwsyzABCDFGHIJKLMNOPQRSTUVWYZ0123456789"
    return  String((0..<length).map{  _ in characters.randomElement()! })
}

