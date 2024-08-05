//
//  MainTabView.swift
//  demo
//
//  Created by Yash Khurana on 8/4/24.
//

import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var authState: AuthenticationState
    
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}

#Preview {
    MainTabView()
}
