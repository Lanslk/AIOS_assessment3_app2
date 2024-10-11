//
//  SwiftUIView.swift
//  Daily Speech
//
//  Created by yuteng Lan on 10/10/2024.
//

import SwiftUI
import SwiftData

struct ShareActivityDetailView: View {
    @State var activity: Activity
    
    var body: some View {
        VStack {
            Text("Shared Speech")
                .foregroundColor(.mint)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            
            Text(activity.topic)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text("Author: \(activity.account)")
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text(activity.content)
                .frame(height: 200)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ShareActivityDetailView(activity: Activity(topic: "Sample Topic", content: "Sample Content", account:"test@gmail.com"))
}
