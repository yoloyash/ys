//
//  AuthenticationView.swift
//  demo
//
//  Created by Yash Khurana on 8/3/24.
//

import SwiftUI

struct AuthenticationView: View {
    
    @EnvironmentObject var authState: AuthenticationState
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)
                    .padding(.top, 80)
                    .padding(.bottom, 100)
                
                NavigationLink {
                    SignInView()
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                NavigationLink {
                    SignUpView()
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
            .navigationTitle("Sign In")
        }
    }
}

#Preview {
    NavigationStack {
        AuthenticationView()
    }
}
