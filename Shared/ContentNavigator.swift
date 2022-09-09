
import SwiftUI

struct SwitchingView: View{
    let  viewControllerFireStore = ViewControllerFireStore()
    
    var body: some View{
        NavigationView{
            TabView{
                PostingView().tabItem {
                    Image(systemName: "plus.circle")
                    Text("投稿")
                }
                SearchingView().tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("検索")
                }
                ViewingView().tabItem {
                    Image(systemName: "mappin.and.ellipse")
                    Text("閲覧")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("あしあと")
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {}){
                    Image(systemName: "gearshape")
                }
            }
        }
    }
}

