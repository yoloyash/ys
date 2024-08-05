//
//  MainTabView.swift
//  demo
//
//  Created by Yash Khurana on 8/4/24.
//

import SwiftUI

struct MainTabView: View {
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            NavigationStack {
                SettingsView(showSignInView: $showSignInView)
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}

#Preview {
    MainTabView(showSignInView: .constant(false))
}
