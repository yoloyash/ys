//
//  RootView.swift
//  demo
//
//  Created by Yash Khurana on 8/3/24.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                SettingsView(showSignInView: $showSignInView)
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView (showSignInView: $showSignInView)
            }
        }
    }
}

#Preview {
    RootView()
}
