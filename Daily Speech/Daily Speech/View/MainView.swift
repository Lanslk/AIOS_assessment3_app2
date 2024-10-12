//
//  MainView.swift
//  Daily Speech
//
//  Created by yuteng Lan on 6/10/2024.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var userAccount: UserAccount
    @State private var isLoggedOut = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                // Logout button
                Button(action: {
                    // Trigger logout by setting isLoggedOut to true
                    isLoggedOut = true
                }) {
                    Text("Logout")
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .font(.caption)
                }
            }
            
            Text("Let's practice English!")
                .font(.title)
                .foregroundColor(.mint)
            
            Spacer()
            HStack {
                NavigationLink(
                    destination: TopicView()
                        .environmentObject(userAccount),
                    label: {
                        CustomRowView(buttonTitle: "Start practice", imageName: "rectangle.and.pencil.and.ellipsis")
                        })
                
            }

            HStack {
                NavigationLink(
                    destination: SavedView()
                        .environmentObject(userAccount),
                    label: {
                        CustomRowView(buttonTitle: "Previous practice", imageName: "book.pages")
                    })
                
            }
            
            HStack {
                NavigationLink(
                    destination: ShareView()
                        .environmentObject(userAccount),
                    label: {
                        CustomRowView(buttonTitle: "Shared speeches", imageName: "rectangle.3.group.bubble")
                    })
                
            }
            Spacer()
            
            // Hidden NavigationLink to navigate to ContentView upon logout
            NavigationLink(destination: ContentView(), isActive: $isLoggedOut) {
                EmptyView()  // Invisible view to trigger navigation
            }
        }
        .font(.title)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainView()
}
