import CoreLocation
import SwiftUI
import Foundation

struct Annotation: Identifiable{
    let id: String
    let img_url: String
    let coordinate: CLLocationCoordinate2D
}

struct PinConfig{
    let frameRadius: CGFloat = 10
    let frameSize: CGFloat = 50
    let photoSize: CGFloat = 45
    let tailWidth: CGFloat = 5
    let tailHeight: CGFloat = 25
}

struct PinBase: View{
    let pinConfig = PinConfig()
    
    var body: some View{
        VStack(spacing: 0){
            ZStack{
                RoundedRectangle(cornerRadius: pinConfig.frameRadius)
                .fill(Color.blue)
                .frame(width: pinConfig.frameSize, height: pinConfig.frameSize)
                URLImage(url:"https://firebasestorage.googleapis.com/v0/b/toratora-dev.appspot.com/o/pic%2Ftest.png?alt=media&token=6a9c744a-1130-4eae-9a7e-d61f819df051")
            }
        Triangle()
            .fill(Color.blue)
            .frame(width: pinConfig.tailWidth, height: pinConfig.tailHeight)
        }
    }
}

/// 三角形を描画するカスタムShape
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            path.closeSubpath()
        }
    }
}
 
class ImageDownloader : ObservableObject {
    @Published var downloadData: Data? = nil

    func downloadImage(url: String) {

        guard let imageURL = URL(string: url) else { return }

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageURL)
            DispatchQueue.main.async {
                self.downloadData = data
            }
        }
    }
}

struct URLImage: View {
    
    let pinConfig = PinConfig()
    let url: String
    @ObservedObject private var imageDownloader = ImageDownloader()

    init(url: String) {
        self.url = url
        self.imageDownloader.downloadImage(url: self.url)
    }

    var body: some View {
        if let imageData = self.imageDownloader.downloadData {
            let img = UIImage(data: imageData)
            return Image(uiImage: img!)
                .resizable()
                .scaledToFit()
                .frame(width:pinConfig.photoSize, height:pinConfig.photoSize)
        } else {
            return Image(uiImage: UIImage(systemName: "icloud.and.arrow.down")!)
                .resizable()
                .scaledToFit()
                .frame(width:pinConfig.photoSize, height:pinConfig.photoSize)
        }
    }
}
