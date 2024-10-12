//
//  ShareView.swift
//  Daily Speech
//
//  Created by yuteng Lan on 11/10/2024.
//

import SwiftUI

struct ShareView: View {
    @State private var cloudActivities: [Activity] = []

    var body: some View {
        VStack {
            Text("Shared Speech")
                .foregroundColor(.mint)
                .font(.title)
            Spacer()
            
            ScrollView {
                LazyVStack {
                    ForEach(cloudActivities, id: \.id) { activity in
                        NavigationLink(destination: ShareActivityDetailView(activity: activity)) {
                            HStack {
                                Text(activity.topic)
                                    .font(.headline)
                            }
                            .padding()
                            .background(Color.mint.opacity(0.2))
                            .cornerRadius(10)
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            loadActivities()
        }
    }
    
    // Function to load activities and update the state
    func loadActivities() {
        fetchActivities { fetchedActivities in
            cloudActivities = fetchedActivities // Update the state with fetched activities
        }
    }
    
}

#Preview {
    ShareView()
}
