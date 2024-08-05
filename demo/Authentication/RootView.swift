//
//  RootView.swift
//  demo
//
//  Created by Yash Khurana on 8/3/24.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var authState: AuthenticationState
    @State private var showMainTabView = false
    
    var body: some View {
        ZStack {
            if authState.isAuthenticated {
                MainTabView()
            } else {
                AuthenticationView()
            }
        }
        .onAppear {
            Task {
                let authUser = try? await AuthenticationManager.shared.getAuthenticatedUser()
                self.authState.isAuthenticated = authUser != nil
            }
        }
        .fullScreenCover(isPresented: .constant(!authState.isAuthenticated)) {
            NavigationStack {
                AuthenticationView()
            }
        }
    }
}

#Preview {
    RootView()
}
