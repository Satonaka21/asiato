
import SwiftUI

struct SwitchingView: View{
    let  viewControllerFireStore = ViewControllerFireStore()
    var body: some View{
        TabView{
            ViewingView(postList: viewControllerFireStore.$postList).tabItem {
                Image(systemName: "map")
            }
            PostingView().tabItem {
                Image(systemName: "paperplane")
            }
            kariView().tabItem {
                Image(systemName: "pencil")
            }
        }
    }
}

