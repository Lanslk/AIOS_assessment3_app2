//
//  TopicView.swift
//  Daily Speech
//
//  Created by yuteng Lan on 6/10/2024.
//

import SwiftUI

struct TopicView: View {
    @State private var yourTopic = ""
    
    @EnvironmentObject var userAccount: UserAccount
    
    @State private var showAlert = false
    @State private var navigateToRecordView = false
    
    var body: some View {
        Text("Pick a topic!")
            .font(.title)
            .foregroundColor(.mint)
        
        Spacer()
        
        VStack {
            TextField("Your Topic", text: $yourTopic)
                .font(.title2)
                .padding()
                .multilineTextAlignment(.center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                if yourTopic.isEmpty {
                    showAlert = true  // Show alert if topic is empty
                } else {
                    // navigate to RecordView
                    navigateToRecordView = true
                }
            }, label: {
                Text("Ready to Speech")
                    .font(.title)
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Name Required"),
                    message: Text("Please enter your topic."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .padding()
        .navigationDestination(isPresented: $navigateToRecordView) {
            RecordView(topic: $yourTopic)
                .environmentObject(userAccount)
        }
        
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

#Preview {
    TopicView()
}
