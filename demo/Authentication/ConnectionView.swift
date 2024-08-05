//
//  ConnectionView.swift
//  demo
//
//  Created by Yash Khurana on 8/4/24.
//

import SwiftUI
import FirebaseFirestore

@MainActor
final class ConnectionViewModel: ObservableObject {
    @Published var generatedCode: String = ""
    @Published var enteredCode: String = ""
    @Published var showCodeGenerator = false
    @Published var showCodeEntry = false
    @Published var errorMessage: String?
    
    private let authManager = AuthenticationManager.shared
    
    func generateCode() async {
        do {
            let code = try await authManager.generateAndSaveCode()
            generatedCode = code
            showCodeGenerator = true
        } catch {
            errorMessage = "Failed to generate code: \(error.localizedDescription)"
        }
    }
    
    func submitCode() async {
        do {
            try await authManager.submitPartnerCode(enteredCode)
            // Handle successful connection
            print("Successfully connected with partner")
        } catch {
            errorMessage = "Failed to submit code: \(error.localizedDescription)"
        }
    }
}

struct ConnectionView: View {
    @StateObject private var viewModel = ConnectionViewModel()
    @EnvironmentObject var authState: AuthenticationState
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Connect with Your Partner")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Button("Generate Code") {
                Task {
                    await viewModel.generateCode()
                }
            }
            .buttonStyle(.borderedProminent)
            
            Button("Enter Partner's Code") {
                viewModel.showCodeEntry = true
            }
            .buttonStyle(.borderedProminent)
            
            if viewModel.showCodeGenerator {
                Text("Your code: \(viewModel.generatedCode)")
                    .font(.title2)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .sheet(isPresented: $viewModel.showCodeEntry) {
            VStack {
                TextField("Enter partner's code", text: $viewModel.enteredCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Submit") {
                    Task {
                        await viewModel.submitCode()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}

#Preview {
    ConnectionView()
}
