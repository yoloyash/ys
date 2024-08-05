//
//  SignUpView.swift
//  demo
//
//  Created by Yash Khurana on 8/4/24.
//

import SwiftUI

@MainActor
final class SignUpViewModel: ObservableObject {
    
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var dateOfBirth = Date()
    
    func signUp() async throws {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            print("Name, email, or password is empty!")
            return
        }
        
        let returnedUserData = try await AuthenticationManager.shared.createUser(name: name, email: email, password: password, dateOfBirth: dateOfBirth)
        print("Successfully Signed Up!")
        print(returnedUserData)
    }
}

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
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
                
                TextField("Name", text: $viewModel.name)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                
                TextField("Email", text: $viewModel.email)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                    .padding(.bottom, 40)
                DatePicker("Date of Birth", selection: $viewModel.dateOfBirth, displayedComponents: .date)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                    .padding(.bottom, 40)
                
                Button {
                    Task {
                        do {
                            try await viewModel.signUp()
                            authState.isAuthenticated = true
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("Sign Up")
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
            .navigationTitle("Sign Up")
        }
    }
}

#Preview {
    SignUpView()
}
