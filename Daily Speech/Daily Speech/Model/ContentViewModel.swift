//
//  ContentViewModel.swift
//  Daily Speech
//
//  Created by yuteng Lan on 8/10/2024.
//

import Foundation

@MainActor
final class ContentViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            throw MyError.inputError
        }
        
        try await AuthenticationManager.shared.createUser(email: email, password: password)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            throw MyError.inputError
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}

enum MyError: LocalizedError {
    case inputError
    
    var errorDescription: String? {
        switch self {
        case .inputError:
            return NSLocalizedString("Please enter email and password.", comment: "")
        }
    }
}
