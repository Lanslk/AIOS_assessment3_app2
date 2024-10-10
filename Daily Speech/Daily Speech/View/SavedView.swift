//
//  SavedView.swift
//  Daily Speech
//
//  Created by yuteng Lan on 7/10/2024.
//

import SwiftUI
import SwiftData

struct SavedView: View {
    @Environment(\.modelContext) private var context
    @Query var activities: [Activity]
    
    
    var body: some View {
        VStack {
            Text("Saved Speech")
                .foregroundColor(.mint)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            Spacer()
            
            ScrollView {
                LazyVStack {
                    ForEach(Array(activities.prefix(10).enumerated()), id: \.element) { index, data in
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
        }
        .padding()
    }
}

#Preview {
    SavedView()
        .modelContainer(for: Activity.self)
}
