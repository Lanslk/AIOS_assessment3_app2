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
                        // create expandable sections
                        DisclosureGroup {
                            Text(data.content)
                        } label: {
                            HStack {
                                Text(String(data.topic))
                            }
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
