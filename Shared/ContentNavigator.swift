
import SwiftUI
import UIKit

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}

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
            .navigationBarTitle("あしあと", displayMode: .inline)
            .background(NavigationConfigurator { nc in
                nc.navigationBar.barTintColor = .blue
                nc.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

