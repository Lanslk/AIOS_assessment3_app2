//
//  ContentView.swift
//  Daily Speech
//
//  Created by yuteng Lan on 6/10/2024.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    @State private var navigateToMainView = false
    
    @State private var errorMessage: String? = nil
    @State private var showAlertSignUp: Bool = false
    @State private var showAlertSignIn: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Daily Speech")
                    .foregroundColor(.mint)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                TextField("Email...", text: $viewModel.email)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                
                SecureField("Password...", text: $viewModel.password)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                
//                NavigationLink(
//                    destination: MainView(),
//                    label: {
//                        CustomRowView(buttonTitle: "Sign in", imageName: "")
//                        })
//                .padding()
                
                HStack {
                    Spacer()
                    Button {
                        
                        Task {
                            do {
                                try await viewModel.signUp()
                                navigateToMainView = true
                                return
                            } catch {
                                errorMessage = error.localizedDescription
                                showAlertSignUp = true
                            }
                        }
                        
                    } label: {
                        Text("Sign up")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                    .alert(isPresented: $showAlertSignUp) {
                        Alert(
                            title: Text("Error"),
                            message: Text(errorMessage ?? "An unknown error occurred"),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    
                    Spacer()
                    
                    Button {
                        
                        Task {
                            do {
                                try await viewModel.signIn()
                                navigateToMainView = true
                                return
                            } catch {
                                errorMessage = error.localizedDescription
                                showAlertSignIn = true
                            }
                        }
                        
                    } label: {
                        Text("Sign in")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                    .alert(isPresented: $showAlertSignIn) {
                        Alert(
                            title: Text("Error"),
                            message: Text(errorMessage ?? "An unknown error occurred"),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    
                    Spacer()
                }
                Spacer()
            }
            .navigationDestination(isPresented: $navigateToMainView) {
                MainView()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
