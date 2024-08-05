//
//  AuthenticationState.swift
//  demo
//
//  Created by Yash Khurana on 8/4/24.
//

import Foundation
import Combine

class AuthenticationState: ObservableObject {
    @Published var isAuthenticated: Bool = false
}
