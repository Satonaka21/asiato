//
//  asiatoApp.swift
//  Shared
//
//  Created by 里中俊介 on 2022/08/29.
//

import SwiftUI
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

@main
struct asiatoApp: App {
    init() {
        initFirebase()
    }
    
    var body: some Scene {
        WindowGroup {
            SwitchingView()
        }
    }
}

extension asiatoApp{
    private func initFirebase() {
      FirebaseApp.configure()
    }
}

