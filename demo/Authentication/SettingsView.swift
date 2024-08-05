//
//  SettingsView.swift
//  demo
//
//  Created by Yash Khurana on 8/3/24.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        Task {
            let authUser = try await AuthenticationManager.shared.getAuthenticatedUser()
            guard let email = authUser.email else {
                throw URLError(.fileDoesNotExist)
            }
            try await AuthenticationManager.shared.resetPassword(email: email)
        }
    }
    
    func updateEmail() async throws {
        let email = "hello123@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        let password = "Yashyash1"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
}

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject var authState: AuthenticationState
    
    var body: some View {
        List {
            Button("Log Out") {
                Task {
                    do {
                        try viewModel.signOut()
                        authState.isAuthenticated = false
                    } catch {
                        print(error)
                    }
                }
            }
            emailSection
        }
        .navigationBarTitle("Settings")
    }
}

#Preview {
    SettingsView()
}

extension SettingsView {
    
    private var emailSection: some View {
        
        Section {
            Button("Reset Password") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("Password Reset!")
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button("Update Password") {
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("Password Updated!")
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button("Update Email") {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("Email Updated!")
                    } catch {
                        print(error)
                    }
                }
            }
        } header: {
            Text("Email Functions")
        }
    }
}
