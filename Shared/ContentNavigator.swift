
import SwiftUI

struct SwitchingView: View{

    var body: some View{
        TabView{
            ViewingView().tabItem {
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

