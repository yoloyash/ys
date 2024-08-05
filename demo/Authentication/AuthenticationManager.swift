//
//  AuthenticationManager.swift
//  demo
//
//  Created by Yash Khurana on 8/3/24.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class AuthenticationStateManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
}

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let name: String?
    let dateOfBirth: Date?
    let photoUrl: String?
    
    init(user: User, name: String?, dateOfBirth: Date?) {
        self.uid = user.uid
        self.email = user.email
        self.name = name
        self.dateOfBirth = dateOfBirth
        self.photoUrl = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() { }
    
    private let db = Firestore.firestore()
    
    func getAuthenticatedUser() async throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        let docRef = db.collection("users").document(user.uid)
        let document = try await docRef.getDocument()
        let data = document.data()
        let name = data?["name"] as? String
        let dateOfBirth = (data?["dataOfBirth"] as? Timestamp)?.dateValue()
        
        return AuthDataResultModel(user: user, name:name, dateOfBirth: dateOfBirth)
    }
    
    @discardableResult
    func createUser(name:String, email: String, password: String, dateOfBirth: Date) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = authDataResult.user
        
        let userData: [String: Any] = [
            "name": name,
            "email": email,
            "dateOfBirth": dateOfBirth
        ]
        
        try await db.collection("users").document(user.uid).setData(userData)
        
        return AuthDataResultModel(user: user, name: name, dateOfBirth: dateOfBirth)
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        let user = authDataResult.user
        
        let docRef = db.collection("users").document(user.uid)
        let document = try await docRef.getDocument()
        
        if let data = document.data() {
            let name = data["name"] as? String
            let dateOfBirth = (data["dateOfBirth"] as? Timestamp)?.dateValue()
            return AuthDataResultModel(user: user, name: name, dateOfBirth: dateOfBirth)
        } else {
            // If for some reason the additional data is not found, return with nil values for name and dateOfBirth
            return AuthDataResultModel(user: user, name: nil, dateOfBirth: nil)
            }
    }
    
    func resetPassword(email: String) async throws{
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await user.updatePassword(to: password)
    }
    
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await user.sendEmailVerification(beforeUpdatingEmail: email)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
