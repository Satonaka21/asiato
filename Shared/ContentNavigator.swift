
import SwiftUI

struct SwitchingView: View{
    
    @StateObject var locationViewModel = LocationViewModel()
    
    var body: some View{
        TabView{
            ViewingView(authorizationStatus: locationViewModel.$authorizationStatus, publishedRegion: locationViewModel.$publishedRegion).tabItem {
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

