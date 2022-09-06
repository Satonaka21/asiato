import SwiftUI
import MapKit   //地図を表示する
import CoreLocation //位置情報を取得する
import PhotosUI
import AVFoundation

import FirebaseStorage

struct ViewingView: View {
    
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    
    @ObservedObject private var postViewModel = PostViewModel()
    @ObservedObject private var locationViewModel = LocationViewModel()
    
    private let pinConfig = PinConfig()
    private let test = ViewControllerFireStore()
    private let annotations: [Annotation] = [
        Annotation(id: "kari", img_url: "gs://", coordinate: CLLocationCoordinate2D(latitude: 35, longitude: 135))
    ]
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $locationViewModel.region,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: $userTrackingMode,
                annotationItems: annotations,
                annotationContent: { (annotation) in MapAnnotation(coordinate: annotation.coordinate) {
                PinBase().offset(x: 0, y: -0.5*(pinConfig.frameSize + pinConfig.tailHeight))
                }
            }
            ).edgesIgnoringSafeArea(.all)
            Button("kuso"){
                let val = test.fetchDocumentData()
                print("ContentView")
                print(val)
            }
        }
    }
}

struct PostingView: View {
    @State private var sentence = ""
    @ObservedObject var postInfomation = PostInfomation()
    @ObservedObject private var locationViewModel = LocationViewModel()
    
    @State var imageData: Data = .init(capacity:0)
    
    var body: some View {
        ZStack {
            VStack{
                CameraView(imageData: $imageData)
                Spacer()
            }
            VStack{
                Spacer().frame(height: 5)
                TextField("text", text: $sentence)
                Spacer()
                HStack{
                    Spacer()
                    Button("post", action: {
                        postInfomation.postInfo(
                            imageData: imageData,
                            coordinate: locationViewModel.getLocation()
                        )
                    }).buttonStyle(.borderedProminent).alert( isPresented: $postInfomation.isNotSelected) {
                        Alert(title: Text("Please take a picture."))
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
    @State var source:UIImagePickerController.SourceType = .photoLibrary
    @State var isImagePicker = false
    
    var body: some View {
        NavigationView{
            NavigationLink(
                destination: Imagepicker(show: $isImagePicker, image: $imageData, sourceType: source),
                isActive:$isImagePicker,
                label: {
                    Button(action: {
                        self.source = .camera
                        self.isImagePicker.toggle()
                    }, label: {
                        if imageData.count != 0{
                            Image(uiImage: UIImage(data: self.imageData)!)
                                .resizable()
                                .scaledToFill()
                                .clipped()
                                .frame(width: UIScreen.main.bounds.width, height: CGFloat(UIScreen.main.bounds.height / 2))
                        } else {
                            Image(systemName: "camera")
                                .resizable()
                                .scaledToFit()
                                .clipped()
                                .frame(width: UIScreen.main.bounds.width, height: CGFloat(UIScreen.main.bounds.height / 2))
                        }
                    })
                }
            )
        }
    }
}

struct kariView: View{
    @ObservedObject private var postViewModel = PostViewModel()
    
    var body: some View {
        NavigationView{
            List(postViewModel.posts) {post in VStack(alignment: .leading){
                Text(post.user_name ?? "cant get").foregroundColor(Color.white)
                }
            }.onAppear(){
                self.postViewModel.getAllData()
            }.navigationTitle("")
        }
    }
}

func randomString(length: Int) -> String {
    let characters = "abcdefghijklmnopqrstuvwsyzABCDFGHIJKLMNOPQRSTUVWYZ0123456789"
    return  String((0..<length).map{  _ in characters.randomElement()! })
}

