//
//  SignInView.swift
//  demo
//
//  Created by Yash Khurana on 8/4/24.
//

import SwiftUI

@MainActor
final class SignInViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        let returnedUserData = try await AuthenticationManager.shared.signInUser(email: email, password: password)
        print("Success!")
        print(returnedUserData)
    }
}

struct SignInView: View {
    @StateObject private var viewModel = SignInViewModel()
    @EnvironmentObject var authState: AuthenticationState
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)
                    .padding(.top, 40)
                    .padding(.bottom, 40)
                
                TextField("Email", text: $viewModel.email)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                    .padding(.bottom, 40)
                
                Button {
                    Task {
                        do {
                            try await viewModel.signIn()
                            authState.isAuthenticated = true
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Sign In")
        }
    }
}

#Preview {
    SignInView()
}
