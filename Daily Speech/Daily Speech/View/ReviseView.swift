//
//  ReviseView.swift
//  Daily Speech
//
//  Created by yuteng Lan on 7/10/2024.
//

import SwiftUI
import SwiftData

struct ReviseView: View {
    @Environment(\.modelContext) private var context  // Get context from the environment
    @Binding public var topic: String
    @Binding public var origin: String
    @Binding public var content: String
    
    @State private var showAlert = false
    @State private var navigateToSavedView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Revise your speech")
                    .font(.title)
                    .foregroundColor(.mint)
                
                Spacer()
                
                Text("Topic: \(topic)")
                
                Spacer()
                
                ScrollView {
                    Text("Original")
                        .font(.title)
                        .padding(.bottom, 5)
                        .foregroundColor(.blue)
                    
                    TextEditor(text: $origin)
                        .padding()
                        .frame(minHeight: 200, maxHeight: 200)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                }
                
                ScrollView {
                    Text("Revised")
                        .font(.title)
                        .padding(.bottom, 5)
                        .foregroundColor(.green)
                    
                    TextEditor(text: $content)
                        .padding()
                        .frame(minHeight: 200, maxHeight: 200)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                }
                
                Button(action: {
                    if content.isEmpty {
                        showAlert = true  // Show alert if topic is empty
                    } else {
                        // navigate to RecordView
                        saveActivity(topic: topic, content: content, context: context)
                        navigateToSavedView = true
                    }
                }, label: {
                    Text("Save Speech")
                        .font(.title)
                })
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Content Required"),
                        message: Text("Revised content is blank."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .navigationDestination(isPresented: $navigateToSavedView) {
                    SavedView()
                }
                
            }
            .padding()
            
        }
    }
}

#Preview {
    ReviseView(topic: .constant("Introduce yourself"), origin: .constant("Introducing yourself"), content: .constant("Introduce yourself"))
}
