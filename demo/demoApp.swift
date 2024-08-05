//
//  demoApp.swift
//  demo
//
//  Created by Yash Khurana on 8/3/24.
//

import SwiftUI
import Firebase

@main
struct demoApp: App {
    
    @StateObject private var authState = AuthenticationState()
    
    init(){
        FirebaseApp.configure()
        print("Configured Firebase!")
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                RootView()
                    .environmentObject(authState)
            }
        }
    }
}
