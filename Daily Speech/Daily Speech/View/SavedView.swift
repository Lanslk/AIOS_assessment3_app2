//
//  SavedView.swift
//  Daily Speech
//
//  Created by yuteng Lan on 7/10/2024.
//

import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct SavedView: View {
    @Environment(\.modelContext) private var context
    @Query var activities: [Activity]
    
    @EnvironmentObject var userAccount: UserAccount
    @Environment(\.presentationMode) var presentationMode
    
    // Add the source attribute
    var source: String? = nil
    
    var body: some View {
        VStack {
            Text("Saved Speech")
                .foregroundColor(.mint)
                .font(.title)
            Spacer()
            
            ScrollView {
                LazyVStack {
                    ForEach(Array(activities.filter { $0.account == userAccount.email }.prefix(10).enumerated()), id: \.element) { index, data in
                        NavigationLink(destination: ActivityDetailView(activity: data)) {
                            HStack {
                                Text(data.topic)
                                    .font(.headline)
                            }
                            .padding()
                            .background(Color.mint.opacity(0.2))
                            .cornerRadius(10)
                        }
                    }
                }
            }
            
            Spacer()
            
            // Show Main Menu button when source is "ReviseView"
            if source == "ReviseView" {
                NavigationLink(destination: MainView().environmentObject(userAccount)) {
                    Text("Main Menu")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.mint)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        // Hide the back button when source is "ReviseView"
        .navigationBarBackButtonHidden(source == "ReviseView")
    }
}

#Preview {
    SavedView()
        .modelContainer(for: Activity.self)
}
