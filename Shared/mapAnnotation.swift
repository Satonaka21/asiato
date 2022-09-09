import CoreLocation
import SwiftUI
import Foundation

//struct Annotation: Identifiable{
//    var id = UUID()
//    var datetime: Date
//    var img_url: String
//    var latitude: String
//    var longitude: String
//    var text: String
//    var user_name: String
//    var weather: String
//}

struct PinConfig{
    let frameRadius: CGFloat = 10
    let frameSize: CGFloat = 50
    let photoSize: CGFloat = 40
    let tailWidth: CGFloat = 5
    let tailHeight: CGFloat = 25
}

struct PinBase: View{
    let pinConfig = PinConfig()
    var img_url: String
    var datetime: String
    var text: String
    var userName: String
    var weather: String
    
    @State var isActive = false

    var body: some View{
        
        Button(action: {
            isActive = true
        }, label: {
            VStack(spacing: 0){
                ZStack{
                    RoundedRectangle(cornerRadius: pinConfig.frameRadius)
                    .fill(Color.blue)
                    .frame(width: pinConfig.frameSize, height: pinConfig.frameSize)
                    AsyncImage(url: URL(string: img_url)) { image in
                        image
                            .resizable()
                            .frame(width: pinConfig.photoSize, height: pinConfig.photoSize)
                            .scaledToFill()
                            .clipped()
                    } placeholder: {
                        Image(systemName: "slowmo")
                            .resizable()
                            .foregroundColor(Color.white)
                            .frame(width: pinConfig.photoSize, height: pinConfig.photoSize)
                            .scaledToFill()
                            .clipped()
                    }
                }
            Triangle()
                .fill(Color.blue)
                .frame(width: pinConfig.tailWidth, height: pinConfig.tailHeight)
            }
        }).fullScreenCover(isPresented: $isActive) {
            PopupView(
                img_url: img_url,
                datetime: datetime,
                text: text,
                userName: userName,
                weather: weather,
                isActive: $isActive
            )
        }
        
    }
}

struct PopupView: View {
    var img_url: String
    var datetime: String
    var text: String
    var userName: String
    var weather: String
    @Binding var isActive: Bool

    var body: some View{
        ZStack{
            VStack{
                AsyncImage(url: URL(string: img_url)) { image in
                    image
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: CGFloat(UIScreen.main.bounds.height / 1.5))
                        .scaledToFit()
                } placeholder: {
                    Image(systemName: "slowmo")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: CGFloat(UIScreen.main.bounds.height / 1.5))
                        .scaledToFit()
                }
                
                
                HStack(){
                    Spacer().frame(width: 5)
                    Text(userName)
                    Spacer()
                    Text(datetime)
                    Spacer().frame(width: 5)
                }
                
                HStack(){
                    Spacer().frame(width: 5)
                    Text(text)
                    Spacer()
                }
                Spacer()
            }
            VStack{
                Spacer().frame(height: 5)
                HStack{
                    Spacer().frame(width: 5)
                    Button(action: {
                        print(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
                        print("pushed!")
                        isActive = false
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                    Spacer()
                }
                Spacer()
            }
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
