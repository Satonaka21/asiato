import SwiftUI
import MapKit   //地図を表示する
import CoreLocation //位置情報を取得する
import PhotosUI
import AVFoundation

struct ViewingView: View {
    
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @Binding var authorizationStatus: CLAuthorizationStatus
    @Binding var publishedRegion: MKCoordinateRegion
    @ObservedObject private var postViewModel = PostViewModel()
    
    private let pinConfig = PinConfig()
    private let annotations: [Annotation] = [
        Annotation(id: "kari", img_url: "gs://", coordinate: CLLocationCoordinate2D(latitude: 35, longitude: 135))
    ]
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $publishedRegion,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: $userTrackingMode,
                annotationItems: annotations,
                annotationContent: { (annotation) in MapAnnotation(coordinate: annotation.coordinate) {
                PinBase().offset(x: 0, y: -0.5*(pinConfig.frameSize + pinConfig.tailHeight))
                }
            }
            ).edgesIgnoringSafeArea(.all)
        }
    }
}

struct PostingView: View {
    @State private var sentence = ""
    @ObservedObject var postInfomation = PostInfomation()
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
                        postInfomation.postInfo(imageData: imageData)
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

    @State var isActionSheet = false
    @State var isImagePicker = false
    
    var body: some View {
        NavigationView{
            VStack(spacing:0){
                ZStack{
                    NavigationLink(
                        destination: Imagepicker(show: $isImagePicker, image: $imageData, sourceType: source),
                        isActive:$isImagePicker,
                        label: {
                            Text("")
                        })
                    VStack{
                        if imageData.count != 0{
                            Image(uiImage: UIImage(data: self.imageData)!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: CGFloat(UIScreen.main.bounds.height / 2))
                        }
                        HStack(spacing:30){
                            Button(action: {
                                    self.source = .photoLibrary
                                    self.isImagePicker.toggle()
                            }, label: {
                                Text("Upload")
                            })
                            Button(action: {
                                    self.source = .camera
                                    self.isImagePicker.toggle()
                            }, label: {
                                Text("Take Photo")
                            })
                        }
                    }
                }
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .background(Color.primary.opacity(0.06).ignoresSafeArea(.all, edges: .all))
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
