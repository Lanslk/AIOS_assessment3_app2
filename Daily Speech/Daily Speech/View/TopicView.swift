//
//  TopicView.swift
//  Daily Speech
//
//  Created by yuteng Lan on 6/10/2024.
//

import SwiftUI

struct TopicView: View {
    @State private var yourTopic = ""
    
    var body: some View {
        NavigationStack {
            Text("Pick a topic!")
                .font(.title)
                .foregroundColor(.mint)
            
            Spacer()
            
            HStack {
                TextField("Your Topic", text: $yourTopic)
                    .font(.title2)
                    .padding()
                    .multilineTextAlignment(.center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            
            List {
                ForEach(categories, id: \.name) { category in
                    // create expandable sections
                    DisclosureGroup {
                        ForEach(category.topics, id: \.self) { topic in
                            // Display each topic as a text
                            Text(topic)
                                .padding(.leading, 10)
                                .onTapGesture {
                                    yourTopic = topic
                                }
                        }
                    } label: {
                        HStack {
                            Image(systemName: category.icon)
                            Text(category.name)
                        }
                    }
                    .padding()
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    TopicView()
}
