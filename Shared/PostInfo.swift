import SwiftUI

class PostInfomation: ObservableObject{
    @Published public var isNotSelected = false
    var ciImage: CIImage? = nil
    
    func postInfo(imageData: Data) {
        print(imageData.count)
        if(imageData.count != 0){
            ciImage = CIImage(data: imageData) ?? nil
            print(ciImage ?? "cantGet:CIImage")
            print(ciImage?.properties ?? "cantGet:properties")
            
            
        }else{
            isNotSelected = true
        }
    }
}

